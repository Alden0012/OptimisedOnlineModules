import rbr_pkg::*;
module online_divider_1D #(
        parameter WIDTH = 48,
        parameter TRUNCATED_WIDTH = 39
    ) (
      input logic clk,
      input logic rst_n,
      input logic en,
      input signed_digit x,
      input signed_digit d,
      output signed_digit q
    );
    localparam IB_WIDTH = 2;
    localparam ONLINE_DELAY = 4;
    localparam STAGES = ONLINE_DELAY + WIDTH;
    localparam J = $clog2(STAGES);
    localparam RESIDUAL_WIDTH = TRUNCATED_WIDTH + IB_WIDTH;
    logic[RESIDUAL_WIDTH-1:0] ws,wc,ws_b,wc_b,d_acc,q_acc,q_acc_prev;
    logic[WIDTH-1:0] d_reg, q_reg;
    logic[J-1:0] j;
    logic init_end;

    ca_reg #(
        .WIDTH(WIDTH)
    ) ca_d (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .x(d),
        .x_plus(d_reg),
        .x_minus()
    );

    ca_reg #(
        .WIDTH(WIDTH)
    ) ca_q (
        .clk(clk),
        .rst_n(rst_n),
        .en(init_end),
        .x(q),
        .x_plus(q_reg),
        .x_minus()
    );

    online_divider_stage #(
        .TRUNCATED_WIDTH(RESIDUAL_WIDTH),
        .RESIDUAL_WIDTH(RESIDUAL_WIDTH)
    ) divider_block (
        .init_end(init_end),
        .ws_prev(ws),
        .wc_prev(wc),
        .q_acc_prev(q_acc_prev),
        .d_acc(d_acc),
        .x(x),
        .d(d),
        .q(q),
        .ws(ws_b),
        .wc(wc_b)
    );

    always_ff @(posedge clk)
    begin 
        if(!rst_n)
        begin 
            ws <= 0;
            wc <= 0;
            q_acc_prev <= 0;
            j <= 0;
        end
        else 
        begin
            if(en)
            begin 
            ws <= $signed(ws_b)<<<1;
            wc <= $signed(wc_b)<<<1;
            q_acc_prev <= q_acc;
            j <= j+1;
            end
        end
    end

    always_comb 
    begin 
        init_end = (j-1) >= ONLINE_DELAY;
        // d_acc = ($signed(d_reg) >>> SHIFT_AMOUNT) <<< 1;
        // q_acc = ($signed(q_reg) >>> SHIFT_AMOUNT) <<< 1;
        if(RESIDUAL_WIDTH > WIDTH)
        begin 
            d_acc = (d_reg << (RESIDUAL_WIDTH-WIDTH))>> 1;
            q_acc = (q_reg << (RESIDUAL_WIDTH-WIDTH))>> 1;
        end 
        else
        begin
            d_acc = (d_reg >> (WIDTH-RESIDUAL_WIDTH))>> 1;
            q_acc = (q_reg >> (WIDTH-RESIDUAL_WIDTH))>> 1;     
        end
    end


endmodule