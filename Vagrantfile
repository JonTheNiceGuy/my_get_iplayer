Vagrant.configure("2") do |config|

   config.vm.box = "ubuntu/xenial64"
   config.vm.box_check_update = false
   config.vm.boot_timeout = 65535

   config.vm.synced_folder "config", "/home/ubuntu/.get_iplayer/"
   config.vm.synced_folder "/content", "/media/sf_host"

   config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
   end

   config.ssh.insert_key = true
   config.ssh.forward_agent = true

   config.vm.provision "shell", run: "always", inline: <<-SHELL
     while ! ping -c 1 8.8.8.8 2>/dev/null >/dev/null ; do
       echo Waiting for network...
     done
     while [ ! -e /var/lib/apt/lists/lock ] ; do
       echo Waiting for file lock...
       sleep 1
     done
     apt update || true
     while [ ! -e /var/lib/apt/lists/lock ] ; do
       echo Waiting for file lock...
       sleep 1
     done
     apt full-upgrade -y || true
     apt autoremove -y || true
     apt autoclean -y || true
   SHELL

   config.vm.provision "shell", inline: <<-SHELL
     while [ ! -e /var/lib/apt/lists/lock ] ; do
       echo Waiting for file lock...
       sleep 1
     done
     sudo add-apt-repository -y ppa:jon-hedgerows/get-iplayer
     while [ ! -e /var/lib/apt/lists/lock ] ; do
       echo Waiting for file lock...
       sleep 1
     done
     sudo apt-get update
     while [ ! -e /var/lib/apt/lists/lock ] ; do
       echo Waiting for file lock...
       sleep 1
     done
     sudo apt-get install -y get-iplayer sendemail ffmpeg xsltproc
   SHELL

   config.vm.define "iplayerpvr" do |iplayerpvr|
     iplayerpvr.vm.hostname = "iplayerpvr"

     iplayerpvr.vm.network "forwarded_port", guest: 1935, host: 1935

     iplayerpvr.vm.provider "virtualbox" do |vb|
       vb.name = "Get-iPlayer-PVR"
     end

     iplayerpvr.vm.provision "shell", inline: <<-SHELL
       sed -i 's/127.0.0.1/0.0.0.0/g' /etc/default/get_iplayer_web_pvr
     SHELL

     iplayerpvr.vm.provision "shell", run: "always", inline: <<-SHELL
       su - ubuntu -c '/sbin/start-stop-daemon -b --name get-iplayer-web-pvr --start -a /bin/bash -- get-iplayer-web-pvr'
     SHELL
   end


   config.vm.define "getiplayer" do |getiplayer|
     getiplayer.vm.hostname = "getiplayer"

     getiplayer.vm.provider "virtualbox" do |vb|
       vb.name = "Get-iPlayer"
     end

     getiplayer.vm.provision "shell", run: "always", inline: <<-SHELL
       if [ -f /vagrant/mailconfig ]; then
         source /vagrant/mailconfig
         su - ubuntu -c 'get-iplayer --raw --pvr 2>>/vagrant/output.stderr' | tee -a /vagrant/output.stdout | sendemail -f $USER -t $USER -u "get-iplayer for `date +%F`" -s $SERVER -o tls=yes -xu $USER -xp $PASS -o timeout=0
       else
         su - ubuntu -c 'get-iplayer --raw --pvr 2>&1'
       fi
       echo Shutting down in 10 minutes. Please vagrant ssh in and perform sudo shutdown -c to cancel.
       sudo shutdown -h +10
     SHELL
   end
end
