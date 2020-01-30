From: Rickard Svensson <myhex2020@gmail.com>
Subject: All disk ar reported as spare disks
Date: Fri, 31 Jan 2020 00:48:50 +0100
Message-ID: <CAC4UdkZoo=B2c-XmRwPA19gEsUtHYVhq2=Sqgs54mf2ZHerDxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

Excuse me for asking again.

But this is a simpler(?) follow-up question to:
https://marc.info/?t=157895855400002&r=1&w=2

In short summary. I had a raid 1 0, there were too many write errors
on one disk (I call it DiskError1), which I did not notice, and then
two days later the same problem on another disk (I call it
DiskError2).

I got good help here, and copy the disk portions of the 2 working
disks as well as disk DiskError2 with ddrescue to new disks.
Later I'll create a new raid 1, so I don't plan reuse the same raid 1 0 again.


My questions:
1) I haven't copied the disk DiskError1, because it is older data, and
it shouldn't be needed.   Or is it better to add that one as well?

2) Everything looks pretty good :)
But all disk ar reported as spare disks in /proc/mdstat
A assume that is because "Events" count is not the same. It is same on
the good disks(2864) but not DiskError2 (2719).
I have been looking how I can "force add" disk DiskError2, use
"--force" or "--- zero-superblock"?
But would prefer to avoid making a mistake now,   what has the
greatest chance of being right :)


Many thanks in advance!!


And the other info:

Debian 10   --  mdadm - v4.1 - 2018-10-01

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sda1[2](S) sdb1[0](S) sdb2[1](S)
      8761499679 blocks super 1.2
unused devices: <none>


# mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 3
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 3

              Name : ttserv:0
              UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
            Events : 2719

    Number   Major   Minor   RaidDevice

       -       8        1        -        /dev/sda1
       -       8       18        -        /dev/sdb2
       -       8       17        -        /dev/sdb1


# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
           Name : ttserv:0
  Creation Time : Tue Oct  9 23:30:23 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 5840999786 (2785.21 GiB 2990.59 GB)
     Array Size : 5840999424 (5570.41 GiB 5981.18 GB)
  Used Dev Size : 5840999424 (2785.21 GiB 2990.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=20538368 sectors
          State : active
    Device UUID : 23079ae3:c67969c2:13299e27:8ca3cf7f

    Update Time : Sun Jan 12 00:11:05 2020
       Checksum : ed375eb5 - correct
         Events : 2719

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)



# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
           Name : ttserv:0
  Creation Time : Tue Oct  9 23:30:23 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 5840999786 (2785.21 GiB 2990.59 GB)
     Array Size : 5840999424 (5570.41 GiB 5981.18 GB)
  Used Dev Size : 5840999424 (2785.21 GiB 2990.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=19520512 sectors
          State : clean
    Device UUID : f474ad64:6bb236d3:9f69f55c:eb9b8c27

    Update Time : Tue Jan 14 22:49:49 2020
       Checksum : 5c312015 - correct
         Events : 2864

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)


# mdadm --examine /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cb5bfe7a:3806324c:3c1e7030:e6267102
           Name : ttserv:0
  Creation Time : Tue Oct  9 23:30:23 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 5840999786 (2785.21 GiB 2990.59 GB)
     Array Size : 5840999424 (5570.41 GiB 5981.18 GB)
  Used Dev Size : 5840999424 (2785.21 GiB 2990.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=19519631 sectors
          State : clean
    Device UUID : 1a67153d:8d15019a:349926d5:e22dd321

    Update Time : Tue Jan 14 22:49:49 2020
       Checksum : 6ddb36ea - correct
         Events : 2864

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
