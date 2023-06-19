import rbr_pkg::*;
module online_divider_2D_wrapper #(
    parameter WIDTH = 15,
    parameter P = 14
) (
    input wire clk,
    input wire rst_n,
    input signed_digit x[WIDTH-1:0],
    input signed_digit d[WIDTH-1:0],
    output signed_digit q[WIDTH-1:0]
);

    signed_digit x_reg[WIDTH-1:0];
    signed_digit d_reg[WIDTH-1:0];
    signed_digit q_reg[WIDTH-1:0];

    online_divider_2D #(
        .WIDTH(WIDTH),
        .P(P)
    ) u_online_div_2D (
        .x(x_reg),
        .d(d_reg),
        .q(q_reg)
    );

    always @(posedge clk) begin
        if (!rst_n) begin
		  for(int i = 0;i<WIDTH;i++)
		  begin
            x_reg[i] <= '0;
            d_reg[i] <= '0;
            q[i] <= '0;
			end
        end else begin
            x_reg <= x;
            d_reg <= d;
            q <= q_reg;
        end
    end


endmodule