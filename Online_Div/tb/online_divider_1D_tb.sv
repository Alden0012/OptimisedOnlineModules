import rbr_pkg::*;
module online_divider_1D_tb;

    logic clk,rst_n, en;
    signed_digit x, d, q;

    online_divider_1D #(
        .WIDTH(16),
        .TRUNCATED_WIDTH(16)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .x(x),
        .d(d),
        .q(q)
    );

    task drive_random_stimulus(input int width);
        real result = 0;
        real x_val = 0;
        real d_val = 0;
        int q_conv = 0;
        int online_delay = 4;

        for(int i = 0;i< width+online_delay;i++)
        begin 
            en = 1;
            if(i==0)
            begin 
                x = 2'b00;
                d = 2'b00;
            end
            else if(i==1)
            begin 
                x = 2'b10;
                d = 2'b10;
            end
            else if(i==2)
            begin 
                x = 2'b00;
                d = 2'b10;            
            end
            else
            begin
                x = 2'b00;
                d = 2'b00;
            end
            x_val = x_val + (real'(x.plus)-real'(x.minus))*1/($pow(2,i));
            d_val = d_val + (real'(d.plus)-real'(d.minus))*1/($pow(2,i));
            #2
            if(i >= online_delay)
            begin 
                case({q.plus,q.minus})
                    2'b10: q_conv = 1;
                    2'b01: q_conv = -1;
                    default: q_conv = 0;
                endcase
                result = result + q_conv*1/($pow(2,i-online_delay));
            end
            $display("Iter %d, x:%f, d:%f, q:%b, result:%f", i, x_val, d_val, q, result);
        end

        $display("Final Result: %f", result);
        $display("Real Result: %f", x_val/d_val);


    endtask


    always begin 
        #1 clk = ~clk;
    end

    initial begin 
        $dumpfile("online_divider_1D_tb.vcd");
        $dumpvars;
        clk = 0;
        rst_n = 0;
        en = 0;
        x = 2'b00;
        d = 2'b00;
        #3
        rst_n = 1;
        #2
        drive_random_stimulus(16);
        $finish;

    end


endmodule