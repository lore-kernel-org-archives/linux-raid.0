From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: mdadm raid6->LVM->ext4 setup
Date: Tue, 16 Nov 2010 20:08:44 +0200
Message-ID: <4CE2C8AC.7010103@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
with the kind help from some of you on this list, I am finally=20
formatting the filesystem.
I'd be grateful if any of you would like to comment on my chosen=20
chunk/stripe/stride/ etc values, as from tomorrow I will be loading TBs=
=20
of 400MB images onto this system, so would prefer to be coerced into=20
making changes before then.

Thanks & regards,
Zoltan



***  Setup:
8 * 5900RPM Seagte 2TB drives on SiI3132 PCIx x1 card.
Linux gs0 2.6.32-25-generic #45-Ubuntu SMP Sat Oct 16 19:52:42 UTC 2010=
=20
x86_64 GNU/Linux
mdadm - v3.1.4 - 31st August 2010
   LVM version:     2.02.54(1) (2009-10-26)
   Library version: 1.02.39 (2009-10-26)
   Driver version:  4.15.0
mke2fs 1.41.11 (14-Mar-2010)

***  Commands used:
mdadm --create /dev/md0 --metadata=3D1.2 --auto=3Dmd --assume-clean=20
--bitmap=3Dinternal --bitmap-chunk=3D131072 --chunk=3D512 --level=3D6=20
--raid-devices=3D8 /dev/sd[abcdefgh]
mdadm --detail --scan >> /etc/mdadm.conf
mdadm --assemble /dev/md0
pvcreate --metadatasize 512 /dev/md0
vgcreate geo_vg0 /dev/md0
lvcreate -n geo_lvm0 -l 100%FREE geo_vg0
mkfs -t ext4  -m 1-b 4096 -E stride=3D128,stripe-width=3D768=20
/dev/geo_vg0/geo_lvm0


*** Results:
root@gs0:/home/geograph# mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Tue Nov 16 17:28:37 2010
      Raid Level : raid6
      Array Size : 11721077760 (11178.09 GiB 12002.38 GB)
   Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
    Raid Devices : 8
   Total Devices : 8
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Nov 16 19:44:10 2010
           State : active
  Active Devices : 8
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : gs0:0  (local to host gs0)
            UUID : c35e7642:7d78c385:61a26db1:89a5ace5
          Events : 3

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       8       48        3      active sync   /dev/sdd
        4       8       64        4      active sync   /dev/sde
        5       8       80        5      active sync   /dev/sdf
        6       8       96        6      active sync   /dev/sdg
        7       8      112        7      active sync   /dev/sdh
root@gs0:/home/geograph#
*******************************************************************
root@gs0:/home/geograph# pvdisplay
   --- Physical volume ---
   PV Name               /dev/md0
   VG Name               geo_vg0
   PV Size               10.92 TiB / not usable 0
   Allocatable           yes (but full)
   PE Size               4.00 MiB
   Total PE              2861463
   Free PE               0
   Allocated PE          2861463
   PV UUID               oE4Itq-rAwe-RQzK-JTnn-XAVk-vObv-ORx5HO

root@gs0:/home/geograph# vgdisplay
   --- Volume group ---
   VG Name               geo_vg0
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  2
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                1
   Open LV               1
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               10.92 TiB
   PE Size               4.00 MiB
   Total PE              2861463
   Alloc PE / Size       2861463 / 10.92 TiB
   Free  PE / Size       0 / 0
   VG UUID               0S3VyN-aMu4-U60o-hz3z-R6RL-hGUd-nJHCTg

root@gs0:/home/geograph# lvdisplay
   --- Logical volume ---
   LV Name                /dev/geo_vg0/geo_lvm0
   VG Name                geo_vg0
   LV UUID                dnhY9R-mGO3-oRg6-0EP7-i6kt-2dIW-R9028r
   LV Write Access        read/write
   LV Status              available
   # open                 1
   LV Size                10.92 TiB
   Current LE             2861463
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     12288
   Block device           252:0

root@gs0:/home/geograph#

*********************************************************

root@gs0:/home/geograph# echo `date` > zz_mkfs ; mkfs -t ext4 -m 1 -b=20
4096 -E stride=3D128,stripe-width=3D768 /dev/geo_vg0/geo_lvm0 ; echo `d=
ate`=20
 >> zz_mkfs
mke2fs 1.41.11 (14-Mar-2010)
=46ilesystem label=3D
OS type: Linux
Block size=3D4096 (log=3D2)
=46ragment size=3D4096 (log=3D2)
Stride=3D128 blocks, Stripe width=3D768 blocks
732536832 inodes, 2930138112 blocks
29301381 blocks (1.00%) reserved for the super user
=46irst data block=3D0
Maximum filesystem blocks=3D4294967296
89421 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,=
=20
2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616,=20
78675968,
         102400000, 214990848, 512000000, 550731776, 644972544, 1934917=
632,
         2560000000



[still running]



--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3260 - Release Date: 11/16/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
