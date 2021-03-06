#!/bin/bash

read -p "What is your User Name?: " UserName
read -p "What is your Device Name?: " AirPlay

#============================== Error Handler ==========================
function excmd {
  echo "==================> Executing: $*"
  if ! $*; then
    echo "Exiting script due to error from: $*"
    exit 1
  fi
}
#============================== End Error Handler ======================

# Installs shairport-sync
apt-get install shairport-sync -y

# Disables shairport-sync as a system daemon
systemctl disable shairport-sync

# Copies the new shairport-start script which will handle starting shairport
excmd cp usr/local/bin/shairport-start /usr/local/bin/shairport-start

# Makes the new script executable
excmd chmod +x /usr/local/bin/shairport-start
excmd cp usr/local/bin/changesink /usr/local/bin/changesink
excmd chmod +x /usr/local/bin/changesink


# Copy the shell script that sets the default sink
excmd cp usr/local/bin/setdefaultsink /usr/local/bin/setdefaultsink

# Made  setdefaultsink executable
excmd chmod +x /usr/local/bin/setdefaultsink


# Inserts the Chosen AirPlay name into shairport-sync.conf at line 7
sed -i "7i \name = \"${AirPlay}\";" /etc/shairport-sync.conf


# Added shairport-sync to the pulse and lp group
excmd usermod -a -G pulse shairport-sync
excmd usermod -a -G lp shairport-sync
exit 0
