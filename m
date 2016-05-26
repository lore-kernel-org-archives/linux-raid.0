From: Bryan Hepworth <bryan.hepworth@newcastle.ac.uk>
Subject: mdadm remove old md details reassemble working drives
Date: Thu, 26 May 2016 09:56:24 +0000
Message-ID: <DB5PR07MB1287BD3F72D4FA302118C075D5410@DB5PR07MB1287.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

Hopefully this will be fairly straight forward. I have a machine that has had hardware added over the course of its existence before I took over. There is an issue with two of the shelves that means that they aren't starting automatically and after digging around I think I know the reason why.

When the raid array was created it would have listed the drives in order /dev/sdb /dev/sdc /dev/sdd etc however at some point it has jumped and the device names have changed. The raid arrays are both currently offline, but running the mdadm --examine command shows that they are all present and correct and all in step with each other just with different device names to /etc/mdadm.conf to what they are in reality. I'd like another pair of eyes to have a look before I commit to making changes. The arrays are formatted as xfs and I've had problems with that in the past so want to be sure.

My question is how do I go about getting the arrays back up? After reading the notes it would appear I would have to re-assemble the drives as follows, is this correct?

mdadm --stop /dev/md130
mdadm --stop /dev/md130

mdadm --assemble /dev/md130 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdp /dev/sdq /dev/sdr /dev/sds
mdadm --assemble /dev/md136 /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdy /dev/sdz /dev/sdaa /dev/sdab /dev/sdac /dev/sdad /dev/sdae

mdadm --detail --scan >> /etc/mdadm.conf

Here's the output from various commands that I believe are the important ones.

Thanks

Bryan

/etc/mdadm.conf

[root@inscribe5 etc]# cat mdadm.conf
ARRAY /dev/md/inscribe5.ncl.ac.uk:130 level=raid5 num-devices=12 metadata=1.2 name=inscribe5.ncl.ac.uk:130 UUID=cb850648:d5b35007:dc6000f0:b48ab578
   devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdf,/dev/sdg,/dev/sdh,/dev/sdi,/dev/sdj,/dev/sdk,/dev/sdl,/dev/sdm
ARRAY /dev/md/igmimager.ncl.ac.uk:136 level=raid5 num-devices=12 metadata=1.2 name=igmimager.ncl.ac.uk:136 UUID=b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
   devices=/dev/sdn,/dev/sdo,/dev/sdp,/dev/sdq,/dev/sdr,/dev/sds,/dev/sdt,/dev/sdu,/dev/sdv,/dev/sdw,/dev/sdx,/dev/sdy
[root@inscribe5 etc]#

/proc/mdstat

[root@inscribe5 ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md126 : inactive sdo[2](S) sdn[4](S)
      3906767024 blocks super 1.2

md127 : active (auto-read-only) raid5 sdm1[4](F) sdl1[2](F) sdk1[1](F) sdj1[0](F)
      5860142592 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/0] [____]
      bitmap: 0/15 pages [0KB], 65536KB chunk

md136 : active (auto-read-only) raid5 super 1.2 level 5, 512k chunk, algorithm 2 [12/0] [____________]
      bitmap: 0/30 pages [0KB], 65536KB chunk

md130 : active (auto-read-only) raid5 super 1.2 level 5, 512k chunk, algorithm 2 [12/0] [____________]
      bitmap: 0/30 pages [0KB], 65536KB chunk

mdadm --examine Output

[root@inscribe5 etc]# mdadm --examine /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : a7ece5a2:cd52d443:15fca242:f9849df7

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9c7c0559 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 135b7c93:88cd0e38:0e86b868:a12f2416

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c5e92321 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : b78cd05e:c441f2ee:e7893ce2:a1a4755e

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9f641dd - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : cd686c04:311bb2ed:cdc54888:07883b40

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 362416ac - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : f183d0da:207286e1:08399567:916810e1

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 807ddc86 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdg
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 2872da1b:1ed23064:c7a72b7d:f35e7a44

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bd328fdb - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdh
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : cdba7e4f:07758d88:2911bba3:ff668906

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : fdd1ecd8 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdi
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 41dd6007:5dd339f2:b8eff43e:d82d9365

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 19a4130c - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

   [root@inscribe5 etc]# mdadm --examine /dev/sdj
mdadm: cannot open /dev/sdj: No such file or directory
[root@inscribe5 etc]# mdadm --examine /dev/sdk
mdadm: cannot open /dev/sdk: No such file or directory
[root@inscribe5 etc]# mdadm --examine /dev/sdl
mdadm: cannot open /dev/sdl: No such file or directory
[root@inscribe5 etc]# mdadm --examine /dev/sdm
mdadm: cannot open /dev/sdm: No such file or directory
[root@inscribe5 etc]# mdadm --examine /dev/sdn
mdadm: cannot open /dev/sdn: No such file or directory
[root@inscribe5 etc]# mdadm --examine /dev/sdo
mdadm: cannot open /dev/sdo: No such file or directory

[root@inscribe5 etc]# mdadm --examine /dev/sdp
/dev/sdp:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : e8b00d6f:157a23c0:638f2508:f75ad939

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ecb15a35 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 8
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdq
/dev/sdq:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : b9da41fa:adefe7b5:360a8993:57fabddb

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9af213d4 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdr
/dev/sdr:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : c5d26859:108844a1:0dd6db16:8e2616b8

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 45209c51 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 10
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
[root@inscribe5 etc]# mdadm --examine /dev/sds

/dev/sds:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : cb850648:d5b35007:dc6000f0:b48ab578
           Name : inscribe5.ncl.ac.uk:130  (local to host inscribe5.ncl.ac.uk)
  Creation Time : Thu May 28 12:17:06 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 4213b169:062dfa7c:c62ef36c:c6110735

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:27 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 426c5b7 - correct
         Events : 31406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 11
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdt
/dev/sdt:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : f72233d4:2a14c7e3:95f4ca36:61db22e6

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3a5364dd - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdu
/dev/sdu:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 89efc0ab:8639052b:e5c44ef0:a3d3c085

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b2411f5d - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdv
/dev/sdv:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : d6b55438:42171969:8450174e:e8a6dd4f

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a4ce224a - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdw
/dev/sdw:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : f9499252:50d79458:f2662aa9:f25f1c3a

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : f3d945f4 - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdx
/dev/sdx:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : b6ce9001:c33349f9:4f1cab26:2a778d5d

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e47df3ba - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdy
/dev/sdy:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : b7a71581:7b81c93c:df58b3a5:6773c94d

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 16c75342 - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdz
/dev/sdz:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 0065d0f6:97a47a2b:1733e172:74b59f40

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3b374fed - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdaa
/dev/sdaa:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 809b7d03:0a06eaa1:6704d4a0:14621573

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1ebc65d1 - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdab
/dev/sdab:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 4c899786:22b4da32:fd268ffe:f4117c6e

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 8be8d42c - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 8
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdac
/dev/sdac:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 8a21bc71:8db320f0:fff1e06b:c006555f

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 927e2ba4 - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdad
/dev/sdad:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 23ccc25a:e36a303a:d7a533c6:a330d5d2

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 93676b4f - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 10
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe5 etc]# mdadm --examine /dev/sdae
/dev/sdae:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
           Name : igmimager.ncl.ac.uk:136
  Creation Time : Thu May 28 12:34:30 2015
     Raid Level : raid5
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 42975758848 (40984.88 GiB 44007.18 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 0f3c30b6:c6adb547:f9a251ad:927a008f

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri May 20 13:17:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9fa36531 - correct
         Events : 16085

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 11
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
