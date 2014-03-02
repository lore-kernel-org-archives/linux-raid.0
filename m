From: John <linux_mailing@internode.on.net>
Subject: Raid 5 events not updates after resync
Date: Sun, 02 Mar 2014 21:33:56 +1100
Message-ID: <53130914.9050309@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moving existing raid 5 to new linux install.

Some strange stuff gone on with one array/drive  (This is after my 
latest assemble with the 3 good drives and adding failed drive & 
allowing resync)

4 Disk array raid 5

mdadm --assemble /dev/md2 /dev/sdc /dev/sda /dev/sdd
mdadm : /dev/md2 assembled from 3 drives - need all 4 drives to assemble 
(use --run to insist)
mdadm --assemble /dev/md2 /dev/sdc /dev/sda /dev/sdd --run
mdadm : /dev/md2 has been started with 3 drives (out of 4)
mdadm -a /dev/md2 /dev/sdb
<resync completes without error a few hours later>

This has been going on for 2-3 re syncs, each time I reboot ends up in 
same situation. No disk errors in dmesg, resync completes without an 
issue.. Any ideas?

3 out of 4  disks show events as 506196
1 disk shows events as  184869 (The disk added in as spare, this seems 
strange to me)

Regards

John

/dev/sda:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 73ea3bd2:50b609a1:768a7e19:ca3ef9f0
            Name : storagepc:raid-2tb
   Creation Time : Fri Oct 28 06:31:30 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 5860540224 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=304 sectors
           State : clean
     Device UUID : 7a9638fc:774dd136:431f0d15:37853f2a

     Update Time : Sun Mar  2 09:19:18 2014
        Checksum : 827e2559 - correct
          Events : 506196

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 73ea3bd2:50b609a1:768a7e19:ca3ef9f0
            Name : storagepc:raid-2tb
   Creation Time : Fri Oct 28 06:31:30 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 5860540224 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=304 sectors
           State : clean
     Device UUID : 14d83150:d2b9ad69:9e004df3:06819bc3

     Update Time : Thu Nov  1 08:14:09 2012
        Checksum : 7e6700eb - correct
          Events : 184869

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 73ea3bd2:50b609a1:768a7e19:ca3ef9f0
            Name : storagepc:raid-2tb
   Creation Time : Fri Oct 28 06:31:30 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 5860540224 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=304 sectors
           State : clean
     Device UUID : 903c8b07:038d4a1c:8588eaa9:defc0550

     Update Time : Sun Mar  2 09:19:18 2014
        Checksum : 2dedebed - correct
          Events : 506196

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 73ea3bd2:50b609a1:768a7e19:ca3ef9f0
            Name : storagepc:raid-2tb
   Creation Time : Fri Oct 28 06:31:30 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 5860540224 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=304 sectors
           State : clean
     Device UUID : 090464a9:11cc8cf4:e22aa863:7d880f58

     Update Time : Sun Mar  2 09:19:18 2014
        Checksum : 69d02087 - correct
          Events : 506196

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

(This is junk as it has no relationship to the actual array!)
mdadm --examine /dev/md126
/dev/md126:
         Version : 1.2
      Raid Level : raid0
   Total Devices : 4
     Persistence : Superblock is persistent

           State : inactive

            Name : storagepc:raid-2tb
            UUID : 73ea3bd2:50b609a1:768a7e19:ca3ef9f0
          Events : 506196

     Number   Major   Minor   RaidDevice

        -       8        0        -        /dev/sda
        -       8       16        -        /dev/sdb
        -       8       32        -        /dev/sdc
        -       8       48        -        /dev/sdd

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md125 : active (auto-read-only) raid5 sdp[5] sdh[1] sdf[4] sdg[2]
       2197720128 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] 
[UUUU]

md126 : inactive sdc[6](S) sda[5](S) sdb[0](S) sdd[4](S)
       7814054240 blocks super 1.2

md127 : active (auto-read-only) raid5 sdj[2] sdn[4] sdm[1] sdl[5]
       2930284224 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] 
[UUUU]

unused devices: <none>

