#! /bin/sh
# A script to set system-wide proxy in Ubuntu / Debian
# Created by thealphadollar
# Contributions from TheMousePotato, Ayushk4 and baymac

if [ $(id -u) -ne 0 ]
  then echo "Error: needs to be run as sudo!!"
  exit 1
fi

exit_with_usage ()
{
echo "setproxy: invalid option"
echo "Usage: ./set_proxy.sh -h [PROXY HOST] -p [PROXY PORT]"
echo "Try './set_proxy.sh --help' for more information."
# Help to be added later when script functions increases
exit 1
}

reset_proxy ()
{
echo "resetting proxy.."
gsettings set org.gnome.system.proxy mode none
truncate -s 0 /etc/profile.d/proxy.sh
sed -i.bak "/Acquire::/d" /etc/apt/apt.conf
sed -i.bak "/Acquire::/,+10d" /etc/apt/apt.conf.d/70debconf
sed -i "/proxy/d" /etc/environment
sed -i "/PROXY/d" /etc/environment
if hash git 2>/dev/null; then
  git config --global --unset http.proxy
  git config --global --unset https.proxy
fi
echo "done"
if hash docker 2>/dev/null; then
  truncate -s 0 /etc/systemd/system/docker.service.d/http-proxy.conf
  truncate -s 0 ~/.docker/config.json
  systemctl daemon-reload
  systemctl restart docker
fi
}

# setting system wide proxy
set_systemwide_proxy () 
{
gsettings set org.gnome.system.proxy mode 'manual'
gsettings set org.gnome.system.proxy.http host "$PROXY_HOST"
gsettings set org.gnome.system.proxy.http port "$PROXY_PORT"
gsettings set org.gnome.system.proxy.https host "$PROXY_HOST"
gsettings set org.gnome.system.proxy.https port "$PROXY_PORT"
gsettings set org.gnome.system.proxy.ftp host "$PROXY_HOST"
gsettings set org.gnome.system.proxy.ftp port "$PROXY_PORT"
gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '127.0.0.1/8', '::1', '10.*.*.*']"
echo "systemwide proxy set"
}

# setting APT-conf proxy

## in /etc/apt/conf **deprecated**
set_apt_proxy_old ()
{
sed -i.bak '/http[s]::proxy/Id' /etc/apt/apt.conf
tee -a /etc/apt/apt.conf <<EOF
Acquire::http::proxy "http://${PROXY_HOST}:${PROXY_PORT}";
Acquire::https::proxy "http://${PROXY_HOST}:${PROXY_PORT}";
Acquire::ftp::proxy "http://${PROXY_HOST}:${PROXY_PORT}";
EOF
echo "APT proxy set"
}

## in /etc/apt/apt.conf.d/70debconf
set_apt_proxy ()
{
sed -i.bak '/http[s]::proxy/Id' /etc/apt/apt.conf.d/70debconf
tee -a /etc/apt/apt.conf.d/70debconf <<EOF
Acquire::http::proxy "http://${PROXY_HOST}:${PROXY_PORT}";
Acquire::https::proxy "http://${PROXY_HOST}:${PROXY_PORT}";
Acquire::ftp
 {
   Proxy "ftp://${PROXY_HOST}:${PROXY_PORT}";
   ProxyLogin 
   {
      "USER $(SITE_USER)@$(SITE)";
      "PASS $(SITE_PASS)";
   }
 }
EOF
echo "APT proxy set"
}

# setting environment proxy
set_environment_proxy ()
{
sed -i.bak '/http[s]_proxy/Id' /etc/environment
tee -a /etc/environment <<EOF
http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
https_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
ftp_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
HTTP_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
HTTPS_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
FTP_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
no_proxy=localhost,127.0.0.0/8,::1,10.0.0.0/8,127.0.0.1/8
EOF
echo "Environment proxy set"
}

# setting bash profile proxy 
set_profile_proxy ()
{
touch /etc/profile.d/proxy.sh
tee -a /etc/profile.d/proxy.sh <<EOF
export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export https_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export HTTP_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
export HTTPS_PROXY="http://${PROXY_HOST}:${PROXY_PORT}"
EOF
echo "Profile proxy set"
}

# application specific proxy

# setting Git proxy
set_git_proxy ()
{
if hash git 2>/dev/null; then
  git config --global http.proxy "http://${PROXY_HOST}:${PROXY_PORT}"
  git config --global https.proxy "http://${PROXY_HOST}:${PROXY_PORT}"
fi
echo "Git proxy set"
}

# setting docker proxy
set_docker_proxy ()
{
if hash docker 2>/dev/null; then
      if [ ! -d "/etc/systemd/system/docker.service.d" ]
      then
               mkdir /etc/systemd/system/docker.service.d
      fi
      touch /etc/systemd/system/docker.service.d/http-proxy.conf
      tee  /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://${PROXY_HOST}:${PROXY_PORT}/"
Environment="NO_PROXY=localhost,127.0.0.0/8"
EOF
      if [ ! -d "$HOME/.docker" ] 
      then
              mkdir ~/.docker
      fi
      touch ~/.docker/config.json
      tee  ~/.docker/config.json <<EOF
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "http://${PROXY_HOST}:${PROXY_PORT}",
     "noProxy": "*.test.example.com,.example2.com",
     "httpsProxy": "https://${PROXY_HOST}:${PROXY_PORT}",
     "ftpProxy": "ftp://${PROXY_HOST}:${PROXY_PORT}"
   }
 }
}
EOF
      #flash changes
      systemctl daemon-reload
      #verify proxy setting
      systemctl show --property Environment docker
      #restart docker
      systemctl restart docker
fi
echo "Docker proxy set"
}

if [ "$#" -eq 1 ]; then
  case $1 in    
    -u| --unset)    
      reset_proxy
      exit 0
      ;;
    *)          
      exit_with_usage 
      ;;
  esac
elif [ "$#" -eq 4 ]; then
    case $1 in
      -h| --host)
        shift
        PROXY_HOST=$1
        echo $PROXY_HOST
        shift
        case $1 in
          -p| --port)
            shift
            PROXY_PORT=$1
            echo $PROXY_PORT
            shift
            ;;
          *) 
            exit_with_usage 
            ;;
        esac
        ;;
      *) 
        exit_with_usage 
        ;;
    esac
else
  exit_with_usage
fi

set_systemwide_proxy
set_environment_proxy
set_apt_proxy_old
set_apt_proxy
set_profile_proxy
set_git_proxy
set_docker_proxy
