#!/bin/bash
# Find and kill the Claude app process
pkill Claude
# Wait a moment for it to close (optional, for safety)
sleep 1
# Open the app from Applications folder
open /Applications/Claude.app
