# The ultimate Pi homelab

Last update: october 2026

## What does it do?
Installs Docker. Starts Jellyfin and qBittorrent in containers

## Where to run
On a freshly installed Rapsberry Pi

## How to use
- Copy all files to your Pi
- Copy the `.env.example` to `.env`
- Update `.env` with your information
- Make `setup.sh` executable: `chmod 700 ./setup.sh`
- Run `setup.sh`

## Notes
- No JELLYFIN_PublishedServerUrl on purpose
- Jellyfin media is read only, cannot delete or overwrite anything, so no artwork saving
    - If you want to save artwork and/or .nfo -> delete `read_only: true` line
- No GPU passthrough: the Pi 5 has no video encoder

## AI statement
- Most of the code, script etc. in this repo is AI generated
