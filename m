From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: GRUB2 MD RAID detection order
Date: Mon, 10 Jan 2011 16:08:35 -0500
Message-ID: <AANLkTimhr-06dvwhiOTZOS7zbCbnePRVXWZ9dXBmD3b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: grub-devel@gnu.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

After having problem with detecting RAID arrays on my computer and
discussions on IRC, I came across a problem in RAID detection in GRUB2
in certain condition. Details of my current setup at the bottom of
this message.
In my setup my 4 disks are partionned using GPT, 320GB each with a
protective 0xEE GPT partition.
Partition 1 on each disk is 0xEF02 for GRUB offsetted at sector 2048.
Partition 2 are 0xFD00 RAID1 with 4 members for /boot
Partition 3 are 0xFD00 RAID5 with 4 members formatted as LVM and takes
the rest of the disk, which means it includes the last available
non-GPT sector.
Both RAIDs have metadata format 0.9.

When GRUB detects RAID1, I get (md0) which is OK, but when it detects
the RAID5, it detects the RAID as starting from sector 0 of the disk
as it checks the disk instead of the GPT partition but still cuts the
length as in the superblock, so I get (md1,gpt[1,2,3]) and (md1,gpt3)
does not show correctly else LVM would detect it anyway (I guess).

So options presented to us to fix are:
1. Check for RAID in partitions first, then in whole disk.
2. Verify minor number in superblock to see if they are divisible per
16 which would mean it is whole disk, however I guess this is
SCSI/SATA-centric.
3. What I currently implemented because I didn't know GRUB2 better,
compare size in superblock vs size of the currently probed device plus
a margin to see if content fits with superblock.

I know I could have fixed this by reducing my last GPT partition a
bit, but I guess other people will fall in this problem sometime when
bigger disk start using GPT, anyway, maybe metadata 0.9 will start
disappearing afterward.

Notice how sda and sda3 are the same.

md0 : active raid1 sdc2[0] sdd2[3] sda2[2] sdb2[1]
=A0 =A0 =A0524224 blocks [4/4] [UUUU]
=A0 =A0 =A0bitmap: 0/64 pages [0KB], 4KB chunk

md1 : active raid5 sdd3[0] sda3[3] sdc3[2] sdb3[1]
=A0 =A0 =A0936115200 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU=
]
=A0 =A0 =A0bitmap: 4/149 pages [16KB], 1024KB chunk



mdadm -E /dev/sda
/dev/sda:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : cdf20521:cfed4cc3:130ede86:cb56fef4
=A0Creation Time : Sun May 17 16:53:26 2009
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 312038400 (297.58 GiB 319.53 GB)
=A0 =A0 Array Size : 936115200 (892.75 GiB 958.58 GB)
=A0 Raid Devices : 4
=A0Total Devices : 4
Preferred Minor : 1

=A0 =A0Update Time : Mon Jan 10 15:37:30 2011
=A0 =A0 =A0 =A0 =A0State : clean
Internal Bitmap : present
Active Devices : 4
Working Devices : 4
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : cfb6f02f - correct
=A0 =A0 =A0 =A0 Events : 3676708

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 =A03 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sda3

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 51 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdd3
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb3
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 35 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc3
=A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 =A03 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sda3
p4 ~ # mdadm -E /dev/sda3
/dev/sda3:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : cdf20521:cfed4cc3:130ede86:cb56fef4
=A0Creation Time : Sun May 17 16:53:26 2009
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 312038400 (297.58 GiB 319.53 GB)
=A0 =A0 Array Size : 936115200 (892.75 GiB 958.58 GB)
=A0 Raid Devices : 4
=A0Total Devices : 4
Preferred Minor : 1

=A0 =A0Update Time : Mon Jan 10 15:37:30 2011
=A0 =A0 =A0 =A0 =A0State : clean
Internal Bitmap : present
Active Devices : 4
Working Devices : 4
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : cfb6f02f - correct
=A0 =A0 =A0 =A0 Events : 3676708

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 =A03 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sda3

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 51 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdd3
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb3
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 35 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc3
=A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 =A03 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sda3




p4 ~ # gdisk -l /dev/sda
GPT fdisk (gdisk) version 0.6.9

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

=46ound valid GPT with protective MBR; using GPT.
Disk /dev/sda: 625142448 sectors, 298.1 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 24746079-21E4-4960-B9B5-479955CC7462
Partition table holds up to 128 entries
=46irst usable sector is 34, last usable sector is 625142414
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            4095   1024.0 KiB  EF02  GRUB2
   2            4096         1052671   512.0 MiB   FD00  RAID1 Boot
   3         1052672       625142414   297.6 GiB   FD00  RAID5 LVM



p4 ~ # fdisk -luc /dev/sda
Disk /dev/sda: 320.1 GB, 320072933376 bytes
256 heads, 63 sectors/track, 38761 cylinders, total 625142448 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1   625142447   312571223+  ee  GPT
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
