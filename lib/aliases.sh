#!/bin/bash
# Copyright (C)2018 Dwight Spencer. All Rights Reserved.
# Licenced under BSD "Simplified". https://github.com/denzuko/ssh-tools/blob/master/LICENSE
# Enable with `bash_it search -e inventory`

cite 'about-alias'
about-alias 'general inventory listing from ~/.ssh/config'

function inventory_add() {
   local host="${1:-'localhost'}"
   local addr="${2:-'127.0.0.1'}"
   local port="${3:-'22'}"

   echo -ne "\nHost ${host}\n\thostname ${addr}\n\tport ${port}\n\n" >> "${HOME}/.ssh/config"
}

function inventory_resolve() {
   local name="${1:-'localhost'}"

   grep -A1 "${name}" ~/.ssh/config | tr '\n' ' ' | awk '{ print $NF }'
}

alias inventory="awk '/.prod|.preprod/ { print \$NF }' ~/.ssh/config"
alias inventory.add=inventory_add
alias inventory.resolve=inventory_resolve
alias inventory.all="awk '/Host / { print \$NF }' ~/.ssh/config"
alias inventory.tun="awk '/.tun/ { print \$NF }' ~/.ssh/config"
alias inventory.prod_containers=inventory.prod | xargs -I{} -P8 ssh {} "docker ps| awk '/Up|Exit/ { \"hostname\" | getline con; print con\"/\"\$NF; }'"
alias inventory.prod_images=inventory.prod | xargs -I{} -P8 ssh {} "docker ps| awk '{ \"hostname\" | getline con; print con\"/\"\$1; }'"
alias inventory.preprod_containers=inventory.preprod | xargs -I{} -P8 ssh {} "docker ps| awk '/Up|Exit/ { \"hostname\" | getline con; print con\"/\"\$NF; }'"
alias inventory.preprod_images=inventory.preprod | xargs -I{} -P8 ssh {} "docker ps| awk '{ \"hostname\" | getline con; print con\"/\"\$1; }'"
alias inventory.prod="awk '/.prod/ { print \$NF }' ~/.ssh/config"
alias inventory.preprod="awk '/.preprod/ { print \$NF }' ~/.ssh/config"
