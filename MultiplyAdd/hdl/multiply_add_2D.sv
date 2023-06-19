module multiply_add_2D #(
        parameter WIDTH = 32,
        parameter P = 22,
        parameter M = 48
    ) (
        // /* QUARTUS OPT */
        // input logic[MAX_RESIDUAL_PRECISION-1:0] ws_in,
        // input logic[MAX_RESIDUAL_PRECISION-1:0] wc_in,
        // /*             */
        input logic[M-1:0] a,
        input logic[WIDTH-1:0][2:0] x,
        input logic[WIDTH-1:0][2:0] c,
        output logic[WIDTH-1:0][2:0] y
    );
    localparam ONLINE_DELAY = 2;
    localparam IB_WIDTH = 3;
    localparam STAGES = WIDTH + ONLINE_DELAY;
    localparam MAX_RESIDUAL_PRECISION = ONLINE_DELAY+M+IB_WIDTH;

    logic[STAGES:0][MAX_RESIDUAL_PRECISION-1:0] ws,wc;
    logic[STAGES-1:0][2:0] z,x_arr,c_arr;
    logic[STAGES-1:0][$clog2(STAGES)-1:0] j;

    function int evaluate_width(int j);
	 if(WIDTH==P)
		evaluate_width = MAX_RESIDUAL_PRECISION;
	 else
        if(j < P)
            evaluate_width = MAX_RESIDUAL_PRECISION;
        else if(j < WIDTH)
            evaluate_width = MAX_RESIDUAL_PRECISION - 4 * (j+1-P);
        else 
            evaluate_width = MAX_RESIDUAL_PRECISION - 4 * (WIDTH-P) - 2 * (j+1-WIDTH);
    endfunction

    genvar i;
    generate
        for(i = 0;i<STAGES;i++)
        begin : generate_rows
            multiply_add_stage #(
                .TRUNCATED_WIDTH(evaluate_width(i)),
                .M(M),
                .RESIDUAL_WIDTH(MAX_RESIDUAL_PRECISION),
                .J($clog2(STAGES))
            ) madd_stage (
                .ws_prev(ws[i]),
                .wc_prev(wc[i]),
                .j(j[i]),
                .x(x_arr[i]),
                .c(c_arr[i]),
                .y(z[i]),
                .a(a),
                .ws_next(ws[i+1]),
                .wc_next(wc[i+1])
            );
        end
    endgenerate

    always_comb 
    begin 
    // ws[0] = ws_in;
    // wc[0] = wc_in;
    wc[0] = 0;
    ws[0] = 0;
        for(int i = 0;i<WIDTH;i++)
        begin
            j[i] = i;
            x_arr[i] = x[i];
            c_arr[i] = c[i];
        end
        for(int i = WIDTH;i<STAGES;i++)
        begin 
            j[i] = i;
            x_arr[i] = '0;
            c_arr[i] = '0;
        end
    end
    assign y = z[STAGES-1-:WIDTH];
    

endmodule