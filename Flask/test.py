import dbus
import dbus.mainloop.glib
from gi.repository import GLib

def properties_changed(interface, changed, invalidated, path):
    # Sinyalin doğru yolda geldiğinden emin olun
    if interface != "org.bluez.MediaPlayer1":
        return

    print(f"📻 Signal from: {path}")
    
    # Durum değişikliği
    if 'Status' in changed:
        print(f"🎬 Status Changed: {changed['Status']}")

    # Meta veri (track) değişikliği
    if 'Track' in changed:
        track = changed['Track']
        title = track.get("Title", "Unknown")
        artist = track.get("Artist", "Unknown")
        album = track.get("Album", "Unknown")
        print(f"🎵 Track changed: {title} - {artist} ({album})")
        print("🆕 Değişti!")

def bluetooth_metadata_listener():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    
    # Sistem bus'ına bağlanıyoruz
    bus = dbus.SystemBus()

    # Signal alıcıyı ekliyoruz (PropertiesChanged sinyali dinliyoruz)
    bus.add_signal_receiver(
        handler_function=properties_changed,
        signal_name="PropertiesChanged",
        dbus_interface="org.freedesktop.DBus.Properties",
        path="/org/bluez/hci0/dev_E0_6D_17_5B_2E_3C/player0"  # Burada doğru yolu kullandığınızdan emin olun
    )

    # D-Bus event loop'unu başlatıyoruz
    loop = GLib.MainLoop()
    print("🎧 Dinlemeye başlandı...")
    loop.run()

if __name__ == "__main__":
    bluetooth_metadata_listener()
