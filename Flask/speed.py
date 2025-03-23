import socket
import time

# UDP ayarları
UDP_PORT = 5005
BROADCAST = "255.255.255.255"

# UDP soketi oluştur
udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

def udp_broadcast():
    speed = 0
    rpm = 0
    speed_increase = True  # Hız artış yönü
    rpm_increase = True    # RPM artış yönü

    while True:
        try:

            # Hız ve RPM güncellemesi
            if speed_increase:
                speed += 1
                if speed >= 160:
                    speed_increase = False
            else:
                speed -= 1
                if speed <= 0:
                    speed_increase = True

            if rpm_increase:
                rpm += 100
                if rpm >= 8000:
                    rpm_increase = False
            else:
                rpm -= 100
                if rpm <= 0:
                    rpm_increase = True

            # UDP mesajı oluştur
            message = f"Speed: {speed}, RPM: {rpm}"
            print(f"Sending: {message}")

            
            udp_socket.sendto(message.encode(), ("127.0.0.1", UDP_PORT))
            udp_socket.sendto(message.encode(), ("10.0.2.2", UDP_PORT))

        except Exception as e:
            print(f"Error sending UDP: {e}")

        time.sleep(0.01)  # 10ms bekle

if __name__ == "__main__":
    udp_broadcast()