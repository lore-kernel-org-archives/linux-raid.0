From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: Unable to mount root
Date: Fri, 21 Feb 2003 14:36:16 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <84BB6E1F4E011742AFB186D469FDEA9A015BDB@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've encountered some hairy problems attempting to boot into a raid1
root filesystem.
The boot fails with unable to mount.  The trouble starts with ...
EXT2-fs: md(9.0): couldn't mount because of unsupported optional
features (fff80000).
cramfs: wrong magic
Md: swapper(pid 1) used obsolete MD ioctl, upgrade your software to use
new ictls.
Kernel Panic.

I'm using a straight debian woody with 2.4.18 all raid options compiled
into the kernel.

I use mkraid to create the md0 device with the following raidtab...

## Test RaidTab

raiddev                 /dev/md0
raid-level              1
nr-raid-disks           2
chunk-size              16
# Spare disks for hot reconstruction
nr-spare-disks          0
persistent-superblock   1
device                  /dev/sda1
raid-disk               0
# pseudo failed disk current root part
device                  /dev/hda1
failed-disk             1


Should I be using mdadm instead of mkraid, or are the Debian woody
raidtools too old, too new???

I'm using Raidtools2 version 0.90.200109.

Any help greatly appreciated!

Lewis
