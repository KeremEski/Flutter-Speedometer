from flask import Flask, request
import socket
import threading
import time

app = Flask(__name__)

UDP_PORT = 5005
ALL_INTERFACES = "0.0.0.0"
BROADCAST = "255.255.255.255"

# Soket oluşturma
udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

def udp_broadcast():
    count = 0
    while True:
        try:
            # Test mesajı oluştur
            message = f"Test UDP message #{count}"
            count += 1
            
            # Mesajı broadcast olarak gönder
            print(f"Sending broadcast: {message}")
            udp_socket.sendto(message.encode(), (BROADCAST, UDP_PORT))
            
            # Loopback adresi:
            print(f"Sending to localhost: {message}")
            udp_socket.sendto(message.encode(), ("127.0.0.1", UDP_PORT))
            
            print(f"Messages sent, cycle #{count} complete")
            
        except Exception as e:
            print(f"Error sending UDP: {e}")
        
        time.sleep(2)

if __name__ == '__main__':
    print(f"Starting UDP broadcast on port {UDP_PORT}")
    udp_thread = threading.Thread(target=udp_broadcast, daemon=True)
    udp_thread.start()
    
    print("Starting Flask server on port 5000")
    app.run(debug=False, host=ALL_INTERFACES, port=5000)