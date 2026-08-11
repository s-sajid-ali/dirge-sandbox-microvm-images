#!/bin/sh
set -eu

resolv_conf="/etc/resolv.conf"

if [ ! -s "$resolv_conf" ] || ! grep -Eq '^[[:space:]]*nameserver[[:space:]]+' "$resolv_conf"; then
    tmp="$(mktemp)"
    {
        echo "# Generated at boot for dirge microVM networking."
        for nameserver in ${DIRGE_DNS_NAMESERVERS:-1.1.1.1 8.8.8.8}; do
            echo "nameserver $nameserver"
        done
        echo "options timeout:2 attempts:2"
    } > "$tmp"
    cat "$tmp" > "$resolv_conf"
    rm -f "$tmp"
fi

exec /usr/sbin/sshd.real "$@"
