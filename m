From: SharksArt <sharksart@gmail.com>
Subject: RAID5 - reshape_position too early for auto-recovery - aborting
Date: Tue, 3 May 2016 20:17:30 +0200
Message-ID: <CAJwyido42Gk0uoMCKCLXk0dLfJ+J91uS=4N359fG0jkwg=jAGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've a little problem with my Xpenology NAS (based on Synology). After
remplacement a disk (500GB) for a bigger one (1TB), it start checking
parity and i let him doing it during the night. But the next day, my
NAS was unreachable. There was no intence activity (led non blinking)
so i decided to power off the NAS, wait a little and power on. Bad
luck, the only volume (about 4.5TB) was unusable and showing no
capacity, used space etc...
So, my NAS is build with Xpenology on an ESXi 5.5 with now 6x 1TB HDD
in RDM plus a virtual disk of 15MB for booting :

Cube> fdisk -l

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sda1               1         311     2490240  fd Linux raid autodetect
Partition 1 does not end on cylinder boundary
/dev/sda2             311         572     2097152  fd Linux raid autodetect
Partition 2 does not end on cylinder boundary
/dev/sda3             588      121601   972036912   f Win95 Ext'd (LBA)
/dev/sda5             589       60801   483652864  fd Linux raid autodetect
/dev/sda6           60802       77825   136737232  fd Linux raid autodetect
/dev/sda7           77826      121601   351622672  fd Linux raid autodetect

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdb1               1         311     2490240  fd Linux raid autodetect
Partition 1 does not end on cylinder boundary
/dev/sdb2             311         572     2097152  fd Linux raid autodetect
Partition 2 does not end on cylinder boundary
/dev/sdb3             588      121601   972036912   f Win95 Ext'd (LBA)
/dev/sdb5             589       60801   483652864  fd Linux raid autodetect
/dev/sdb6           60802       77825   136737232  fd Linux raid autodetect
/dev/sdb7           77826      121601   351622672  fd Linux raid autodetect

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdc1               1         311     2490240  fd Linux raid autodetect
Partition 1 does not end on cylinder boundary
/dev/sdc2             311         572     2097152  fd Linux raid autodetect
Partition 2 does not end on cylinder boundary
/dev/sdc3             588      121601   972036912   f Win95 Ext'd (LBA)
/dev/sdc5             589       60801   483652864  fd Linux raid autodetect
/dev/sdc6           60802       77825   136737232  fd Linux raid autodetect
/dev/sdc7           77826      121601   351622672  fd Linux raid autodetect

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdd1               1         311     2490240  fd Linux raid autodetect
Partition 1 does not end on cylinder boundary
/dev/sdd2             311         572     2097152  fd Linux raid autodetect
Partition 2 does not end on cylinder boundary
/dev/sdd3             588      121601   972036912   f Win95 Ext'd (LBA)
/dev/sdd5             589       60801   483652864  fd Linux raid autodetect
/dev/sdd6           60802       77825   136737232  fd Linux raid autodetect
/dev/sdd7           77826      121601   351622672  fd Linux raid autodetect

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sde1               1         311     2490240  fd Linux raid autodetect
Partition 1 does not end on cylinder boundary
/dev/sde2             311         572     2097152  fd Linux raid autodetect
Partition 2 does not end on cylinder boundary
/dev/sde3             588      121601   972036912   f Win95 Ext'd (LBA)
/dev/sde5             589       60801   483652864  fd Linux raid autodetect
/dev/sde6           60802       77825   136737232  fd Linux raid autodetect
/dev/sde7           77826      121601   351622672  fd Linux raid autodetect

Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdf1               1         311     2490240  fd Linux raid autodetect
Partition 1 does not end on cylinder boundary
/dev/sdf2             311         572     2097152  fd Linux raid autodetect
Partition 2 does not end on cylinder boundary
/dev/sdf3             588      121601   972036912   f Win95 Ext'd (LBA)
/dev/sdf5             589       60801   483652864  fd Linux raid autodetect
/dev/sdf6           60802       77825   136737232  fd Linux raid autodetect
/dev/sdf7           77826      121601   351622672  fd Linux raid autodetect

