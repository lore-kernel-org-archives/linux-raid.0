From: Carabetta Giulio <g.carabetta@abi.it>
Subject: Data recovery after the failure of two disks of 4
Date: Wed, 5 Sep 2012 15:34:00 +0200
Message-ID: <4FDB990B62C2D849BA8EADBDD1C5928E13718F91D0@CCRMBX.abiad.abi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: it-IT
Sender: linux-raid-owner@vger.kernel.org
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm trying to retrieve a raid 5 array after the failure of two disks of 4.
"Simply", the controller has lost a disk, and after a couple of minutes, it lost another.
The disappearance of the disk also happened to me while I was trying to pull out the data from the disk, so I guess it should be a problem with the control board of the disks...

However, the server at the time of the fault was not doing anything special, so the data "critics"  are still there, on the surface of the disk ...

Anyhow, I have two good disks and two faults.

More specifically, the disks (4 identical 2TB WD20EARS) are all partitioned in the same way: the first partition, about 250mb, the second with the rest of the free space.
- sda1 and sdb1 as md0 (raid1) with /boot
- sdc1 and sdd1 as md2 (raid1) with swaps 
- sd[abcd]2 as md1 (RAID5) with root partition.

Swap is not a matter, and boot array has no problem. The first time I found the problem it didn't boot just because the bios did not see the disks (both with boot partition...), but was temporary error...

The first disk to fail was sdb, and the second was sda: I'm guessing by looking at the differences between the superblocks: (the full dump of superblocks is queued to the message)

---
sda2:
        Update Time: Mon Aug 27 20:46:05 2012
             Events: 622
       Array State: A.AA ('A' == active, '.' == Missing)

sdb2:
        Update Time: Mon Aug 27 20:44:22 2012
             Events: 600
       Array State: AAAA ('A' == active, '.' == Missing)

SdC2:
        Update Time: Mon Aug 27 20:46:33 2012
             Events: 625
       Array State: ..AA ('A' == active, '.' == Missing)

sdd2:
        Update Time: Mon Aug 27 20:46:33 2012
             Events: 625
       Array State: ..AA ('A' == active, '.' == Missing)
---

Now I'm copying partitions elsewhere, with ddrescue, to replace the faulty disks and rebuild everything.

In the meantime, I did a first test on the array md1 (root partition, the one with all my data...)

Trying to reassemble the array I got:

# Mdadm --assemble --force --verbose /dev/md11 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
mdadm: forcing event count in /dev/sda2(o) from 622 upto 625
mdadm: Marking array /dev/md11 as 'clean'
mdadm: added /dev/sdb2 to /dev/md11 as 1 (possibly out of date)
mdadm: /dev/md11 has been started with 3 drives (out of 4).


Then I mounted the array and I saw the correct file system.
To avoid a new fault (with disks very unstable), I stopped and removed the array very quickly, so I didn't tryed to read a file, I simply did few ls...

Now the question.

I was copying only 3 disks, sdd, sdc, and the "freshest" faulty: sda. With 3 out of 4 disks in raid5 should be sufficient...
But while copying the data, I got a read error on sda. I lost just 4Kbyte, but I do not know what piece of data is part of what...

So now I'm ddrescue'ing the fourth disk.

And then what?

While I wait for the replacement disks (luckily under warranty, at least that ...), I need some suggestions.

I supposed to copy the images on the new disk, and then try to assemble the array, but not know what could be the best approach (and if there's another one over a simple "mdadm --assemble").

Keeping hold sdc and sdd as they are intact (at the moment ...): on the one hand we have a data disk "old" (sdb, the first to break ...) but without surface errors, and on the other hand, we have the other disk with the newest data (sda, the last to break), but with a 4k hole.
Moreover sda has been forced as "good"...

Which options I have?

Thanks

Giulio Carabetta

===================================================
    root@PartedMagic:/mnt# mdadm --examine /dev/sda2
    /dev/sda2:
              Magic : a92b4efc
            Version : 1.2
        Feature Map : 0x0
         Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
               Name : ubuntu:0
      Creation Time : Sun Sep 25 09:10:23 2011
         Raid Level : raid5
       Raid Devices : 4
     
     Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
         Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
      Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
        Data Offset : 2048 sectors
       Super Offset : 8 sectors
              State : active
        Device UUID : 3d01cfa9:6313d51c:402b3ca5:815a84e9
     
        Update Time : Mon Aug 27 20:46:05 2012
           Checksum : c51fe8dc - correct
             Events : 622
     
             Layout : left-symmetric
         Chunk Size : 512K
     
       Device Role : Active device 0
       Array State : A.AA ('A' == active, '.' == missing)
     
     
    root@PartedMagic:/mnt# mdadm --examine /dev/sdb2
    /dev/sdb2:
              Magic : a92b4efc
            Version : 1.2
        Feature Map : 0x0
         Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
               Name : ubuntu:0
      Creation Time : Sun Sep 25 09:10:23 2011
         Raid Level : raid5
       Raid Devices : 4
     
     Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
         Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
      Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
        Data Offset : 2048 sectors
       Super Offset : 8 sectors
              State : clean
        Device UUID : 0c64fdf8:c55ee450:01f05a3c:57b87308
     
        Update Time : Mon Aug 27 20:44:22 2012
           Checksum : fe6eb926 - correct
             Events : 600
     
             Layout : left-symmetric
         Chunk Size : 512K
     
       Device Role : Active device 1
       Array State : AAAA ('A' == active, '.' == missing)
     
     
    root@PartedMagic:/mnt# mdadm --examine /dev/sdc2
    /dev/sdc2:
              Magic : a92b4efc
            Version : 1.2
        Feature Map : 0x0
         Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
               Name : ubuntu:0
      Creation Time : Sun Sep 25 09:10:23 2011
         Raid Level : raid5
       Raid Devices : 4
     
     Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
         Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
      Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
        Data Offset : 2048 sectors
       Super Offset : 8 sectors
              State : clean
        Device UUID : 0bb6c440:a2e47ae9:50eee929:fee9fa5e
     
        Update Time : Mon Aug 27 20:46:33 2012
           Checksum : 22e0c195 - correct
             Events : 625
     
             Layout : left-symmetric
         Chunk Size : 512K
     
       Device Role : Active device 2
       Array State : ..AA ('A' == active, '.' == missing)
     
     
    root@PartedMagic:/mnt# mdadm --examine /dev/sdd2
    /dev/sdd2:
              Magic : a92b4efc
            Version : 1.2
        Feature Map : 0x0
         Array UUID : 4e7bb63f:74d1ac58:b01b1b48:44c7b7d7
               Name : ubuntu:0
      Creation Time : Sun Sep 25 09:10:23 2011
         Raid Level : raid5
       Raid Devices : 4
     
     Avail Dev Size : 3906539520 (1862.78 GiB 2000.15 GB)
         Array Size : 5859807744 (5588.35 GiB 6000.44 GB)
      Used Dev Size : 3906538496 (1862.78 GiB 2000.15 GB)
        Data Offset : 2048 sectors
       Super Offset : 8 sectors
              State : clean
        Device UUID : 1f06610d:379589ed:db2a719b:82419b35
     
        Update Time : Mon Aug 27 20:46:33 2012
           Checksum : 3bb3564f - correct
             Events : 625
     
             Layout : left-symmetric
         Chunk Size : 512K
     
       Device Role : Active device 3
       Array State : ..AA ('A' == active, '.' == missing)

===================================================