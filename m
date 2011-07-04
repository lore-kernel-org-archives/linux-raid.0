From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: advanced partition format, mdadm, and raw disks
Date: Mon, 04 Jul 2011 17:15:33 +0100
Message-ID: <1309796133.2766.63.camel@baal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Everyone,

I've created a RAID-10 array with mdadm. I created the array using
partitions /dev/sd[abcd]1, where the partition starts at sector 2048 and
uses the rest of the disk, as specified here:

http://www.ibm.com/developerworks/linux/library/l-4kb-sector-disks/index.html#tools

IE:
1. fdisk -c -u /dev/sda
2. create partition at 2048 to -0, of type fd
3. repeat for all drives or clone with sfdisk
4. create the array

mdadm -A /dev/md0 -v --raid-devices=4
--level=raid10 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

5. add to mdadm.conf

mdadm -Es >> /etc/mdadm/mdadm.conf

After reboot, the array worked, and I formatted it and started loading
it with files. Only later did I realise that at some point (perhaps 2-3
reboots), the partitions were gone, and the array is running on the raw
devices:

root@venkman:/var/log/cacti# cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10] 
md0 : active raid10 sdc[2] sda[0] sdd[3] sdb[1]
      3907026944 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      
unused devices: <none>

fdisk shows the partition tables are gone too. I found NeilBrown's
comment ID #1857419, partway down this page:

http://www.issociate.de/board/post/463176/Superblocks.html

"If a partition starts a multiple of 64K from the start of the device,
and ends with about 64K of the end of the device, then a superblock on
the partition will also look like a superblock on the whole device.
This is one of the shortcomings of v0.90 superblocks. v1.0 doesn't
have this problem."

I used mdadm v2.6.7.1, as it comes on Ubuntu 10.10. Is this still a
shortcoming of superblock v1.2? Obviously I want to align to the sector
size, and use the entire disk.

Should I just accept this and not raw devices? Will it happen again if I
try to start over?

Regards,
Tyler

-- 
"If one would give me six lines written by the hand of the most honest
man, I would find something in them to have him hanged."
  -- Armand Jean du Plessis, Cardinal Richelieu

