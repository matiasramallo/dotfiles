#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=la-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo Contraseña para el usuario root: 
read rootPass
echo root:$rootPass | chpasswd
echo Nuevo usuario: 
read userName
useradd -mG wheel $userName
echo Contraseña para el nuevo usuario: 
read userPass
passwd $userName

pacman -Syy

pacman -S --noconfirm efibootmgr base-devel xdg-user-dirs xdg-utils xf86-video-intel

pacman -S --noconfirm xorg-server xorg-xinit libev libx11 libxft libxinerama xorg-xbacklight xsel xwallpaper iwd alsa-utils pulseaudio mpd mpc ncmpcpp mpv scrot

pacman -S --noconfirm ttc-iosevka

git clone https://aur.archlinux.org/aura-bin.git
cd aura-bin
makepkg
pacman -U aura-bin-*.zst

aura -A --noconfirm libxft-bgra

sed -i 's/MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

bootctl install
sed -i 's/#timeout 3/timeout 5/' /boot/loader/loader.conf
sed -i 's/#console-mode keep/console-mode max/' /boot/loader/loader.conf
sed -i 's/default.*/default arch.conf/' /boot/loader/loader.conf
echo "title	Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux	/vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd	/intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd	/initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo 'options	root="LABEL=arch" rw' >> /boot/loader/entries/arch.conf

systemctl enable iwd
systemctl enable systemd-resolved
systemctl --user start mpd
systemctl --user enable mpd
timedatectl set-ntp true

sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 4/g' /etc/pacman.conf
sed -i 's/#Color/Color/g' /etc/pacman.conf

#mkdir -p /home/rosenfort/.config/{awesome,alacritty,mpd,ncmpcpp}
#rm ~/.bashrc
#ln -s ~/dotfiles/.bashrc ~/.bashrc
#ln -s ~/dotfiles/.config/awesome/rc.lua /home/rosenfort/.config/awesome/rc.lua
#ln -s ~/dotfiles/.config/awesome/theme.lua /home/rosenfort/.config/awesome/theme.lua
#ln -s ~/dotfiles/.config/alacritty/alacritty.yml /home/rosenfort/.config/alacritty/alacritty.yml
#ln -s ~/dotfiles/.config/picom/picom.conf /home/rosenfort/.config/picom/picom.conf
#ln -s ~/dotfiles/.config/mpd/mpd.conf /home/rosenfort/.config/mpd/mpd.conf
#ln -s ~/dotfiles/.config/ncmpcpp/config /home/rosenfort/.config/ncmpcpp/config
