From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Thu, 8 Dec 2011 13:42:44 -0800
Message-ID: <D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <20111208075709.587ac227@notabene.brown> <654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu> <20111208091651.2a56dd5b@notabene.brown> <2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu> <20111209065140.107aa286@notabene.brown> <46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu> <20111209075931.29b26b5e@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111209075931.29b26b5e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 8, 2011, at 12:59 PM, NeilBrown wrote:

> On Thu, 8 Dec 2011 12:39:10 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> 
>> 
> 
>> 
>> and here is the verbose assemble output:
>> 
>> [root@stratus log]# mdadm --verbose --assemble /dev/md5 --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 
>> mdadm: looking for devices for /dev/md5
>> mdadm: /dev/sda1 is identified as a member of /dev/md5, slot 0.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot -1.
>> mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 2.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 3.
>> mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 4.
>> mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 5.
>> mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 6.
>> mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 7.
>> mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot -1.
>> mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 9.
>> mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 10.
>> mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 11.
>> mdadm: /dev/sdm1 is identified as a member of /dev/md5, slot 12.
>> mdadm: /dev/sdn1 is identified as a member of /dev/md5, slot 13.
>> mdadm: /dev/sdo1 is identified as a member of /dev/md5, slot -1.
>> mdadm: no uptodate device for slot 1 of /dev/md5
>> mdadm: added /dev/sdc1 to /dev/md5 as 2
>> mdadm: added /dev/sdd1 to /dev/md5 as 3
>> mdadm: added /dev/sde1 to /dev/md5 as 4
>> mdadm: added /dev/sdf1 to /dev/md5 as 5
>> mdadm: added /dev/sdg1 to /dev/md5 as 6
>> mdadm: added /dev/sdh1 to /dev/md5 as 7
>> mdadm: no uptodate device for slot 8 of /dev/md5
>> mdadm: added /dev/sdj1 to /dev/md5 as 9
>> mdadm: added /dev/sdk1 to /dev/md5 as 10
>> mdadm: added /dev/sdl1 to /dev/md5 as 11
>> mdadm: added /dev/sdm1 to /dev/md5 as 12
>> mdadm: added /dev/sdn1 to /dev/md5 as 13
>> mdadm: no uptodate device for slot 14 of /dev/md5
>> mdadm: no uptodate device for slot 15 of /dev/md5
>> mdadm: added /dev/sdb1 to /dev/md5 as -1
>> mdadm: added /dev/sdi1 to /dev/md5 as -1
>> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
>> mdadm: added /dev/sda1 to /dev/md5 as 0
>> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to start the array.
>> 
>> 
> 
> Thank.
> 
> I know what the 'busy' thing is now.
> sdo1 appears the be the 'same' as some other device in some way.
> 
> Also it looks like you might have turned some drives into spares
> unintentionally, though I'm not sure
> 
> Could you pleas send "mdadm --examine" output for all of these drives and
> I'll have a look.
> 
> Thanks,
> NeilBrown
> 
> 
> 

Thanks Neil. I wasn't sure if you wanted the output of all the drives or just the 'removed' ones, so here is the output for all the drives in the array.

Just FYI, I don't know what I could have done to make these spares. Between when things worked fine and when they did not, I did not make any hardware or configuration changes to the array.

Thanks!

Eli


[root@stratus log]# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2f2219e1:52ba8e9f:59a99614:19023955

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 9d39863 - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4457f369:e449cbd3:b1d00987:d0b3ec45

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 2a11360a - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 03b89c44:e2db0b0a:7fea4aa4:6ac80958

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 6a59573f - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 26be9b16:d2c39c72:498f3873:d8e60059

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 74ce088b - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5b3c19ab:034cd1f3:708cf5ca:a3be4093

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 1c7ce3e6 - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0c48ca56:414f4d53:21da2d1a:7d519272

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 5633d35f - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f6e4c4f9:4b00903e:e8ccf189:f345287c

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 5dcb0892 - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 793be893:3192ae21:57f59ea7:97f76b4f

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : cbfdcb0e - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1cad41bf:75b756e2:71a83b96:cc3bf444

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 9c24592f - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 74a09868:6978117b:8f2c4e22:f0e30ab0

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : d55f39d4 - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdk1
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 88ec1371:4cd85c1b:62f5deaa:2821bc7b

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : d267ebd7 - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 10
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdl1
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9a009907:d9ff6097:4ac84cbf:8726797f

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : fd1bffbe - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 11
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdm1
/dev/sdm1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 481d50b4:65352be3:f65d8152:69e11c40

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 4975a288 - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 12
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdn1
/dev/sdn1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3898edca:756c1f76:b33a66a0:a2dcce69

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 6a9e2c7f - correct
         Events : 32

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 13
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdo1
/dev/sdo1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a31ac4c9:a37eb6e8:97aa7298:b3b0bf8d

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : f80904f1 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

[root@stratus log]# mdadm --examine /dev/sdp1
/dev/sdp1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
  Creation Time : Wed Oct 12 16:32:41 2011
     Raid Level : raid5
   Raid Devices : 16

 Avail Dev Size : 3907025039 (1863.01 GiB 2000.40 GB)
     Array Size : 58605358080 (27945.21 GiB 30005.94 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 66e0b547:26c72e70:a6756af6:eccaef5a

    Update Time : Mon Dec  5 12:52:46 2011
       Checksum : 289af87f - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.AAAAAA.AAAAA.. ('A' == active, '.' == missing)

