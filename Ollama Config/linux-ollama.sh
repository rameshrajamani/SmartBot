#!/bin/bash

# Define variables
OLLAMA_URL="https://ollama.com/install.sh"
TEXT_MODEL="phi3.5"
IMAGE_MODEL="moondream"
OLLAMA_DIR="$HOME/ollama"
OLLAMA_EXE="$OLLAMA_DIR/ollama"

# Function to check for root privileges
check_root() {
    if [ "$(id -u)" -ne "0" ]; then
        echo "This script requires root privileges. Please run as root or with sudo."
        exit 1
    fi
}

# Function to download and install Ollama
install_ollama() {
    echo "Downloading Ollama..."
    curl -fsSL "$OLLAMA_URL" | sh

    echo "Ollama installed successfully."

    # Ensure the Ollama executable is in the expected location
    mkdir -p "$OLLAMA_DIR"
    mv "$(which ollama)" "$OLLAMA_EXE"
}

# Function to pull models
pull_models() {
    echo "Starting Ollama service..."
    "$OLLAMA_EXE" serve &

    # Wait for the service to start
    sleep 10

    echo "Pulling text model $TEXT_MODEL..."
    "$OLLAMA_EXE" pull "$TEXT_MODEL"

    echo "Text model $TEXT_MODEL pulled successfully."

    echo "Pulling image model $IMAGE_MODEL..."
    "$OLLAMA_EXE" pull "$IMAGE_MODEL"

    echo "Image model $IMAGE_MODEL pulled successfully."
}

# Main script
check_root
install_ollama
pull_models
