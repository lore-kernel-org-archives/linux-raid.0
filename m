From: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
Subject: AW: [HELP] Recover a RAID5 with 8 drives
Date: Tue, 28 Jan 2014 20:11:02 +0000
Message-ID: <A2EC67620EC7424F9EC3DD49243E9060466D9512@AUDIINSX0328.audi.vwg>
References: <52E7CCE4.3030408@morganspa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E7CCE4.3030408@morganspa.com>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: 'Maurizio De Santis' <m.desantis@morganspa.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Maurizio
A very likewise case did happened to me (search for QNAP).
Your box dropped a second one (=3Dfull failure) while rebuilding, I gue=
ss due to read errors and no TLER capable drive.
Western Digital is prone for this.

I was lucky to be able to copy all of my faulty (5 of 8) drives and cur=
rently I try to recreate the md superblocks which have been lost on the=
 last write.
What drives do you use?

Cheers
Sam


-----Urspr=FCngliche Nachricht-----
Von: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.ker=
nel.org] Im Auftrag von Maurizio De Santis
Gesendet: Dienstag, 28. Januar 2014 16:30
An: linux-raid@vger.kernel.org
Betreff: [HELP] Recover a RAID5 with 8 drives

Hi!

I think I've got a problem :-/ I have a QNAP NAS with a 8 disks RAID5.=20
Some days ago I got a "Disk Read/Write Error" on the 8th drive=20
(/dev/sdh), with the suggestion to replace the disk.

I replaced it, but after a bit the RAID rebuilding failed, and the QNAP=
=20
Admin Interface still gives me a "Disk Read/Write Error" on /dev/sdh.=20
Plus, I can't access to the RAID data anymore :-/

I was following this guide=20
https://raid.wiki.kernel.org/index.php/RAID_Recovery but, since I=20
haven't got any backup (I promise I will do them in the future!) I'm=20
afraid to run any possibly destructive command.

How do you suggest to proceed? I would like to make a RAID excluding th=
e=20
8th disk in order to mount it and backup important data, but I don't=20
even know if it is doable :-/ Moreover, looking at `mdadm --examine`=20
output I see that sdb seems to have problems too, also if QNAP Admin=20
Interface doesn't report it.

Here some informations about the machine status:

# uname -a
Linux NAS 3.4.6 #1 SMP Thu Sep 12 10:56:51 CST 2013 x86_64 unknown

# mdadm -V
mdadm - v2.6.3 - 20th August 2007

# cat /etc/mdadm.conf
ARRAY /dev/md0=20
devices=3D/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sdd3,/dev/sde3,/dev/sdf3,/=
dev/sdg3,/dev/sdh3

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]=20
[raid4] [multipath]
md8 : active raid1 sdg2[2](S) sdf2[3](S) sde2[4](S) sdd2[5](S)=20
sdc2[6](S) sdb2[1] sda2[0]
       530048 blocks [2/2] [UU]

md13 : active raid1 sda4[0] sde4[6] sdf4[5] sdg4[4] sdd4[3] sdc4[2] sdb=
4[1]
       458880 blocks [8/7] [UUUUUUU_]
       bitmap: 8/57 pages [32KB], 4KB chunk

md9 : active raid1 sda1[0] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1=
[1]
       530048 blocks [8/7] [UUUUUUU_]
       bitmap: 30/65 pages [120KB], 4KB chunk

unused devices: <none>

# mdadm --examine /dev/sd[abcdefgh]3
/dev/sda3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 418e2add:2c4b313b:d12fb7ea:993d5bf7
   Creation Time : Fri Jan 20 02:19:47 2012
      Raid Level : raid5
   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
      Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 0

     Update Time : Fri Jan 24 17:19:58 2014
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 982047ab - correct
          Events : 0.2944851

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
/dev/sdb3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 418e2add:2c4b313b:d12fb7ea:993d5bf7
   Creation Time : Fri Jan 20 02:19:47 2012
      Raid Level : raid5
   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
      Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
    Raid Devices : 8
   Total Devices : 8
