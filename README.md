# Knockd for OpenWrt/LEDE

Tested with LEDE v17.01.1 for ar71xx

## About

This is an updates package source for building the latest stable version of knockd for OpenWrt/LEDE.

Initscript and logbuffer compatible config are included.

## Precompiled packages
Available [here](https://github.com/milaq/openwrt_knockd/releases/)

## Building

Using Debian Jessie

````
apt-get install build-essential libncurses5-dev gawk git subversion libssl-dev gettext unzip zlib1g-dev file python curl
git clone https://git.lede-project.org/source.git lede
cd lede
git checkout v17.01.1
mkdir package/knockd/
````
Put all repository contents (Makefile, files/) into `package/knockd/`

Build Toolchain:
````
make tools/install
make toolchain/install
````

Build package:
````
make package/knockd/configure
make package/knockd/compile
make package/knockd/install
````

Get the built ipk from: `bin/packages/mips_24kc/base/knockd_*.ipk`

## Installing

Install the ipk via:
````
opkg install knockd.ipk
````

Change the default configuration:
````
/etc/knockd.conf
````

Start and enable the deamon:
````
/etc/init.d/knockd start
/etc/init.d/knockd enable
````
