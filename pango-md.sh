#!/data/data/com.termux/files/usr/bin/bash

DOWNLOAD_DIR="/sdcard/PANGO-Downloads"
mkdir -p "$DOWNLOAD_DIR"

# Check yt-dlp
if ! command -v yt-dlp &>/dev/null; then
  echo "Installing yt-dlp..."
  pkg install -y python ffmpeg
  pip install yt-dlp
fi

# UI
clear
logo=$(cat << "EOF"
██████╗  █████╗ ███╗   ██╗ ██████╗  ██████╗ 
██╔══██╗██╔══██╗████╗  ██║██╔════╝ ██╔═══██╗
██████╔╝███████║██╔██╗ ██║██║  ███╗██║   ██║
██╔═══╝ ██╔══██║██║╚██╗██║██║   ██║██║   ██║
██║     ██║  ██║██║ ╚████║╚██████╔╝╚██████╔╝
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝ 
EOF
)
echo "$logo" | lolcat

echo -e "\e[1;36m                Downloader: YouTube - TikTok - Instagram - Facebook"
echo -e "\e[1;33m                Save Path: $DOWNLOAD_DIR\n"

# Platform
echo -e "\e[1;34mChoose platform:"
echo "1) YouTube"
echo "2) TikTok"
echo "3) Instagram"
echo "4) Facebook"
read -p $'\e[1;33mYour choice (1-4): \e[0m' platform

# URL
read -p $'\n\e[1;32mEnter the video URL:\e[0m ' url

# Format
echo -e "\n\e[1;34mChoose format:"
echo "1) Video (MP4)"
echo "2) Audio (MP3)"
read -p $'\e[1;33mFormat (1/2): \e[0m' format

# Filename
echo -e "\n\e[1;34mFilename options:"
echo "1) Let the tool choose (safe auto name)"
echo "2) I want to write my own filename"
read -p $'\e[1;33mChoice (1/2): \e[0m' name_choice

if [ "$name_choice" == "2" ]; then
  read -p $'\n\e[1;32mEnter custom filename (no extension): \e[0m' custom_name
  OUT_NAME="$DOWNLOAD_DIR/${custom_name}.%(ext)s"
else
  OUT_NAME="$DOWNLOAD_DIR/%(upload_date)s_%(id)s.%(ext)s"
fi

# Subtitles for YouTube
if [ "$platform" == "1" ] && [ "$format" == "1" ]; then
  read -p $'\n\e[1;36mDownload subtitles (if any)? (y/n):\e[0m ' subs
  read -p $'\e[1;36mSubtitles language (default: en):\e[0m ' sub_lang
  sub_lang=${sub_lang:-en}
fi

echo -e "\n\e[1;35mDownloading now...\n" | lolcat

# Logic
if [ "$format" == "1" ]; then
  yt-dlp -f "mp4" \
    -o "$OUT_NAME" \
    $( [ "$platform" == "1" ] && [ "$subs" == "y" ] && echo "--write-subs --embed-subs --sub-lang $sub_lang" ) \
    "$url"
elif [ "$format" == "2" ]; then
  yt-dlp -x --audio-format mp3 \
    -o "$OUT_NAME" \
    "$url"
else
  echo -e "\n\e[1;31mInvalid format!\e[0m"
  exit 1
fi

echo -e "\n\e[1;32mDownload complete! Saved in: $DOWNLOAD_DIR\n" 
