From: Niels Wassenberg <nielswassenberg@me.com>
Subject: replaced disk raid 5 array, after sync,
 missing file system and/or superblock
Date: Mon, 09 Dec 2013 19:51:12 +0100
Message-ID: <20698060-290F-46CF-821E-B9A9FC1C5C54@me.com>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: majordomo@vger.kernel.org
List-Id: linux-raid.ids

Dear sir/madam,

I recently replace a faulty disk on my soft raid array.
I used the following command to add the new disk.
sudo mdadm --add /dev/md127 /dev/sdd1
After this it started to sync. I watched the sync with:
watch cat /proc/mdstat

After the sync, everything looked fine, but after a reboot the array wo=
uldn=92t mount.

I also tried to create the array with 1 drive missing, suspecting that =
was the problem. Probably not a good idea with hindsight.
sudo mdadm --create /dev/md127 --assume-clean --metadata=3D1.2 --level=3D=
5 --raid-devices=3D4 --force missing /dev/sda1 /dev/sdb1 /dev/sdc1=20

Anyway i now have a borked array and of course no recent backup.

some more info:

Old information of array:

Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : f32c54e2:ad1715e3:57aacd78:5abb7d73
          Name : :Data RAID Array
 Creation Time : Sun May 15 11:40:22 2011
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
    Array Size : 5860529664 (5589.04 GiB 6001.18 GB)
 Used Dev Size : 3907019776 (1863.01 GiB 2000.39 GB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : 46d66cf7:8f3b010e:b03eff76:880d07cc

   Update Time : Sun Nov  3 01:42:07 2013
      Checksum : 3f664778 - correct
        Events : 65317

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : Active device 3
  Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)



nelis@xbmc:~$ sudo fdisk -l
[sudo] password for nelis:

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fd=
isk doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

  Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048  3907024064  1953511008+  83  Linux

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util fd=
isk doesn't support GPT. Use GNU Parted.


Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

  Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048  3907029167  1953513560   83  Linux

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util fd=
isk doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

  Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048  3907029167  1953513560   83  Linux

WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util fd=
isk doesn't support GPT. Use GNU Parted.


Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

  Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048  3907029167  1953513560   83  Linux


