from http.server import SimpleHTTPRequestHandler,ThreadingHTTPServer
from pathlib import Path
import os,webbrowser
os.chdir(Path(__file__).resolve().parent)
class Handler(SimpleHTTPRequestHandler):
    extensions_map={**SimpleHTTPRequestHandler.extensions_map,'.webmanifest':'application/manifest+json','.json':'application/json','.svg':'image/svg+xml'}
    def end_headers(self):
        self.send_header('Cache-Control','no-cache, must-revalidate')
        super().end_headers()
if __name__=='__main__':
    h=None
    for port in (8080,8081,8082):
        try:
            h=ThreadingHTTPServer(('127.0.0.1',port),Handler)
            break
        except OSError as exc:
            if getattr(exc,'errno',None) not in (48,98,10048):
                raise
    if h is None:
        raise SystemExit('ERROR: Ports 8080, 8081 and 8082 are occupied. Close other web servers.')
    url=f'http://127.0.0.1:{h.server_address[1]}/'
    print('PDR B server ready:',url,'  (Ctrl+C to stop)',flush=True)
    webbrowser.open(url)
    try:h.serve_forever()
    except KeyboardInterrupt:pass
