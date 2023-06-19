import rbr_pkg::*;
module online_mult_2D_wrapper #(
    parameter WIDTH = 32,
    parameter P = 26
) (
    input wire clk,
    input wire rst_n,
    input signed_digit x[WIDTH-1:0],
    input signed_digit y[WIDTH-1:0],
    output signed_digit z[WIDTH-1:0]
);

    signed_digit x_reg[WIDTH-1:0];
    signed_digit y_reg[WIDTH-1:0];
    signed_digit z_reg[WIDTH-1:0];

    online_mult_2D #(
        .WIDTH(WIDTH),
        .P(P)
    ) u_online_mult_2D (
        .x(x_reg),
        .y(y_reg),
        .z(z_reg)
    );

    always @(posedge clk) begin
        if (!rst_n) begin
		  for(int i = 0;i<WIDTH;i++)
		  begin
            x_reg[i] <= '0;
            y_reg[i] <= '0;
            z[i] <= '0;
			end
        end else begin
            x_reg <= x;
            y_reg <= y;
            z <= z_reg;
        end
    end


endmodule