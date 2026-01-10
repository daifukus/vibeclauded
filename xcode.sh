#!/bin/bash
# xcode.sh
# Notifies when Claude finishes in Xcode
#
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                                                                          ║
# ║   ██╗   ██╗██╗██████╗ ███████╗ ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗  
# ║   ██║   ██║██║██╔══██╗██╔════╝██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝  
# ║   ██║   ██║██║██████╔╝█████╗  ██║     ██║     ███████║██║   ██║██║  ██║█████╗    
# ║   ╚██╗ ██╔╝██║██╔══██╗██╔══╝  ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝    
# ║    ╚████╔╝ ██║██████╔╝███████╗╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗  
# ║     ╚═══╝  ╚═╝╚═════╝ ╚══════╝ ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝  
# ║                                                                          ║
# ║                           ✦ by DFK Labs ✦                                ║
# ║                                                                          ║
# ║        ██████╗ ███████╗██╗  ██╗    ██╗      █████╗ ██████╗ ███████╗      ║
# ║        ██╔══██╗██╔════╝██║ ██╔╝    ██║     ██╔══██╗██╔══██╗██╔════╝      ║
# ║        ██║  ██║█████╗  █████╔╝     ██║     ███████║██████╔╝███████╗      ║
# ║        ██║  ██║██╔══╝  ██╔═██╗     ██║     ██╔══██║██╔══██╗╚════██║      ║
# ║        ██████╔╝██║     ██║  ██╗    ███████╗██║  ██║██████╔╝███████║      ║
# ║        ╚═════╝ ╚═╝     ╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝      ║
# ║                                                                          ║
# ║                   🎧 Xcode Claude Monitor Edition 🎧                    ║
# ║                                                                         ║
# ╚════════════════════════════════════════════════════════════════════════╝
#

# FIRST THING: Clear screen completely
clear
printf "\033c"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'
# Claude orange
ORANGE='\033[38;5;208m'
PEACH='\033[38;5;216m'
# Inverted colors
INV_GREEN='\033[7;32m'
INV_YELLOW='\033[7;33m'
INV_RED='\033[7;31m'
INV_ORANGE='\033[7;38;5;208m'

was_working="false"
running="false"
auto_run="false"
flash_key=""
spinner_frame=0

# Claude-style sparkle animation frames
SPARKLE=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# Hide cursor and cleanup on exit
trap 'tput cnorm; clear; exit' INT TERM
tput civis

# Resize terminal window
printf '\e[8;18;42t'

trigger() {
  afplay /System/Library/Sounds/Glass.aiff &
  osascript -e 'tell application "Xcode" to activate'
}

trigger_and_run() {
  afplay /System/Library/Sounds/Glass.aiff &
  osascript -e 'tell application "Xcode" to activate'
  sleep 1
  osascript -e 'tell application "System Events" to keystroke "r" using command down'
}

is_xcode_open() {
  pgrep -x "Xcode" > /dev/null
}

open_xcode() {
  osascript -e 'tell application "Xcode" to activate'
}

start_sound() {
  afplay /System/Library/Sounds/Tink.aiff &
}

draw_screen() {
  local status_text="$1"
  local monitor_state="$2"
  
  # Key colors (normal or inverted)
  local k1="${GREEN}1${NC}"
  local k2="${YELLOW}2${NC}"
  local k3="${RED}3${NC}"
  local k0="${ORANGE}0${NC}"
  
  if [[ "$flash_key" == "1" ]]; then
    k1="${INV_GREEN}1${NC}"
  elif [[ "$flash_key" == "2" ]]; then
    k2="${INV_YELLOW}2${NC}"
  elif [[ "$flash_key" == "3" ]]; then
    k3="${INV_RED}3${NC}"
  elif [[ "$flash_key" == "0" ]]; then
    k0="${INV_ORANGE}0${NC}"
  fi
  
  # Get current sparkle frame
  local sparkle="${SPARKLE[$spinner_frame]}"
  
  # Move cursor to top and clear
  tput cup 0 0
  tput ed
  
  echo -e "${ORANGE}"
  echo "   ╦  ╦╦╔╗ ╔═╗╔═╗╦  ╔═╗╦ ╦╔╦╗╔═╗╔╦╗"
  echo "   ╚╗╔╝║╠╩╗║╣ ║  ║  ╠═╣║ ║ ║║║╣  ║║"
  echo "    ╚╝ ╩╚═╝╚═╝╚═╝╩═╝╩ ╩╚═╝═╩╝╚═╝═╩╝"
  echo -e "                         ${GRAY}by ${PEACH}${BOLD}DFKlabs${NC}"
  echo ""
  echo -e "   ${ORANGE}╔══════════════════════════════════╗${NC}"
  echo -e "   ${ORANGE}║${NC}     ${BOLD}${PEACH}🎧 Xcode Claude Monitor${NC}      ${ORANGE}║${NC}"
  echo -e "   ${ORANGE}╠══════════════════════════════════╣${NC}"
  echo -e "   ${ORANGE}║${NC}                                  ${ORANGE}║${NC}"
  echo -e "   ${ORANGE}║${NC}     ${k1}${GRAY}▸${NC}Start  ${k2}${GRAY}▸${NC}Pause  ${k3}${GRAY}▸${NC}Exit     ${ORANGE}║${NC}"
  echo -e "   ${ORANGE}║${NC}                                  ${ORANGE}║${NC}"
  echo -e "   ${ORANGE}║${NC}              ${k0}${GRAY}▸${NC}AutoRun           ${ORANGE}║${NC}"
  echo -e "   ${ORANGE}║${NC}                                  ${ORANGE}║${NC}"
  echo -e "   ${ORANGE}╚══════════════════════════════════╝${NC}"
  
  # Auto-run indicator
  if [[ "$auto_run" == "true" ]]; then
    echo -e "   ${ORANGE}⌘R Auto-Run: ${GREEN}ON${NC}"
  else
    echo -e "   ${GRAY}⌘R Auto-Run: OFF${NC}"
  fi
  
  if [[ "$monitor_state" == "false" ]]; then
    echo -e "   ${GRAY}● ${RED}PAUSED${NC}"
  elif [[ "$status_text" == *"Opening"* ]]; then
    echo -e "   ${ORANGE}${sparkle} ${BOLD}Opening Xcode...${NC}"
  elif [[ -z "$status_text" ]]; then
    echo -e "   ${GREEN}● ${GRAY}Waiting...${NC}"
  elif [[ "$status_text" == *"Searching"* ]]; then
    echo -e "   ${ORANGE}${sparkle} ${BOLD}Searching...${NC}"
  elif [[ "$status_text" == *"Generating"* ]]; then
    echo -e "   ${ORANGE}${sparkle} ${BOLD}Generating...${NC}"
  elif [[ "$status_text" == *"Responding"* ]]; then
    echo -e "   ${ORANGE}${sparkle} ${BOLD}Responding...${NC}"
  elif [[ "$status_text" == *"Finished"* ]]; then
    echo -e "   ${GREEN}✓ ${BOLD}Finished${NC}"
  else
    echo -e "   ${BLUE}● ${NC}Idle"
  fi
}

