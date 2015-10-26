From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Converting 4 disk RAID10 to RAID5
Date: Mon, 26 Oct 2015 12:26:26 +1100
Message-ID: <562D8142.80507@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm trying to convert a 4 disk RAID10 to a RAID5. Currently I have:
cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sdd1[2] sdc1[1] sdb1[0] sde1[3]
       7813772288 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 0/59 pages [0KB], 65536KB chunk

Disks are:
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD40EFRX-68WT0N0

My plan was to see if mdadm can do this directly, but it seems that it 
can't:
mdadm --grow --level=5 /dev/md0
mdadm: RAID10 can only be changed to RAID0
unfreeze

(Please let me know if a newer version of kernel/mdadm can do this):
mdadm - v3.3.2 - 21st August 2014
Linux dr 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u2 (2015-07-17) 
x86_64 GNU/Linux

So, my other idea is:
1) fail two drives from the array:
mdadm --manage /dev/md0 --fail /dev/sdb1
mdadm --manage /dev/md0 --remove /dev/sdb1
mdadm --manage /dev/md0 --fail /dev/sdd1
mdadm --manage /dev/md0 --remove /dev/sdd1
mdadm --misc --zero-superblock /dev/sdb1
mdadm --misc --zero-superblock /dev/sdd1

It seems that RAID10 device number is in order:
sdb1 device0
sdc1 device1
sdd1 device2
sde1 device3
Therefore, I can fail device 0 (sdb1) and device 2 (sdd1) without losing 
any data.

2) create a 3 disk RAID5 with one disk missing.
mdadm --create /dev/md1 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdd1 
missing

3) Then copy all of the existing data across
unmount partitions, stop LVM/etc
dd bs=16M if=/dev/md0 of=/dev/md1

4) Finally, stop the md0, and add the two devices to the new raid5, and 
then grow the array to use the space on the 4th drive.
mdadm --manage --stop /dev/md0
mdadm --misc --zero-superblock /dev/sdc1
mdadm --manage /dev/md1 --add /dev/sdc1
mdadm --misc --zero-superblock /dev/sde1
mdadm --manage /dev/md1 --add /dev/sde1
mdadm --grow /dev/md1 --raid-devices=4

5) Add the space to my LVM
pvresize /dev/md1

6) Start up LVM, mount LV's, etc

Does the above sound reasonable? Any other suggestions which would be 
better/less dangerous?
Some more detailed info on my existing array:
mdadm --misc --examine /dev/sdb1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 40a09d68:b217d8ec:c90a61a7:ab35f26e
            Name : backuppc:0
   Creation Time : Sat Mar 21 01:19:22 2015
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 7813772943 (3725.90 GiB 4000.65 GB)
      Array Size : 7813772288 (7451.79 GiB 8001.30 GB)
   Used Dev Size : 7813772288 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 4b9d99c9:2a930721:e8052eb2:65121805

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Oct 26 12:00:12 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : d435138c - correct
          Events : 27019

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 40a09d68:b217d8ec:c90a61a7:ab35f26e
            Name : backuppc:0
   Creation Time : Sat Mar 21 01:19:22 2015
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 7813772943 (3725.90 GiB 4000.65 GB)
      Array Size : 7813772288 (7451.79 GiB 8001.30 GB)
   Used Dev Size : 7813772288 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : a8486bf8:b0e7c4d7:8e09bdc6:1a5f409b

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Oct 26 12:00:12 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 647b63cd - correct
          Events : 27019

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 40a09d68:b217d8ec:c90a61a7:ab35f26e
            Name : backuppc:0
   Creation Time : Sat Mar 21 01:19:22 2015
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 7813772943 (3725.90 GiB 4000.65 GB)
      Array Size : 7813772288 (7451.79 GiB 8001.30 GB)
   Used Dev Size : 7813772288 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : c46cdf6f:19f0ea49:1f5cc79a:1df744d7

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Oct 26 12:00:12 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 5e247ae6 - correct
          Events : 27019

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 40a09d68:b217d8ec:c90a61a7:ab35f26e
            Name : backuppc:0
   Creation Time : Sat Mar 21 01:19:22 2015
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 7813772943 (3725.90 GiB 4000.65 GB)
      Array Size : 7813772288 (7451.79 GiB 8001.30 GB)
   Used Dev Size : 7813772288 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : b9639e06:b48b15f4:8403c056:ea9bdcd3

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Oct 26 12:00:12 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 579e59a9 - correct
          Events : 27019

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
