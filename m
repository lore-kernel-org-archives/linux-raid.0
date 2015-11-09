From: Mathias Mueller <raidfail@gmx.de>
Subject: broken raid level 5 array caused by user error
Date: Mon, 09 Nov 2015 12:27:09 +0100
Message-ID: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Folks,

I'm running a raid level 5 with 4 devices for some years and tried to 
grow my array yesterday. I wanted to add two more devices and used the 
following commands:

mdadm --add /dev/md0 /dev/sdf1 /dev/sdg1
mdadm --grow --raid-devices=6 /dev/md0

So far, so good. Everything seems to work, but after about 2 hours, the 
reshape progress was still at 0.0% and now, my own stupidity kicked in. 
I checked the logs via journalctl (I'm running Centos 7) and read 
something about "main process died" or similar... then I decided to 
reboot.

After reboot, assembling the array failed:

mdadm: Failed to restore critical section for reshape, sorry. Possibly 
you needed to specify the --backup-file

But I did not have a backup file and so I panicked and made even worse 
decisions.

First I tried to assemble the array using --invalid-backup but it did 
not work. I should stop here and ask but I didn't. I read at some board, 
that rebuilding the original array with 4 devices will fix my problem. I 
did not validate this and entered the suggested command:

mdadm -CR /dev/md0 --metadata=1.2 -n4 -l5 -c512 /dev/sd[bcde]1 
--assume-clean

But this did not work (the array assembled but I could not access the 
ext4 filesystem), it seems that I assembled it in the wrong device 
order, so I also tried different (i.e. all possible) orders, but nothing 
helped ( I always used --assume-clean).

I guess this is the perfect guide for how _not_ to do it :(

I continued reading and found this:

http://serverfault.com/questions/347606/recover-raid-5-data-after-created-new-array-instead-of-re-using

This gave me some hope and now I wonder, if there is a way to get my 
data back, maybe the offset is wrong?

Things I know about the array:

metadata: 1.2
Left-symetric
chunk-size: 512

When I run mdadm --detail /dev/md0 it still shows an array size of 6TB, 
the UUID is also still the same

         Version : 1.2
   Creation Time : Mon Nov  9 00:00:40 2015
      Raid Level : raid5
      Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
   Used Dev Size : 1953380864 (1862.89 GiB 2000.26 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Mon Nov  9 00:00:45 2015
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : xxxx
            UUID : 1d0fdb4e:6111bd7a:96cad2dd:b6a29039
          Events : 1

     Number   Major   Minor   RaidDevice State
        0       8       49        0      active sync   /dev/sdd1
        1       8       65        1      active sync   /dev/sde1
        2       8       33        2      active sync   /dev/sdc1
        3       8       17        3      active sync   /dev/sdb1



an mdadm --examine gives this results:

/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 1d0fdb4e:6111bd7a:96cad2dd:b6a29039
            Name : xxxx
   Creation Time : Mon Nov  9 00:00:40 2015
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3906766961 (1862.89 GiB 2000.26 GB)
      Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
   Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=5233 sectors
           State : clean
     Device UUID : e14f0e2d:a26a7b90:d7dbf780:e2218327

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov  9 00:00:45 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 7a76b0d6 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 1d0fdb4e:6111bd7a:96cad2dd:b6a29039
            Name : xxxx
   Creation Time : Mon Nov  9 00:00:40 2015
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
   Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=3248 sectors
           State : clean
     Device UUID : d408e617:37f3f0f5:feb5d77f:07e57668

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov  9 00:00:45 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : a9787e9 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdd:
    MBR Magic : aa55
Partition[0] :   3907024002 sectors at           63 (type fd)

/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 1d0fdb4e:6111bd7a:96cad2dd:b6a29039
            Name : xxxx
   Creation Time : Mon Nov  9 00:00:40 2015
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
      Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
   Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=130 sectors
           State : clean
     Device UUID : faf7ec39:e7c0cb77:770a439d:18dc65a0

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov  9 00:00:45 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 3d38419 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 1d0fdb4e:6111bd7a:96cad2dd:b6a29039
            Name : xxx
   Creation Time : Mon Nov  9 00:00:40 2015
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
   Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=3248 sectors
           State : clean
     Device UUID : fe31b351:3559f949:978035ae:616ae615

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov  9 00:00:45 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 743a6702 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)



I guess I know the old device order as well, I saved an old boot-log:

md: bind<sde1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md/raid:md127: device sdd1 operational as raid disk 0
md/raid:md127: device sdc1 operational as raid disk 1
md/raid:md127: device sdb1 operational as raid disk 2
md/raid:md127: device sde1 operational as raid disk 3
md/raid:md127: allocated 4314kB
md/raid:md127: raid level 5 active with 4 out of 4 devices, algorithm 2
created bitmap (15 pages) for device md127
md127: bitmap initialized from disk: read 1 pages, set 0 of 29809 bits
md127: detected capacity change from 0 to 6001188667392



Please help me, I know I'm stupid and don't deserve it. I really hope, 
there is a chance for reovering the array.

Thanks a lot in advance

Mathias
