impls=multiply_add_1D multiply_add_1D_tb multiply_add_2D multiply_add_2D_tb

multiply_add_1D:
	iverilog -g 2012 -o multiply_add_1D ../Primitives/rbr_pkg.sv hdl/multiply_add_1D.sv hdl/multiply_add_stage.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv 

multiply_add_1D_tb:
	iverilog -g 2012 -o multiply_add_1D_tb ../Primitives/rbr_pkg.sv tb/multiply_add_1D_tb.sv hdl/multiply_add_1D.sv hdl/multiply_add_stage.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv 

multiply_add_2D:
	iverilog -g 2012 -o multiply_add_2D ../Primitives/rbr_pkg.sv hdl/multiply_add_2D.sv hdl/multiply_add_stage.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv

multiply_add_2D_tb:
	iverilog -g 2012 -o multiply_add_2D_tb ../Primitives/rbr_pkg.sv tb/multiply_add_2D_tb.sv hdl/multiply_add_2D.sv hdl/multiply_add_stage.sv ../Primitives/csa_4_2.sv ../Primitives/csa_4_2_bitslice.sv 
clean:
	rm -f $(impls) *.o
	rm -f $(impls) *.vcd