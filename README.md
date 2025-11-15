# GhostHook - Custom XSS Hook Generator

GhostHook is a simple Bash-based tool that allows you to generate custom XSS hooks and serve them via a PHP server. It's designed for security testing and learning purposes.

---

## Features

- Generates a `hook.js` file for custom XSS payloads.
- Prompts for server port with a default value (`8080`).
- Allows setting a redirect URL for the hook.
- Automatically starts a PHP server to serve the hook file.
- Provides example script tags for easy embedding.
- Simple and lightweight, fully written in Bash.

---

## Requirements

- Bash shell
- PHP installed (`php -S` command must be available)
- Internet browser to test the hook
- Termux or Linux environment (tested on Kali Linux)

---