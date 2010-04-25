From: "Christian Graf" <chr.graf@gmx.de>
Subject: nested mdadm-raid6 fails assembly - missing superblock
Date: Sun, 25 Apr 2010 14:22:15 +0200
Message-ID: <20100425122215.7210@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

since long I am using my raid6 with perfects results and now I am askin=
g kindly for help.
My raid6 consisting of 7 * 500GB became to small, so I decided to upgra=
de with 2 * 1TB-drives (sda and sdb) and use striping for the old-drive=
s (sd[c-i]) to become 1TB as well. The resulting new raid6 is md10.

 keeper:/home/behn# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [multipath] [faulty] [raid0]
md10 : active raid6 md3p1[6] md2p1[3] md1p1[2] sdb1[1] sda1[0]
      3907039232 blocks super 1.0 level 6, 64k chunk, algorithm 2 [6/4]=
 [UUUU__]
      [>....................]  recovery =3D  0.0% (434432/976759808) fi=
nish=3D15374.9min speed=3D1057K/sec

md3 : active raid0 sdd1[0] sdc1[1]
      976767872 blocks 64k chunks

md2 : active raid0 sde1[0] sdf1[1]
      976767872 blocks 64k chunks

md1 : active raid0 sdh1[0] sdi1[1]
      976767872 blocks 64k chunks

Of course that means creating and assembling of the new m10 was just fi=
ne, however due to money the 6th drive was declared missing:

 keeper:/home/behn# mdadm --create /dev/md10 --name=3D10 --metadata=3D1=
=2E0 --level=3D6 --raid-devices=3D6 /dev/sda1 /dev/sdb1 /dev/md[1-3]p1 =
missing
mdadm: /dev/sda1 appears to be part of a raid array:
    level=3Draid6 devices=3D5 ctime=3DFri Apr 23 00:03:31 2010
mdadm: /dev/sdb1 appears to contain an ext2fs file system
    size=3D-1096252032K  mtime=3DFri Apr 23 11:33:16 2010
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=3Draid6 devices=3D5 ctime=3DFri Apr 23 00:03:31 2010
Continue creating array? y
mdadm: array /dev/md10 started.


I just created the ext3-fs on the newly created md10 and tuned it:
keeper:/home/behn# fdisk -l /dev/md10

WARNING: The size of this disk is 4.0 TB (4000808173568 bytes).
DOS partition table format can not be used on drives for volumes
larger than (2199023255040 bytes) for 512-byte sectors. Use parted(1) a=
nd GUID
partition table format (GPT).


Disk /dev/md10: 4000.8 GB, 4000808173568 bytes
2 heads, 4 sectors/track, 976759808 cylinders
Units =3D cylinders of 8 * 512 =3D 4096 bytes
Disk identifier: 0xfc0ca3a2

     Device Boot      Start         End      Blocks   Id  System
/dev/md10p1               1   536870911  2147483642   83  Linux

keeper:/home/behn# tune2fs -m 1 -j /dev/md10p1
tune2fs 1.41.11 (14-Mar-2010)
Setting reserved blocks percentage to 1% (5368709 blocks)
Creating journal inode:

done
This filesystem will be automatically checked every 27 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

Solong, until this point all was perfectly fine to me. I copied some la=
rge stuff to md10 and the array looked good:

keeper:/home/behn# mdadm --detail /dev/md10
/dev/md10:
        Version : 1.00
  Creation Time : Fri Apr 23 20:18:56 2010
     Raid Level : raid6
     Array Size : 3907039232 (3726.04 GiB 4000.81 GB)
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
   Raid Devices : 6
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Fri Apr 23 20:21:04 2010
          State : active, degraded, recovering
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 64K

 Rebuild Status : 0% complete

           Name : keeper:10  (local to host keeper)
           UUID : 3c35cc46:f7afe8be:5ce1aa14:73a5567c
         Events : 3

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2     259        0        2      active sync   /dev/md1p1
       3     259        1        3      active sync   /dev/md2p1
       6     259        2        4      spare rebuilding   /dev/md3p1
       5       0        0        5      removed

here comes my pain now:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
But once I stopped the array, I can't reassmble it:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
keeper:/home/behn# mdadm --assemble /dev/md10 /dev/sda1 /dev/sdb1 /dev/=
md[1-3]
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has no superblock - assembly aborted



Can please someone suggest how to continue here please? I have not chan=
ged hw and even in addition the /dev/sda and /dev/sdb worked like a cha=
rm in a raid1 before I decided to create the nested md10:

I am using this as mdadm.conf
keeper:/home/behn# mdadm --detail --scan
DEVICE /dev/sd[a-z]
ARRAY /dev/md1 metadata=3D0.90 UUID=3D5ece961d:9f6b8d08:3e3ade9f:30eaa9=
84
ARRAY /dev/md2 metadata=3D0.90 UUID=3D9b6fc6e1:d1798014:3e3ade9f:30eaa9=
84
ARRAY /dev/md3 metadata=3D0.90 UUID=3D2eec48f7:45b2e76a:3e3ade9f:30eaa9=
84
ARRAY /dev/md10 metadata=3D1.00 spares=3D1 name=3Dkeeper:10 UUID=3D3c35=
cc46:f7afe8be:5ce1aa14:73a5567c



many thanks for your help


christian

--=20
GRATIS f=FCr alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
