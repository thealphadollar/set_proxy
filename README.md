# LINUX Proxy KGP 

The script in the repository sets proxy for almost everything in the
Ubuntu/Debian system.

-- Gnome system wise
-- Apt Package Installer
-- Environment 
-- Export to terminal

## How to run

- Clone the repository
- `sudo chmod +x set_proxy_kgp.sh && sudo ./set_proxy_kgp.sh`
- Preferably restart the system, or at least restart the terminal session.

## Test

- Open `www.google.com` in browser
- In terminal `sudo apt-get install curl`
- In terminal `curl www.google.com`

If all the above steps pass, congratulations.
For any quries, contant github@thealphadollar
