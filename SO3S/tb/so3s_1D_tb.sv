`timescale 1ns/1ps
import rbr_pkg::*;
module so3s_1D_tb;
    logic clk, rst_n, en;
    signed_digit x,y,z;
    logic[3:0] s;

    so3s_1D #(
        .WIDTH(15),
        .TRUNCATED_WIDTH(15)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .x(x),
        .y(y),
        .z(z),
        .s(s)
    );


    task drive_random_stimulus(input int width);
        real result = 0;
        real x_val = 0;
        real y_val = 0;
        real z_val = 0;
        for(int i = 0;i < width;i++)
        begin
            #1 
            en = 1;
            if((i > 0) && (i < 3))
            begin
                x = 2'b10;
                y = 2'b10;
                z = 2'b10;
            end
            else
            begin
                x = 2'b00;
                y = 2'b00;
                z = 2'b00;              
            end
            x_val = x_val + (real'(x.plus)-real'(x.minus))*1/($pow(2,i));
            y_val = y_val + (real'(y.plus)-real'(y.minus))*1/($pow(2,i));
            z_val = z_val + (real'(z.plus)-real'(z.minus))*1/($pow(2,i));
            //$display("x_acc: %b, y_acc: %b, z_acc: %b",DUT.acc_xp,DUT.acc_yp,DUT.acc_zp);
            #1
            result = result + s*1/($pow(2,i));
            $display("Iter %d, x: %f, y: %f, z: %f, s: %b, result: %f",i,x_val,y_val,z_val,s,result);
            //$display(result);
        end
        $display("Final Result: ",result);
        $display("Real Result: ",$pow(x_val,2)+$pow(y_val,2)+$pow(z_val,2));
        en = 0;
    endtask

    initial begin 
        $dumpfile("so3s.vcd");
        $dumpvars;
        clk = 0;
        rst_n = 0;
        en = 0;
        #4
        rst_n = 1;
        drive_random_stimulus(15);
        $finish;
    end
    always begin 
        #1 clk = ~clk;
    end

endmodule