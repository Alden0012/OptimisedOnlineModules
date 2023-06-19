module multiply_add_1D #(
        parameter WIDTH = 21,
        parameter TRUNCATED_WIDTH = 21,
        parameter M = 16
    ) (
        input logic clk,
        input logic rst_n,
        input logic en,
        input logic[M-1:0] a,
        input logic[2:0] x,
        input logic[2:0] c,
        output logic[2:0] y
    );
    localparam IB_WIDTH = 3;
    localparam ONLINE_DELAY = 2;
    localparam STAGES = WIDTH+ONLINE_DELAY;
    localparam BETA = 5;
    localparam RESIDUAL_WIDTH = M + ONLINE_DELAY + IB_WIDTH;
    logic [RESIDUAL_WIDTH-1:0]    ws,wc,vs,vc;
    logic[$clog2(STAGES)-1:0] j;
 
    multiply_add_stage #(
        .TRUNCATED_WIDTH(RESIDUAL_WIDTH),
        .M(M),
        .RESIDUAL_WIDTH(RESIDUAL_WIDTH),
        .J($clog2(STAGES))
    ) multiply_add_block (
        .ws_prev(ws),
        .wc_prev(wc),
        .j(j),
        .x(x),
        .c(c),
        .a(a),
        .y(y),
        .ws_next(vs),
        .wc_next(vc)
    );

    always_ff @(posedge clk)
    begin 
        if(!rst_n)
        begin 
            ws <= 0;
            wc <= 0;
            j <= 0;
        end
        else
        begin
            if(en)
            begin 
            j <= j + 1;
            ws <= vs;
            wc <= vc;
            end
        end
    end


endmodule

