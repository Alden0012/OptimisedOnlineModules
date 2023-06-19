import rbr_pkg::*;
module online_divider_stage #(
        parameter TRUNCATED_WIDTH = 15,
        parameter RESIDUAL_WIDTH = 15
    ) (
        input logic init_end,
        input logic[RESIDUAL_WIDTH-1:0]  ws_prev,
        input logic[RESIDUAL_WIDTH-1:0]  wc_prev,
        input logic[RESIDUAL_WIDTH-1:0]  q_acc_prev,
        input logic[RESIDUAL_WIDTH-1:0]  d_acc,
        input signed_digit x,
        input signed_digit d,
        output signed_digit q,
        output logic[RESIDUAL_WIDTH-1:0] ws,
        output logic[RESIDUAL_WIDTH-1:0] wc
    );
    localparam IB_WIDTH = 2;
    localparam ONLINE_DELAY = 4;
    localparam SHIFT_AMOUNT = RESIDUAL_WIDTH-IB_WIDTH-ONLINE_DELAY;
    logic[RESIDUAL_WIDTH-1:0] dq, qd, x_shifted, vs,vc;
    logic c_d,c_q,c_x;
    logic[4:0] v_hat;

    csa_4_2 #(
        .WIDTH(RESIDUAL_WIDTH),
        .TRUNCATED_WIDTH(TRUNCATED_WIDTH)
    ) csa_1 (
        .a(x_shifted),
        .b(dq),
        .c(ws_prev),
        .d(wc_prev),
        .cin1(c_d),
        .cin2(c_x),
        .ws(vs),
        .wc(vc)
    );

    csa_4_2 #(
        .WIDTH(RESIDUAL_WIDTH),
        .TRUNCATED_WIDTH(TRUNCATED_WIDTH)
    ) csa_2 (
        .a(vs),
        .b(vc),
        .c(qd),
        .d('0),
        .cin1(c_q),
        .cin2('0),
        .ws(ws),
        .wc(wc)
    );

    seld seld(
        .v_hat(v_hat[4:1]),
        .q(q)
    );

    always_comb
    begin 
        v_hat = vs[RESIDUAL_WIDTH-1-:5] + (vc[RESIDUAL_WIDTH-1-:5] << 1);
        c_d = d.plus&&!d.minus;
        c_x = x.minus&&!x.plus;
        c_q = init_end ? q.plus&&!q.minus : 0;

        case({x.plus,x.minus})
            2'b10: x_shifted = (1<<SHIFT_AMOUNT);
            2'b01: x_shifted = ~(1<<SHIFT_AMOUNT);
            default: x_shifted = 0;
        endcase
        case({d.plus,d.minus})
            2'b10: dq = ~(q_acc_prev>>4);
            2'b01: dq = q_acc_prev>>4;
            default: dq = '0;
        endcase
        if(init_end)
        case({q.plus,q.minus})
            2'b10: qd = ~d_acc;
            2'b01: qd = d_acc; 
            default: qd = '0;
        endcase
        else
            qd = '0;

    end




endmodule