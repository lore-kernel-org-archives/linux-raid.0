From: Terrence Martin <tmartin@physics.ucsd.edu>
Subject: Best Practice for Raid1 Root
Date: Wed, 14 Jan 2004 15:43:04 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4005D408.8060002@physics.ucsd.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I wanted to post this question for a while.

On several systems I have configured a root software raid setup with two 
IDE hard drives. The systems are always some version of redhat. Each 
disk has its own controller and is partitioned similar to the following, 
maybe with more partitions, but this is the minimum.

hda1 fd   100M
hda2 swap 1024M
hda3 fd   10G

hdc1 fd   100M
hdc2 swap 1024M
hdc3 fd   10G

The Raid devices would be

/dev/md0 mounted under /boot made of /dev/hda1 and /dev/hdc1
/dev/md1 mounted under / made of /dev/hda3 and /dev/hdc3

The boot loader is grub and I want both /boot and / raided.

In the event of a failure of hda I would like the system to switch to 
hdc. This works fine. However what I have had problems with is if the 
system reboots. If /dev/hda is unavailable I no longer have a disk with 
a boot sector set up correctly. Unless I have a floppy or CDROM with a 
boot loader the system will not come up.

So my main question is what is the best practice to get a workable boot 
sector on /dev/hdc? How are other people making sure that their system 
remains bootable after a disk failure of the boot disk? Is it even 
possible with software raid and PC BIOS? Also when you replace /dev/hda 
how are you getting a valid boot sector on that disk?

I have found grub to often be problematic so that even when I move the 
good drive to be hda grub does not like to install itself correctly.

I am sure I am approaching this incorrect in some way, I am just not 
sure what is the right way.

Terrence Martin
UCSD Physics

