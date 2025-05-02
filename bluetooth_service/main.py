from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
import asyncio

import uvicorn
from bluetooth_manager import scan_devices, connect_device, list_paired_devices
from avrcp_handler import get_player, get_metadata
from settings import LAST_CONNECTED_MAC

app = FastAPI()

# CORS (Flutter localhost/web erişimi için)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Gerekirse IP sınırı koyabilirsin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 🔄 Uygulama başladığında son bağlı cihaza otomatik bağlan
@app.on_event("startup")
def auto_connect():
    if LAST_CONNECTED_MAC:
        print(f"🔁 Otomatik bağlantı başlatılıyor: {LAST_CONNECTED_MAC}")
        connect_device(LAST_CONNECTED_MAC)

# 1️⃣ Tüm cihazları ara
@app.websocket("/ws/devices")
async def websocket_scan_devices(websocket: WebSocket):
    await websocket.accept()
    try:
        devices = scan_devices()
        await websocket.send_json(devices)
    except Exception as e:
        await websocket.send_json({"error": str(e)})

# 2️⃣ Belirli bir cihaza bağlan
@app.websocket("/ws/connect")
async def websocket_connect_device(websocket: WebSocket):
    await websocket.accept()
    try:
        data = await websocket.receive_json()
        mac = data.get("mac")
        if mac:
            connect_device(mac)
            await websocket.send_text("connected")
        else:
            await websocket.send_text("no_mac_provided")
    except Exception as e:
        await websocket.send_json({"error": str(e)})

# 3️⃣ Kayıtlı (paired) cihazları listele
@app.websocket("/ws/paired")
async def websocket_list_paired(websocket: WebSocket):
    await websocket.accept()
    try:
        paired = list_paired_devices()
        await websocket.send_json(paired)
    except Exception as e:
        await websocket.send_json({"error": str(e)})

# 5️⃣ AVRCP Metadata verilerini dinleyiciye gönder
@app.websocket("/ws/metadata")
async def websocket_metadata(websocket: WebSocket):
    await websocket.accept()
    player = get_player(LAST_CONNECTED_MAC)

    if not player:
        await websocket.send_json({"error": "AVRCP player bulunamadı"})
        return

    try:
        while True:
            metadata = get_metadata(player)
            await websocket.send_json(metadata)
            await asyncio.sleep(1)
    except WebSocketDisconnect:
        print("❌ Flutter bağlantısı koptu")
    except Exception as e:
        print("🛑 Metadata hatası:", e)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)