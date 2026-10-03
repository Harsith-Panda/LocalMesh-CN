#!/usr/bin/env python3
"""
Backend Server A - Simple HTTP/REST Service
Listens on port 3001
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class BackendHandler(BaseHTTPRequestHandler):
    """Simple HTTP handler for Backend A"""

    def do_GET(self):
        """Handle GET requests"""

        # Set headers
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('X-Backend', 'A')
        self.send_header('Cache-Control', 'max-age=60')
        self.send_header('ETag', '"backend-a-v1"')
        self.end_headers()

        # Root endpoint
        if self.path == '/':
            response = {
                "service": "Backend A",
                "status": "running",
                "message": "Backend Server A is operational"
            }
            self.wfile.write(json.dumps(response, indent=2).encode())

        # Status endpoint
        elif self.path == '/api/status':
            response = {
                "backend": "A",
                "status": "ok"
            }
            self.wfile.write(json.dumps(response, indent=2).encode())

        # 404 for other paths
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'{"error": "Not Found"}')

    def log_message(self, format, *args):
        """Suppress default logging"""
        pass

def run_server(host='0.0.0.0', port=3001):
    """Start the HTTP server"""
    server_address = (host, port)
    httpd = HTTPServer(server_address, BackendHandler)
    print(f"Backend A running on http://{host}:{port}")
    print("Endpoints:")
    print("  GET /          - Service info")
    print("  GET /api/status - Status check")
    httpd.serve_forever()

if __name__ == '__main__':
    run_server()
