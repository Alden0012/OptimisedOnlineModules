module so3s_2D_wrapper #(
        parameter WIDTH = 32,
        parameter TRUNCATED_WIDTH = 24
    ) (
        input logic clk,
        input logic rst_n,
        input signed_digit x[WIDTH-1:0],
        input signed_digit y[WIDTH-1:0],
        input signed_digit z[WIDTH-1:0],
        output logic[WIDTH-1:0][3:0]  s
    );

    signed_digit x_r[WIDTH-1:0], y_r[WIDTH-1:0], z_r[WIDTH-1:0];
    logic[WIDTH-1:0][3:0] s_b;

    so3s_2D #(
        .WIDTH(WIDTH),
        .TRUNCATED_WIDTH(TRUNCATED_WIDTH)
    ) so3s (
        .en('1),
        .x(x_r),
        .y(y_r),
        .z(z_r),
        .s(s_b)
    );

    always_ff @(posedge clk)
    begin 
        if(!rst_n)
        begin
		 for(int i = 0;i<WIDTH;i++)
			begin 
            x_r[i] <= 2'b00;
            y_r[i] <= 2'b00;
            z_r[i] <= 2'b00;
			end
            s <= '0;
        end
        else
        begin
            x_r <= x; 
            y_r <= y;
            z_r <= z;
            s <= s_b;
        end
    end

endmodule