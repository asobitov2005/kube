require 'json'
require 'socket'

server = TCPServer.new('0.0.0.0', 8080)
loop do
  client = server.accept
  request = client.gets.to_s
  path = request.split(' ')[1] || '/'
  while (line = client.gets)
    break if line.strip.empty?
  end
  body = JSON.generate(
    message: 'Ruby servisidan salom!',
    service: 'ruby-api',
    pod: ENV.fetch('HOSTNAME', 'local'),
    status: path == '/readyz' ? 'ready' : 'ok'
  )
  client.write "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: #{body.bytesize}\r\nConnection: close\r\n\r\n#{body}"
  client.close
end
