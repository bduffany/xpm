# "Enters" an XPM namespace, meaning that it allows referencing
# functions or variables in the namespace without needing to use the
# namespace prefix.
#
# example usage:
#
#   eval $(xpm source -g log.sh)  # -g flag automatically calls "xpm::using log" afterwards
#   success "Able to call log::success without log:: prefix!"
function xpm::using() {

}
