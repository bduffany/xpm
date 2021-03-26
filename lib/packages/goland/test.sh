set -ex
[[ -e /opt/GoLand/bin/goland.sh ]]
[[ -e ~/.local/share/applications/goland.desktop ]]
[[ -e /usr/share/pixmaps/goland.png ]]
[[ "$(readlink /usr/local/bin/goland)" == /opt/GoLand/bin/goland.sh ]]
