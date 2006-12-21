From: matt black <cache22@webkorner.com>
Subject: boot root no /dev
Date: Thu, 21 Dec 2006 11:35:54 -0500
Message-ID: <458AB7EA.7010903@webkorner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings helpful people, welcome to me your kindly list  :)

I set up raid-1 on new drive /dev/sdb, and copied files from /dev/sda. 
I test boot to it with following grub.conf:

title  Gentoo 2.6.18-r4-md
root   (hd1,0)
kernel /2.6.18-gentoo-r4-md root=/dev/md1 dxs_support=5 
video=mtrr,vesafb:1024x768

/dev/md1 corresponds to /dev/sd*2 which is root part. (/dev/sd*1 is /boot)

Kernel autodetects and reiserfs looks happy with it, then I get 
"Warning: unable to open an initial console."  This an error that occurs 
in init/init.c after setting up the initial rootfs and freeing initial 
memory.  After the warning init.c tries to run /sbin/init, /etc/init, 
/bin/init, or /bin/sh.

I believe it succeeds because then udev errors scroll by endlessly and 
killing things with magic-sysrq give me the impression that bash is 
running.  So I get the impression that /dev/md1 got mounted 
automagically.  I did create an empty /dev dir on md1 for /dev to mount 
to, but I didn't copy anything from original /dev (shouldn't have to 
right?)  It just occurred to me to cd-boot and see if the original 
system is cheating with static /dev/ entries--it was originally a devfs 
system.

The kernel docs imply (it wouldn't be appropriate to be crystal clear) 
that there is always a default initramfs built in if not overridden, 
correct?  In my source it looks like that would be:

---

# This is a very simple, default initramfs

dir /dev 0755 0 0
nod /dev/console 0600 0 0 c 5 1
dir /root 0700 0 0
# file /kinit usr/kinit/kinit 0755 0 0
# slink /init kinit 0755 0 0

---

in the course of my wanderings I tried making my own initramfs list with 
the addition of "nod /dev/md1 0600 0 0 b 9 1" which makes no difference.

in my kernel config:

CONFIG_INITRAMFS_SOURCE="/root/my_initramfs_list"
CONFIG_INITRAMFS_ROOT_UID=0
CONFIG_INITRAMFS_ROOT_GID=0

# CONFIG_BLK_DEV_RAM is not set
CONFIG_BLK_DEV_INITRD=y

Note that sometime in 2.6.17 the CONFIG_BLK_DEV_RAM option was given to 
break out ramdisk from INITRD.  CONFIG_BLK_DEV_INITRD now enables only 
initramfs by itself but it has to be enabled along with 
CONFIG_BLK_DEV_RAM if you want a ramdisk.  Maybe I'll build a 2.6.16 md 
kernel and see what happens.

Is it required that this initramfs be built-in so that I have /dev 
nodes?  How can I verify it is doing so?  In init/initramfs.c it seems I 
should get a message from  printk(KERN_INFO "Unpacking initramfs..."); 
which I never see even when successfully booting this kernel from 
/dev/sda.

Thanks for any assistance...