Preferred Minor : 0

     Update Time : Fri Jan 24 17:09:57 2014
           State : active
  Active Devices : 7
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 1
        Checksum : 97f3567d - correct
          Events : 0.2944837

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       8       19        1      active sync   /dev/sdb3
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
    8     8       8      115        8      spare   /dev/sdh3
/dev/sdc3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 418e2add:2c4b313b:d12fb7ea:993d5bf7
   Creation Time : Fri Jan 20 02:19:47 2012
      Raid Level : raid5
   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
      Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 0

     Update Time : Fri Jan 24 17:19:58 2014
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 982047cf - correct
          Events : 0.2944851

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       35        2      active sync   /dev/sdc3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
/dev/sdd3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 418e2add:2c4b313b:d12fb7ea:993d5bf7
   Creation Time : Fri Jan 20 02:19:47 2012
      Raid Level : raid5
   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
      Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 0

     Update Time : Fri Jan 24 17:19:58 2014
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 982047e1 - correct
          Events : 0.2944851

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       51        3      active sync   /dev/sdd3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
/dev/sde3:
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 982047f3 - correct
          Events : 0.2944851

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8       67        4      active sync   /dev/sde3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
/dev/sdf3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 418e2add:2c4b313b:d12fb7ea:993d5bf7
   Creation Time : Fri Jan 20 02:19:47 2012
      Raid Level : raid5
   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
      Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 0

     Update Time : Fri Jan 24 17:19:58 2014
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 98204805 - correct
          Events : 0.2944851

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     5       8       83        5      active sync   /dev/sdf3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
/dev/sdg3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 418e2add:2c4b313b:d12fb7ea:993d5bf7
   Creation Time : Fri Jan 20 02:19:47 2012
      Raid Level : raid5
   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
      Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 0

     Update Time : Fri Jan 24 17:19:58 2014
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 98204817 - correct
          Events : 0.2944851

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     6       8       99        6      active sync   /dev/sdg3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
/dev/sdh3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 418e2add:2c4b313b:d12fb7ea:993d5bf7
   Creation Time : Fri Jan 20 02:19:47 2012
      Raid Level : raid5
   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
      Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
    Raid Devices : 8
   Total Devices : 8
Preferred Minor : 0

     Update Time : Fri Jan 24 17:18:26 2014
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : 98204851 - correct
          Events : 0.2944847

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     8       8      115        8      spare   /dev/sdh3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
    2     2       8       35        2      active sync   /dev/sdc3
    3     3       8       51        3      active sync   /dev/sdd3
    4     4       8       67        4      active sync   /dev/sde3
    5     5       8       83        5      active sync   /dev/sdf3
    6     6       8       99        6      active sync   /dev/sdg3
    7     7       0        0        7      faulty removed
    8     8       8      115        8      spare   /dev/sdh3

