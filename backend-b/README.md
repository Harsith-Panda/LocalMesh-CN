# Backend Server B

This directory contains the code for Backend Server B (Ubuntu VM).

## Requirements

- Listen on port 3002
- Bind to LAN-accessible interface (0.0.0.0)
- Implement endpoints:
  - `GET /` - Basic page confirming service is running
  - `GET /api/status` - JSON with `{ "backend": "B", "status": "ok" }`
- Add `X-Backend: B` response header
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

The server will start on http://0.0.0.0:3002

### 5. Allow port through firewall (if UFW is enabled)
```bash
sudo ufw allow 3002/tcp
```

This is UTM **LocalMesh - 1**, Port Forward **3002** (Emulated VLAN). Other machines use `http://$YOUR_MAC_IP:3002/`.

## Testing

From Your Mac or Manohar's Mac:
```bash
curl http://$YOUR_MAC_IP:3002/
curl http://$YOUR_MAC_IP:3002/api/status
curl -I http://$YOUR_MAC_IP:3002/api/status
```

Expected responses:
- `GET /` returns service info with X-Backend: B
- `GET /api/status` returns `{"backend": "B", "status": "ok"}`
- Headers include Cache-Control and ETag

## Running in Background

To run the service in the background:
```bash
nohup python3 app.py > backend-b.log 2>&1 &
```

To stop the service:
```bash
pkill -f "python3 app.py"
```
