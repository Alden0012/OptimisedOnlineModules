import rbr_pkg::*;
module so3s_2D #(
        parameter WIDTH = 32,
        parameter TRUNCATED_WIDTH = 32
    ) (
        /* TO PREVENT QUARTUS OPT */
        // input logic[WIDTH+3-1:0] xp_in,
        // input logic[WIDTH+3-1:0] xm_in,
        // input logic[WIDTH+3-1:0] yp_in,
        // input logic[WIDTH+3-1:0] ym_in,
        // input logic[WIDTH+3-1:0] zp_in,
        // input logic[WIDTH+3-1:0] zm_in,
        // input logic[WIDTH+3-1:0] ws_in,
        // input logic[WIDTH+3-1:0] wc_in,
        /* COMMENT OUT ABOVE SIGNALS WHEN TESTING */
        input logic en,
        input signed_digit x[WIDTH-1:0],
        input signed_digit y[WIDTH-1:0],
        input signed_digit z[WIDTH-1:0],
        output logic[WIDTH-1:0][3:0]  s
    );

    localparam ONLINE_DELAY = 0;
    localparam IB_WIDTH = 3;
    localparam STAGES = ONLINE_DELAY + WIDTH;
    localparam RESIDUAL_WIDTH = IB_WIDTH + STAGES;

    function int evaluate_width(int j);
    if(TRUNCATED_WIDTH!=WIDTH)
        if(j < TRUNCATED_WIDTH)
            evaluate_width = j+1;
        else
            evaluate_width = TRUNCATED_WIDTH+1 - 3 * (j-TRUNCATED_WIDTH);
    else
        evaluate_width = WIDTH;
    endfunction

    logic [STAGES:0][RESIDUAL_WIDTH-1:0] acc_xp, acc_xm , acc_yp, acc_ym, acc_zp, acc_zm, ws, wc;
    
    genvar i;
    generate 
        for(i = 0; i < STAGES; i++)
        begin : generate_stages
        so3s_2D_stage #(
                .FULL_WIDTH(RESIDUAL_WIDTH),
                .WIDTH(evaluate_width(i)),
                .IB_WIDTH(IB_WIDTH),
                .J(i)
        ) so3s_row (
                .en(en),
                .xp_prev(acc_xp[i]),
                .xm_prev(acc_xm[i]),
                .yp_prev(acc_yp[i]),
                .ym_prev(acc_ym[i]),
                .zp_prev(acc_zp[i]),
                .zm_prev(acc_zm[i]),
                .ws_prev(ws[i]),
                .wc_prev(wc[i]),
                .x(x[i]),
                .y(y[i]),
                .z(z[i]),
                .s(s[i]),
                .xp_next(acc_xp[i+1]),
                .xm_next(acc_xm[i+1]),
                .yp_next(acc_yp[i+1]),
                .ym_next(acc_ym[i+1]),
                .zp_next(acc_zp[i+1]),
                .zm_next(acc_zm[i+1]),
                .ws_next(ws[i+1]),
                .wc_next(wc[i+1])
            );        
        end
    endgenerate

    always_comb
    begin 
        /* UNCOMMENT BELOW WHEN TESTING */
        acc_xp[0] = 0;
        acc_xm[0] = 0;
        acc_yp[0] = 0;
        acc_ym[0] = 0;
        acc_zp[0] = 0;
        acc_zm[0] = 0;
        ws[0] = 0;
        wc[0] = 0;
        /* COMMENT BELOW WHEN TESTING */
        // acc_xp[0] = xp_in;
        // acc_xm[0] = xm_in;
        // acc_yp[0] = yp_in;
        // acc_ym[0] = ym_in;
        // acc_zp[0] = zp_in;
        // acc_zm[0] = zm_in;
        // ws[0] = ws_in;
        // wc[0] = wc_in;
    end

endmodule