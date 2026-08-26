use std::env;
use std::io::{Read, Write};
use std::net::{TcpListener, TcpStream};

fn handle(mut stream: TcpStream) {
    let mut buffer = [0; 1024];
    let size = stream.read(&mut buffer).unwrap_or(0);
    let request = String::from_utf8_lossy(&buffer[..size]);
    let status = if request.starts_with("GET /readyz ") { "ready" } else { "ok" };
    let pod = env::var("HOSTNAME").unwrap_or_else(|_| "local".into());
    let body = format!(
        "{{\"message\":\"Rust servisidan salom!\",\"service\":\"rust-api\",\"pod\":\"{}\",\"status\":\"{}\"}}",
        pod, status
    );
    let response = format!(
        "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{}",
        body.len(), body
    );
    let _ = stream.write_all(response.as_bytes());
}

fn main() {
    let listener = TcpListener::bind("0.0.0.0:8080").expect("8080 portini ochib bo'lmadi");
    for stream in listener.incoming().flatten() {
        handle(stream);
    }
}