# dmesg **edited (removed unuseful parts)**
, wo:0, o:1, dev:sdb2
[  975.516724] RAID1 conf printout:
[  975.516728]  --- wd:2 rd:2
[  975.516732]  disk 0, wo:0, o:1, dev:sda2
[  975.516737]  disk 1, wo:0, o:1, dev:sdb2
[  975.516740] RAID1 conf printout:
[  975.516744]  --- wd:2 rd:2
[  975.516748]  disk 0, wo:0, o:1, dev:sda2
[  975.516753]  disk 1, wo:0, o:1, dev:sdb2
[  977.495709] md: unbind<sdh2>
[  977.505048] md: export_rdev(sdh2)
[  977.535277] md/raid1:md9: Disk failure on sdh1, disabling device.
[  977.575038]  disk 2, wo:0, o:1, dev:sdc1
[  977.575043]  disk 3, wo:0, o:1, dev:sdd1
[  977.575048]  disk 4, wo:0, o:1, dev:sde1
[  977.575053]  disk 5, wo:0, o:1, dev:sdf1
[  977.575058]  disk 6, wo:0, o:1, dev:sdg1
[  979.547149] md: unbind<sdh1>
[  979.558031] md: export_rdev(sdh1)
[  979.592646] md/raid1:md13: Disk failure on sdh4, disabling device.
[  979.592650] md/raid1:md13: Operation continuing on 7 devices.
[  979.650862] RAID1 conf printout:
[  979.650869]  --- wd:7 rd:8
[  979.650875]  disk 0, wo:0, o:1, dev:sda4
[  979.650880]  disk 1, wo:0, o:1, dev:sdb4
[  979.650885]  disk 2, wo:0, o:1, dev:sdc4
[  979.650890]  disk 3, wo:0, o:1, dev:sdd4
[  979.650895]  disk 4, wo:0, o:1, dev:sdg4
[  979.650900]  disk 5, wo:0, o:1, dev:sdf4
[  979.650905]  disk 6, wo:0, o:1, dev:sde4
[  979.650911]  disk 7, wo:1, o:0, dev:sdh4
[  979.656024] RAID1 conf printout:
[  979.656029]  --- wd:7 rd:8
[  979.656034]  disk 0, wo:0, o:1, dev:sda4
[  979.656039]  disk 1, wo:0, o:1, dev:sdb4
[  979.656044]  disk 2, wo:0, o:1, dev:sdc4
[  979.656049]  disk 3, wo:0, o:1, dev:sdd4
[  979.656054]  disk 4, wo:0, o:1, dev:sdg4
[  979.656059]  disk 5, wo:0, o:1, dev:sdf4
[  979.656063]  disk 6, wo:0, o:1, dev:sde4
[  981.604906] md: unbind<sdh4>
[  981.616035] md: export_rdev(sdh4)
[  981.753058] md/raid:md0: Disk failure on sdh3, disabling device.
[  981.753062] md/raid:md0: Operation continuing on 6 devices.
[  983.765852] md: unbind<sdh3>
[  983.777030] md: export_rdev(sdh3)
[ 1060.094825] journal commit I/O error
[ 1060.099196] journal commit I/O error
[ 1060.103525] journal commit I/O error
[ 1060.108698] journal commit I/O error
[ 1060.116311] journal commit I/O error
[ 1060.123634] journal commit I/O error
[ 1060.127225] journal commit I/O error
[ 1060.130930] journal commit I/O error
[ 1060.137651] EXT4-fs (md0): previous I/O error to superblock detected
[ 1060.178323] Buffer I/O error on device md0, logical block 0
[ 1060.181873] lost page write due to I/O error on md0
[ 1060.185634] EXT4-fs error (device md0): ext4_put_super:849: Couldn't=
=20
clean up the journal
[ 1062.662723] md0: detected capacity change from 13991546060800 to 0
[ 1062.666308] md: md0 stopped.
[ 1062.669760] md: unbind<sda3>
[ 1062.681031] md: export_rdev(sda3)
[ 1062.684466] md: unbind<sdg3>
[ 1062.695023] md: export_rdev(sdg3)
[ 1062.698342] md: unbind<sdf3>
[ 1062.709021] md: export_rdev(sdf3)
[ 1062.712310] md: unbind<sde3>
[ 1062.723029] md: export_rdev(sde3)
[ 1062.726245] md: unbind<sdd3>
[ 1062.737022] md: export_rdev(sdd3)
[ 1062.740112] md: unbind<sdc3>
[ 1062.751022] md: export_rdev(sdc3)
[ 1062.753934] md: unbind<sdb3>
[ 1062.764021] md: export_rdev(sdb3)
[ 1063.772687] md: md0 stopped.
[ 1064.782381] md: md0 stopped.
[ 1065.792585] md: md0 stopped.
[ 1066.801668] md: md0 stopped.
[ 1067.812573] md: md0 stopped.
[ 1068.821548] md: md0 stopped.
[ 1069.830667] md: md0 stopped.
[ 1070.839554] md: md0 stopped.
[ 1071.848418] md: md0 stopped.

--=20

Maurizio De Santis

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
