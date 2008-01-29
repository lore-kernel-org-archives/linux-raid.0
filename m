From: Moshe Yudkowsky <moshe@pobox.com>
Subject: In this partition scheme, grub does not find md information?
Date: Mon, 28 Jan 2008 22:44:50 -0600
Message-ID: <479EAF42.6010604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm finding a problem that isn't covered by the usual FAQs and online 
recipes.

Attempted setup: RAID 10 array with 4 disks.

Because Debian doesn't include RAID10 in its installation disks, I 
created a Debian installation on the first partition of sda, in 
/dev/sda1. Eventually I'll probably convert it to swap, but in the 
meantime that 4G has  a complete 2.6.18 install (Debian stable).

I created a RAID 10 array of four partitions, /dev/md/all, out of 
/dev/sd[abcd]2.

Using fdisk/cfdisk, I created the partition/dev/md/all1 (500 MB) for 
/boot, and the parition /dev/md/all2  with all remaining space into one 
large partition (about 850 GB). That larger partition contains /, /usr, 
/home, etc. each as a separate LVM volume. I copied usr, var, etc. (but 
not proc or sys, of course) files over to the raid array, mounted that 
array, did a chroot to its root, and started grub.

I admit that I'm no grub expert, but it's clear that grub cannot "find" 
any of the information in /dev/md/all1. For example,

grub> find /boot/grub/this_is_raid

can't find a file that exists only on the raid array. Grub only searches 
/dev/sda1, not /dev/md/all1.

Perhaps I'm mistaken but I though it was possible to do boot from 
/dev/md/all1.

I've tried other attacks but without success. For example, also while in 
chroot,

grub-install /dev/md/all2 does not work. (Nor does it work with the 
--root=/boot option.)

I also tried modifications to menu.lst, adding root=/dev/md/all1 to the 
kernel command, but RAID array's version of menu.lst is never detected.

What I do see is

grub> find /boot/grub/stage1
  (hd0,0)

which indicates (as far as I can tell) that it's found the information 
written on /dev/sda1 and nothing in /dev/md/all1.

Am I trying to do something that's basically impossible?

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
