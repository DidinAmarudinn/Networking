import UIKit

class WebSocketDelegate: NSObject, URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket Open.")
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        guard let theReason = String(data: reason!, encoding: .utf8) else { return }
        print("WebSocket closed with reason: \(theReason)")
    }
}

let delegate = WebSocketDelegate()
let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())
let url = URL(string: "wss://movies-feed.dicoding.dev")!
let task = session.webSocketTask(with: url)
task.resume()

let hello = "Hello from world"
let message = URLSessionWebSocketTask.Message.string(hello)

task.send(message) { error in
    if let error = error {
        print("Websocket sending error: \(error)")
    }
    
    print("Sending message: \(hello)")
}
task.sendPing { error in
    if let error = error {
        print("Ping failed: \(error)")
    }
    
    print("Send Ping")
}


task.receive { result in
    switch result {
    case .success(let message):
        switch message {
        case .data(let data):
            print("Recive binary message: \(data)")
        case .string(let text):
            print("Recive text message: \(text)")
        default:
            print("Message unformated")
        }
    case .failure(let failure):
        print("Failed to recive message: \(failure.localizedDescription)")
    }
    
    task.cancel(with: .goingAway, reason: "Im going away".data(using: .utf8))
}