Disk /dev/sdaf: 16 MB, 16515072 bytes
4 heads, 32 sectors/track, 252 cylinders
Units = cylinders of 128 * 512 = 65536 bytes

    Device Boot      Start         End      Blocks  Id System
/dev/sdaf1   *           1         252       16096+  e Win95 FAT16 (LBA)


// State after reboot :

Cube> cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md4 : active raid5 sdf7[0] sda7[5] sdc7[4] sde7[3] sdd7[1]
      1758107520 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]

md2 : active raid5 sda5[9] sdd5[6] sdf5[5] sdc5[8] sde5[7]
      2418258240 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/5] [_UUUUU]

md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[4] sde2[3] sdf2[5]
      2097088 blocks [12/6] [UUUUUU______]

md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[5] sdf1[4]
      2490176 blocks [12/6] [UUUUUU______]

unused devices: <none>

// I've added sdb5 to md2 and sdb7 to md4 :
mdadm --manage /dev/md2 --add /dev/sdb5
    mdadm: added /dev/sdb5

Cube> mdadm --manage /dev/md4 --add /dev/sdb7
    mdadm: added /dev/sdb7

// Then after rebuild :

Cube> cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md4 : active raid5 sdb7[6] sdf7[0] sda7[5] sdc7[4] sde7[3] sdd7[1]
      1758107520 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

md2 : active raid5 sdb5[10] sda5[9] sdd5[6] sdf5[5] sdc5[8] sde5[7]
      2418258240 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[4] sde2[3] sdf2[5]
      2097088 blocks [12/6] [UUUUUU______]

md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[5] sdf1[4]
      2490176 blocks [12/6] [UUUUUU______]

unused devices: <none>

//

