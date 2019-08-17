transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/top_level.sv}
vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/full_adder.sv}
vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/reg_8.sv}
vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/HexDriver.sv}
vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/control.sv}
vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/Synchronizers.sv}
vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/9_bit_adder.sv}
vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/ffx.sv}

vlog -sv -work work +incdir+C:/ece385/lab5_multiplier {C:/ece385/lab5_multiplier/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
