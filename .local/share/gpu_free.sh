#!/usr/bin/env bash

# gpu_available.sh
# Prints currently unallocated GPUs on usable nodes for h200_public and l40s_public.
# No set -e, no exit, no background processes.
# Run with: bash gpu_available.sh
# Do not source it.

scontrol -o show nodes 2>/dev/null | awk '
function field(name,   r) {
  r = name "=[^ ]+"
  if (match($0, r)) {
    return substr($0, RSTART + length(name) + 1, RLENGTH - length(name) - 1)
  }
  return ""
}

function tres_count(tres, generic_key, typed_key,   n, i, parts, kv, generic, typed) {
  generic = -1
  typed = -1

  n = split(tres, parts, ",")
  for (i = 1; i <= n; i++) {
    split(parts[i], kv, "=")

    if (kv[1] == typed_key) {
      if (typed < 0) typed = 0
      typed += kv[2] + 0
    }

    if (kv[1] == generic_key) {
      if (generic < 0) generic = 0
      generic += kv[2] + 0
    }
  }

  if (typed >= 0) return typed
  if (generic >= 0) return generic
  return 0
}

function unusable_state(s) {
  return s ~ /DOWN|DRAIN|FAIL|MAINT|RESERVED|POWER|NOT_RESPOND/
}

function add_partition(part, gpu_type, state, cfg, alloc,   total, used, free) {
  total = tres_count(cfg, "gres/gpu", "gres/gpu:" gpu_type)
  used  = tres_count(alloc, "gres/gpu", "gres/gpu:" gpu_type)

  free = total - used
  if (free < 0) free = 0

  all_nodes[part] += 1
  all_configured[part] += total
  all_allocated[part] += used

  if (unusable_state(state)) {
    unusable_nodes[part] += 1
    unusable_gpus[part] += total
    return
  }

  usable_nodes[part] += 1
  configured[part] += total
  allocated[part] += used
  available[part] += free

  if (free >= 1) nodes_ge1[part] += 1
  if (free >= 2) nodes_ge2[part] += 1
  if (free >= 4) nodes_ge4[part] += 1
}

{
  part = field("Partitions")
  state = field("State")
  cfg = field("CfgTRES")
  alloc = field("AllocTRES")

  if (part ~ /(^|,)h200_public(,|$)/) {
    add_partition("h200_public", "h200", state, cfg, alloc)
  }

  if (part ~ /(^|,)l40s_public(,|$)/) {
    add_partition("l40s_public", "l40s", state, cfg, alloc)
  }
}

END {
  printf "\n%-15s %12s %12s %12s %12s %12s %12s %12s\n", \
    "PARTITION", "USABLE_NODES", "CONFIGURED", "ALLOCATED", "AVAILABLE", "NODES_>=1", "NODES_>=2", "NODES_>=4"

  printf "%-15s %12s %12s %12s %12s %12s %12s %12s\n", \
    "---------", "------------", "----------", "---------", "---------", "---------", "---------", "---------"

  printf "%-15s %12d %12d %12d %12d %12d %12d %12d\n", \
    "h200_public", usable_nodes["h200_public"], configured["h200_public"], allocated["h200_public"], available["h200_public"], nodes_ge1["h200_public"], nodes_ge2["h200_public"], nodes_ge4["h200_public"]

  printf "%-15s %12d %12d %12d %12d %12d %12d %12d\n", \
    "l40s_public", usable_nodes["l40s_public"], configured["l40s_public"], allocated["l40s_public"], available["l40s_public"], nodes_ge1["l40s_public"], nodes_ge2["l40s_public"], nodes_ge4["l40s_public"]

  printf "\n"
  printf "AVAILABLE = unallocated GPUs on usable nodes only.\n"
  printf "NODES_>=N = usable nodes with at least N free GPUs on the same node.\n"
  printf "This matters for l40sx2/l40sx4/h200x2/h200x4 single-node requests.\n"
  printf "\n"
}
' || true