nelis@xbmc:~$ sudo mdadm --examine /dev/*

/dev/sda:
  MBR Magic : aa55
Partition[0] :   3907022017 sectors at         2048 (type 83)
/dev/sda1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : cff45973:0f987f54:cc11969e:86634cc5
          Name : xbmc:127  (local to host xbmc)
 Creation Time : Sun Dec  8 21:26:44 2013
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3906759873 (1862.89 GiB 2000.26 GB)
    Array Size : 5860137984 (5588.66 GiB 6000.78 GB)
 Used Dev Size : 3906758656 (1862.89 GiB 2000.26 GB)
   Data Offset : 262144 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : 04fc7be1:682b7bec:55e02536:d04b78c9

   Update Time : Mon Dec  9 18:07:03 2013
      Checksum : b3eae050 - correct
        Events : 6

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : Active device 1
  Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb:
  MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type 83)
/dev/sdb1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : cff45973:0f987f54:cc11969e:86634cc5
          Name : xbmc:127  (local to host xbmc)
 Creation Time : Sun Dec  8 21:26:44 2013
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
    Array Size : 5860137984 (5588.66 GiB 6000.78 GB)
 Used Dev Size : 3906758656 (1862.89 GiB 2000.26 GB)
   Data Offset : 262144 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : d9ce846f:84f7fa16:646aab04:b0aa8b72

   Update Time : Mon Dec  9 18:07:03 2013
      Checksum : e40c7c1e - correct
        Events : 6

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : Active device 2
  Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc:
  MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type 83)
/dev/sdc1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : cff45973:0f987f54:cc11969e:86634cc5
          Name : xbmc:127  (local to host xbmc)
 Creation Time : Sun Dec  8 21:26:44 2013
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
    Array Size : 5860137984 (5588.66 GiB 6000.78 GB)
 Used Dev Size : 3906758656 (1862.89 GiB 2000.26 GB)
   Data Offset : 262144 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : 50b0abb3:593fa051:ab69f466:b18e1ec6

   Update Time : Mon Dec  9 18:07:03 2013
      Checksum : 18b488b5 - correct
        Events : 6

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : Active device 3
  Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:
  MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type 83)
/dev/sdd1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : f32c54e2:ad1715e3:57aacd78:5abb7d73
          Name : :Data RAID Array
 Creation Time : Sun May 15 11:40:22 2011
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
    Array Size : 5860529664 (5589.04 GiB 6001.18 GB)
 Used Dev Size : 3907019776 (1863.01 GiB 2000.39 GB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : 46d66cf7:8f3b010e:b03eff76:880d07cc

   Update Time : Sun Nov  3 01:42:07 2013
      Checksum : 3f664778 - correct
        Events : 65317

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : Active device 3
  Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)

Notice the array names and dates changed.


With old faulty drive attached:
nelis@xbmc:~$ sudo mdadm --examine /dev/sd[abcde...]1 | egrep 'dev|Upda=
te|Role|State|Chunk size'
mdadm: only give one device per ARRAY line: /dev/md/Data and RAID
mdadm: only give one device per ARRAY line: /dev/md/Data and Array
mdadm: only give one device per ARRAY line: /dev/md/Data and RAID
mdadm: only give one device per ARRAY line: /dev/md/Data and Array
mdadm: No md superblock detected on /dev/sde1.
/dev/sda1:
         State : clean
   Update Time : Mon Dec  9 18:07:03 2013
  Device Role : Active device 1
  Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb1:
         State : clean
   Update Time : Mon Dec  9 18:07:03 2013
  Device Role : Active device 2
  Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc1:
         State : clean
   Update Time : Mon Dec  9 18:07:03 2013
  Device Role : Active device 3
  Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd1:
         State : clean
   Update Time : Sun Nov  3 01:42:07 2013
  Device Role : Active device 3
  Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)




Without faulty disk
sudo mdadm --detail /dev/md127
/dev/md127:
       Version : 1.2
 Creation Time : Sun Dec  8 21:26:44 2013
    Raid Level : raid5
    Array Size : 5860137984 (5588.66 GiB 6000.78 GB)
 Used Dev Size : 1953379328 (1862.89 GiB 2000.26 GB)
  Raid Devices : 4
 Total Devices : 3
   Persistence : Superblock is persistent

   Update Time : Sun Dec  8 22:01:24 2013
         State : clean, degraded=20
Active Devices : 3
Working Devices : 3
=46ailed Devices : 0
 Spare Devices : 0

        Layout : left-symmetric
    Chunk Size : 512K

          Name : xbmc:127  (local to host xbmc)
          UUID : cff45973:0f987f54:cc11969e:86634cc5
        Events : 2

   Number   Major   Minor   RaidDevice State
      0       0        0        0      removed
      1       8        1        1      active sync   /dev/sda1
      2       8       17        2      active sync   /dev/sdb1
      3       8       33        3      active sync   /dev/sdc1

trying to start array with faulty disk attached.
nelis@xbmc:~$ sudo mdadm --assemble --scan -fv
mdadm: looking for devices for further assembly
mdadm: Cannot assemble mbr metadata on /dev/sdf1
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: no recogniseable superblock on /dev/sde5
mdadm: Cannot assemble mbr metadata on /dev/sde2
mdadm: no recogniseable superblock on /dev/sde1
mdadm: Cannot assemble mbr metadata on /dev/sde
mdadm: no RAID superblock on /dev/sdd
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sdc
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdd1 is identified as a member of /dev/md/:Data RAID Array,=
 slot 3.
mdadm: no uptodate device for slot 0 of /dev/md/:Data RAID Array
mdadm: no uptodate device for slot 1 of /dev/md/:Data RAID Array
mdadm: no uptodate device for slot 2 of /dev/md/:Data RAID Array
mdadm: added /dev/sdd1 to /dev/md/:Data RAID Array as 3
mdadm: /dev/md/:Data RAID Array assembled from 1 drive - not enough to =
start the array.
mdadm: looking for devices for further assembly
mdadm: /dev/sdb1 is identified as a member of /dev/md/127, slot 2.
mdadm: /dev/sdc1 is identified as a member of /dev/md/127, slot 3.
mdadm: /dev/sda1 is identified as a member of /dev/md/127, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md/127
mdadm: added /dev/sdb1 to /dev/md/127 as 2
mdadm: added /dev/sdc1 to /dev/md/127 as 3
mdadm: added /dev/sda1 to /dev/md/127 as 1
mdadm: /dev/md/127 has been started with 3 drives (out of 4).
mdadm: looking for devices for further assembly
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/md127
mdadm: Cannot assemble mbr metadata on /dev/sdf1
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: no recogniseable superblock on /dev/sde5
mdadm: Cannot assemble mbr metadata on /dev/sde2
mdadm: no recogniseable superblock on /dev/sde1
mdadm: Cannot assemble mbr metadata on /dev/sde
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdb1 is busy - skipping
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdc1 is busy - skipping
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sda1 is busy - skipping
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdd1 is identified as a member of /dev/md/:Data RAID Array,=
 slot 3.
mdadm: no uptodate device for slot 0 of /dev/md/:Data RAID Array
mdadm: no uptodate device for slot 1 of /dev/md/:Data RAID Array
mdadm: no uptodate device for slot 2 of /dev/md/:Data RAID Array
mdadm: added /dev/sdd1 to /dev/md/:Data RAID Array as 3
mdadm: /dev/md/:Data RAID Array assembled from 1 drive - not enough to =
start the array.
mdadm: looking for devices for further assembly
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sda1 is busy - skipping

nelis@xbmc:~$ sudo mount -a
mount: wrong fs type, bad option, bad superblock on /dev/md127,
      missing codepage or helper program, or other error
      In some cases useful info is found in syslog - try
      dmesg | tail  or so
elis@xbmc:~$ dmesg|tail
[ 6002.310450]  disk 2, o:1, dev:sdb1
[ 6002.312343]  disk 3, o:1, dev:sdc1
[ 6002.314325] md127: detected capacity change from 0 to 6000781295616
[ 6002.712509]  md127: unknown partition table
[ 6003.000363] md: md126 stopped.
[ 6003.012062] md: bind<sdd1>
[ 6003.020399] md: md126 stopped.
[ 6003.024541] md: unbind<sdd1>
[ 6003.028528] md: export_rdev(sdd1)
[ 6077.995977] EXT4-fs (md127): VFS: Can't find ext4 filesystem

Missing filesystem, damn.

elis@xbmc:~$ sudo dumpe2fs /dev/sda
dumpe2fs 1.42.5 (29-Jul-2012)
dumpe2fs: Bad magic number in super-block while trying to open /dev/sda
Couldn't find valid filesystem superblock.
nelis@xbmc:~$ sudo dumpe2fs /dev/sda1
dumpe2fs 1.42.5 (29-Jul-2012)
dumpe2fs: Bad magic number in super-block while trying to open /dev/sda=
1
Couldn't find valid filesystem superblock.

nelis@xbmc:~$ sudo e2fsck /dev/md127
e2fsck 1.42.5 (29-Jul-2012)
ext2fs_open2: Bad magic number in super-block
e2fsck: Superblock invalid, trying backup blocks...
e2fsck: Bad magic number in super-block while trying to open /dev/md127

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
   e2fsck -b 8193 <device>

nelis@xbmc:~$ sudo e2fsck -b 8193 /dev/md127
e2fsck 1.42.5 (29-Jul-2012)
e2fsck: Bad magic number in super-block while trying to open /dev/md127

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
   e2fsck -b 8193 <device>


Should i try to reinstate the filesystem with test disk or something?

Could someone point me in the right direction please?

Kind regards,
Niels



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
