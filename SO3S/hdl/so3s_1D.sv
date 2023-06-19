import rbr_pkg::*;
module so3s_1D #(
    parameter WIDTH = 32,
    parameter TRUNCATED_WIDTH = 24
    ) (
        input logic clk,
        input logic rst_n,
        input logic en,
        input signed_digit x,
        input signed_digit y,
        input signed_digit z,
        output logic[3:0] s
    );
    localparam ONLINE_DELAY = 0;
    localparam IB_WIDTH = 3;
    localparam RESIDUAL_WIDTH = TRUNCATED_WIDTH+ONLINE_DELAY+IB_WIDTH-1;
    localparam CS_FRAC_RANGE = ONLINE_DELAY+TRUNCATED_WIDTH-1;
    reg[RESIDUAL_WIDTH-1:0] acc_xp, acc_xm , acc_yp, acc_ym, acc_zp, acc_zm;
    logic[RESIDUAL_WIDTH-1:0] acc_xp_b, acc_xm_b , acc_yp_b, acc_ym_b, acc_zp_b, acc_zm_b;
    logic[RESIDUAL_WIDTH-1:0] xp, xm , yp, ym, zp, zm;
    logic[RESIDUAL_WIDTH-1:0] mulapp_xp , mulapp_xm, mulapp_yp, mulapp_ym, mulapp_zp, mulapp_zm;
    logic[RESIDUAL_WIDTH-1:0] x_sqr,y_sqr,z_sqr;
    logic[RESIDUAL_WIDTH-1:0] vs,vc,ws,wc;
    logic[3:0] v, vs_hat, vc_hat;
    logic append_en;
    logic[$clog2(WIDTH+ONLINE_DELAY)-1:0] j;

    so3s_append #(
        .X_WIDTH(TRUNCATED_WIDTH),
        .WIDTH(RESIDUAL_WIDTH)
    ) x_append (
        .x(x),
        .en(en),
        .append_en(append_en),
        .xp_prev(acc_xp),
        .xm_prev(acc_xm),
        .j(j),
        .xp(mulapp_xp),
        .xm(mulapp_xm),
        .Q(xp),
        .QM(xm)
    );

    so3s_append #(
        .X_WIDTH(TRUNCATED_WIDTH),
        .WIDTH(RESIDUAL_WIDTH)
    ) y_append (
        .x(y),
        .en(en),
        .append_en(append_en),
        .xp_prev(acc_yp),
        .xm_prev(acc_ym),
        .j(j),
        .xp(mulapp_yp),
        .xm(mulapp_ym),
        .Q(yp),
        .QM(ym)
    );

    so3s_append #(
        .X_WIDTH(TRUNCATED_WIDTH),
        .WIDTH(RESIDUAL_WIDTH)
    ) z_append (
        .x(z),
        .en(en),
        .append_en(append_en),
        .xp_prev(acc_zp),
        .xm_prev(acc_zm),
        .j(j),
        .xp(mulapp_zp),
        .xm(mulapp_zm),
        .Q(zp),
        .QM(zm)
    );

    csa_5_2 #(
        .WIDTH(RESIDUAL_WIDTH)
    ) csa (
        .a(ws),
        .b(wc),
        .c(x_sqr),
        .d(y_sqr),
        .e(z_sqr),
        .cin1('0),
        .cin2('0),
        .sum(vs),
        .carry(vc)
    );


    always_ff @(posedge clk)
    begin 
        if(!rst_n)
        begin 
            j <= '0;
            ws <= '0;
            wc <= '0;
            acc_xp <= '0;
            acc_xm <= '0;
            acc_yp <= '0;
            acc_ym <= '0;
            acc_zp <= '0;
            acc_zm <= '0;
        end
        else 
        begin 
            if(en)
            begin 
                j <= j + 1;
                ws <=  vs[RESIDUAL_WIDTH-IB_WIDTH-1:0] << 1;
                wc <=  vc[RESIDUAL_WIDTH-IB_WIDTH-1:0] << 1;
                acc_xp <= acc_xp_b;
                acc_xm <= acc_xm_b;
                acc_yp <= acc_yp_b;
                acc_ym <= acc_ym_b;
                acc_zp <= acc_zp_b;
                acc_zm <= acc_zm_b;
            end
        end
    end



    always_comb
    begin
        acc_xp_b = xp;
        acc_xm_b = xm;
        acc_yp_b = yp;
        acc_ym_b = ym;
        acc_zp_b = zp;
        acc_zm_b = zm;

        append_en = en && (j-1 < TRUNCATED_WIDTH);
        vs_hat = vs[RESIDUAL_WIDTH-1-:IB_WIDTH];
        vc_hat = vc[RESIDUAL_WIDTH-1-:IB_WIDTH];
        v = vs_hat + (vc_hat << 1);
        //v = vs[RESIDUAL_WIDTH-1-:IB_WIDTH]+(vc[RESIDUAL_WIDTH-1-:IB_WIDTH]<<1);
        s = v;
        case({x.plus,x.minus})
            2'b10:      x_sqr = mulapp_xp;
            2'b01:      x_sqr = -mulapp_xp;    
            default:    x_sqr = 0;
        endcase
        case({y.plus,y.minus})
            2'b10:      y_sqr = mulapp_yp;
            2'b01:      y_sqr = -mulapp_yp;    
            default:    y_sqr = 0;
        endcase
        case({z.plus,z.minus})
            2'b10:      z_sqr = mulapp_zp;
            2'b01:      z_sqr = -mulapp_zp;    
            default:    z_sqr = 0;
        endcase        
    end
endmodule