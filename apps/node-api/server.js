const http = require('http');
const os = require('os');

const server = http.createServer((req, res) => {
  const status = req.url === '/readyz' ? 'ready' : 'ok';
  const body = JSON.stringify({
    message: 'Node.js servisidan salom!',
    service: 'node-api',
    pod: os.hostname(),
    status
  });
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(body);
});

server.listen(8080, '0.0.0.0');
