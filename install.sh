#!/bin/bash
printf "INSTALLING ..."
apt update
apt-get install -y stunnel4
cat << EOF > /root/banner.txt
    @IranProxy
EOF
mkdir /etc/stunnel
cat << EOF > /etc/stunnel/stunnel.conf
    cert = /etc/stunnel/stunnel.pem
    [openssh]
    accept = 443
    connect = 0.0.0.0:22
EOF
sudo apt install python3-pip -y
pip3 install redis flask waitress requests
bash <(curl -Ls https://raw.githubusercontent.com/Alirezad07/Nethogs-Json-main/master/install.sh --ipv4)
clear
printf "Secure SSHD"
cat << EOF > /etc/ssh/sshd_config
    Port 22
    Protocol 2
    KeyRegenerationInterval 3600
    ServerKeyBits 1024
    SyslogFacility AUTH
    LogLevel INFO
    LoginGraceTime 120
    PermitRootLogin yes
    StrictModes yes
    RSAAuthentication yes
    PubkeyAuthentication yes
    IgnoreRhosts yes
    RhostsRSAAuthentication no
    HostbasedAuthentication no
    PermitEmptyPasswords no
    PermitTunnel yes
    ChallengeResponseAuthentication no
    PasswordAuthentication yes
    X11Forwarding yes
    X11DisplayOffset 10
    PrintMotd no
    PrintLastLog yes
    TCPKeepAlive yes
    #UseLogin no
    AcceptEnv LANG LC_*
    Subsystem sftp /usr/lib/openssh/sftp-server
    UsePAM yes
EOF
clear

[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
	echo 'PasswordAuthentication yes' > /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
service ssh restart > /dev/null; sleep 2s; passwd
printf "Done"
