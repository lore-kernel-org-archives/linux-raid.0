From: mike@nerdcore.net
Subject: RAID5 Recovery From NAS With 4x3TB SATA Disks
Date: Thu, 24 Sep 2015 08:41:59 -0400
Message-ID: <bc6f920d307275a8dc69fbcd8870c672.squirrel@nerdcore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am attempting to recover some data from a RAID-5 NAS enclosure on my PC.
A number of things were already done wrong, but I am hopeful to recover at
least some of the data from the array.

The array was created on a Synology NAS enclosure consisting of 4 x 3TB
drives in a RAID-5 configuration. I gather everything was working well
until a power surge or brownout which caused one drive to die completely
(disk #0) and was likely the cause of some read errors on the other disks.

When the owner of the array noticed the disk failure, the wrong disk was
replaced to cause a rebuild! Disk #2 was replaced instead of disk #0, so
the NAS would never have succeeded at a rebuild operation. At this point
my friend came to me for assistance and I began pulling the drives from
the NAS into my PC running Ubuntu 14.04 (amd64) to attempt to restore at
least some of the files.

I cannot get disk #0 to spin at all. Disk #1 and disk #3 appear to
automatically assemble into the array in the correct slots.

Disk #2 appears to mdadm as "disk #32770".

Here is the output of `mdadm --examine` on each of the RAID partitions,
and the contents of /proc/mdstat when the drives are spun up inside my PC:


/dev/sdb5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d06e7cf6:05704b33:ea53fc30:0c087b55
           Name : DiskStation:2
  Creation Time : Thu Apr  3 13:41:58 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5851063680 (2790.00 GiB 2995.74 GB)
     Array Size : 8776594944 (8370.01 GiB 8987.23 GB)
  Used Dev Size : 5851063296 (2790.00 GiB 2995.74 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 46277a0d:f75e3612:911d4e5f:50b46678

    Update Time : Fri May 29 08:20:37 2015
       Checksum : cd5c1a5f - correct
         Events : 1908912

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 32770
   Array State : .A.A ('A' == active, '.' == missing)

/dev/sdc5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d06e7cf6:05704b33:ea53fc30:0c087b55
           Name : DiskStation:2
  Creation Time : Thu Apr  3 13:41:58 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5851063680 (2790.00 GiB 2995.74 GB)
     Array Size : 8776594944 (8370.01 GiB 8987.23 GB)
  Used Dev Size : 5851063296 (2790.00 GiB 2995.74 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fa5bf9cd:629d2a75:7e3d9ab3:6189e4f9

    Update Time : Sun May 31 11:05:20 2015
       Checksum : c69bcc20 - correct
         Events : 1908922

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AA.A ('A' == active, '.' == missing)

/dev/sdd5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d06e7cf6:05704b33:ea53fc30:0c087b55
           Name : DiskStation:2
  Creation Time : Thu Apr  3 13:41:58 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5851063680 (2790.00 GiB 2995.74 GB)
     Array Size : 8776594944 (8370.01 GiB 8987.23 GB)
  Used Dev Size : 5851063296 (2790.00 GiB 2995.74 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0da09e5b:b3557017:dec76908:02543203

    Update Time : Sun May 31 11:05:20 2015
       Checksum : 54a41d85 - correct
         Events : 1908922

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AA.A ('A' == active, '.' == missing)

/proc/mdstat:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md2 : inactive sdb5[2](S) sdc5[1](S) sdd5[3](S)
      8776595520 blocks super 1.2


I've read a bunch of forum posts and articles detailing a number of
techniques to try and recover some of the data. I gather from these
Synology instructions that once the array is assembled I must use
`vgchange` to register a Volume Group:
https://www.synology.com/en-us/knowledgebase/faq/579

This wiki page gave me the idea of using `mdadm --create --assume-clean
...` to bring the array to a state where I might be able to see some of
its contents: https://raid.wiki.kernel.org/index.php/RAID_Recovery

I'm also familiar with concerns over using large disks in a RAID-5
configuration and would like to be clear that this was not my idea and I
am simply trying to help a friend retrieve at least some of the files from
the array - I do not expect complete recovery will be possible:
http://www.zdnet.com/article/why-raid-5-stops-working-in-2009/

I attempted to bring this array up with this command:

  mdadm --create --assume-clean --level=5 --raid-devices=4 --chunk=64
/dev/md2 missing /dev/sdc5 /dev/sdb5 /dev/sdd5

This appeared to bring up a new array with 0 Events. I've restored my
backups and can try again from the best state I have to work with.

All disks experienced some read errors while creating the backups, and I
realize complete recovery will be impossible, but if I could retrieve any
data we would be pleased with that.

Any help greatly appreciated.

