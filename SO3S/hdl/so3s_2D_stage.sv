import rbr_pkg::*;
module so3s_2D_stage #(
        parameter FULL_WIDTH=15,
        parameter WIDTH = 15,
        parameter IB_WIDTH=3,
        parameter J = 0
    ) (
        input logic en,
        input logic[FULL_WIDTH-1:0] xp_prev,
        input logic[FULL_WIDTH-1:0] xm_prev,
        input logic[FULL_WIDTH-1:0] yp_prev,
        input logic[FULL_WIDTH-1:0] ym_prev,
        input logic[FULL_WIDTH-1:0] zp_prev,
        input logic[FULL_WIDTH-1:0] zm_prev,
        input logic[FULL_WIDTH-1:0] ws_prev,
        input logic[FULL_WIDTH-1:0] wc_prev,
        input signed_digit x,
        input signed_digit y,
        input signed_digit z,
        output logic[3:0] s,
        output logic[FULL_WIDTH-1:0] xp_next,
        output logic[FULL_WIDTH-1:0] xm_next,
        output logic[FULL_WIDTH-1:0] yp_next,
        output logic[FULL_WIDTH-1:0] ym_next,
        output logic[FULL_WIDTH-1:0] zp_next,
        output logic[FULL_WIDTH-1:0] zm_next,
        output logic[FULL_WIDTH-1:0] ws_next,
        output logic[FULL_WIDTH-1:0] wc_next
    );
    localparam RESIDUAL_WIDTH = IB_WIDTH+WIDTH;
    logic[RESIDUAL_WIDTH-1:0] xp_prev_t,xm_prev_t,yp_prev_t,ym_prev_t,zp_prev_t,zm_prev_t,ws_prev_t,wc_prev_t;
    logic[RESIDUAL_WIDTH-1:0] xp_next_t,xm_next_t,yp_next_t,ym_next_t,zp_next_t,zm_next_t,ws_next_t,wc_next_t;
    logic[RESIDUAL_WIDTH-1:0] mul_xp, mul_xm, mul_yp, mul_ym, mul_zp, mul_zm, mul_ws, mul_wc;
    logic[RESIDUAL_WIDTH-1:0] x_sqr,y_sqr,z_sqr;
    logic[RESIDUAL_WIDTH-1:0] vs,vc,ws,wc;
    logic[3:0] v;
    so3s_append_2D #(
        .X_WIDTH(WIDTH),
        .WIDTH(RESIDUAL_WIDTH),
        .J(J)
    ) x_append (
        .x(x),
        .en(en),
        .append_en(en),
        .xp_prev(xp_prev_t),
        .xm_prev(xm_prev_t),
        .xp(mul_xp),
        .xm(mul_xm),
        .Q(xp_next_t),
        .QM(xm_next_t)
    );

    so3s_append_2D #(
        .X_WIDTH(WIDTH),
        .WIDTH(RESIDUAL_WIDTH),
        .J(J)
    ) y_append (
        .x(y),
        .en(en),
        .append_en(en),
        .xp_prev(yp_prev_t),
        .xm_prev(ym_prev_t),
        .xp(mul_yp),
        .xm(mul_ym),
        .Q(yp_next_t),
        .QM(ym_next_t)
    );

    so3s_append_2D #(
        .X_WIDTH(WIDTH),
        .WIDTH(RESIDUAL_WIDTH),
        .J(J)
    ) z_append (
        .x(z),
        .en(en),
        .append_en(en),
        .xp_prev(zp_prev_t),
        .xm_prev(zm_prev_t),
        .xp(mul_zp),
        .xm(mul_zm),
        .Q(zp_next_t),
        .QM(zm_next_t)
    );

    csa_5_2 #(
        .WIDTH(RESIDUAL_WIDTH)
    ) csa (
        .a(ws_prev_t),
        .b(wc_prev_t),
        .c(x_sqr),
        .d(y_sqr),
        .e(z_sqr),
        .cin1('0),
        .cin2('0),
        .sum(vs),
        .carry(vc)
    );

    always_comb
    begin 
        xp_prev_t = xp_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 
        xm_prev_t = xm_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 
        yp_prev_t = yp_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 
        ym_prev_t = ym_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 
        zp_prev_t = zp_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 
        zm_prev_t = zm_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 
        ws_prev_t = ws_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 
        wc_prev_t = wc_prev >> (FULL_WIDTH-RESIDUAL_WIDTH); 

        v = vs[RESIDUAL_WIDTH-1-:IB_WIDTH]+(vc[RESIDUAL_WIDTH-1-:IB_WIDTH]<<1);
        ws_next_t = vs[RESIDUAL_WIDTH-IB_WIDTH-1:0] << 1;
        wc_next_t = vc[RESIDUAL_WIDTH-IB_WIDTH-1:0] << 1;

        xp_next = xp_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);
        xm_next = xm_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);
        yp_next = yp_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);
        ym_next = ym_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);
        zp_next = zp_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);
        zm_next = zm_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);
        ws_next = ws_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);
        wc_next = wc_next_t << (FULL_WIDTH-RESIDUAL_WIDTH);

        s = v;
        case({x.plus,x.minus})
            2'b10:      x_sqr = mul_xp;
            2'b01:      x_sqr = -mul_xp;    
            default:    x_sqr = 0;
        endcase
        case({y.plus,y.minus})
            2'b10:      y_sqr = mul_yp;
            2'b01:      y_sqr = -mul_yp;    
            default:    y_sqr = 0;
        endcase
        case({y.plus,y.minus})
            2'b10:      z_sqr = mul_zp;
            2'b01:      z_sqr = -mul_zp;    
            default:    z_sqr = 0;
        endcase     
    end
    



endmodule