#!/bin/bash
# teardown-topology.sh
NAMESPACES=("ns-hostA" "ns-router" "ns-hostB")
for ns in "${NAMESPACES[@]}"; do
if ip netns list | grep -q "$ns"; then
ip netns del "$ns"
echo "Deleted $ns"
else
echo "$ns does not exist, skipping"
fi
done


