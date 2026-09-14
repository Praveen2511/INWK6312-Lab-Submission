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
# TODO: create the veth pairs and move each end into the right namespace
# TODO: assign addresses to each interface
# TODO: bring up every interface and every loopback
# TODO: enable IP forwarding on ns-router
# TODO: add the static routes on ns-hostA and ns-hostB
echo "Topology build complete"


