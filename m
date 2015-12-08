From: Andrew Wilkins <andrew.m.wilkins@gmail.com>
Subject: Help Reassembling a raid5 array
Date: Tue, 8 Dec 2015 01:26:54 +0000
Message-ID: <CAJGWEk93QAmCdik4_rxGPcq7dm=2tXX1U19Zkn5OwcAog0Z-RA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, please can someone help me with a raid array which as gone wrong
On Friday a backup server was rebooted, but failed to boot, possibly
with an unrelated issue


On Monday someone booted from a usb disk to try and recover it
they were originally able to assemble the array but now they are not,
2 out of the 5 drives are showing out of date.
Device 1 is showing
  Bad Block Log : 512 entries available at offset 72 sectors
  Array State : AAAAA
and is showing 256 less a events
last updated 2 hours before the others

Device 4 is showing
 Array State : A.AAA
and 2 less events
last update 1 hour before the others

The rest all show
 Array State : A.AA.

I've tried manually assembling without device 1, but even with --force
it refused to assemble, force seems to do nothing at all, i am
assuming this maybe because the array state has been updated to say
missing for 2 devices.
The example here
https://raid.wiki.kernel.org/index.php/RAID_Recovery
seems to suggest that in my situation recreating might be my only option

Are there any better options before i go ahead and do this?


If not is the best case to create with device 1 missing then try and
recover once device 4 is back to normal?
Is there anything i can backup other than the array stats that i already have?

Also i am wonder if anyone can shed any light on how it might have got
into this state?
There are a few bad blocks showing on device 1, but am not sure if
that is enough to point toward it being a drive failure on it, and if
the last updates are reliable to point to when failures happened,
nothing went wrong till this afternoon.


Thanks If anyone can Help


Copy of the full array status:



/dev/sda:
   MBR Magic : aa55
Partition[0] :     60592833 sectors at           63 (type 0c)
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
/dev/sdf:
   MBR Magic : aa55
Partition[0] :   1953521664 sectors at         2048 (type fd)
/dev/sda1:
   MBR Magic : aa55
Partition[0] :    432871117 sectors at   3224498923 (type 07)
Partition[1] :   1953460034 sectors at   3272020941 (type 16)
Partition[3] :    924335794 sectors at     50200576 (type 00)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1
           Name : srv-bk1:0
  Creation Time : Thu Jun 20 13:09:09 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 3906516992 (3725.55 GiB 4000.27 GB)
  Used Dev Size : 1953258496 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : 6b4406c8:0fd049d6:81c29c9a:7969b355

    Update Time : Mon Dec  7 15:32:11 2015
       Checksum : b242234c - correct
         Events : 1285255

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.AA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : xxxxxxxx:xxxxxxxx:xxxxxxxx:abb20cf1
           Name : srv-bk1:0
  Creation Time : Thu Jun 20 13:09:09 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 3906516992 (3725.55 GiB 4000.27 GB)
  Used Dev Size : 1953258496 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 152682776 sectors
   Unused Space : before=262056 sectors, after=1024 sectors
          State : clean
    Device UUID : 7c3d5188:39eddb20:96973dee:9c71dc89

    Update Time : Mon Dec  7 12:40:28 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4e0caeec - correct
         Events : 1284999

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1
           Name : srv-bk1:0
  Creation Time : Thu Jun 20 13:09:09 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 3906516992 (3725.55 GiB 4000.27 GB)
  Used Dev Size : 1953258496 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : 2ec58774:2cea69a3:660a0aba:98c57ed7

    Update Time : Mon Dec  7 15:32:11 2015
       Checksum : cd1c6232 - correct
         Events : 1285255

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.AA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1
           Name : srv-bk1:0
  Creation Time : Thu Jun 20 13:09:09 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 3906516992 (3725.55 GiB 4000.27 GB)
  Used Dev Size : 1953258496 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : e784451d:b024c581:badf6818:2a8a481e

    Update Time : Mon Dec  7 15:32:11 2015
       Checksum : f95df654 - correct
         Events : 1285255

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : A.AA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7847e506:deaf87e5:7c6cd502:abb20cf1
           Name : srv-bk1:0
  Creation Time : Thu Jun 20 13:09:09 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 3906516992 (3725.55 GiB 4000.27 GB)
  Used Dev Size : 1953258496 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1024 sectors
          State : clean
    Device UUID : 119b942e:5012da9f:42384d61:5f81fd95

    Update Time : Mon Dec  7 14:20:10 2015
       Checksum : e95a3900 - correct
         Events : 1285253

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : A.AAA ('A' == active, '.' == missing, 'R' == replacing)
