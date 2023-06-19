import rbr_pkg::*;
module ca_reg_2d
    #(
        parameter           WIDTH = 16,
        parameter           J = 0
    ) (
        input logic [WIDTH-1:0]     xp_in,
        input logic [WIDTH-1:0]     xm_in,
        input signed_digit          x,
        output logic [WIDTH-1:0]    xp,
        output logic [WIDTH-1:0]    xm
    );


    localparam SHIFT_AMOUNT = ((WIDTH-1)>J) ? WIDTH-1-J : J-WIDTH+1;

    always_comb
    begin 
            xp = '0;
            xm = '0;
            if(x.plus && !x.minus)
            begin 
                xp   =  xp_in | (x.plus << SHIFT_AMOUNT); 
                xm  =  xp_in;
            end
            else if(!x.plus && x.minus)
            begin 
                xp   =  xm_in | (x.minus << SHIFT_AMOUNT);
                xm  =  xm_in;
            end 
            else 
            begin 
                xp   =  xp_in | (x.plus << SHIFT_AMOUNT); 
                xm  =  xm_in | ('1 << SHIFT_AMOUNT);
            end
    end



endmodule