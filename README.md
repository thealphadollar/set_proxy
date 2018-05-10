# LINUX Proxy KGP 

The script in the repository sets proxy for most frequently used commands in the
Ubuntu/Debian system.

-- Gnome system wide</br>
-- Apt Package Installer</br>
-- Environment</br>
-- Terminal</br>

## How to run

You need to have internet to download the script, use mobile data and hotspot.

- Open terminal by pressing `Ctrl+Alt+T`
- Install wget. </br>
    `sudo apt-get install wget`
- Download the repository.</br>
    `wget https://github.com/thealphadollar/set_proxy_kgp/archive/master.zip`
- Unzip the file.</br>
    `unzip master.zip`
- Change directory to the inflated archive folder.</br>
    `cd ./set_proxy_kgp-master`
- Make the script executable and launch it.</br>
    `sudo chmod +x set_proxy_kgp.sh && sudo ./set_proxy_kgp.sh`
- Preferably restart the system, or at least restart the terminal session.

## Test

Connect to the campus network; wifi or LAN.

- Open `www.google.com` in browser
- In terminal `sudo apt-get install curl`
- In terminal `curl www.google.com`

If all the above steps pass, congratulations!

# support

For any quries, please raise an issue or contant github@thealphadollar.
