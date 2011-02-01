From: Naira Kaieski <naira@faccat.br>
Subject: Bootable Raid-1
Date: Tue, 01 Feb 2011 18:20:59 -0200
Message-ID: <4D486B2B.6030609@faccat.br>
Reply-To: naira@faccat.br
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have read several articles on the internet and researched in the 
messages list, but I'm still having trouble configuring a raid level 1 
array that is bootable.

I configured a server some time agowith Gentoo Linux, Kernel 
2.6.28-hardened-r9, mdadm - v3.0 and 2 IDE hard drives, this is working 
correctly. For this installation iused as a basis for consultation 
Article http://en.gentoo-wiki.com/wiki/Migrate_to_RAID

Now, I want to use two SATA drives in raid level 1,

Now i have Gentoo Linux with kernel  2.6.36-hardened-r6 and mdadm - 
v3.1.4 and the instructions of Article dont work. The kernel was 
configured with support for disks raid autodetect and supported the raid 
level 1. But in the logs of dmesg does not run the auto-detection of the 
disks to the array, so in the boot when mounting the root device / 
dev/md2 the system can not find the device.

When I run mdadm - auto-detect the array are found somewhere but still 
displays message indicating that the raid device is not a valid 
partition table.

How can you configure a raid level 1 with bootable disks / dev / sda and 
/ dev / sdb?
I want three partitions:
     /dev/md1  - swap  - /dev/sda1, /dev/sdb1
     /dev/md2  - boot   - /dev/sda2, /dev/sdb2
     /dev/md3  - / - /dev/sda3, /dev/sdb3

I am using grub as bootloader.

Thanks,
Naira Kaieski
