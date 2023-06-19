import rbr_pkg::*;
module so3s_2D_tb;
    signed_digit x[15:0],y[15:0],z[15:0];
    logic[15:0][3:0] s;
    logic en;
    real result;
    so3s_2D #(
        .WIDTH(16),
        .TRUNCATED_WIDTH(16)
    ) DUT (
        .en(en),
        .x(x),
        .y(y),
        .z(z),
        .s(s)
    );

    initial begin 
        $dumpfile("so3s_2D.vcd");
        $dumpvars;
        result = 0;
        en = 1;
        //CLEAR ALL
        for(int i = 0;i<16;i++)
        begin 
            x[i] = 2'b00;
            y[i] = 2'b00;
            z[i] = 2'b00;
        end
        for(int i = 1;i<3;i++)
        begin 
            x[i] = 2'b10;
            y[i] = 2'b10;
            z[i] = 2'b10;
        end
        #1
        for(int i = 0;i<16;i++)
        begin
            $display("S_{%d}: %b",i,s[i]);
            result = result + s[i]*1/($pow(2,i));
        end
        $display("Final Result: %f", result);
        $finish;
    end



endmodule