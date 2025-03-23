import requests

url = "http://127.0.0.1:5000/send_udp"
data = {"message": "Hello UDP from Python!"}

response = requests.post(url, json=data)

print(response.json())  # {"status": "Message sent", "message": "Hello UDP from Python!"}
