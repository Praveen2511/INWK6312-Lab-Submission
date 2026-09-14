
# INWK6312 Lab 1 — Linux and Git Foundations

This repository contains the coursework for INWK6312, starting with Lab 1.

## Repository Structure

- `lab1/` — Deliverables for Lab 1, including filesystem exercises, text processing
  practice, systemd service configuration, and the namespace-based routed topology.
- `lab1/scripts/` — Automation scripts for building and tearing down the lab
  network topology.
- `tools/` — Shared utilities used across labs (populated in later modules).
- `topology/` — Persistent network topology definitions (starting Lab 2).
- `.velab/` — Local Python virtual environment (excluded from version control).
- `requirements.txt` — Cumulative list of Python dependencies used across labs.

## Running the Topology Scripts

The scripts in `lab1/scripts/` build and tear down a three-host routed network
using Linux network namespaces: `ns-hostA`, `ns-hostB`, and `ns-hostC`, all
connected through a central `ns-router` namespace.

To build the topology:

\`\`\`bash
sudo ./lab1/scripts/build-topology.sh
\`\`\`

To tear it down:

\`\`\`bash
sudo ./lab1/scripts/teardown-topology.sh
\`\`\`

Both scripts are idempotent — running `build-topology.sh` when namespaces already
exist will skip creation rather than fail, and `teardown-topology.sh` will skip
namespaces that don't exist.

## Environment Setup

Activate the shared Python virtual environment before working in this repository:

\`\`\`bash
source ~/labs/.velab/bin/activate
\`\`\`

