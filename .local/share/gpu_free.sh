#!/usr/bin/env bash

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

  nodes[part] += 1
  configured[part] += total
  allocated[part] += used

  if (!unusable_state(state)) {
    usable_nodes[part] += 1
    available[part] += free
  }
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
  printf "\n%-15s %12s %12s %12s %12s\n", "PARTITION", "NODES", "CONFIGURED", "ALLOCATED", "AVAILABLE"
  printf "%-15s %12s %12s %12s %12s\n", "---------", "-----", "----------", "---------", "---------"

  printf "%-15s %12d %12d %12d %12d\n", \
    "h200_public", usable_nodes["h200_public"], configured["h200_public"], allocated["h200_public"], available["h200_public"]

  printf "%-15s %12d %12d %12d %12d\n", \
    "l40s_public", usable_nodes["l40s_public"], configured["l40s_public"], allocated["l40s_public"], available["l40s_public"]

  print ""
}
' || true
