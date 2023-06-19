import rbr_pkg::*;
module online_mult_2D_tb;
    signed_digit x[15:0],y[15:0];
    signed_digit z[15:0];

    online_mult_2D #(
        .WIDTH(16),
        .P(16)
    ) DUT (
        .x(x),
        .y(y),
        .z(z)
    );

    initial begin 
        $dumpfile("online_mult_2D.vcd");
        $dumpvars;
        for(int i = 0;i<16;i++)
        begin 
            x[i] = 0;
            y[i] = 0;
        end
        x[0] = 2'b10;
        y[0] = 2'b10;
        x[1] = 2'b10;
        y[1] = 2'b00;
        x[2] = 2'b00;
        y[2] = 2'b10;
        x[3] = 2'b01;
        y[3] = 2'b01;
        x[4] = 2'b00;
        y[4] = 2'b10;
        x[5] = 2'b01;
        y[5] = 2'b10;
        x[6] = 2'b10;
        #1
        for(int i = 0;i<16;i++)
        begin 
            $display("z %d: %b",i,DUT.z[i]);
        end
    end


endmodule