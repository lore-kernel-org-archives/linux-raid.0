From: Jonathan Wilson <piercing_male@hotmail.com>
Subject: Delete and re-purpose a mdadm raid partition
Date: Thu, 20 Jun 2013 14:14:56 +0100
Message-ID: <BLU0-SMTP47546CBE9D49D65539F974F988E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Having made the spectacular mistake of undersizing my root partition I
am inquiring the best way to delete an existing linear raid and create a
new secondary / partition which will be used to install a fresh debian
system.

I should also say that I'm not a linux expert, although computer
literate and with experience of installing debian previously hence the
detailed "check list."

My system contains the following...

2 "system and other data drives" on a 2 port sata card.
6 "pure data drives, raid6" on motherboard.

The two system disks have the following (X=g or h) GPT partitions.

sdX1 bios boot 1MB
sdX2 Raid1 boot 210MB (md0)
sdX3 Raid1 root 13GB (md1)<<< keep for old debian
sdX4 Swap 9.7GB
sdX5 Raid1 home 11GB (md2)(not used for users, root does have a small
about of data/folders set up in it)
sdX6 Linear 54GB (md3)<<< to be new root for new debian
sdX7 Raid1 data 413GB (md4)

I'm guessing what I need to do is with the existing debian install is
the following. (this is where I need conformation)

unmount the Linear volume /dev/md3

stop the array

Make sure the data on the volume(s) are blank by "dd'ing" into /dev/sdX6

Create a new raid1 array on sdX6

Do NOT update mdadm.conf <<< I believe nothing much will change here as
the uuid of the underlying partition will not have changed also leaving
it as it is will make sure it gets the existing /dev/md/3 slot.

Make sure the array is started/synced ok.

Create ext4 file system on md3

Update fstab to reflect new uuid of new file system.

Re-boot system, check all is well (in theory it should be). 



At this point I start to go outside of mdadm but any help is much
appreciated.


As I don't have enough sata slots I'm going to have to do a bit of
fiddling about...

Get the network card firmware, place it and the iso and the hd-media
files on md3's ext4 partition.

re-boot and manually load/start from md3 (I believe as its raid1 it
should be started ok by grub so will be accessible) the
vmlinuz/initrd.gz which should then start the installation process.

During the install only setup/define the md3 as / and also set the home
on / (so it doesn't conflict with anything in md2's home); also set
up /boot on the md0 (same as where the existing boot is located) leave
all other file systems alone as will set them up once new debian is
bootable.

re-boot, check new install ok and / is on md3 (or what ever the new
clean install has called it)

re-boot, check old install is ok and is using the old / (which it should
be as nothing changed as far as its concerned)

re-boot to new debian, run grub-update to refresh bios boot partition on
sdH

reboot with removed sdG, test new and old boot's ok.

reboot new install with re-attached sdG, test ok, update mdadm.conf and
fstab to include all other file systems.

final re-boot and test and data/application migration from old
debian... 

finished... hopefully!

Thanks in advance, JonXx




