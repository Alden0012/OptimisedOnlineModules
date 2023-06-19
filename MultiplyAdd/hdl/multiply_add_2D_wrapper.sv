module multiply_add_2D_wrapper #(
        parameter WIDTH = 16,
        parameter P = 6,
        parameter M = 48
    ) (
        input logic clk,
        input logic rst_n,
        input logic[M-1:0] a,
        input logic[WIDTH-1:0][2:0] x,
        input logic[WIDTH-1:0][2:0] c,
        output logic[WIDTH-1:0][2:0] y
    );

    logic[WIDTH-1:0][2:0] x_r, c_r, y_b;
    logic[M-1:0] a_r;

    multiply_add_2D #(
        .WIDTH(WIDTH),
        .P(P),
        .M(M)
    ) multiply_add_module (
        .a(a_r),
        .x(x_r),
        .c(c_r),
        .y(y_b)
    );

    always_ff @(posedge clk)
    begin 
        if(!rst_n)
        begin 
            a_r <= '0;
            x_r <= '0;
            c_r <= '0;
            y <= '0;
        end
        else
        begin
            a_r <= a;
            x_r <= x;
            c_r <= c;
            y <= y_b;
        end
    end
endmodule