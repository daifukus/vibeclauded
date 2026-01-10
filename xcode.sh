#!/bin/bash
# xcode.sh
# Notifies when Claude finishes in Xcode

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

was_working="false"
running="false"

# Hide cursor and cleanup on exit
trap 'tput cnorm; exit' INT TERM
tput civis

# Resize terminal window
printf '\e[8;16;40t'

show_splash() {
  clear
  echo -e "${CYAN}"
  echo "  ╦  ╦╦╔╗ ╔═╗╔═╗╦  ╔═╗╦ ╦╔╦╗╔═╗╔╦╗"
  echo "  ╚╗╔╝║╠╩╗║╣ ║  ║  ╠═╣║ ║ ║║║╣  ║║"
  echo "   ╚╝ ╩╚═╝╚═╝╚═╝╩═╝╩ ╩╚═╝═╩╝╚═╝═╩╝"
  echo -e "${NC}"
  echo -e "        ${GRAY}by ${WHITE}${BOLD}DFKlabs${NC}"
  echo ""
  echo -e "  ${YELLOW}Press any key to continue...${NC}"
  read -rsn1
}

trigger() {
  afplay /System/Library/Sounds/Glass.aiff &
  osascript -e 'tell application "Xcode" to activate'
}

start_sound() {
  afplay /System/Library/Sounds/Tink.aiff &
}

draw_screen() {
  local status_text="$1"
  local monitor_state="$2"
  
  clear
  echo -e "${CYAN}╔════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC} ${BOLD}${WHITE}🎧 Xcode Claude Monitor${NC}    ${CYAN}║${NC}"
  echo -e "${CYAN}╠════════════════════════════════╣${NC}"
  echo -e "${CYAN}║${NC} ${GREEN}1${NC}Start ${YELLOW}2${NC}Pause ${RED}3${NC}Exit ${BLUE}4${NC}Test ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════╝${NC}"
  
  if [[ "$monitor_state" == "false" ]]; then
    echo -e "${GRAY}● ${RED}PAUSED${NC}"
  elif [[ -z "$status_text" ]]; then
    echo -e "${GREEN}● ${GRAY}Waiting...${NC}"
  elif [[ "$status_text" == *"Searching"* ]]; then
    echo -e "${BLUE}◉ ${BOLD}Searching...${NC}"
  elif [[ "$status_text" == *"Generating"* ]]; then
    echo -e "${YELLOW}◉ ${BOLD}Generating...${NC}"
  elif [[ "$status_text" == *"Responding"* ]]; then
    echo -e "${MAGENTA}◉ ${BOLD}Responding...${NC}"
  elif [[ "$status_text" == *"Finished"* ]]; then
    echo -e "${GREEN}✓ ${BOLD}Finished${NC}"
  else
    echo -e "${BLUE}● ${NC}Idle"
  fi
}

monitor() {
  local last_status=""
  
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
    
    if [[ "$current_status" != "$last_status" ]]; then
      draw_screen "$current_status" "$running"
      last_status="$current_status"
    fi
    
    if [[ "$current_status" == *"Generating"* ]] || [[ "$current_status" == *"Responding"* ]] || [[ "$current_status" == *"Searching"* ]]; then
      was_working="true"
      sleep 0.1
    elif [[ "$current_status" == *"Finished"* ]] && [[ "$was_working" == "true" ]]; then
      trigger
      was_working="false"
      sleep 0.1
    else
      # Waiting/Idle state - sleep longer
      sleep 10
    fi
  done
}

# Splash screen
show_splash

# Init
draw_screen "" "false"

# Main loop
while true; do
  read -rsn1 key
  
  case $key in
    1)
      if [[ "$running" == "false" ]]; then
        running="true"
        was_working="false"
        start_sound
        draw_screen "" "$running"
        monitor &
        monitor_pid=$!
      fi
      ;;
    2)
      if [[ "$running" == "true" ]]; then
        running="false"
        kill $monitor_pid 2>/dev/null
        wait $monitor_pid 2>/dev/null
        draw_screen "" "false"
      fi
      ;;
    3)
      running="false"
      kill $monitor_pid 2>/dev/null
      tput cnorm
      clear
      exit 0
      ;;
    4)
      trigger
      ;;
  esac
done