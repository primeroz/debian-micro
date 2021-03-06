#!/bin/bash

# Wrapper around scripts to create a miniature debian rootfs
# Usage:
# ./wrapper.sh

# Fail upon any errors
set -e

# Change these settings as needed

MIRROR=http://172.17.42.1:3142/http.debian.net/debian
SUITE=jessie

# Run the scripts
cd /root/buildboot

# Generate the package list
PACKAGES=$(./generate_package_list.sh /root/package-lists)

# Bootstrap the Debian base image
./bootstrap.sh $MIRROR $SUITE /root/output $PACKAGES

# Extract the kernel out of the image so we can put it in the ISO
mv /root/output/boot/vmlinuz* /root/vmlinuz
rm -rf /root/output/boot

# Run hooks
./run_hooks.sh /root/hooks /root/output

# Include files into the chroot
cp -Rfp /root/includes.chroot/* /root/output

# Build the ramdisk
./build_ramdisk.sh /root /root/init.gz ./init

# Build the rootfs
./build_rootfs.sh

# Build the ISO
./build_iso.sh

