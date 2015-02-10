From: "G. Michael Carter" <mikey@carterfamily.ca>
Subject: Re: mdsadm -A won't assemble my array
Date: Mon, 9 Feb 2015 20:36:41 -0500
Message-ID: <CANjusZdgzDxN4ZxsXFc20OU1Y9_LoScYQcZmffyRGHWYUviY0Q@mail.gmail.com>
References: <CANjusZesi-8zxpZ9rCOEToSXwFoiApeN-ivO51qY=80R6_xb_g@mail.gmail.com>
	<CANjusZcnX=BArJJLMiBN4hfzRRLdUtD6mSq-mDZ6OhPB=KMX3w@mail.gmail.com>
	<54D94D3C.3060808@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D94D3C.3060808@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Was actually dreading the complete info question, as the machine has
no CD/DVD, it is my netboot station and holds all my ISO mirrors.  But
turns out starting it's network interface from the emergency shell was
easier than I thought.

---- uname
Linux andromeda 3.16.6-203.fc20.x86_64 #1 SMP Sat Oct 25 12:44:32 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux
---- mdadm -V
mdadm - v3.3 - 3rd September 2013
---- disk-by-id
total 0
lrwxrwxrwx 1 root root  9 Feb  9 20:16
ata-OCZ-AGILITY2_OCZ-12ENW740X6E8681U -> ../../sdc
lrwxrwxrwx 1 root root 10 Feb  9 20:16
ata-OCZ-AGILITY2_OCZ-12ENW740X6E8681U-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Feb  9 20:16
ata-OCZ-AGILITY2_OCZ-12ENW740X6E8681U-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 Feb  9 20:16
ata-OCZ-AGILITY2_OCZ-12ENW740X6E8681U-part3 -> ../../sdc3
lrwxrwxrwx 1 root root 10 Feb  9 20:16
ata-OCZ-AGILITY2_OCZ-12ENW740X6E8681U-part4 -> ../../sdc4
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST2000DL003-9VT166_5YD5QSG3
-> ../../sda
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST2000DL003-9VT166_5YD604E0
-> ../../sde
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST3000DM001-1CH166_Z1F2H9YC
-> ../../sdm
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST3000DM001-9YN166_S1F026CS
-> ../../sdf
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST3000DM001-9YN166_W1F0GD7Y
-> ../../sdn
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST3000DM001-9YN166_W1F0JSVP
-> ../../sdh
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST33000651AS_9XK0A9AD -> ../../sdd
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST33000651AS_9XK0AV1G -> ../../sdl
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST33000651AS_9XK0N7GY -> ../../sdg
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST33000651AS_Z291009B -> ../../sdi
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST33000651AS_Z2911DKS -> ../../sdj
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_W3009GE3
-> ../../sdp
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_W300E08A
-> ../../sdk
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_Z300PYF2
-> ../../sdb
lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_Z300Q4YS
-> ../../sdo
lrwxrwxrwx 1 root root  9 Feb  9 20:16
lvm-pv-uuid-fIZX8P-yR3l-KR3t-b206-KiDM-PhpK-JwLevw -> ../../md0
lrwxrwxrwx 1 root root  9 Feb  9 20:16
lvm-pv-uuid-Uvrg7m-X8Hr-JJn9-CAlu-Lno6-K3rp-A2p6fj -> ../../md1
lrwxrwxrwx 1 root root  9 Feb  9 20:16
lvm-pv-uuid-XetEWl-bxcb-WOHF-jNIg-M10Q-xxz1-HDeCwH -> ../../md2
lrwxrwxrwx 1 root root  9 Feb  9 20:16 md-name-andromeda:0 -> ../../md0
lrwxrwxrwx 1 root root  9 Feb  9 20:16 md-name-andromeda:1 -> ../../md1
lrwxrwxrwx 1 root root  9 Feb  9 20:16 md-name-andromeda:2 -> ../../md2
lrwxrwxrwx 1 root root  9 Feb  9 20:16
md-uuid-569d52c7:91ba146a:2dc88abf:1dbd4f12 -> ../../md0
lrwxrwxrwx 1 root root  9 Feb  9 20:16
md-uuid-8b1dbda6:fc378fa5:774dcb4f:c273dca5 -> ../../md1
lrwxrwxrwx 1 root root  9 Feb  9 20:16
md-uuid-fb065d4d:c906243c:945b8291:73539d13 -> ../../md2
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c5002da066d5 -> ../../sdd
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c5002dad7e24 -> ../../sdl
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c50036281493 -> ../../sdi
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c50036406c91 -> ../../sdj
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c50044338d40 -> ../../sde
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c50045add261 -> ../../sda
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c5004a1255d8 -> ../../sdf
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c5004ffa2772 -> ../../sdm
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c50050dd4721 -> ../../sdn
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c500510652c5 -> ../../sdh
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c500608925d1 -> ../../sdp
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c5006434f070 -> ../../sdb
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5000c50064360fff -> ../../sdo
lrwxrwxrwx 1 root root  9 Feb  9 20:16 wwn-0x5e83a97f4233045f -> ../../sdc
lrwxrwxrwx 1 root root 10 Feb  9 20:16 wwn-0x5e83a97f4233045f-part1 ->
../../sdc1
lrwxrwxrwx 1 root root 10 Feb  9 20:16 wwn-0x5e83a97f4233045f-part2 ->
../../sdc2
lrwxrwxrwx 1 root root 10 Feb  9 20:16 wwn-0x5e83a97f4233045f-part3 ->
../../sdc3
lrwxrwxrwx 1 root root 10 Feb  9 20:16 wwn-0x5e83a97f4233045f-part4 ->
../../sdc4
---- mdadm -E
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
           Name : andromeda:3  (local to host andromeda)
  Creation Time : Tue Jul 22 16:02:30 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=3760 sectors
          State : clean
    Device UUID : e9e7af60:e1bc1c7f:107157b4:4099c48a

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Feb  9 05:13:20 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 57eaf19 - correct
         Events : 158964

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
           Name : andromeda:3  (local to host andromeda)
  Creation Time : Tue Jul 22 16:02:30 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=3760 sectors
          State : active
    Device UUID : ed09357e:36655c6d:b7430500:63d5e540

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Feb  9 05:10:53 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 131587ad - correct
         Events : 158964

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdo:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
           Name : andromeda:3  (local to host andromeda)
  Creation Time : Tue Jul 22 16:02:30 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=3760 sectors
          State : clean
    Device UUID : de849807:80d7f071:9909f3f2:78022d94

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Feb  9 05:11:55 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e73f681f - correct
         Events : 158962

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : A.AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdp:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
           Name : andromeda:3  (local to host andromeda)
  Creation Time : Tue Jul 22 16:02:30 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=3760 sectors
          State : clean
    Device UUID : 67fcd9a9:432b0c8b:178cc556:67b003b3

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Feb  9 05:11:55 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 254563d8 - correct
         Events : 158962

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.AA ('A' == active, '.' == missing, 'R' == replacing)
---- blkid
/dev/sda: UUID="8b1dbda6-fc37-8fa5-774d-cb4fc273dca5"
UUID_SUB="82a7750b-74d9-c901-766e-7802b2737d3e" LABEL="andromeda:1"
TYPE="linux_raid_member"
/dev/sdb: UUID="ce6de916-62ae-da9c-b568-8f54f5a9249d"
UUID_SUB="e9e7af60-e1bc-1c7f-1071-57b44099c48a" LABEL="andromeda:3"
TYPE="linux_raid_member"
/dev/sdc: PTUUID="99e8af68-ba3a-4343-9751-3217c4e3d9a1" PTTYPE="gpt"
/dev/sdc1: PARTUUID="69de1013-cf8a-4131-bdab-03705decd42e"
/dev/sdc2: UUID="944c019a-4fb0-434d-b998-361d90352230" TYPE="ext4"
PARTLABEL="ext4" PARTUUID="cf7f5556-567e-450a-9712-e3d2bc735537"
/dev/sdc3: UUID="9dbf5b08-afdd-47c5-b92b-5350dc26524c" TYPE="ext4"
PARTUUID="46335bee-eea2-441a-8422-207b5c5fa44c"
/dev/sdc4: UUID="7407b6b8-517f-49ca-aac0-01120d98fcdc" TYPE="swap"
PARTUUID="f14bdff5-23f9-42f0-a6e3-b859076ca0bc"
/dev/sdd: UUID="569d52c7-91ba-146a-2dc8-8abf1dbd4f12"
UUID_SUB="9786712b-834a-47c1-4402-a4eba529e89e" LABEL="andromeda:0"
TYPE="linux_raid_member"
/dev/sde: UUID="8b1dbda6-fc37-8fa5-774d-cb4fc273dca5"
UUID_SUB="44280e97-717e-09d5-92f5-3af95a5c7364" LABEL="andromeda:1"
TYPE="linux_raid_member"
/dev/sdf: UUID="569d52c7-91ba-146a-2dc8-8abf1dbd4f12"
UUID_SUB="fdb635cc-f399-943e-bbb0-67809f0ac896" LABEL="andromeda:0"
TYPE="linux_raid_member"
/dev/sdg: UUID="fb065d4d-c906-243c-945b-829173539d13"
UUID_SUB="08104eec-720d-4cae-ed0e-3ef06d4938ff" LABEL="andromeda:2"
TYPE="linux_raid_member"
/dev/sdh: UUID="fb065d4d-c906-243c-945b-829173539d13"
UUID_SUB="49b3eafa-f4ab-2bb3-7faa-6996dfc4bb00" LABEL="andromeda:2"
TYPE="linux_raid_member"
/dev/sdi: UUID="fb065d4d-c906-243c-945b-829173539d13"
UUID_SUB="a70e7fa1-6909-b030-e899-0f85555f0094" LABEL="andromeda:2"
TYPE="linux_raid_member"
/dev/sdj: UUID="fb065d4d-c906-243c-945b-829173539d13"
UUID_SUB="c74f4f4f-0b4b-65d4-b8e9-90ce689678c8" LABEL="andromeda:2"
TYPE="linux_raid_member"
/dev/sdk: UUID="ce6de916-62ae-da9c-b568-8f54f5a9249d"
UUID_SUB="ed09357e-3665-5c6d-b743-050063d5e540" LABEL="andromeda:3"
TYPE="linux_raid_member"
/dev/sdl: UUID="569d52c7-91ba-146a-2dc8-8abf1dbd4f12"
UUID_SUB="bd04495d-ce3b-09c7-0cac-37b98f74b3a7" LABEL="andromeda:0"
TYPE="linux_raid_member"
/dev/sdm: UUID="569d52c7-91ba-146a-2dc8-8abf1dbd4f12"
UUID_SUB="5c6e4d63-3f4d-a05e-d64e-62b339f4f767" LABEL="andromeda:0"
TYPE="linux_raid_member"
/dev/sdn: UUID="569d52c7-91ba-146a-2dc8-8abf1dbd4f12"
UUID_SUB="1b2773d1-391b-3c78-42e0-fd405416d9e7" LABEL="andromeda:0"
TYPE="linux_raid_member"
/dev/sdo: UUID="ce6de916-62ae-da9c-b568-8f54f5a9249d"
UUID_SUB="de849807-80d7-f071-9909-f3f278022d94" LABEL="andromeda:3"
TYPE="linux_raid_member"
/dev/sdp: UUID="ce6de916-62ae-da9c-b568-8f54f5a9249d"
UUID_SUB="67fcd9a9-432b-0c8b-178c-c55667b003b3" LABEL="andromeda:3"
TYPE="linux_raid_member"
---- dmesg
[  576.890380] md: md3 stopped.
[  576.891629] md: unbind<sdb>
[  576.900841] md: export_rdev(sdb)
[  576.902147] md: unbind<sdo>
[  576.906824] md: export_rdev(sdo)
[  576.908029] md: unbind<sdk>
[  576.911845] md: export_rdev(sdk)
[  576.913030] md: unbind<sdp>
[  576.916862] md: export_rdev(sdp)
[  585.164936] md: md3 stopped.
[  585.360571] md: bind<sdk>
[  585.360833] md: bind<sdp>
[  585.361050] md: bind<sdo>
[  585.361261] md: bind<sdb>
[  585.361294] md: md3 stopped.
[  585.361298] md: unbind<sdb>
[  585.386616] md: export_rdev(sdb)
[  585.387767] md: unbind<sdo>
[  585.398644] md: export_rdev(sdo)
[  585.399633] md: unbind<sdp>
[  585.404662] md: export_rdev(sdp)
[  585.405681] md: unbind<sdk>
[  585.410647] md: export_rdev(sdk)
---- mdadm -A output
mdadm: looking for devices for /dev/md3
mdadm: /dev/sdb is identified as a member of /dev/md3, slot 0.
mdadm: /dev/sdk is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdo is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sdp is identified as a member of /dev/md3, slot 2.
mdadm: added /dev/sdk to /dev/md3 as 1
mdadm: added /dev/sdp to /dev/md3 as 2 (possibly out of date)
mdadm: added /dev/sdo to /dev/md3 as 3 (possibly out of date)
mdadm: added /dev/sdb to /dev/md3 as 0
mdadm: /dev/md3 assembled from 2 drives - not enough to start the array.
---- /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md1 : active raid1 sda[0] sde[1]
      1953383488 blocks super 1.2 [2/2] [UU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

md0 : active raid5 sdl[0] sdn[3] sdd[5] sdm[1]
      8790405120 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 0/22 pages [0KB], 65536KB chunk

md2 : active raid6 sdj[0] sdi[1] sdg[3] sdh[2]
      5860270080 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 0/22 pages [0KB], 65536KB chunk

unused devices: <none>

** md3 is shutdown which is why I'm assuming it's not there.
