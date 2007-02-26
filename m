From: Michael <michael@kmaclub.com>
Subject: Problems with software raid - all mine I am sure
Date: Mon, 26 Feb 2007 10:48:26 -0700
Message-ID: <45E31D6A.4040805@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have been trying to get a software raid configuration working for a 
few weeks with little success.

I currently have a 3ware 7506-4 card with 4 drives.  The raid 5 
performance of this card is poor and it was recommended to me to try 
using the card as a JBOD controller and running software raid on top of it.

I am currently running FC6 on this machine.

Here is what I have tried:

1) Backup the machine
2) Boot from knoppix DVD
3) Partition the drives using fdisk into 4 partitions.  100M for /boot ( 
bootable ), 2048M for swap, 16384M for /, and the rest for /export.  All 
partitions were tagged as 'fd'
4) Use sfdisk -d to copy the exact partitions to all 4 drives
5) Use mdadm to create md0 as raid 1 for /boot ( first two disks ), 
md1-3 as raid5 with no spares ( all four disks )
6) Restore /boot, /, export
7) mkswap /dev/md1
8) update fstab and grub.conf to reflect new partitions ( chrooted )

Here is where I get lost and confused

I tried to chroot into the old image mounted completely under 
/mnt/sysimage.  I ran grub-install on /dev/sda and /dev/sdb.  It 
complained about /dev/sdb not being a bios drive ( or similar ).  I 
figured that was ok and I could fix it later.

Upon reboot, grub was definitely in sda, but it failed to boot 
complaining it couldn't find stage1 files.

I tried to boot from Redhat rescue DVD.  It sees a 4 disks, but the raid 
comes up without sda.  I can do a dmesg and see sda, but the raid says 
it is missing.  It looks like Redhat thinks there is a /dev/dm_* devices 
as well.  However, these disks have no lvm on them.

Rebooting into Knoppix now shows the array is in degradated mode.  
/dev/sda is being thrown out..but I can't remember the exact error.  
Googling showed that I needed use mdadm to fail sda, remove it, and 
re-add it.  However, mdadm wouldn't remove it because it said it was 
busy.  I am assuming this is related to same issue as the Redhat rescue 
issue.

The software raid seems a little fragile as well.  If I have my external 
drive plugged in and all devices shift ( sda-d become sdb-e) when 
booting from Knoppix which seems to cause problems as well.  I thought 
with all the data being written to the superblocks it would handle this 
problem.

So, I am looking for a little guidance in where I am going wrong.  It 
takes about 24 hours for me to make this work and restore if it goes 
badly so I am a little hesitant to play to much without figuring out a 
correct path.

In the end, I went back to hardware raid on the 3ware card which works 
perfectly, just abysmal performance.

Any thoughts or suggestions?

Michael




