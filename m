From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 20:24:55 +0200
Message-ID: <b4bfd58e-dea0-a7e3-5555-2e819aaf17e1@gmail.com>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5ECC09D6.1010300@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>
> Especially
>
> https://raid.wiki.kernel.org/index.php/Asking_for_help
>
> More will follow but we need this info.
>
> Cheers,
> Wol

And the output of examine:
root@nas:~# mdadm -E /dev/sda1
/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x5
      Array UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
            Name : nas:0  (local to host nas)
   Creation Time : Sun May 17 00:23:42 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 23437504512 (11175.87 GiB 12000.00 GB)
      Array Size : 46875009024 (44703.49 GiB 48000.01 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : active
     Device UUID : 64b8c8bd:400cf9d1:d5161aac:4b8ac29a

Internal Bitmap : 8 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (4->5)

     Update Time : Mon May 25 16:05:38 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : d9c3b859 - correct
          Events : 38602

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

======================================

root@nas:~# mdadm -E /dev/sdb1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x5
      Array UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
            Name : nas:0  (local to host nas)
   Creation Time : Sun May 17 00:23:42 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 23437504512 (11175.87 GiB 12000.00 GB)
      Array Size : 46875009024 (44703.49 GiB 48000.01 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : active
     Device UUID : d1f20899:f22a1267:6525deb0:e109960c

Internal Bitmap : 8 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (4->5)

     Update Time : Mon May 25 16:05:38 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : c0b49f9e - correct
          Events : 38602

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

=========================================

root@nas:~# mdadm -E /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x5
      Array UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
            Name : nas:0  (local to host nas)
   Creation Time : Sun May 17 00:23:42 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 23437504512 (11175.87 GiB 12000.00 GB)
      Array Size : 46875009024 (44703.49 GiB 48000.01 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : active
     Device UUID : 6e6c5cd4:0f3d0695:fac0399d:060554d8

Internal Bitmap : 8 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (4->5)

     Update Time : Mon May 25 16:05:38 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : e215c214 - correct
          Events : 38602

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

============================================

root@nas:~# mdadm -E /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x5
      Array UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
            Name : nas:0  (local to host nas)
   Creation Time : Sun May 17 00:23:42 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 23437504512 (11175.87 GiB 12000.00 GB)
      Array Size : 46875009024 (44703.49 GiB 48000.01 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : active
     Device UUID : 999c5ee2:180dc99f:7c65cac5:d46fac89

Internal Bitmap : 8 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (4->5)

     Update Time : Mon May 25 16:05:38 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : d4c3d19a - correct
          Events : 38602

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

===============================================

root@nas:~# mdadm -E /dev/sde1
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x5
      Array UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
            Name : nas:0  (local to host nas)
   Creation Time : Sun May 17 00:23:42 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 23437504512 (11175.87 GiB 12000.00 GB)
      Array Size : 46875009024 (44703.49 GiB 48000.01 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=0 sectors
           State : active
     Device UUID : 29cfb720:59627867:f11153ce:443a6395

Internal Bitmap : 8 sectors from superblock
   Reshape pos'n : 0
   Delta Devices : 1 (4->5)

     Update Time : Mon May 25 16:05:38 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : ef0bd050 - correct
          Events : 38602

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

========================


root@nas:~# mdadm -E /dev/sda
/dev/sda:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
root@nas:~# mdadm -E /dev/sdb
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
root@nas:~# mdadm -E /dev/sdc
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
root@nas:~# mdadm -E /dev/sdd
/dev/sdd:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
root@nas:~# mdadm -E /dev/sde
/dev/sde:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
