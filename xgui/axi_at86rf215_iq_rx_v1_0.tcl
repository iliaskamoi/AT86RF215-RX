
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/axi_at86rf215_iq_rx_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "DESYNC_THRESHOLD"
  ipgui::add_param $IPINST -name "SYNC_THRESHOLD"
  ipgui::add_param $IPINST -name "FIFO_DEPTH"

}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DESYNC_THRESHOLD { PARAM_VALUE.DESYNC_THRESHOLD } {
	# Procedure called to update DESYNC_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DESYNC_THRESHOLD { PARAM_VALUE.DESYNC_THRESHOLD } {
	# Procedure called to validate DESYNC_THRESHOLD
	return true
}

proc update_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to update FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to validate FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.SYNC_THRESHOLD { PARAM_VALUE.SYNC_THRESHOLD } {
	# Procedure called to update SYNC_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_THRESHOLD { PARAM_VALUE.SYNC_THRESHOLD } {
	# Procedure called to validate SYNC_THRESHOLD
	return true
}


proc update_MODELPARAM_VALUE.SYNC_THRESHOLD { MODELPARAM_VALUE.SYNC_THRESHOLD PARAM_VALUE.SYNC_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_THRESHOLD}] ${MODELPARAM_VALUE.SYNC_THRESHOLD}
}

proc update_MODELPARAM_VALUE.DESYNC_THRESHOLD { MODELPARAM_VALUE.DESYNC_THRESHOLD PARAM_VALUE.DESYNC_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DESYNC_THRESHOLD}] ${MODELPARAM_VALUE.DESYNC_THRESHOLD}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.FIFO_DEPTH { MODELPARAM_VALUE.FIFO_DEPTH PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_DEPTH}] ${MODELPARAM_VALUE.FIFO_DEPTH}
}

