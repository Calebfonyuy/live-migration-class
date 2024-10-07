#! /bin/bash
sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
apt-get update
apt-get upgrade -y
apt-get -y install build-essential
apt-get -y install bcc bin86 gawk bridge-utils iproute2 libcurl4 libcurl4-openssl-dev bzip2 kmod transfig tgif pkg-config
apt-get -y install texinfo texlive-latex-base texlive-latex-recommended texlive-fonts-extra texlive-fonts-recommended libpci-dev mercurial
apt-get -y install make gcc libc6-dev zlib1g-dev python python-dev python3-twisted libncurses5-dev patch libvncserver-dev libsdl-dev libjpeg-dev
apt-get -y install python3-dev libglib2.0-dev
apt-get -y install libnl-3-dev libnl-cli-3-dev libnl-genl-3-dev libnl-route-3-dev libnl-idiag-3-dev libnl-xfrm-3-dev
apt-get -y install iasl libbz2-dev e2fslibs-dev git-core uuid-dev ocaml ocaml-findlib ocamlbuild libx11-dev bison flex xz-utils libyajl-dev
apt-get -y install gettext libpixman-1-dev libaio-dev markdown pandoc iasl cmake figlet

apt-get -y install libc6-dev-i386
apt-get -y install lzma lzma-dev liblzma-dev
apt-get -y install libsystemd-dev

apt-get -y install ninja-build

git clone git://xenbits.xen.org/xen.git xen_source

cd xen_source

git checkout stable-4.18

apt-get -y build-dep xen

./configure --libdir=/usr/lib

make install

update-bootloader --refresh

update-grub

update-rc.d xencommons defaults 19 18
update-rc.d xendomains defaults 21 20
update-rc.d xen-watchdog defaults 22 23

systemctl enable xen-qemu-dom0-disk-backend.service
systemctl enable xen-init-dom0.service
systemctl enable xenconsoled.service
systemctl enable xendomains.service
systemctl enable xen-watchdog.service
systemctl enable xendriverdomain.service
