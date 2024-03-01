set_global_assignment -entity "pll_tres" -library "lib_pll_tres" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_tres" -library "lib_pll_tres" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "pll_tres" -library "lib_pll_tres" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_tres" -name SPD_FILE [file join $::quartus(sip_path) "pll_tres.spd"]

set_global_assignment -library "lib_pll_tres" -name MISC_FILE [file join $::quartus(sip_path) "pll_tres_sim/pll_tres.vo"]
