import rbr_pkg::*;
module online_divider_2D_tb;

    parameter WIDTH = 16;
    parameter P = 16;
    signed_digit x[15:0],d[15:0];
    signed_digit q[15:0];

    online_divider_2D #(.WIDTH(WIDTH), .P(P)) DUT (
        .x(x),
        .d(d),
        .q(q)
    );
    logic[1:0] val;
    real x_val;
    real d_val;
    real result;
    // Testbench initialization
    initial begin
        $dumpfile("online_divider_2D_tb.vcd");
        $dumpvars;
        x_val = 0;
        d_val = 0;
        result = 0;

        for(int i = 0;i<WIDTH;i++)
        begin 
            if(i==0)
            begin 
                x[i] = '0;
                d[i] = '0;
            end
            else if(i == 1)
            begin 
                val = 2'b10;
                x[i] = 2'b00;
                d[i] = 2'b10;
                d_val = d_val + (real'(val[1])-real'(val[0]))*1/$pow(2,i);
            end
            else if(i>1)
            begin   
                val = 2'b10;
                x[i] = 2'b10;
                d[i] = 2'b10;
                x_val = x_val + (real'(val[1])-real'(val[0]))*1/$pow(2,i);
                d_val = d_val + (real'(val[1])-real'(val[0]))*1/$pow(2,i);
            end
        end
        #1
        for(int i = 0;i<WIDTH;i++)
        begin 
            val = DUT.q[i];
            $display("x: %b, d: %b, q: %b",x[i],d[i],val);
            result = result + (real'(val[1])-real'(val[0]))*1/$pow(2,i);
        end
        $display("Result: ",result);
        $display("Real Result: ",x_val/d_val);
    end


endmodule