# Backend Server A

This directory contains the code for Backend Server A (Ubuntu VM).

## Requirements

- Listen on port 3001
- Bind to LAN-accessible interface (0.0.0.0)
- Implement endpoints:
  - `GET /` - Basic page confirming service is running
  - `GET /api/status` - JSON with `{ "backend": "A", "status": "ok" }`
- Add `X-Backend: A` response header
- Add Cache-Control and ETag headers for caching demonstration

## Setup (Ubuntu)

### 1. Install Python (if not already installed)
```bash
sudo apt update
sudo apt install python3 -y
```

### 2. Copy the application
```bash
# Upload app.py to the Ubuntu VM
# Or clone the repository
```

### 3. Make the script executable
```bash
chmod +x app.py
```

### 4. Start the service
```bash
python3 app.py
```

The server will start on http://0.0.0.0:3001

### 5. Allow port through firewall (if UFW is enabled)
```bash
sudo ufw allow 3001/tcp
```

This is the UTM VM whose Port Forward is **3001** (Emulated VLAN). Other machines use `http://$YOUR_MAC_IP:3001/`. Do not run this on LocalMesh - 1 (that VM is port 3002 / Backend B).

## Testing

From Your Mac or Manohar's Mac:
```bash
curl http://$YOUR_MAC_IP:3001/
curl http://$YOUR_MAC_IP:3001/api/status
curl -I http://$YOUR_MAC_IP:3001/api/status
```

Expected responses:
- `GET /` returns service info with X-Backend: A
- `GET /api/status` returns `{"backend": "A", "status": "ok"}`
- Headers include Cache-Control and ETag

## Running in Background

To run the service in the background:
```bash
nohup python3 app.py > backend-a.log 2>&1 &
```

To stop the service:
```bash
pkill -f "python3 app.py"
```
