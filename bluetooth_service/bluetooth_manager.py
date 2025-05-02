import subprocess
import time

def scan_devices():

    process = subprocess.Popen(["bluetoothctl"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Tarama başlatılıyor
    process.stdin.write(b"scan on\n")
    process.stdin.flush()
    time.sleep(6)

    process.stdin.write(b"scan off\n")
    process.stdin.flush()

    process.stdin.write(b"devices\n")
    process.stdin.flush()
    out, err = process.communicate()

    lines = out.decode().splitlines()

    devices = []
    for line in lines:
        if "Device" in line:
            parts = line.split(" ", 2)
            devices.append({"mac": parts[1], "name": parts[2]})
    
    return devices

def connect_device(mac):
    subprocess.run(f"bluetoothctl trust {mac}", shell=True)
    subprocess.run(f"bluetoothctl connect {mac}", shell=True)
    with open("settings.py", "w") as f:
        f.write(f'LAST_CONNECTED_MAC = "{mac}"\n')

def dissconnect_device():
    subprocess.run(f"bluetoothctl disconnect", shell=True)


def list_paired_devices():

    out = subprocess.check_output("bluetoothctl devices Paired", shell=True)

    paired_devices = []
    for line in out.decode().splitlines():
        if "Device" in line:
            mac_address = line.split()[1]
            device_info = subprocess.check_output(f"bluetoothctl info {mac_address}", shell=True).decode()
            name = ""
            for info in device_info.splitlines():
                if "Name" in info:
                    name = info.split(":")[1].strip()
            paired_devices.append({"mac": mac_address, "name": name})

    with open("bluetooth_service/paired_devices.txt", "w") as file:
        for device in paired_devices:
            file.write(f"MAC: {device['mac']}, Name: {device['name']}\n")

    return paired_devices


""" connect_device("E0:6D:17:5B:2E:3C") """


