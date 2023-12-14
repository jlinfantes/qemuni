#!/bin/bash
dependencias(){ 
	apt install -y qemu-utils qemu-system-common qemu-system-x86 
	}
echo "Selecciona acciones a realizar"
echo "1. Descarga ISO e instalalo en una maquina qemu"
echo "2. Crea y ejecuta un contenedor"
echo "3. Crear un contenedor con tu sistema"
read qemuni
case $qemuni in
1) $SO ;;
2) echo " debootstrap-chroot";; 
3) echo "rsync+chroot";;
esac
echo "Ram Asignada"
echo "1. 512Mb"
echo "2. 1Gb"
echo "3. 2Gb"
echo "4. 4Gb"
echo "5. 8Gb"
read memoria
case $memoria in
1) ram=512;;
2) ram=1024;;
3) ram=2048;;
4) ram=4096;;
5) ram=8192;;
*) echo "Incorrecto";
esac
echo "Nucleos Asignados"
echo "1. 1"
echo "2. 2"
echo "3. 3"
echo "4. 4"
echo "5. 5"
echo "6. 6"
echo "7. 7"
echo "8. 8"
read cores
case $cores in
1) nucleos=1;;
2) nucleos=2;;
3) nucleos=3;;
4) nucleos=4;;
5) nucleos=5;;
6) nucleos=6;;
7) nucleos=7;;
8) nucleos=8;;
*) echo "Incorrecto"
esac
echo "Tamaño del disco"
echo "1. 4Gb"
echo "2. 8Gb"
echo "3. 16Gb"
echo "4. 32Gb"
read disk
case $disk in
1) disco=4;;
2) disco=8;;
3) disco=16;;
4) disco=32;;
*) echo "Incorrecto"
esac
ubuntu_qemu() {
echo "Ubuntu "
echo "1. Trusty"
echo "2. Xenial"
echo "3. Bionic"
echo "4. Focal"
echo "5. Jammy"
echo "6 Salir"
echo -n " Selecciona una opción [1-6]"
read ubuntu 
case $ubuntu in 
1)  $memoria ;
	dependencias ;
	wget https://releases.ubuntu.com/14.04/ubuntu-14.04.6-desktop-amd64.iso
	nombre=trusty
	cdrom=ubuntu-14.04.6-desktop-amd64.iso
	imagen=trusty.img
	carpeta=trusty ;;
2) wget https://releases.ubuntu.com/16.04/ubuntu-16.04.7-desktop-amd64.iso
	nombre=xenial
	cdrom=ubuntu-16.04.7-desktop-amd64.iso
	imagen=xenial.img
	carpeta=xenial ;;
3) wget https://releases.ubuntu.com/18.04/ubuntu-18.04.6-desktop-amd64.iso
	nombre=bionic	
	cdrom=ubuntu-18.04.6-desktop-amd64.iso
	imagen=bionic.img
	carpeta=bionic ;;
4) wget https://releases.ubuntu.com/focal/ubuntu-20.04.6-desktop-amd64.iso
	nombre=focal
	cdrom=ubuntu-20.04.6-desktop-amd64.iso
	imagen=focal.img
	carpeta=focal ;;
5) wget https://releases.ubuntu.com/jammy/ubuntu-22.04.3-desktop-amd64.iso
	nombre=jammy
	cdrom=ubuntu-22.04.3-desktop-amd64.iso
	imagen=jammy.img
	carpeta=jammy ;;
6) exit;;
*) echo "$opc no es una opción valida";
esac
}
alpine_qemu() {
	wget https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-virt-3.18.5-x86_64.iso
	nombre=alpine 
	cdrom=alpine-virt-3.18.5-x86_64.iso
	imagen=alpine.img
	carpeta=alpine 
}
fedora_qemu() {
	wget https://download.fedoraproject.org/pub/fedora/linux/releases/39/Cloud/x86_64/images/Fedora-Cloud-Base-39-1.5.x86_64.qcow2
	nombre=fedora
	cdrom=Fedora-Cloud-Base-39-1.5.x86_64.qcow2
	imagen=fedora.img
	carpeta=fedora
}
debian_qemu() {
	wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.2.0-amd64-netinst.iso
	nombre=debian
	cdrom=debian-12.2.0-amd64-netinst.iso
	imagen=debian.img
	carpeta=debian
}
mx_qemu() {
	wget http://mirror.datamossa.io/mxlinux-iso/MX/Final/Xfce/MX-23.1_x64.iso
	nombre=MX
	cdrom=MX-23.1_x64.iso
	imagen=mx.img
	carpeta=mxlinux
}
opensuse_qemu() {
	wget https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Current.iso
	nombre=opensuse 
	cdrom=openSUSE-Tumbleweed-DVD-x86_64-Current.iso
	imagen=opensuse.img
	carpeta=opensuse
}
echo "	qemu launcher"
echo "1.	Ubuntu"
echo "2.	Debian"
echo "3.	Fedora"
echo "4.	MX Linux"
echo "5.	OpenSuse"
echo "6.	Alpine"
echo "7.	Salir"
echo -n " Seleccione una opción [1-7] "
read SO
case $SO in
    1) ubuntu_qemu;;
    2) debian_qemu;;
    3) fedora_qemu;;
    4) mx_qemu;;
    5) opensuse_qemu;;
    6) alpine_qemu;;
    7) exit;;
    *) echo "$qemu no es una opción válida";
esac

qemu-img create -f qcow2 $imagen "$disco"G
qemu-system-x86_64 -machine q35 -m $ram -smp cpus=$nucleos -cpu qemu64 \
  -drive if=pflash,format=raw,read-only,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1 \
  -cdrom $cdrom \
  -nographic $imagen 
