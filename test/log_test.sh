#!/bin/bash

test/install_test.sh bash -c '
cd $(mktemp -d)
cat > ./test.sh << EOF
eval $(xpm source lib/log.sh)
xpm::log::alias
success "This text should render in green"
EOF
chmod +x test.sh
./test.sh
'
