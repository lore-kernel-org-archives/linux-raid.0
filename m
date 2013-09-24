From: Karel Walters <karel.walters@gmail.com>
Subject: [Recovery] RAID10 hdd failureS help requested
Date: Tue, 24 Sep 2013 15:12:30 +0200
Message-ID: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hopefully someone can help me with this.
I have a 7 drive raid10 array.
A single drive failed this night and the 7th spare drive was trying to
pickup the failed drive.
During the re-sync a second drive failed and the re-sync stopped.

Now I know I should replace the failed drives but I would like to have
them online one more time for some critical files that were produced
last night.

As it stands I tried:

remove from array and re-add:
This failed with:
mdadm: --re-add for /dev/sdd1 to /dev/md1 is not possible

I tried forced reassemble:
this failed:
mdadm: failed to add /dev/sde1 to /dev/md1: Device or resource busy
mdadm: failed to add /dev/sdj1 to /dev/md1: Device or resource busy
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error

From what I read online I should re-create the array with
assume-clean, but I am quite hesitant to do so since a single type
means the destruction of my raid array.

Could someone please advice?


Added is the output from --examine and --detail

/dev/md1:
        Version : 1.2
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
  Used Dev Size : -1
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Tue Sep 24 13:52:16 2013
          State : active, degraded, Not Started
 Active Devices : 4
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 2

         Layout : far=2
     Chunk Size : 64K

           Name : phobos:0  (local to host phobos)
           UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
         Events : 6298

    Number   Major   Minor   RaidDevice State
       8       8       81        0      active sync   /dev/sdf1
       7       8      129        1      active sync   /dev/sdi1
       2       8      113        2      active sync   /dev/sdh1
       3       0        0        3      removed
       4       0        0        4      removed
       6       8       97        5      active sync   /dev/sdg1

       9       8       33        -      spare   /dev/sdc1
      10       8       49        -      spare   /dev/sdd1


/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526080 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3b46e91f:bd2a3481:f1818a46:19e77284

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : 2d4b1c52 - correct
         Events : 0

         Layout : far=2
     Chunk Size : 64K

   Device Role : spare
   Array State : AAA..A ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526080 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0be3d9d6:376a68fe:ef7df0e5:9b369dea

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : 67003c20 - correct
         Events : 0

         Layout : far=2
     Chunk Size : 64K

   Device Role : spare
   Array State : AAA..A ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526080 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 21d32b5b:4817285e:928eb39d:f9c7090b

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : 23417b46 - correct
         Events : 0

         Layout : far=2
     Chunk Size : 64K

   Device Role : spare
   Array State : AAA..A ('A' == active, '.' == missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526080 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a300c489:7a42f41a:2cbf23eb:1db87ae8

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : 39870d51 - correct
         Events : 6298

         Layout : far=2
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAA..A ('A' == active, '.' == missing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526991 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a9cd4f3b:c562c203:3b2c6d3a:2df429bd

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : f7d9a74b - correct
         Events : 6298

         Layout : far=2
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : AAA..A ('A' == active, '.' == missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526080 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b2439c7e:6e1048b9:87da7045:3c2d5249

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : 87d7aec6 - correct
         Events : 6298

         Layout : far=2
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAA..A ('A' == active, '.' == missing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526080 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : cc3485c3:08acfa6b:25c11841:f80e07b7

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : e8d00bd9 - correct
         Events : 6298

         Layout : far=2
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAA..A ('A' == active, '.' == missing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d2d84ef9:7981fe2b:2140e1cb:1ec86f38
           Name : phobos:0  (local to host phobos)
  Creation Time : Thu Apr 26 11:33:56 2012
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 5860526080 (2794.52 GiB 3000.59 GB)
     Array Size : 8790788352 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860525568 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2e8d438b:16ad5bb7:6e2dafcd:804b37ce

    Update Time : Tue Sep 24 13:52:16 2013
       Checksum : 9fb6061d - correct
         Events : 6298

         Layout : far=2
     Chunk Size : 64K

   Device Role : spare
   Array State : AAA..A ('A' == active, '.' == missing)
