`timescale 1ns/1ps
module multiply_add_1D_tb;

    logic clk, rst_n, en;
    logic[2:0] x, c, y;
    logic[7:0] a;

    multiply_add_1D #(
        .WIDTH(16),
        .TRUNCATED_WIDTH(16),
        .M(8)
    ) DUT(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .a(a),
        .x(x),
        .c(c),
        .y(y)
    );

    task drive_random_stimulus(input int width, input int iters);
        real result = 0;
        real x_val = 0;
        real c_val = 0;
        real a_val = 1.5;
        for(int i = 0; i < iters;i++)
        begin 
            #2
            en = 1;
            a = 8'b00110000;
            if((i>1)&&(i<3))
            begin 
                x = 3'b001;
                c = 3'b001;
            end
            else
            begin
                x = 3'b000;
                c = 3'b000;
            end
                x_val = x_val + x*1/($pow(4,i));
                c_val = c_val + c*1/($pow(4,i));
            if(i >= 2)
                result = result + $signed(y)*1/($pow(4,i-2));
            $display("Iter: %d, a: %b, x_val: %f, x: %b,c_val: %f,c: %b, y: %b, result: %f, real_result: %f, v: %b",i,DUT.a,x_val,x,c_val,c,y, result, x_val * a + c_val, DUT.multiply_add_block.v);
        end
        $display("Real Result: %f", x_val * a_val + c_val);
        $display("Final Result: %f",result);
        assert((x_val * a_val + c_val)<(2+2/3));
        en = 0;
    endtask

    initial begin 
        $dumpfile("multiply_add_1D.vcd");
        $dumpvars;
        clk = 0;
        rst_n = 0;
        en = 0;
        #2
        rst_n = 1;
        drive_random_stimulus(16,18);
        $finish;
    end
    always begin 
        #1 clk = ~clk;
    end
endmodule