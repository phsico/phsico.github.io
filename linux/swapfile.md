Creating a SWAP File

```Bash
#!/usr/bin/env bash
# Swapfile setup helper
# English comments and prompts
# Menu: automatic (executes), manual (shows steps), show (display current swap), exit

set -e

info() { printf '\n[INFO] %s\n' "$1"; }
err()  { printf '\n[ERROR] %s\n' "$1" >&2; exit 1; }

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

prompt_yesno() {
  local prompt="$1"; local default="$2"; local ans
  while true; do
    read -rp "$prompt [$default] " ans
    ans=${ans:-$default}
    case "${ans,,}" in
      y|yes) return 0;;
      n|no)  return 1;;
      *) echo "Please enter yes/no (y/n).";;
    esac
  done
}

show_swap() {
  echo
  echo "Current swap summary:"
  swapon --show || echo "(no active swap)"
  free -h
  echo
}

# Build the sequence of steps (as strings). Each step is a command to run.
build_steps() {
  STEPS=()
  STEPS+=("Create swap file at: $SWAP_PATH of size: ${SWAP_SIZE} (bytes: $SWAP_BYTES)")
  if [ "$METHOD" = "fallocate" ]; then
    STEPS+=("fallocate -l ${SWAP_SIZE} \"$SWAP_PATH\"")
  else
    STEPS+=("dd if=/dev/zero of=\"$SWAP_PATH\" bs=1M count=$COUNT_MB status=progress")
  fi
  STEPS+=("chmod 600 \"$SWAP_PATH\"")
  STEPS+=("mkswap \"$SWAP_PATH\"")
  STEPS+=("swapon \"$SWAP_PATH\"")
  STEPS+=("Add to /etc/fstab: $SWAP_PATH none swap defaults 0 0")
}

execute_steps() {
  for cmd in "${CMD_LIST[@]}"; do
    info "Running: $cmd"
    eval "$cmd"
  done
}

show_manual_steps() {
  echo
  echo "Manual steps (do NOT execute):"
  for s in "${STEPS[@]}"; do
    printf "  %s\n" "$s"
  done
  echo
}

# --- Menu loop ---
while true; do
  echo
  echo "Swapfile Setup Helper"
  echo "1) automatic (execute)"
  echo "2) manual (show steps only)"
  echo "3) show (current swap)"
  echo "4) exit"
  read -rp "Choose an option [1-4]: " choice
  case "$choice" in
    3) show_swap; continue;;
    4) echo "Exit."; exit 0;;
    1|2) ;;
    *) echo "Invalid choice."; continue;;
  esac

  # Ask whether to create a swap file
  if ! prompt_yesno "Create SWAP File (yes/no):" "yes"; then
    echo "Swap creation skipped."; continue
  fi

  # Check tools
  HAVE_FALLOCATE=0
  HAVE_DD=0
  if check_cmd fallocate; then HAVE_FALLOCATE=1; fi
  if check_cmd dd; then HAVE_DD=1; fi

  if [ $HAVE_FALLOCATE -eq 0 ] && [ $HAVE_DD -eq 0 ]; then
    err "Neither 'fallocate' nor 'dd' found on PATH. Install coreutils/allocating tools."
  fi

  # Ask preference if both available, else pick available one
  if [ $HAVE_FALLOCATE -eq 1 ] && [ $HAVE_DD -eq 1 ]; then
    echo "Choose creation method:"
    echo "1) fallocate (fast)"
    echo "2) dd (portable, slower)"
    read -rp "fallocate or dd (1/2): " method_choice
    case "$method_choice" in
      1) METHOD="fallocate";;
      2) METHOD="dd";;
      *) METHOD="dd";;
    esac
  elif [ $HAVE_FALLOCATE -eq 1 ]; then
    METHOD="fallocate"
  else
    METHOD="dd"
  fi

  # Ask path and size
  read -rp "Swapfile path (default: /swapfile): " SWAP_PATH
  SWAP_PATH=${SWAP_PATH:-/swapfile}
  # Ensure path is absolute
  case "$SWAP_PATH" in
    /*) ;;
    *) err "Please give an absolute path (e.g. /swapfile).";;
  esac

  # Ask size using base-2 units (GiB) and convert
  read -rp "Swap size in GiB (integer, base 2, default 2): " SIZE_GIB
  SIZE_GIB=${SIZE_GIB:-2}
  if ! [[ "$SIZE_GIB" =~ ^[0-9]+$ ]]; then
    err "Size must be an integer number of GiB."
  fi
  # Convert GiB to bytes and MB count for dd
  SWAP_BYTES=$((SIZE_GIB * 1024 * 1024 * 1024))
  COUNT_MB=$((SIZE_GIB * 1024))
  SWAP_SIZE="${SIZE_GIB}G"

  # Build steps and commands
  build_steps

  # Prepare command list for execution
  CMD_LIST=()
  if [ "$METHOD" = "fallocate" ]; then
    CMD_LIST+=("fallocate -l ${SWAP_SIZE} \"$SWAP_PATH\"")
  else
    CMD_LIST+=("dd if=/dev/zero of=\"$SWAP_PATH\" bs=1M count=$COUNT_MB status=progress")
  fi
  CMD_LIST+=("chmod 600 \"$SWAP_PATH\"")
  CMD_LIST+=("mkswap \"$SWAP_PATH\"")
  CMD_LIST+=("swapon \"$SWAP_PATH\"")
  # fstab entry command for display/append
  FSTAB_LINE="$SWAP_PATH none swap defaults 0 0"

  if [ "$choice" = "2" ]; then
    show_manual_steps
    echo "Suggested fstab line:"
    printf "  %s\n\n" "$FSTAB_LINE"
    continue
  fi

  # choice == 1 -> automatic execution
  echo
  echo "About to run the following steps:"
  for s in "${STEPS[@]}"; do printf "  %s\n" "$s"; done
  echo
  if ! prompt_yesno "Proceed and execute these commands now?" "yes"; then
    echo "Aborted by user."
    continue
  fi

  # Execute with privileges checks
  if [ "$EUID" -ne 0 ]; then
    err "This script must be run as root (or via sudo) to modify swap and /etc/fstab."
  fi

  # Run commands
  for cmd in "${CMD_LIST[@]}"; do
    info "Executing: $cmd"
    eval "$cmd"
  done

  # Append to /etc/fstab if not already present
  if ! grep -Fq "$SWAP_PATH none swap" /etc/fstab 2>/dev/null; then
    echo "$FSTAB_LINE" >> /etc/fstab
    info "Appended swap entry to /etc/fstab"
  else
    info "fstab already contains an entry for this swap path; skipping append."
  fi

  info "Swapfile setup complete."
  show_swap
done
```
