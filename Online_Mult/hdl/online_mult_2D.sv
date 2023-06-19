import rbr_pkg::*;
module online_mult_2D 
    #(  
        parameter WIDTH = 32,
        parameter P = 32
    ) (
        // input logic[P+5-1:0] ws_pipe_in,
        // input logic[P+5-1:0] wc_pipe_in,
        // input logic[P+5-1:0] x_minus_in,
        // input logic[P+5-1:0] x_plus_in,
        // input logic[P+5-1:0] y_minus_in,
        // input logic[P+5-1:0] y_plus_in,
        input signed_digit x[WIDTH-1:0],
        input signed_digit y[WIDTH-1:0],
        output signed_digit z[WIDTH-1:0]
    );
    localparam IB_WIDTH = 2;
    localparam ONLINE_DELAY = 3;
    localparam STAGES = WIDTH + ONLINE_DELAY;
    localparam RESIDUAL_WIDTH = P + IB_WIDTH + ONLINE_DELAY;

    signed_digit x_in[STAGES],y_in[STAGES];
    logic[STAGES:0][P-1:0] x_minus, x_plus, y_minus, y_plus;
    logic[STAGES-1:0][RESIDUAL_WIDTH-1:0] x_sel, y_sel;
    logic[STAGES:0][RESIDUAL_WIDTH-1:0] wc_pipe, ws_pipe;
    signed_digit out[STAGES];
    logic[STAGES-1:0] cin_pipe1, cin_pipe2;

    function int evaluate_width(int j);
        if(WIDTH==P)
        begin 
            evaluate_width = RESIDUAL_WIDTH;
        end
        else
        begin 
            if(j <= P)
            begin 
                evaluate_width = (P > (j+5)) ? 6 + j : P+2;
            end
            else if(j <= WIDTH)
            begin 
                evaluate_width = P+2 - 3*(j-P);
            end
            else
            begin
                evaluate_width = 5 + (STAGES-j);
            end
        end
    endfunction

    genvar i;
    generate
        for(i = 0; i< STAGES;i++) 
        begin : generate_slices
            ca_reg_2d #(
                .WIDTH(P),
                .J(i)
            ) ca_x(
                .xp_in(x_plus[i]),
                .xm_in(x_minus[i]),
                .x(x_in[i]),
                .xp(x_plus[i+1]),
                .xm(x_minus[i+1])
            );

            ca_reg_2d #(
                .WIDTH(P),
                .J(i)
            ) ca_y(
                .xp_in(y_plus[i]),
                .xm_in(y_minus[i]),
                .x(y_in[i]),
                .xp(y_plus[i+1]),
                .xm(y_minus[i+1])
            );

            online_mult_bitslice #(
                .FULL_WIDTH(RESIDUAL_WIDTH),
                .TRUNCATED_WIDTH(evaluate_width(i))
            ) bitslice (
                .x(x_sel[i]),
                .y(y_sel[i]),
                .ws(ws_pipe[i]),
                .wc(wc_pipe[i]),
                .cin1(cin_pipe1[i]),
                .cin2(cin_pipe2[i]),
                .z(out[i]),
                .ws_out(ws_pipe[i+1]),
                .wc_out(wc_pipe[i+1])
            );
        end
    endgenerate

    always_comb 
    begin 
        for(int i = 0;i<WIDTH;i++)
        begin 
            x_in[i] = x[i];
            y_in[i] = y[i];
        end
        for(int i = WIDTH;i<STAGES;i++)
        begin 
            x_in[i] = '0;
            y_in[i] = '0;
        end
        ws_pipe[0] = 0;
        wc_pipe[0] = 0;
        x_minus[0] = 0;
        x_plus[0] = 0;
        y_minus[0] = 0;
        y_plus[0] = 0; 
        // ws_pipe[0] = ws_pipe_in; 
        // wc_pipe[0] = wc_pipe_in; 
        // x_minus[0] = x_minus_in; 
        // x_plus[0] = x_plus_in; 
        // y_minus[0] = y_minus_in; 
        // y_plus[0] = y_plus_in; 

        for(int i = 0;i<STAGES;i++)
        begin 
            cin_pipe1[i] = y_in[i] == 2'b01;
            cin_pipe2[i] = x_in[i] == 2'b01;
            case(y_in[i])
                2'b10:  x_sel[i] = x_plus[i];
                2'b01:  x_sel[i] = ~x_plus[i];
                default: x_sel[i] = 0;
            endcase
            case(x_in[i])
                2'b10:  y_sel[i] = y_plus[i+1];
                2'b01:  y_sel[i] = ~y_plus[i+1];
                default: y_sel[i] = 0;
            endcase
        end

        for(int i = ONLINE_DELAY;i<STAGES;i++)
        begin 
            z[i-ONLINE_DELAY] = out[i];
        end
    end

endmodule
