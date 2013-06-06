From: Claude Nobs <claudenobs@blunet.cc>
Subject: sas driver lockup during raid reshape. recoverable?
Date: Thu, 6 Jun 2013 05:13:08 +0200
Message-ID: <CAF82EXfyLStKq3v7tJwmsHhB+731qgTZ9cUOWQncBEHk9pa4dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

i had a sas driver failure leading to a failure of 4 drives out of 7+1
during a raid5 grow reshape.... first i tried mdadm -Avv then -Afvv
but it still doesn't work... is this recoverable?

bernstein@server:~$ sudo mdadm --assemble -vv /dev/md5 /dev/sd[efghijkl]1
mdadm: looking for devices for /dev/md5
mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot -1.
mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 3.
mdadm:/dev/md5 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on device-6
mdadm: No backup metadata on device-7
mdadm: added /dev/sdi1 to /dev/md5 as 0 (possibly out of date)
mdadm: added /dev/sdk1 to /dev/md5 as 1 (possibly out of date)
mdadm: added /dev/sdj1 to /dev/md5 as 2 (possibly out of date)
mdadm: added /dev/sdl1 to /dev/md5 as 3 (possibly out of date)
mdadm: added /dev/sde1 to /dev/md5 as 5
mdadm: added /dev/sdg1 to /dev/md5 as 6
mdadm: added /dev/sdh1 to /dev/md5 as -1
mdadm: added /dev/sdf1 to /dev/md5 as 4
mdadm: /dev/md5 assembled from 3 drives and 1 spare - not enough to
start the array.

so i know the 4 drives attached to the sas card are now out of date,
verified by:

bernstein@server:~$ sudo mdadm -E /dev/sdl1
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : dac93bfc:702d2146:9aed480b:916cc4fe
           Name : server:5  (local to host server)
  Creation Time : Fri Apr 15 20:16:31 2011
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
     Array Size : 5860563840 (5589.07 GiB 6001.22 GB)
  Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6833d9f1:6b0461f1:4a784ee9:8e91d2f9

  Reshape pos'n : 4031497728 (3844.74 GiB 4128.25 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Jun 06 04:37:24 2013
       Checksum : cde0f44f - correct
         Events : 3428

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' == active, '.' == missing)
bernstein@server:~$ sudo mdadm -E /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : dac93bfc:702d2146:9aed480b:916cc4fe
           Name : server:5  (local to host server)
  Creation Time : Fri Apr 15 20:16:31 2011
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
     Array Size : 5860563840 (5589.07 GiB 6001.22 GB)
  Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6a4e2b2a:67487ba6:6ea4bad8:1a528bf3

  Reshape pos'n : 4031497728 (3844.74 GiB 4128.25 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Jun 06 04:47:33 2013
       Checksum : a46e425d - correct
         Events : 3430

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : .AA.AAA ('A' == active, '.' == missing)
bernstein@server:~$ sudo mdadm -E /dev/sdk1
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : dac93bfc:702d2146:9aed480b:916cc4fe
           Name : server:5  (local to host server)
  Creation Time : Fri Apr 15 20:16:31 2011
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
     Array Size : 5860563840 (5589.07 GiB 6001.22 GB)
  Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0d82174d:83124ce9:947dea32:77cf5cdb

  Reshape pos'n : 4032783744 (3845.96 GiB 4129.57 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Jun 06 04:48:55 2013
       Checksum : 4c53d5f1 - correct
         Events : 3431

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : .AA.AAA ('A' == active, '.' == missing)
bernstein@server:~$ sudo mdadm -E /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : dac93bfc:702d2146:9aed480b:916cc4fe
           Name : server:5  (local to host server)
  Creation Time : Fri Apr 15 20:16:31 2011
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
     Array Size : 5860563840 (5589.07 GiB 6001.22 GB)
  Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2fd2c79c:2c54ee4a:546057d7:8db5e2be

  Reshape pos'n : 4031497728 (3844.74 GiB 4128.25 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Jun 06 04:40:39 2013
       Checksum : 8570efa1 - correct
         Events : 3429

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAA.AAA ('A' == active, '.' == missing)


compared to the rest :

bernstein@server:~$ sudo mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : dac93bfc:702d2146:9aed480b:916cc4fe
           Name : server:5  (local to host server)
  Creation Time : Fri Apr 15 20:16:31 2011
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
     Array Size : 5860563840 (5589.07 GiB 6001.22 GB)
  Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : cedef881:6080f029:2d123ffc:a8fd8e84

  Reshape pos'n : 4032783744 (3845.96 GiB 4129.57 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Jun 06 15:35:42 2012
       Checksum : 345efafb - correct
         Events : 3440

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : ....AAA ('A' == active, '.' == missing)

so i tried forcing:

bernstein@server:~$ sudo mdadm --assemble -fvv /dev/md5 /dev/sd[efghijkl]1
mdadm: looking for devices for /dev/md5
mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 5.
mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 4.
mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 6.
mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot -1.
mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot 0.
mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 2.
mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 1.
mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 3.
mdadm: forcing event count in /dev/sdk1(1) from 3431 upto 3440
mdadm: forcing event count in /dev/sdj1(2) from 3430 upto 3440
mdadm: forcing event count in /dev/sdi1(0) from 3429 upto 3440
mdadm: forcing event count in /dev/sdl1(3) from 3428 upto 3440
mdadm: clearing FAULTY flag for device 7 in /dev/md5 for /dev/sdl1
mdadm: Marking array /dev/md5 as 'clean'
mdadm:/dev/md5 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on device-6
mdadm: No backup metadata on device-7
mdadm: added /dev/sdk1 to /dev/md5 as 1
mdadm: added /dev/sdj1 to /dev/md5 as 2
mdadm: added /dev/sdl1 to /dev/md5 as 3
mdadm: added /dev/sdf1 to /dev/md5 as 4
mdadm: added /dev/sde1 to /dev/md5 as 5
mdadm: added /dev/sdg1 to /dev/md5 as 6
mdadm: added /dev/sdh1 to /dev/md5 as -1
mdadm: added /dev/sdi1 to /dev/md5 as 0
mdadm: /dev/md5 assembled from 7 drives and 1 spare - not enough to
start the array.

so now i have all devices, but it still doesn't work.

any help is appreciated!

thx