flash() {
  local key="$1"
  flash_key="$key"
  draw_screen "" "$running"
  sleep 0.5
  flash_key=""
}

monitor() {
  local last_status=""
  local idle_start=0
  local idle_triggered="false"
  
  while [[ "$running" == "true" ]]; do
    current_status=$(osascript -e '
      tell application "System Events"
        tell process "Xcode"
          try
            return value of static text 1 of group 1 of group 1 of front window
          on error
            return ""
          end try
        end tell
      end tell
    ' 2>/dev/null)
    
    # Always redraw when working (for animation)
    local is_working="false"
    if [[ "$current_status" == *"Generating"* ]] || [[ "$current_status" == *"Responding"* ]] || [[ "$current_status" == *"Searching"* ]]; then
      is_working="true"
    fi
    
    if [[ "$current_status" != "$last_status" ]] || [[ "$is_working" == "true" ]]; then
      # Advance spinner frame
      spinner_frame=$(( (spinner_frame + 1) % 10 ))
      draw_screen "$current_status" "$running"
      last_status="$current_status"
    fi
    
    if [[ "$is_working" == "true" ]]; then
      was_working="true"
      idle_start=0
      idle_triggered="false"
      sleep 0.15
    elif [[ "$current_status" == *"Finished"* ]] && [[ "$was_working" == "true" ]]; then
      if [[ "$auto_run" == "true" ]]; then
        trigger_and_run
      else
        trigger
      fi
      was_working="false"
      idle_start=0
      idle_triggered="false"
      sleep 0.1
    else
      # Waiting/Idle state - check for 5 min timeout
      if [[ $idle_start -eq 0 ]]; then
        idle_start=$(date +%s)
      else
        local now=$(date +%s)
        local elapsed=$((now - idle_start))
        if [[ $elapsed -ge 300 ]] && [[ "$idle_triggered" == "false" ]]; then
          trigger
          idle_triggered="true"
        fi
      fi
      sleep 5
    fi
  done
}

# Init
draw_screen "" "false"

# Main loop
while true; do
  read -rsn1 key
  
  case $key in
    1)
      if [[ "$running" == "false" ]]; then
        flash "1"
        # Open Xcode if not running
        if ! is_xcode_open; then
          running="true"
          draw_screen "Opening" "$running"
          open_xcode
          sleep 2
        fi
        running="true"
        was_working="false"
        auto_run="true"
        start_sound
        draw_screen "" "$running"
        monitor &
        monitor_pid=$!
      fi
      ;;
    2)
      if [[ "$running" == "true" ]]; then
        flash "2"
        running="false"
        kill $monitor_pid 2>/dev/null
        wait $monitor_pid 2>/dev/null
        draw_screen "" "false"
      fi
      ;;
    3)
      flash "3"
      running="false"
      kill $monitor_pid 2>/dev/null
      tput cnorm
      clear
      exit 0
      ;;
    0)
      flash "0"
      if [[ "$auto_run" == "true" ]]; then
        auto_run="false"
      else
        auto_run="true"
      fi
      draw_screen "" "$running"
      ;;
  esac
done
