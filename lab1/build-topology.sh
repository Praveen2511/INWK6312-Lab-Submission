#!/bin/bash
# build-topology.sh
# Builds the INWK6312 Lab 1 routed namespace topology:
# ns-hostA -- ns-router -- ns-hostB

set -e

NAMESPACES=("ns-hostA" "ns-router" "ns-hostB")

for ns in "${NAMESPACES[@]}"; do
  if ip netns list | grep -q "$ns"; then
    echo "$ns already exists, skipping"
  else
    ip netns add "$ns"
    echo "Created $ns"
  fi
done

# Create the veth pairs and move each end into the right namespace
ip link add veth-a type veth peer name veth-r1
ip link set veth-a netns ns-hostA
ip link set veth-r1 netns ns-router

ip link add veth-r2 type veth peer name veth-b
ip link set veth-r2 netns ns-router
ip link set veth-b netns ns-hostB

# Assign addresses to each interface
ip netns exec ns-hostA ip addr add 10.10.1.2/24 dev veth-a
ip netns exec ns-router ip addr add 10.10.1.1/24 dev veth-r1
ip netns exec ns-router ip addr add 10.10.2.1/24 dev veth-r2
ip netns exec ns-hostB ip addr add 10.10.2.2/24 dev veth-b

# Bring up every interface and every loopback
for ns in "${NAMESPACES[@]}"; do
  ip netns exec "$ns" ip link set lo up
done
ip netns exec ns-hostA ip link set veth-a up
ip netns exec ns-router ip link set veth-r1 up
ip netns exec ns-router ip link set veth-r2 up
ip netns exec ns-hostB ip link set veth-b up

# Enable IP forwarding on ns-router
ip netns exec ns-router sysctl -w net.ipv4.ip_forward=1

# Add the static routes on ns-hostA and ns-hostB
ip netns exec ns-hostA ip route add 10.10.2.0/24 via 10.10.1.1
ip netns exec ns-hostB ip route add 10.10.1.0/24 via 10.10.2.1

echo "Topology build complete"

