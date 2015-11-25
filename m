From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 25 Nov 2015 20:32:10 +0300
Message-ID: <398591448472730@web17m.yandex.ru>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
	 <3822301448453563@web17m.yandex.ru> <5655B62F.2070806@turmel.org>
	 <240681448462882@web25o.yandex.ru> <939171448463324@web17m.yandex.ru>
	 <5655D75B.9020901@turmel.org> <166511448468944@web24o.yandex.ru> <5655E8D1.2050906@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5655E8D1.2050906@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Hmmm. That's interesting. That means mdadm wrote the revert-reshape
> before it finished assembly. Try this:
>
> mdadm --stop /dev/md3
>
> mdadm --assemble --update=revert-reshape /dev/md3 /dev/sdj3
>
> That should fail w/ not enough to start, but apply the revert to that
> one drive. Then --stop again, and try with [a-j].

Phil, thanks for your sustaining.

Does you think, that problem is that "Raid Devices : 10", but
"Array State : AAAAAAAA.A.", where the extra, 11th, device is sdj3, which
was rejected from system in past, but record about it leave in superblock?

# mdadm --stop /dev/md3
mdadm: error opening /dev/md3: No such file or directory

# mdadm --assemble --update=revert-reshape /dev/md3 /dev/sdj3
mdadm: /dev/md3 assembled from 1 drive - not enough to start the array.

# mdadm --stop /dev/md3
mdadm: error opening /dev/md3: No such file or directory

# mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-j]3
mdadm: looking for devices for /dev/md3
mdadm: /dev/sda3 is identified as a member of /dev/md3, slot -1.
mdadm: /dev/sdb3 is identified as a member of /dev/md3, slot 6.
mdadm: /dev/sdc3 is identified as a member of /dev/md3, slot 7.
mdadm: /dev/sdd3 is identified as a member of /dev/md3, slot 4.
mdadm: /dev/sde3 is identified as a member of /dev/md3, slot 5.
mdadm: /dev/sdf3 is identified as a member of /dev/md3, slot 0.
mdadm: /dev/sdg3 is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sdh3 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sdi3 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdj3 is identified as a member of /dev/md3, slot 9.
mdadm: added /dev/sdi3 to /dev/md3 as 1
mdadm: added /dev/sdh3 to /dev/md3 as 2
mdadm: added /dev/sdg3 to /dev/md3 as 3
mdadm: added /dev/sdd3 to /dev/md3 as 4
mdadm: added /dev/sde3 to /dev/md3 as 5
mdadm: added /dev/sdb3 to /dev/md3 as 6
mdadm: added /dev/sdc3 to /dev/md3 as 7
mdadm: no uptodate device for slot 16 of /dev/md3
mdadm: added /dev/sdj3 to /dev/md3 as 9
mdadm: no uptodate device for slot 20 of /dev/md3
mdadm: added /dev/sda3 to /dev/md3 as -1
mdadm: added /dev/sdf3 to /dev/md3 as 0
mdadm: /dev/md3 assembled from 9 drives and 1 spare - not enough to start the array.

# mdadm -v --assemble --update=revert-reshape --force /dev/md3 /dev/sd[a-j]3
mdadm: looking for devices for /dev/md3
mdadm: /dev/sda3 is identified as a member of /dev/md3, slot -1.
mdadm: /dev/sdb3 is identified as a member of /dev/md3, slot 6.
mdadm: /dev/sdc3 is identified as a member of /dev/md3, slot 7.
mdadm: /dev/sdd3 is identified as a member of /dev/md3, slot 4.
mdadm: /dev/sde3 is identified as a member of /dev/md3, slot 5.
mdadm: /dev/sdf3 is identified as a member of /dev/md3, slot 0.
mdadm: /dev/sdg3 is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sdh3 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sdi3 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdj3 is identified as a member of /dev/md3, slot 9.
mdadm: added /dev/sdi3 to /dev/md3 as 1
mdadm: added /dev/sdh3 to /dev/md3 as 2
mdadm: added /dev/sdg3 to /dev/md3 as 3
mdadm: added /dev/sdd3 to /dev/md3 as 4
mdadm: added /dev/sde3 to /dev/md3 as 5
mdadm: added /dev/sdb3 to /dev/md3 as 6
mdadm: added /dev/sdc3 to /dev/md3 as 7
mdadm: no uptodate device for slot 16 of /dev/md3
mdadm: added /dev/sdj3 to /dev/md3 as 9
mdadm: no uptodate device for slot 20 of /dev/md3
mdadm: added /dev/sda3 to /dev/md3 as -1
mdadm: added /dev/sdf3 to /dev/md3 as 0
mdadm: /dev/md3 assembled from 9 drives and 1 spare - not enough to start the array.

# mdadm --examine /dev/sd?3
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c0155214:a9c8e378:d368b6f6:735048a8

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 952aa5ef - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 375d85e2:9077dd68:bc1327af:8fee4112

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 75b9e502 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 67cd2bfa:affa578c:e0c1286a:bd4d2627

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 80c8e5f0 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4490843e:d2c5c2e7:d222fa0a:f98b277c

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 165712cf - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1d41056f:88149b1a:48e939e5:8c775e23

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : fb26c467 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fa7c541d:a25babd8:14ffe1c0:c6c1578c

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : ac27a760 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a4b8b425:b0307fe5:9eb8e3ac:ae985311

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 3259488d - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 345b0212:6c3a0ae8:d8ed9273:ecc53573

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 49c35750 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 70afdaad:b0979fb1:1b99ef18:dd58cc3a

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1c2c4756 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 7799105167 (3718.90 GiB 3993.14 GB)
     Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 251904 sectors
     New Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a5f2cea8:a89c88a0:0dd3900c:624f0491

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (11->10)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 4fdabfb0 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : AAAAAAAA.A. ('A' == active, '.' == missing, 'R' == replacing)



END OF MESSAGE
