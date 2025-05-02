import subprocess
import re

def parse_music_info(output):
    # Çıktıdan müzik bilgilerini çekmek için regex desenleri
    artist_pattern = r"Artist: (.+)"
    title_pattern = r"Title: (.+)"
    album_pattern = r"Album: (.+)"
    position_pattern = r"Position: (.+)"
    status_pattern = r"Status: (.+)"
    state_pattern = r"State: (.+)"
    
    # Regex kullanarak sanatçı, başlık, albüm, pozisyon bilgilerini alıyoruz
    artist = re.search(artist_pattern, output)
    title = re.search(title_pattern, output)
    album = re.search(album_pattern, output)
    position = re.search(position_pattern, output)
    status = re.search(status_pattern,output)
    state = re.search(state_pattern,output)
    
    # Bilgileri işliyoruz ve terminalde yazdırıyoruz
    if artist:
        print(f"Artist: {artist.group(1)}")
    if title:
        print(f"Title: {title.group(1)}")
    if album:
        print(f"Album: {album.group(1)}")
    if position:
        print(f"Position: {position.group(1)}")
    if status:
        print(f"Status: {status.group(1)}")
    if state:
        print(f"State: {state.group(1)}")

def run_bluetoothctl():
    # bluetoothctl komutunu başlatıyoruz
    command = ["bluetoothctl"]
    
    # Popen ile subprocess başlatıyoruz ve çıkışı anlık olarak okuyoruz
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    
    # Çıktıyı sürekli okuma
    while True:
        output = process.stdout.readline()
        
        # Eğer çıktı varsa, yazdırıyoruz
        if output:
            # Müzikle ilgili bilgileri işle
            parse_music_info(output.strip())
        
        # Eğer işlem bitmişse (terminasyon), döngüden çıkıyoruz
        if process.poll() is not None:
            break

# Python kodunu çalıştırarak bluetoothctl çıktısını işlemeye başlayabilirsiniz
run_bluetoothctl()
