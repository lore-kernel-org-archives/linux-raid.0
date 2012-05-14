From: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?=
	<Sergiusz.Brzezinski@supersystem.pl>
Subject: mdadm doesn't wont to grow - help please
Date: Mon, 14 May 2012 15:49:53 +0200
Message-ID: <4FB10D81.7070803@supersystem.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I would like to grow the RAID1.

- Raid1 size has about 50GB
- two HD partition (sda2, sdb2) have about 80GB+ (each)

I do:

# mdadm --grow /dev/md0 --size=3Dmax

and I get the info, that the new size is 50GB. And I wonder: why not 80=
GB? The=20
size doesn't change! If I try to force size (--size=3Dxxxxx), I get the=
 message=20
that there is no space.

What did I wrong?

Bellow some facts about my configuration.

Please help.

Thank You in advance

Sergiusz Brzezi=C5=84ski
-----------------------------------------------

# mdadm --detail /dev/md0

/dev/md0:
         Version : 1.2
   Creation Time : Wed Mar 30 07:25:47 2011
      Raid Level : raid1
      Array Size : 52427776 (50.00 GiB 53.69 GB)
   Used Dev Size : 52427776 (50.00 GiB 53.69 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Mon May 14 09:16:16 2012
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : linux-uo1f.site:1
            UUID : 603ab02b:f8e9c2b9:863ce780:7f8dfca7
          Events : 5472151

     Number   Major   Minor   RaidDevice State
        2       8        2        0      active sync   /dev/sda2
        4       8       18        1      active sync   /dev/sdb2



# cat /proc/mdstat

Personalities : [raid1]
md0 : active raid1 sda2[2] sdb2[4]
       52427776 blocks super 1.2 [2/2] [UU]

unused devices: <none>


# fdisk /dev/sdb

Disk /dev/sdb: 320.1 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders, total 625142448 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0008f6dc

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *        2048      208895      103424   83  Linux
/dev/sdb2          208896   625142447   312466776   fd  Linux raid auto=
detect


# fdisk /dev/sda

Disk /dev/sda: 90.0 GB, 90028302336 bytes
255 heads, 63 sectors/track, 10945 cylinders, total 175836528 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x08e607c5

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048      208895      103424   83  Linux
/dev/sda2          208896   175836527    87813816   fd  Linux raid auto=
detect
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
