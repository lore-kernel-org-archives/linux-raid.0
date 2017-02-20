From: Martin Bosner <martin@bosner.de>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 18:48:14 +0100
Message-ID: <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

> { Note: convention on kernel.org is reply-to-all, bottom post or
> interleave, and trim unneeded material. }
Sorry, hope this one is better.


> for x in /dev/sd[a-z] /dev/sda[a-j] ; do mdadm -E ${x}1 ; done

See below for full output.


> Eewwww!  You have desktop drives.  Which means your array has
> blown up due to timeout mismatch.  You have some reading to
> do.[1]

I will be using so called “NAS” or “enterprise disks in the next cluster …  especially these seagate disks were a bad decision.


> http://marc.info/?l=linux-raid&m=142487508806844&w=3
> http://marc.info/?l=linux-raid&m=144535576302583&w=2


I will read through it.

Martin

#########

for x in /dev/sd[a-z] /dev/sda[a-j] ; do mdadm -E ${x}1 ; done
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : f90e9c41:5aa3c3b2:d715781b:1abbb439

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b0b57ef2 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : bf3081d1:5afead3a:839df956:098403b9

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 83554c55 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 6e592519:9dafe1fd:6616a6b4:6de9ab52

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 8582048f - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 465ca8a2:45bd05a3:94b4d0cc:0bf9ee5d

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d796c2dc - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 79f7fb50:15f0887f:4d7adf0c:632e9743

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 88248bf0 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 5a1097b1:7da38314:8633c3f9:d3b843ab

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d24a9be4 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 31076c1e:97f2be2f:1ae76487:48667fc7

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 43842df - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
mdadm: No md superblock detected on /dev/sdh1.
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 34ecbf22:16e15f2f:a9075b03:6f8f2de3

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9fd16018 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 8
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 390cbe6a:bceed865:5d88091f:86c7228b

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e1ec468f - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 79b27fa7:954302fe:4f669a20:1ddf9a15

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : 42e0375d - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : c7215fad:1c6ecbbf:2c2e0feb:aabbb208

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : c8157597 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 11
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdm1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x8b
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 296160 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 1366f174:d65cf0f7:b20f5b4f:c2263bbe

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : e1a5d782 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 12
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdn1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : c9b9b4ad:74b4989c:1c0003cd:dd402919

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 97a2aaf2 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 13
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdo1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : d5a5ec07:91695b21:087ebb12:f3e6bf3f

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e2ec701c - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 14
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdp1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 7f4f1b78:7a0ae004:664b2208:da13eed6

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : c334b517 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 15
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdq1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : a2158ac6:82ac5c70:31d9b49b:66077e36

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 70429e7a - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 16
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdr1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : af23e4bb:04bae1e3:6b79aa24:ebf1ccb3

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : df6644c9 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 17
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sds1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 0c1675d5:0e2e9b88:3ab7545c:f5f2cd99

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bb5bea0a - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 18
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdt1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : f2920d03:7784140f:0108652e:ef335243

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : eb024f19 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 19
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdu1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 00b49bc7:54fa2eb2:38be88f4:177812ad

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 828ee067 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 20
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdv1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : a04149c8:d99b98d4:6ad76d27:b6930004

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2f79445d - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 21
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdw1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 3609155b:7272da25:a6ccf32b:707e27e1

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : f533c282 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 22
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdx1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : c5462d71:6f69ab33:a6ddeb6a:28210c6e

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : e4f9aae3 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 23
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdy1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 44823783:34d0edf7:03d4ae6f:522befc6

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 18ec4da1 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 24
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdz1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 063185d5:e0d3dbce:ab39c4fa:ae855b0c

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 12a9c008 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 25
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdaa1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : da6a846c:563d61bf:ee1e786a:c9e5280b

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : 8afa8c7 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 26
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdab1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 0ea3c624:8e2e59ab:ed195520:23917089

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e10e7875 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 27
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdac1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : e6c66c40:e0c49813:e87dc481:7b57ef8b

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c8e25cf3 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 28
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdad1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : af24f1fb:a55ddb8b:3ecd2971:6f9dc92d

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : 8de8e8dd - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 29
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdae1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : d4e87abe:00003a9d:e950d72c:f5b93939

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : 28eeef8f - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 30
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdaf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 2ea54072:67978e8b:c6b99895:76f4157f

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : 79a6e6b2 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 31
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdag1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 52ee4e92:9a60fdd5:b3393a70:f0e8e53f

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 7f956d5e - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 32
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdah1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 80818d5a:85638be1:f9974e08:081404d2

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
       Checksum : 7d948cde - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 33
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdai1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 6f014106:2eea458c:4a6dcf1a:a2666db0

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c4ecbb59 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 34
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdaj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 0fdc0ec2:42d30dcb:f00d2c63:26171824

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 7b89d039 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 35
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
