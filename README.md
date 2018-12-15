## WEBAPP

ProxyMaster is now available at https://proxymaster.herokuapp.com

# LINUX Proxy 

The script in the repository sets/unsets proxy for most frequently used commands in the
Ubuntu/Debian system.

- Gnome system wide</br>
- Apt Package Installer</br>
- Environment</br>
- Terminal</br>
- Git</br>

## How to run

You need to have internet to download the script, use mobile data and hotspot.

- Open terminal by pressing `Ctrl+Alt+T`
- Install wget. </br>
    `sudo apt-get install wget`
- Download the repository.</br>
    `wget https://github.com/thealphadollar/set_proxy/archive/master.zip`
- Unzip the file.</br>
    `unzip master.zip`
- Change directory to the inflated archive folder.</br>
    `cd ./set_proxy-master`
- Launch the script </b>
    `sudo ./set_proxy.sh`
- Enter `proxy host` (172.16.2.30 for KGP) and `proxy port` (8080 for KGP) when
  prompted.</br>
- Voila, proxy set! Preferably restart the system, or at least restart the terminal session.

## Going Home?

You can use the same script to remove proxy from your system when going to
home. Just run following command in your terminal and restart system.

`sudo ./set_proxy.sh --unset`

## Test

Connect to the campus network; wifi or LAN.

- Open `www.google.com` in browser
- In terminal `sudo apt-get install curl`
- In terminal `curl www.google.com`

If all the above steps pass, congratulations!

# support

For any queries, please raise an issue or contact github@thealphadollar.

## Contributing

Please read CONTRIBUTING.md guide to know more.
