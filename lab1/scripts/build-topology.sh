#!/bin/bash
# build-topology.sh
# Builds the INWK6312 Lab 1 routed namespace topology:
# ns-hostA -- ns-router -- ns-hostB
set -e

NAMESPACES=("ns-hostA" "ns-router" "ns-hostB" "ns-hostC")

for ns in "${NAMESPACES[@]}"; do
    if ip netns list | grep -q "$ns"; then
        echo "$ns already exists, skipping"
    else
        ip netns add "$ns"
        echo "Created $ns"
    fi
done

# TODO: create the veth pairs and move each end into the right namespace
ip link add veth-hostA type veth peer name veth-routerA
ip link add veth-hostB type veth peer name veth-routerB
ip link add veth-hostC type veth peer name veth-routerC

ip link set veth-hostA netns ns-hostA
ip link set veth-routerA netns ns-router
ip link set veth-hostB netns ns-hostB
ip link set veth-routerB netns ns-router
ip link set veth-hostC netns ns-hostC
ip link set veth-routerC netns ns-router

# TODO: assign addresses to each interface
ip netns exec ns-hostA ip addr add 10.10.21.2/24 dev veth-hostA
ip netns exec ns-router ip addr add 10.10.21.1/24 dev veth-routerA

ip netns exec ns-hostB ip addr add 10.10.2.2/24 dev veth-hostB
ip netns exec ns-router ip addr add 10.10.2.1/24 dev veth-routerB

ip netns exec ns-hostC ip addr add 10.10.3.2/24 dev veth-hostC
ip netns exec ns-router ip addr add 10.10.3.1/24 dev veth-routerC

# TODO: bring up every interface and every loopback
ip netns exec ns-hostA ip link set dev veth-hostA up
ip netns exec ns-hostA ip link set dev lo up

ip netns exec ns-hostB ip link set dev veth-hostB up
ip netns exec ns-hostB ip link set dev lo up

ip netns exec ns-hostC ip link set dev veth-hostC up
ip netns exec ns-hostC ip link set dev lo up

ip netns exec ns-router ip link set dev veth-routerA up
ip netns exec ns-router ip link set dev veth-routerB up
ip netns exec ns-router ip link set dev veth-routerC up
ip netns exec ns-router ip link set dev lo up

# TODO: enable IP forwarding on ns-router
ip netns exec ns-router sysctl -w net.ipv4.ip_forward=1

# TODO: add the static routes on ns-hostA and ns-hostB
ip netns exec ns-hostA ip route add default via 10.10.21.1
ip netns exec ns-hostB ip route add default via 10.10.2.1
ip netns exec ns-hostC ip route add default via 10.10.3.1

echo "Topology build complete"
