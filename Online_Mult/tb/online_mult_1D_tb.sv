`timescale 1ns/1ps

typedef struct packed{
    logic   plus;
    logic   minus;
}  signed_digit;

module online_mult_1D_tb;
    signed_digit x,y,z;
    logic clk, rst_n, en;

    online_mult_1D DUT (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .x(x),
        .y(y),
        .z(z)
    );

    // online_mult_1D DUT (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .en(en),
    //     .x_aplus(x.plus),
    //     .x_aminus(x.minus),
    //     .y_aplus(y.plus),
    //     .y_aminus(y.minus),
    //     .z_aplus(z.plus),
    //     .z_aminus(z.minus)
    // );

    initial begin 
        $dumpfile("online_mult_1D.vcd");
        $dumpvars;
        clk = 0;
        rst_n = 0;
        en = 0;
        x = 2'b0;
        y = 2'b0;
        #2
        rst_n =1;
        #1 // j = -3
        en = 1;
        x.plus = 1;
        y.plus = 1;
        #2 // j = -2
        y.plus = 0;
        #2 // j = -1
        x.plus = 0;
        y.plus = 1;
        #2 // j = 0
        x.plus = 0;
        x.minus = 1;
        y.plus = 0;
        y.minus = 1;
        #2  // j = 1
        x.plus = 1;
        x.minus = 0;
        #2 // j = 2 
        x.plus = 0;
        y.plus = 1;
        y.minus = 0;
        #2 // j = 3
        x.minus = 1;
        #2 // j = 4
        x.plus = 1;
        x.minus = 0;
        y.plus = 0;
        #2
        en = 0;
        x.plus = 0;
        #2
        $finish;
    end

    always begin 
        #1 clk = ~clk;
    end
    
endmodule