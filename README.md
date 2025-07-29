# Simple Network Proxy

A simple iptables-based network proxy designed for Docker Compose environments to expose internal network services to external networks.

## Purpose

This proxy solves the problem of exposing services running in Docker Compose internal networks where port forwarding is not available. It uses iptables NAT rules to bridge internal services to external networks.

## Features

- Dynamic hostname resolution with automatic rule updates
- iptables-based TCP forwarding
- Multiple proxy configurations supported
- Optimized for Docker Compose environments
- Exposes internal network services externally

## Usage

### Docker Compose

```bash
docker-compose up --build
```

Default configuration exposes:

- Port 1080 → nginx:80 (internal nginx service)
- Port 13117 → nc:8080 (internal netcat service)

### Custom Configuration

Edit the `command` section in `docker-compose.yml` for the `proxy` service:

```yaml
proxy:
  command:
    - -p
    - 8080:web-service:80
    - -p
    - 3306:database:3306
```

## Network Architecture

```
External Network (eth-public) ← → Proxy ← → Internal Network (eth-internal)
                             Port 1080         nginx:80
                             Port 13117        nc:8080
```

## Requirements

- `NET_ADMIN` capability (for iptables manipulation)
- Two network interfaces:
  - `eth-public`: Connected to external network
  - `eth-internal`: Connected to internal services network

## How it Works

1. Parses proxy configurations from command line arguments
2. Continuously monitors IP resolution of internal hostnames
3. Updates iptables NAT rules when IP addresses change
4. Uses DNAT to redirect external traffic to internal services
5. Uses SNAT to ensure return traffic goes through the proxy