import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

public class Main {
    private static void reply(HttpExchange exchange) throws IOException {
        String path = exchange.getRequestURI().getPath();
        String status = path.equals("/readyz") ? "ready" : "ok";
        String body = String.format(
            "{\"message\":\"Java servisidan salom!\",\"service\":\"java-api\",\"pod\":\"%s\",\"status\":\"%s\"}",
            System.getenv().getOrDefault("HOSTNAME", "local"), status
        );
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().add("Content-Type", "application/json");
        exchange.sendResponseHeaders(200, bytes.length);
        exchange.getResponseBody().write(bytes);
        exchange.close();
    }

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", 8080), 0);
        server.createContext("/", Main::reply);
        server.start();
    }
}