Cube> mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Thu Jul 10 21:13:14 2014
     Raid Level : raid5
     Array Size : 2418258240 (2306.23 GiB 2476.30 GB)
  Used Dev Size : 483651648 (461.25 GiB 495.26 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Mon May  2 00:16:36 2016
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : cube:2
           UUID : 103009d5:68bcfd24:c017fe46:a505b66b
         Events : 36638

    Number   Major   Minor   RaidDevice State
      10       8       21        0      active sync   /dev/sdb5
       9       8        5        1      active sync   /dev/sda5
       7       8       69        2      active sync   /dev/sde5
       8       8       37        3      active sync   /dev/sdc5
       5       8       85        4      active sync   /dev/sdf5
       6       8       53        5      active sync   /dev/sdd5

//

Cube> mdadm -D /dev/md4
/dev/md4:
        Version : 1.2
  Creation Time : Sun Apr  5 11:43:39 2015
     Raid Level : raid5
     Array Size : 1758107520 (1676.66 GiB 1800.30 GB)
  Used Dev Size : 351621504 (335.33 GiB 360.06 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Mon May  2 04:07:05 2016
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : cube:4
           UUID : b0803ba8:eb54f644:84dc0b1f:b66dcc0f
         Events : 6823

    Number   Major   Minor   RaidDevice State
       0       8       87        0      active sync   /dev/sdf7
       1       8       55        1      active sync   /dev/sdd7
       3       8       71        2      active sync   /dev/sde7
       4       8       39        3      active sync   /dev/sdc7
       5       8        7        4      active sync   /dev/sda7
       6       8       23        5      active sync   /dev/sdb7

// Good... but volume was not ok... because md3 has disappeared (RAID
informations one day before the crash) :

Cube> cat /etc/space/space_history_20160429_002313.xml
<?xml version="1.0" encoding="UTF-8"?>
<spaces>
 <space path="/dev/vg1000/lv" reference="/volume1" >
 <device>
  <lvm path="/dev/vg1000"
uuid="5pSrIp-2W4j-LJUb-77OA-7g1h-Wdyz-pz83ku" designed_pv_counts="3"
status="normal" total_size="4476601630720" free_size="0"
pe_size="4194304">
   <raids>
    <raid path="/dev/md4" uuid="b0803ba8:eb54f644:84dc0b1f:b66dcc0f"
level="raid5" version="1.2">
     <disks>
      <disk status="normal" dev_path="/dev/sda7" model="Virtual SATA
Hard Drive " serial="00000000000000000001" partition_version="8"
slot="4">
      </disk>
      <disk status="normal" dev_path="/dev/sdb7" model="Virtual SATA
Hard Drive " serial="01000000000000000001" partition_version="8"
slot="5">
      </disk>
      <disk status="normal" dev_path="/dev/sdc7" model="Virtual SATA
Hard Drive " serial="02000000000000000001" partition_version="8"
slot="3">
      </disk>
      <disk status="normal" dev_path="/dev/sdd7" model="Virtual SATA
Hard Drive " serial="03000000000000000001" partition_version="7"
slot="1">
      </disk>
      <disk status="normal" dev_path="/dev/sde7" model="Virtual SATA
Hard Drive " serial="04000000000000000001" partition_version="8"
slot="2">
      </disk>
      <disk status="normal" dev_path="/dev/sdf7" model="Virtual SATA
Hard Drive " serial="05000000000000000001" partition_version="7"
slot="0">
      </disk>
     </disks>
    </raid>
    <raid path="/dev/md2" uuid="103009d5:68bcfd24:c017fe46:a505b66b"
level="raid5" version="1.2">
     <disks>
      <disk status="normal" dev_path="/dev/sda5" model="Virtual SATA
Hard Drive " serial="00000000000000000001" partition_version="8"
slot="1">
      </disk>
      <disk status="normal" dev_path="/dev/sdb5" model="Virtual SATA
Hard Drive " serial="01000000000000000001" partition_version="8"
slot="0">
      </disk>
      <disk status="normal" dev_path="/dev/sdc5" model="Virtual SATA
Hard Drive " serial="02000000000000000001" partition_version="8"
slot="3">
      </disk>
      <disk status="normal" dev_path="/dev/sdd5" model="Virtual SATA
Hard Drive " serial="03000000000000000001" partition_version="7"
slot="5">
      </disk>
      <disk status="normal" dev_path="/dev/sde5" model="Virtual SATA
Hard Drive " serial="04000000000000000001" partition_version="8"
slot="2">
      </disk>
      <disk status="normal" dev_path="/dev/sdf5" model="Virtual SATA
Hard Drive " serial="05000000000000000001" partition_version="7"
slot="4">
      </disk>
     </disks>
    </raid>
    <raid path="/dev/md3" uuid="bf5e3c59:d407890c:bb467cfa:f698458f"
level="raid5" version="1.2">
     <disks>
      <disk status="normal" dev_path="/dev/sda6" model="Virtual SATA
Hard Drive " serial="00000000000000000001" partition_version="8"
slot="4">
      </disk>
      <disk status="normal" dev_path="/dev/sdb6" model="Virtual SATA
Hard Drive " serial="01000000000000000001" partition_version="8"
slot="5">
      </disk>
      <disk status="normal" dev_path="/dev/sdc6" model="Virtual SATA
Hard Drive " serial="02000000000000000001" partition_version="8"
slot="1">
      </disk>
      <disk status="normal" dev_path="/dev/sdd6" model="Virtual SATA
Hard Drive " serial="03000000000000000001" partition_version="7"
slot="2">
      </disk>
      <disk status="normal" dev_path="/dev/sde6" model="Virtual SATA
Hard Drive " serial="04000000000000000001" partition_version="8"
slot="3">
      </disk>
      <disk status="normal" dev_path="/dev/sdf6" model="Virtual SATA
Hard Drive " serial="05000000000000000001" partition_version="7"
slot="0">
      </disk>
     </disks>
    </raid>
   </raids>
  </lvm>
 </device>
  <reference>
   <volumes>
    <volume path="/volume1" dev_path="/dev/vg1000/lv">
    </volume>
   </volumes>
  </reference>
 </space>
</spaces>

// So i've scanned sd[abcdef]6 :

Cube> mdadm -E /dev/sda6
/dev/sda6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : bf5e3c59:d407890c:bb467cfa:f698458f
           Name : cube:3
  Creation Time : Tue Jul 15 08:00:26 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 273472416 (130.40 GiB 140.02 GB)
     Array Size : 1367361280 (652.01 GiB 700.09 GB)
  Used Dev Size : 273472256 (130.40 GiB 140.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c7e8d7b9:26c766b7:71338730:ab9fbd18

  Reshape pos'n : 0
  Delta Devices : 1 (5->6)

    Update Time : Fri Apr 29 00:23:11 2016
       Checksum : 835fdf82 - correct
         Events : 3383

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing)


Cube> mdadm -E /dev/sdb6
/dev/sdb6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : bf5e3c59:d407890c:bb467cfa:f698458f
           Name : cube:3
  Creation Time : Tue Jul 15 08:00:26 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 273472416 (130.40 GiB 140.02 GB)
     Array Size : 1367361280 (652.01 GiB 700.09 GB)
  Used Dev Size : 273472256 (130.40 GiB 140.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3ca84eae:4f12ab74:e534b2de:a22df4af

  Reshape pos'n : 0
  Delta Devices : 1 (5->6)

    Update Time : Fri Apr 29 00:23:11 2016
       Checksum : 7a7c798d - correct
         Events : 3383

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing)


Cube> mdadm -E /dev/sdc6
/dev/sdc6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : bf5e3c59:d407890c:bb467cfa:f698458f
           Name : cube:3
  Creation Time : Tue Jul 15 08:00:26 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 273472416 (130.40 GiB 140.02 GB)
     Array Size : 1367361280 (652.01 GiB 700.09 GB)
  Used Dev Size : 273472256 (130.40 GiB 140.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f50b2511:20431fd3:39385708:da820eb2

  Reshape pos'n : 0
  Delta Devices : 1 (5->6)

    Update Time : Fri Apr 29 00:23:11 2016
       Checksum : 678666a0 - correct
         Events : 3383

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAAAA ('A' == active, '.' == missing)


Cube> mdadm -E /dev/sdd6
/dev/sdd6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : bf5e3c59:d407890c:bb467cfa:f698458f
           Name : cube:3
  Creation Time : Tue Jul 15 08:00:26 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 273472416 (130.40 GiB 140.02 GB)
     Array Size : 1367361280 (652.01 GiB 700.09 GB)
  Used Dev Size : 273472256 (130.40 GiB 140.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 920dbf7c:fdea401f:99537d57:45d6b816

  Reshape pos'n : 0
  Delta Devices : 1 (5->6)

    Update Time : Fri Apr 29 00:23:11 2016
       Checksum : d3127ee1 - correct
         Events : 3383

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAAAA ('A' == active, '.' == missing)



Cube> mdadm -E /dev/sde6
/dev/sde6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : bf5e3c59:d407890c:bb467cfa:f698458f
           Name : cube:3
  Creation Time : Tue Jul 15 08:00:26 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 273472416 (130.40 GiB 140.02 GB)
     Array Size : 1367361280 (652.01 GiB 700.09 GB)
  Used Dev Size : 273472256 (130.40 GiB 140.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 18c59328:dec7f04a:211a05a1:97d48710

  Reshape pos'n : 0
  Delta Devices : 1 (5->6)

    Update Time : Fri Apr 29 00:23:11 2016
       Checksum : ededd824 - correct
         Events : 3383

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAAAA ('A' == active, '.' == missing)



Cube> mdadm -E /dev/sdf6
/dev/sdf6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : bf5e3c59:d407890c:bb467cfa:f698458f
           Name : cube:3
  Creation Time : Tue Jul 15 08:00:26 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 273472416 (130.40 GiB 140.02 GB)
     Array Size : 1367361280 (652.01 GiB 700.09 GB)
  Used Dev Size : 273472256 (130.40 GiB 140.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1340d676:ebd4f963:c9f39dfb:40d7d9d4

  Reshape pos'n : 0
  Delta Devices : 1 (5->6)

    Update Time : Fri Apr 29 00:23:11 2016
       Checksum : 74243c7b - correct
         Events : 3383

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAAAA ('A' == active, '.' == missing)

// All look ok (State clean, Array State AAAAAA and same events number 3383)
// So i've tried to assemble the array :

Cube> mdadm --assemble --verbose /dev/md3 /dev/sda6 /dev/sdb6
/dev/sdc6 /dev/sdd6 /dev/sde6 /dev/sdf6
mdadm: looking for devices for /dev/md3
mdadm: /dev/sda6 is identified as a member of /dev/md3, slot 4.
mdadm: /dev/sdb6 is identified as a member of /dev/md3, slot 5.
mdadm: /dev/sdc6 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdd6 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sde6 is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sdf6 is identified as a member of /dev/md3, slot 0.
mdadm:/dev/md3 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on device-5
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file

// As i don't have any backup-file i've tried with "--invalid-backup"
but this option doesn't exist on Synology so i stop the NAS and mount
all 6 disk into a fresh Ubuntu install (virtualised too) :
// First interesting thing, "md3" is now visible (but inactive) :
// Because of the system disk, the 6 disks are now sd[bcdefg] insted
of sd[abcdef]

tks@Tks:~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md2 : active raid5 sdg5[5] sdf5[7] sdd5[8] sde5[6] sdc5[10] sdb5[9]
      2418258240 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

md3 : inactive sdf6[4](S) sdg6[0](S) sde6[2](S) sdd6[5](S) sdc6[7](S) sdb6[6](S)
      820417248 blocks super 1.2

md4 : active raid5 sdg7[0] sdf7[3] sde7[1] sdd7[4] sdc7[6] sdb7[5]
      1758107520 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

unused devices: <none>

tks@Tks:~$ sudo mdadm -D /dev/md3
/dev/md3:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 6
    Persistence : Superblock is persistent

          State : inactive

  Delta Devices : 1, (-1->0)
      New Level : raid5
     New Layout : left-symmetric
  New Chunksize : 64K

           Name : cube:3
           UUID : bf5e3c59:d407890c:bb467cfa:f698458f
         Events : 3383

    Number   Major   Minor   RaidDevice

       -       8       22        -        /dev/sdb6
       -       8       38        -        /dev/sdc6
       -       8       54        -        /dev/sdd6
       -       8       70        -        /dev/sde6
       -       8       86        -        /dev/sdf6
       -       8      102        -        /dev/sdg6

// I've tried to assemble the disks :

tks@Tks:~$ sudo mdadm --assemble --verbose --invalid-backup --force
/dev/md3 /dev/sdb6 /dev/sdc6 /dev/sdd6 /dev/sde6 /dev/sdf6 /dev/sdg6
mdadm: looking for devices for /dev/md3
mdadm: /dev/sdb6 is identified as a member of /dev/md3, slot 4.
mdadm: /dev/sdc6 is identified as a member of /dev/md3, slot 5.
mdadm: /dev/sdd6 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sde6 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sdf6 is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sdg6 is identified as a member of /dev/md3, slot 0.
mdadm: :/dev/md3 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on device-5
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/sdd6 to /dev/md3 as 1
mdadm: added /dev/sde6 to /dev/md3 as 2
mdadm: added /dev/sdf6 to /dev/md3 as 3
mdadm: added /dev/sdb6 to /dev/md3 as 4
mdadm: added /dev/sdc6 to /dev/md3 as 5
mdadm: added /dev/sdg6 to /dev/md3 as 0
mdadm: failed to RUN_ARRAY /dev/md3: Invalid argument

// and after lots of search, i found this error :

dmesg
 md/raid:md3: reshape_position too early for auto-recovery - aborting.
 md: pers->run() failed ...

// and i found some message of Phil Genera and Neil Brown about this
problem... but no solution for my case :(

I've tried to remove the last added disk to see but nothing more.

So, now, i need help because i'm a bit lost :-s i've seen that maybe
with "--create --assume-clean" and good options, it could works but
i'm not very confident... and i don't want to overwrite something.
I use mdadm v3.4 on Ubuntu 16.04x64.
The NAS :
   Synology DSM 5.1-5022
   Cube> uname -a
   Linux Cube 3.2.40 #1 SMP Tue Mar 3 23:34:55 CST 2015 x86_64
GNU/Linux synology_bromolow_3615xs
   mdadm 3.1.4

I hope that all information above will be useful for you to help me.

Thank you in advance for reading and if you have any ideas for restoring datas.

Laurent
