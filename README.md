# INWK6312 - Lab 1: Network Namespaces and Git Operations

## Project Overview
This repository contains shell scripts to automate the creation, management, and teardown of a routed network namespace topology simulating multiple hosts (`ns-hostA`, `ns-hostB`, `ns-hostC`) connected through a central router (`ns-router`).

## Directory Structure.
├── lab1/
│   └── scripts/
│       ├── build-topology.sh      # Script to create namespaces, veth pairs, assign IPs, and set static routes
│       └── teardown-topology.sh   # Script to cleanly remove all network namespaces
└── README.md                      # Project documentation

## How to Execute the Scripts

### 1. Rebuild the Network Topology
To create all namespaces, virtual ethernet (`veth`) pairs, assign IP addresses, and enable IP forwarding on the router, run:

```bash
sudo ./lab1/scripts/build-topology.sh


