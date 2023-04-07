import os
from http.server import HTTPServer, BaseHTTPRequestHandler

HOST = '0.0.0.0'
PORT = 90


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()

        with open('mk.html', 'rb') as file:
            content = file.read()
            self.wfile.write(content)


def run(host, port, server_class=HTTPServer, handler_class=Handler):
    server_address = (host, port)
    httpd = server_class(server_address, handler_class)

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass

    httpd.server_close()


if __name__ == '__main__':
    run(HOST, PORT)
