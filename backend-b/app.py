#!/usr/bin/env python3
"""
Backend Server B - Simple HTTP/REST Service
Listens on port 3002
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class BackendHandler(BaseHTTPRequestHandler):
    """Simple HTTP handler for Backend B"""

    def _response(self):
        if self.path == '/':
            return {"service": "Backend B", "status": "running",
                    "message": "Backend Server B is operational"}
        if self.path == '/api/status':
            return {"backend": "B", "status": "ok"}
        return None

    def _send(self, body, status=200):
        payload = json.dumps(body, indent=2).encode()
        etag = '"backend-b-v1"'
        if status == 200 and self.headers.get('If-None-Match') == etag:
            status = 304
            payload = b''
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('X-Backend', 'B')
        self.send_header('Cache-Control', 'max-age=60')
        self.send_header('ETag', etag)
        self.send_header('Content-Length', str(len(payload)))
        self.end_headers()
        if self.command != 'HEAD':
            self.wfile.write(payload)

    def do_GET(self):
        body = self._response()
        self._send(body if body is not None else {"error": "Not Found"},
                   200 if body is not None else 404)

    def do_HEAD(self):
        body = self._response()
        self._send(body if body is not None else {"error": "Not Found"},
                   200 if body is not None else 404)

    def log_message(self, format, *args):
        """Suppress default logging"""
        pass

def run_server(host='0.0.0.0', port=3002):
    """Start the HTTP server"""
    server_address = (host, port)
    httpd = HTTPServer(server_address, BackendHandler)
    print(f"Backend B running on http://{host}:{port}")
    print("Endpoints:")
    print("  GET /          - Service info")
    print("  GET /api/status - Status check")
    httpd.serve_forever()

if __name__ == '__main__':
    run_server()
