# Backend Server B

This directory contains the code for Backend Server B.

## Requirements

- Listen on port 3002
- Bind to LAN-accessible interface (not 127.0.0.1)
- Implement endpoints:
  - `GET /` - Basic page confirming service is running
  - `GET /api/status` - JSON with `{ "backend": "B", "status": "ok" }`
- Add `X-Backend: B` response header

## Setup

1. Install dependencies
2. Configure to listen on 0.0.0.0:3002
3. Start the service
4. Test accessibility from other machines

## Testing

```bash
curl http://<backend-b-ip>:3002/
curl http://<backend-b-ip>:3002/api/status
```
