import rbr_pkg::*;
module online_mult_bitslice
    #(
    parameter FULL_WIDTH = 21,
    parameter TRUNCATED_WIDTH = 16
    ) (
        input logic[FULL_WIDTH-1:0] x,
        input logic[FULL_WIDTH-1:0] y,
        input logic[FULL_WIDTH-1:0] ws,
        input logic[FULL_WIDTH-1:0] wc,
        input logic cin1,
        input logic cin2,
        output signed_digit z,
        output logic[FULL_WIDTH-1:0] ws_out,
        output logic[FULL_WIDTH-1:0] wc_out
    );
    localparam IB_WIDTH = 2;
    localparam ONLINE_DELAY = 3;
    localparam RESIDUAL_WIDTH = TRUNCATED_WIDTH;
    
    logic[FULL_WIDTH-1:0] x_in,y_in,vs,vc;
    logic[3:0] v_hat;
    logic[2:0] m;

    csa_4_2 #(
        .WIDTH(FULL_WIDTH),
        .TRUNCATED_WIDTH(RESIDUAL_WIDTH)
    ) csa (
        .a(x_in),
        .b(y_in),
        .c(ws),
        .d(wc),
        .cin1(cin1),
        .cin2(cin2),
        .ws(vs),
        .wc(vc)
    );

    selm sel(
        .v(v_hat[3:1]),
        .p(z)
    );

    always_comb
    begin 
        x_in = x >> 3;
        y_in = y >> 3;
        v_hat = vs[FULL_WIDTH-1-:IB_WIDTH+2] + (vc[FULL_WIDTH-1-:IB_WIDTH+2] << 1);
        m = {v_hat[2]^(z.plus^z.minus),v_hat[1:0]};
        ws_out = {m,vs[FULL_WIDTH-IB_WIDTH-2:0]} << 1;
        wc_out = vc[FULL_WIDTH-IB_WIDTH-2:0] << 1;
    end

endmodule