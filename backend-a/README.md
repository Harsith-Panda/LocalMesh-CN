# Backend Server A

This directory contains the code for Backend Server A.

## Requirements

- Listen on port 3001
- Bind to LAN-accessible interface (not 127.0.0.1)
- Implement endpoints:
  - `GET /` - Basic page confirming service is running
  - `GET /api/status` - JSON with `{ "backend": "A", "status": "ok" }`
- Add `X-Backend: A` response header

## Setup

1. Install dependencies
2. Configure to listen on 0.0.0.0:3001
3. Start the service
4. Test accessibility from other machines

## Testing

```bash
curl http://<backend-a-ip>:3001/
curl http://<backend-a-ip>:3001/api/status
```
