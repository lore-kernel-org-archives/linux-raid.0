From: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Subject: Re: Help - Urgent!!!
Date: Thu, 12 Nov 2009 23:14:13 -0600
Message-ID: <200911122314.13426.lrhorer@satx.rr.com>
References: <200911122253.01626.lrhorer@satx.rr.com> <19196.60011.858158.550391@notabene.brown> <19196.60094.69339.36550@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19196.60094.69339.36550@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 12 November 2009 11:12:30 pm you wrote:
> On Friday November 13, neilb@suse.de wrote:
> > 1/ show us what the result of --examine was.
> > 2/ add -vvv to the --assemble and report the result of that.
>
>   3/ report the output of "mdadm -X /dev/list-of-devices"



RAID-Server:/etc/cron.d# mdadm --examine /dev/sd[a-j]
/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : RAID-Server:0  (local to host RAID-Server)
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : d40c9255:cef0739f:966d448d:e549ada8

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : 9a4e478a - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 0 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : Uuuuuuuuuu
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b38a638b:ec546588:4f9a4c8b:16886fe6

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : 24e4ca52 - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 1 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uUuuuuuuuu
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 5158e257:4f166c7f:f5abf1b6:5341dff8

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : 267f2437 - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 2 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuUuuuuuuu
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : bd1b5e0a:a34494e8:c445f3e0:7cf0bd2d

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : a1035eef - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 3 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuuUuuuuuu
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : baf86255:b30938e9:edaf8c86:87b4f49a

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : ff7c2f31 - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 4 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuuuUuuuuu
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 8e2c9eac:617f70f4:5bd00aa3:f59ef3cf

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : b36ce391 - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 5 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuuuuUuuuu
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 0b5819b7:82845162:3e06a649:f7d4664b

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : 4dd78014 - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 6 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuuuuuUuuu
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 654fa4ee:290ddbd4:c171e2c5:7b57fdd8

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : 1beee1f - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 7 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuuuuuuUuu
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 51f8418f:e2dd7c93:6a898b0c:74d6661a

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : e910fe64 - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 8 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuuuuuuuUu
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : 'RAID-Server':0
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 42993978:e422dd03:9417b109:cdfd6b07

    Update Time : Thu Nov 12 21:34:18 2009
       Checksum : 2c9399db - correct
         Events : 489251

     Chunk Size : 256K

    Array Slot : 9 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : uuuuuuuuuU
