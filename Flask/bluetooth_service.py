import subprocess
import asyncio
import re
import uvicorn
from fastapi import FastAPI, WebSocket
from fastapi.responses import JSONResponse

app = FastAPI()

connected_device_mac = None

@app.on_event("startup")
async def on_startup():
    await initialize_bluetooth()

async def run_bluetoothctl(commands: list[str], delay: float = 0.5) -> str:
    process = await asyncio.create_subprocess_exec(
        "bluetoothctl",
        stdin=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )

    for cmd in commands:
        print(f"📤 Komut gönderiliyor: {cmd}")
        process.stdin.write(f"{cmd}\n".encode())
        await process.stdin.drain()
        await asyncio.sleep(delay)

    process.stdin.write(b"exit\n")
    await process.stdin.drain()
    process.stdin.close()
    await process.wait()

    output = await process.stdout.read()
    return output.decode()

@app.get("/init")
async def initialize_bluetooth():
    print("🔧 Bluetooth başlatılıyor...")

    # Bluetooth varsayılan ayarlarını yap
    await run_bluetoothctl([
        "power on",
        "agent on",
        "default-agent",
        "discoverable on",
        "pairable on",
        "connectable on"
    ])

    # Eşleşmiş cihazları listele
    paired_output = await run_bluetoothctl(["devices"])
    devices = re.findall(r"Device ([0-9A-F:]{17}) (.+)", paired_output)

    if not devices:
        print("🔍 Hiç eşleşmiş cihaz bulunamadı.")
        return {"status": "no_paired_devices"}

    # Cihazlara sırayla bağlanmayı dene
    for mac, name in devices:
        print(f"🔌 {mac} ({name}) cihazına bağlanma deneniyor...")
        result = await run_bluetoothctl([f"connect {mac}"],delay=3)
        if any("Connection successful" in line for line in result.splitlines()):
            print(f"✅ Bağlantı başarılı: {mac} ({name})")
        else:
            print(f"❌ Bağlantı başarısız: {mac} ({name})")

    return {"status": "connection_failed"}

# Cihaz tarama
@app.get("/scan")
async def scan_devices():
    process = await asyncio.create_subprocess_exec(
        "bluetoothctl", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    await run_bluetoothctl([
        "power on",
        "agent on",
        "default-agent",
        "discoverable on",
        "pairable on",
        "connectable on"
    ])
    # Taramayı başlat
    process.stdin.write(b"scan on\n")
    await process.stdin.drain()
    await asyncio.sleep(10)

    # Taramayı durdur
    process.stdin.write(b"scan off\n")
    await process.stdin.drain()
    await asyncio.sleep(1)  # scan off'un işlenmesi için küçük bekleme

    # Artık process'i kapat
    process.terminate()
    await process.wait()

    # Çıktıyı oku
    output, _ = await process.communicate()

    devices = set()
    lines = output.decode().splitlines()

    for line in lines:
        if "[CHG] Device" in line and "RSSI is nil" not in line and "TxPower is nil" not in line:
            matches = re.findall(r"Device ([0-9A-F:]{17}) (.+)", line)
            if matches:
                for mac, name in matches:
                    devices.add((mac, name))

    return [{"mac": mac, "name": name} for mac, name in devices]


# Cihaza bağlanma
@app.post("/connect")
async def connect_device(mac: str):
    global connected_device_mac

    process = await asyncio.create_subprocess_exec(
        "bluetoothctl", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    process.stdin.write(f"connect {mac}\n".encode())
    await process.stdin.drain()
    await asyncio.sleep(3)

    output = await process.stdout.read()
    if b"Connection successful" in output:
        connected_device_mac = mac
        return JSONResponse(content={"message": "Connected!"})
    else:
        return JSONResponse(content={"message": "Connection failed."}, status_code=400)

# WebSocket ile müzik bilgisini gönderme
@app.websocket("/ws")
async def stream_metadata(websocket: WebSocket):
    await websocket.accept()
    process = await asyncio.create_subprocess_exec(
        "bluetoothctl", stdout=subprocess.PIPE, stdin=subprocess.PIPE
    )

    while True:
        line = await process.stdout.readline()
        decoded = line.decode().strip()
        if "[CHG] Player" in decoded and any(key in decoded for key in ["Title", "Artist", "Album", "Status", "Position"]):
            print(decoded)
            await websocket.send_text(decoded)

if __name__ == "__main__":
    uvicorn.run("bluetooth_service:app", host="0.0.0.0", port=8000)
    
 
