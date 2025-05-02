from pydbus import SystemBus

def get_player(mac):
    try:
        path = f"/org/bluez/hci0/dev_{mac.replace(':', '_')}/player0"
        return SystemBus().get("org.bluez", path)
    except:
        return None

def get_metadata(player):
    try:
        meta = player.Properties["org.bluez.MediaPlayer1"]["Metadata"]
        return {
            "title": meta.get("Title", ""),
            "artist": meta.get("Artist", ""),
            "album": meta.get("Album", ""),
            "duration": meta.get("Duration", 0),
        }
    except:
        return {}
