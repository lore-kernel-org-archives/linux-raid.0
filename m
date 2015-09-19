From: Another Sillyname <anothersname@googlemail.com>
Subject: Failed Raid6 Array.....want some guidance before attempting restart
Date: Sat, 19 Sep 2015 19:33:47 +0100
Message-ID: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I came back earlier today to find some problems on my server, having
looked at the logs it looked like there was a power spike or something
that caused the server to cough and the array to kick.  I had to
reboot the server to get any info at all as it had locked.

As the array has gone offline I thought rather then me just messing
around it would be wiser to take advice before causing any further
potential damage.

Here is the output of

mdadm -E on the active drives in the array.

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : arandomserver.arandomlan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : active
    Device UUID : 968a5c1d:ab019235:fb578b6e:2f5ee382

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep 19 14:28:32 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9e8960f5 - correct
         Events : 285433

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : arandomserver.arandomlan.com:1
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
    Update Time : Sat Sep 19 18:23:15 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 87b27b15 - correct
         Events : 285455

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .AAA..A ('A' == active, '.' == missing, 'R' == replacing)


/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : arandomserver.arandomlan.com:1
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
    Update Time : Sat Sep 19 18:23:15 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1f77f61b - correct
         Events : 285455

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : .AAA..A ('A' == active, '.' == missing, 'R' == replacing)


/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : arandomserver.arandomlan.com:1
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
    Update Time : Sat Sep 19 18:23:15 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 544df34e - correct
         Events : 285455

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .AAA..A ('A' == active, '.' == missing, 'R' == replacing)


/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : arandomserver.arandomlan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : active
    Device UUID : df5af6ce:9017c863:697da267:046c9709

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep 19 14:28:32 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : fe247a62 - correct
         Events : 285433

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : arandomserver.arandomlan.com:1
  Creation Time : Sun May 10 14:47:51 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
     Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720780800 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=143 sectors
          State : active
    Device UUID : 10563c18:d7c7a547:ec8ee742:4d6cc1a3

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep 19 14:28:32 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a0b737ab - correct
         Events : 285433

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
           Name : arandomserver.arandomlan.com:1
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
    Update Time : Sat Sep 19 18:23:15 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9eafc329 - correct
         Events : 285455

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : .AAA..A ('A' == active, '.' == missing, 'R' == replacing)


This gives me a reasonable level of confidence as on first glance it
looks to me like when the server coughed three of the drives in the
array went offline thus the array immediately failed.  One thing I
have noticed is the Device UUID value has changed form what the arrays
value was in fstab

cat /proc/mdstat gives me this....

Personalities :
md127 : inactive sdh1[5](S) sdf1[3](S) sdc1[4](S) sdd1[1](S)
sdi1[6](S) sdg1[0](S) sde1[2](S)
      41022733300 blocks super 1.2

unused devices: <none>


I don't just want to try a forced assemble until someone casts their
eye over this (and anything else wanted) and lets me know the best way
to proceed.....



Thanks in advance.

Tony


p.s. Before anyone says you do of course have a backup....thats what
the array was doing when it failed as the old backup had to be moved
yesterday.
