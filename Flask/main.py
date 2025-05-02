import json
import os
import subprocess
import asyncio
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import List

import uvicorn

app = FastAPI()

last_connected_file = "last_connected.json"
connected_device_mac = None

# ---------- Bluetooth İşlemleri ----------

@app.get("/scan")
def scan_devices():
    output = subprocess.check_output(["bluetoothctl", "scan", "on"], timeout=5)
    result = subprocess.check_output(["bluetoothctl", "devices"])
    lines = result.decode().splitlines()
    devices = []
    for line in lines:
        parts = line.split(" ", 2)
        if len(parts) >= 3:
            devices.append({"mac": parts[1], "name": parts[2]})
    return devices

@app.post("/connect/{mac}")
def connect(mac: str):
    global connected_device_mac
    subprocess.run(["bluetoothctl", "connect", mac], capture_output=True)
    connected_device_mac = mac
    with open(last_connected_file, "w") as f:
        json.dump({"mac": mac}, f)
    return {"status": "connected", "mac": mac}

@app.post("/disconnect")
def disconnect():
    subprocess.run(["bluetoothctl", "disconnect"], capture_output=True)
    return {"status": "disconnected"}

# ---------- Otomatik Bağlanma ----------

@app.on_event("startup")
def connect_last():
    global connected_device_mac
    if os.path.exists(last_connected_file):
        with open(last_connected_file) as f:
            data = json.load(f)
            mac = data.get("mac")
            if mac:
                subprocess.run(["bluetoothctl", "connect", mac], capture_output=True)
                connected_device_mac = mac

# ---------- Müzik Metadata ----------

def get_metadata():
    try:
        output = subprocess.check_output(["playerctl", "metadata", "--format",
            '{{"title":"{{title}}","artist":"{{artist}}","album":"{{album}}","status":"{{status}}"}}'])
        return json.loads(output.decode())
    except Exception:
        return {"title": "", "artist": "", "album": "", "status": "Stopped"}

@app.get("/metadata")
def metadata():
    return get_metadata()

# ---------- WebSocket Metadata Yayını ----------

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: dict):
        for connection in self.active_connections:
            try:
                await connection.send_json(message)
            except Exception:
                self.disconnect(connection)

manager = ConnectionManager()

@app.websocket("/ws/metadata")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            meta = get_metadata()
            await manager.broadcast(meta)
            await asyncio.sleep(1.0)
    except WebSocketDisconnect:
        manager.disconnect(websocket)

# ---------- Medya Kontrolleri ----------

@app.post("/media/{action}")
def media_control(action: str):
    if action in ["play", "pause", "play-pause", "next", "previous", "stop"]:
        subprocess.run(["playerctl", action])
        return {"status": action}
    return {"error": "invalid action"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)