From: "David PARRIEL" <dparriel@gfi.fr>
Subject: Mount root filesystem on Raid 1 Software
Date: Mon, 24 Feb 2003 12:18:49 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C1256CD7.003DBA2C.00@mta-out.gfi.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Hello,

I try to use Raid 1 software on a Linux Debian 3.0 (kernel 2.4).

I've no problems to mount my /boot partition on /dev/md1 device and my /usr
partition on /dev/md2 device, no problems to reboot.

On boot when Debian system try to mount the root filesystem on /dev/md0
(/dev/sdb3 is raid-disk and /dev/sda3 is failed-disk), I obtain this message :

"fsck.ext3 : invalid argument while trying to open /dev/md0.

 The superblock could not be read or does not describe a correct ext2
 filesystem. If the device is valid and it really contain an ext2
 filesystem then the superblock is corrupt and you might try running
 e2fsck with an alternate superblock.
      e2fsck -b 8193 <device>
 fsck failed. Please repair manually."

 I ran "fsck /dev/md0" and bellow the result :
 "Bad magic number in superblock while trying to open /dev/hda. The
 superblock could not be read or does not describe a correct
 filesystem" .

 I tried with mke2fs -b 4096 -R stride=8 /dev/md0 and other values, I've always
the same problem when I reboot.

 Have you got an idea of this problem ?

 In advance, thank you.

 David


