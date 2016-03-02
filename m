From: Another Sillyname <anothersname@googlemail.com>
Subject: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Wed, 2 Mar 2016 03:46:48 +0000
Message-ID: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a 30TB RAID6 array using 7 x 6TB drives that I wanted to
migrate to RAID5 to take one of the drives offline and use in a new
array for a migration.

sudo mdadm --grow /dev/md127 --level=raid5 --raid-device=6
--backup-file=mdadm_backupfile

I watched this using cat /proc/mdstat and even after an hour the
percentage of the reshape was still 0.0%.

I know from previous experience that reshaping can be slow, but did
not expect it to be this slow frankly.  But erring on the side of
caution I decided to leave the array for 12 hours and see what was
happening then.

Sure enough, 12 hours later cat /proc/mdstat still shows reshape at 0.0%

Looking at CPU usage the reshape process is using 0% of the CPU.

So reading a bit more......if you reboot a server the reshape should continue.

Reboot.....

Array will not come back online at all.

Bring the server up without the array trying to automount.

cat /proc/mdstat shows the array offline.

Personalities :
md127 : inactive sdf1[2](S) sde1[3](S) sdg1[0](S) sdb1[8](S)
sdh1[7](S) sdc1[1](S) sdd1[6](S)
      41022733300 blocks super 1.2

unused devices: <none>

Try to reassemble the array.

>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
mdadm: /dev/sdg1 is busy - skipping
mdadm: /dev/sdh1 is busy - skipping
mdadm: Merging with already-assembled /dev/md/server187.internallan.com:1
mdadm: Failed to restore critical section for reshape, sorry.
       Possibly you needed to specify the --backup-file


Have no idea where the server187 stuff has come from.

stop the array.

>sudo mdadm --stop /dev/md127

try to re-assemble

>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1

mdadm: Failed to restore critical section for reshape, sorry.
       Possibly you needed to specify the --backup-file


try to re-assemble using the backup file

>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 --backup-file=mdadm_backupfile

mdadm: Failed to restore critical section for reshape, sorry.

have a look at the individual drives

>sudo mdadm --examine /dev/sd[b-h]1

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 1152bdeb:15546156:1918b67d:37d68b1f

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3a66db58 - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 140e09af:56e14b4e:5035d724:c2005f0b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 88916c56 - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : a50dd0a1:eeb0b3df:76200476:818e004d

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9f8eb46a - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 7d0b65b3:d2ba2023:4625c287:1db2de9b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 552ce48f - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : cda4f5e5:a489dbb9:5c1ab6a0:b257c984

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2056e75c - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : df5af6ce:9017c863:697da267:046c9709

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : fefea2b5 - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : server187.internallan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : clean
    Device UUID : 9d98af83:243c3e02:94de20c7:293de111

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
     New Layout : left-symmetric-6

    Update Time : Wed Mar  2 01:19:42 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b9f6375e - correct
         Events : 369282

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


As all the drives are showing Reshape pos'n 0 I'm assuming the reshape
never got started (even though cat /proc/mdstat showed the array
reshaping)?

So now I'm well out of my comfort zone so instead of flapping around
have decided to sleep for a few hours before revisiting this.

Any help and guidance would be appreciated, the drives showing clean
gives me comfort that the data is likely intact and complete (crossed
fingers) however I can't re-assemble the array as I keep getting the
'critical information for reshape, sorry' warning.

Help???
