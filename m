From: Brandon Evans <maillists@hosttuls.com>
Subject: mkraid creating 5G raid device from 110G partitions
Date: Fri, 05 Dec 2003 17:38:42 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD13322.4060906@hosttuls.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all,
	I'm trying to create a RAID-1 array  using 2 WD hard drives on  a 
server running knoppix.  For some reason mkraid /dev/md1 creates a raid 
device that is only 5 Gigs, however the partitions I am using in the 
array are about 110Gigs.  This is urgent, so if the answer to this is 
out there but I havent found it on google yet, I apologize.


Here is the relevant Raid configuration:

The server is running knoppix 3.3, 2 WD 120Gig HD's, 2G Ram

mkraid version 0.90.0


root@0[mnt]# fdisk -l

Disk /dev/hda: 120.0 GB, 120034123776 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hda1             1         6     48163+  fd  Linux raid autodetect
/dev/hda2             7       132   1012095   82  Linux swap
/dev/hda3           133     14593 116157982+  fd  Linux raid autodetect

Disk /dev/hdb: 120.0 GB, 120000000000 bytes
255 heads, 63 sectors/track, 14589 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hdb1             1         6     48163+  fd  Linux raid autodetect
/dev/hdb2             7     14589 117137947+  fd  Linux raid autodetect



root@0[mnt]# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md1 : active raid1 hdb2[1] hda3[0]
       5116608 blocks [2/2] [UU]

md0 : active raid1 hdb1[1] hda1[0]
       48064 blocks [2/2] [UU]

unused devices: <none>


root@0[mnt]# cat /etc/raidtab
raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/hda1
     raid-disk     0
     device          /dev/hdb1
     raid-disk     1
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/hda3
     raid-disk     0
     device          /dev/hdb2
     raid-disk     1







-- 
Thanks,
     Brandon E.
