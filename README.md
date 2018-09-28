# Knockd for OpenWrt/LEDE

Tested with LEDE v17.01.4 for ar71xx

Built from latest (as of January 2018) release 0.7.

Be advised that the upstream project is more or less unmaintained. This does _not_ mean you can't use knockd in production, but to think about it carefully. But if other, modern portknocking solutions feel too cumbersome for you, knockd may exactly be what you need.

## About

This is an updates package source for building the latest stable version of knockd for OpenWrt/LEDE.

Initscript and logbuffer compatible config are included.

## Precompiled packages
Available [here](https://github.com/milaq/openwrt_knockd/releases/)

## Building

Install prerequisites (for _Debian_):
````
apt-get install build-essential libncurses5-dev gawk git subversion libssl-dev gettext unzip zlib1g-dev file python curl
````

Get the LEDE source and checkout the latest revision:
````
git clone https://git.lede-project.org/source.git lede
cd lede
git checkout v18.06.1
````

Prepare package directory for knockd:
````
mkdir package/knockd/
````
and put all repository contents (`Makefile`, `files/`, `patches/`) into `package/knockd/`

or alternatively fetch directly from git:
````
cd package
git clone https://github.com/milaq/openwrt_knockd.git knockd
````

Build toolchain:  
When initially building select your target system and make sure `Network` -> `Firewall` -> `knockd` is selected.
````
make tools/install
make toolchain/install
````

In case you didn't built the whole tree before you need to compile libpcap:
````
make package/libs/libpcap/configure
make package/libs/libpcap/compile
````

Build the package:
````
make package/knockd/clean
make package/knockd/download
make package/knockd/compile
````

Get the built ipk from:
````
bin/packages/mips_24kc/base/knockd_<VERSION>.ipk
````

## Installing

Install the ipk:  
Scp the ipk to `/tmp` on your LEDE machine and issue a
````
opkg install /tmp/knockd_<VERSION>.ipk
````

Change the default configuration:
````
/etc/config/knockd
````

Start and enable the deamon:
````
/etc/init.d/knockd start
/etc/init.d/knockd enable
````
