import rbr_pkg::*;
module online_divider_2D #(
        parameter WIDTH = 15,
        parameter P = 15
    ) (
	 /* QUARTUS OPT */
        // input logic[P+2-1:0] ws_in,
        // input logic[P+2-1:0] wc_in,
        // input logic[WIDTH-1:0] dp_in,
        // input logic[WIDTH-1:0] dm_in,
        // input logic[WIDTH-1:0] qp_in,
        // input logic[WIDTH-1:0] qm_in,
	/* 				 */
        input signed_digit x[WIDTH-1:0],
        input signed_digit d[WIDTH-1:0],
        output signed_digit q[WIDTH-1:0]
    );

    localparam ONLINE_DELAY = 4;
    localparam IB_WIDTH = 2;
    localparam STAGES = WIDTH+ONLINE_DELAY;
    localparam RESIDUAL_WIDTH = P + IB_WIDTH + ONLINE_DELAY;
    logic[STAGES:0][RESIDUAL_WIDTH-1:0] ws,wc, d_acc, q_acc;
    logic[STAGES:0][WIDTH-1:0] dp_acc, dm_acc, qp_acc, qm_acc;
    signed_digit[STAGES-1:0] x_in,d_in,q_in;

    function int evaluate_width(int j);
    if(WIDTH==P)
        evaluate_width = RESIDUAL_WIDTH;
    else
        if(j < ONLINE_DELAY)
            evaluate_width = ONLINE_DELAY+IB_WIDTH+1;
        else if(j < P)
            evaluate_width = (ONLINE_DELAY+IB_WIDTH+1)+j < P+IB_WIDTH ? (ONLINE_DELAY+IB_WIDTH+1)+j : P+IB_WIDTH;
        else if(j < WIDTH)
            evaluate_width = P+2 - 3 * (j+1-P);
        else
            evaluate_width = 5 + 2 * (STAGES-(j+1));     
    endfunction

    genvar i;
    generate 
        for(i = 0;i<STAGES;i++)
        begin : generate_slices 
            ca_reg_2d #(
                .WIDTH(WIDTH),
                .J(i)
            ) ca_d(
                .xp_in(dp_acc[i]),
                .xm_in(dm_acc[i]),
                .x(d_in[i]),
                .xp(dp_acc[i+1]),
                .xm(dm_acc[i+1])
            );

            if(i >= ONLINE_DELAY)
                ca_reg_2d #(
                    .WIDTH(WIDTH),
                    .J(i-ONLINE_DELAY)
                ) ca_q(
                    .xp_in(qp_acc[i]),
                    .xm_in(qm_acc[i]),
                    .x(q_in[i]),
                    .xp(qp_acc[i+1]),
                    .xm(qm_acc[i+1])
                ); 
            else
            begin
                assign qp_acc[i] = 0;
                assign qm_acc[i] = 0;
            end          

            online_divider_stage #(
                .TRUNCATED_WIDTH(evaluate_width(i)),
                .RESIDUAL_WIDTH(RESIDUAL_WIDTH)
            ) divider_block (
                .init_end(i >= ONLINE_DELAY),
                .ws_prev($signed(ws[i])<<<1),
                .wc_prev($signed(wc[i])<<<1),
                .q_acc_prev(q_acc[i]),
                .d_acc(d_acc[i]),
                .x(x_in[i]),
                .d(d_in[i]),
                .q(q_in[i]),
                .ws(ws[i+1]),
                .wc(wc[i+1])
            );

        end
    endgenerate
    
    always_comb 
    begin 
        ws[0] = 0;
        wc[0] = 0;
        dp_acc[0] = 0;
        dm_acc[0] = 0;
        qp_acc[ONLINE_DELAY] = 0;
        qm_acc[ONLINE_DELAY] = 0;
        // ws[0] = ws_in;
        // wc[0] = wc_in;
        // dp_acc[0] = dp_in;
        // dm_acc[0] = dm_in;
        // qp_acc[ONLINE_DELAY] = qp_in;
        // qm_acc[ONLINE_DELAY] = qm_in;
        for(int i = 0;i<STAGES;i++)
        begin 
                if(RESIDUAL_WIDTH > WIDTH)
                begin 
                    q_acc[i] = (qp_acc[i] << (RESIDUAL_WIDTH-WIDTH))>>1;
                    d_acc[i] = (dp_acc[i+1] << (RESIDUAL_WIDTH-WIDTH))>>1;
                end 
                else  
                begin 
                    q_acc[i] = (qp_acc[i] >> (WIDTH-RESIDUAL_WIDTH))>>1;
                    d_acc[i] = (dp_acc[i+1] >> (WIDTH-RESIDUAL_WIDTH))>>1;
                end

            if(i < WIDTH)
            begin
                x_in[i] = x[i];
                d_in[i] = d[i];
            end 
            else
            begin
                x_in[i] = '0;
                d_in[i] = '0;            
            end
        end

        for(int i = ONLINE_DELAY;i<STAGES;i++)
            q[i-ONLINE_DELAY] = q_in[i];

    end
endmodule