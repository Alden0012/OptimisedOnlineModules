module online_mult_1D
    import rbr_pkg::*;
    #(
        parameter WIDTH = 32,
		  parameter TRUNCATED_WIDTH = 26
    ) (
        input logic clk,
        input logic rst_n,
        input logic en,
        input signed_digit x,
        input signed_digit y,
        output signed_digit z
    );
	 localparam IB_WIDTH = 2;
	 localparam RESIDUAL_WIDTH = WIDTH+IB_WIDTH;
    logic[WIDTH-1:0] x_prev, x_minus, x_plus, y_minus, y_plus;
    logic[RESIDUAL_WIDTH-1:0] ws,wc;
    logic[RESIDUAL_WIDTH-1:0] vs,vc,x_sel,y_sel;
    logic[3:0] v_hat;
    signed_digit z_b;
    logic[2:0] m;

    ca_reg #(
        .WIDTH(WIDTH)
    ) ca_x(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .x(x),
        .x_plus(x_plus),
        .x_minus(x_minus)
    );

    ca_reg #(
        .WIDTH(WIDTH)
    ) ca_y(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .x(y),
        .x_plus(y_plus),
        .x_minus(y_minus)
    );

    csa_4_2 #(
        .WIDTH(RESIDUAL_WIDTH),
        .TRUNCATED_WIDTH(TRUNCATED_WIDTH+IB_WIDTH)
    ) csa (
        .a($signed(x_sel) >>> 3),
        .b($signed(y_sel) >>> 3),
        .c(ws),
        .d(wc),
        .cin1(x.minus && !x.plus),
        .cin2(y.minus && !y.plus),
        .ws(vs),
        .wc(vc)
    );

    selm sel(
        .v(v_hat[3:1]),
        .p(z_b)
    );

    always_ff @(posedge clk)
    begin 
        if(!rst_n)
        begin 
            ws <= 0;
            wc <= 0;
            z <= 0;
            x_prev <= 0;
        end
        else 
        begin
            ws <= {m,vs[WIDTH-3:0]} << 1;
            wc <= vc[WIDTH-3:0] << 1;
            z <= z_b;
            x_prev <= x_plus;
        end
    end
    always_comb
    begin 
        x_sel = !(y.plus^y.minus) ? 0 : (y.minus ? ~x_prev : x_prev);
        y_sel = !(x.plus^x.minus) ? 0 : (x.minus ? ~y_plus : y_plus);
        v_hat = vs[RESIDUAL_WIDTH-1-:IB_WIDTH+2] + (vc[RESIDUAL_WIDTH-1-:IB_WIDTH+2] << 1);
        m = {v_hat[2]^(z_b.plus^z_b.minus),v_hat[1:0]};
    end


endmodule
