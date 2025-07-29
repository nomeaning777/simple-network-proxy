#!/bin/bash

set -exu

echo 'Setup base rules'
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -P INPUT DROP

iptables -A OUTPUT -o lo -j ACCEPT
iptables -P OUTPUT DROP

iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -A FORWARD -i eth-public -o eth-internal -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -P FORWARD DROP

echo 'Base rules done'

python3 /proxy.py "$@"
