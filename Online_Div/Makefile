impls=online_divider_1D online_divider_1D_tb online_divider_2D online_divider_2D_tb

online_divider_1D:
	iverilog -g 2012 -o online_divider_1D ../Primitives/rbr_pkg.sv hdl/online_divider_1D.sv hdl/online_divider_stage.sv hdl/seld.sv ../Primitives/ca_reg.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv 

online_divider_1D_tb:
	iverilog -g 2012 -o online_divider_1D_tb ../Primitives/rbr_pkg.sv tb/online_divider_1D_tb.sv hdl/online_divider_1D.sv hdl/online_divider_stage.sv hdl/seld.sv ../Primitives/ca_reg.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv 

online_divider_2D:
	iverilog -g 2012 -o online_divider_2D ../Primitives/rbr_pkg.sv hdl/online_divider_2D.sv hdl/online_divider_stage.sv hdl/seld.sv ../Primitives/ca_reg_2d.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv 

online_divider_2D_tb:
	iverilog -g 2012 -o online_divider_2D_tb ../Primitives/rbr_pkg.sv tb/online_divider_2D_tb.sv hdl/online_divider_2D.sv hdl/online_divider_stage.sv hdl/seld.sv ../Primitives/ca_reg_2d.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv 

clean:
	rm -f $(impls) *.o
	rm -f $(impls) *.vcd
