From: Alex Owen <alex@alexxx.co.uk>
Subject: Lost RAID6 disks when moving to new PC
Date: Wed, 27 Jul 2016 11:35:34 +0100
Message-ID: <CAFmAqNtzaWBhAkYoNEdyV0VMniEVt0Xv_4mOHoeTsCYbmecReg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

Thank you in advance for any help you might be able to give. I'm
another person with a broken RAID array and potentially lots of lost
data. I'm really stuck and would be very grateful for any help you
might be able to give.

Earlier I tried to move my mdadm array from a Ubuntu Server to a
virtualised Ubuntu Server running on an ESXi host.

I connected them and could see the disks in ESXi, then used
passthrough to get them to the Ubuntu Server instance, but this didn't
work and I could only see three of them.

Then I moved the disks back into the old server and booted it up,
where it failed to see the array on boot, and it still fails to
assemble it.

The array should be RAID6 on /dev/sd{a-f}.

I have backups of the most important 2TB, but there is a lot of data
for which this is the only copy (which I can afford to lose, but
hopefully won't have to).

I've tried:

mdadm --assemble --scan --verbose :

----------

mdadm: looking for devices for /dev/md0
mdadm: no RAID superblock on /dev/sdg1
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdf requires wrong number of drives.
mdadm: /dev/sde requires wrong number of drives.
mdadm: no RAID superblock on /dev/sdd2
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: no RAID superblock on /dev/sdb2
mdadm: no RAID superblock on /dev/sdb1
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sdc2
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sda requires wrong number of drives.

----------

Which gives this in /cat/mdstat:

----------

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
unused devices: <none>

----------

Occasionally it will assemble md0, but with three spares and no data.

fdisk -l :

----------

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 3000.6 GB, 3000592982016 bytes
5 heads, 3 sectors/track, 390702211 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048  4294967294  2147482623+  8e  Linux LVM

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdc: 3000.6 GB, 3000592982016 bytes
256 heads, 63 sectors/track, 363376 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x7b8883da

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1  4294967295  2147483647+  ee  GPT
Partition 1 does not start on physical sector boundary.

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 3000.6 GB, 3000592982016 bytes
256 heads, 63 sectors/track, 363376 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x7b8883db

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1  4294967295  2147483647+  ee  GPT
Partition 1 does not start on physical sector boundary.

WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdd: 3000.6 GB, 3000592982016 bytes
256 heads, 63 sectors/track, 363376 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x453c133d

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1  4294967295  2147483647+  ee  GPT
Partition 1 does not start on physical sector boundary.

WARNING: GPT (GUID Partition Table) detected on '/dev/sde'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sde: 3000.6 GB, 3000592982016 bytes
5 heads, 3 sectors/track, 390702211 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1            2048  4294967294  2147482623+  8e  Linux LVM

Disk /dev/sdf: 3000.6 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

Disk /dev/sdf doesn't contain a valid partition table

----------

parted -l

Warning: /dev/sda contains GPT signatures, indicating that it has a GPT table.
However, it does not have a valid fake msdos partition table, as it should.
Perhaps it was corrupted -- possibly by a program that doesn't understand GPT
partition tables.  Or perhaps you deleted the GPT table, and are now using an
msdos partition table.  Is this a GPT partition table?
Yes/No? n

Model: ATA WDC WD30EZRX-00D (scsi)
Disk /dev/sdb: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name                          Flags
 1      17.4kB  134MB   134MB                Microsoft reserved
partition  msftres
 2      135MB   3001GB  3000GB               Basic data partition
    msftdata


Model: ATA WDC WD30EZRX-00D (scsi)
Disk /dev/sdc: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name                          Flags
 1      17.4kB  134MB   134MB                Microsoft reserved
partition  msftres
 2      135MB   3001GB  3000GB               Basic data partition
    msftdata


Model: ATA WDC WD30EZRX-00M (scsi)
Disk /dev/sdd: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name                          Flags
 1      17.4kB  134MB   134MB                Microsoft reserved
partition  msftres
 2      135MB   3001GB  3000GB               Basic data partition
    msftdata


Warning: /dev/sde contains GPT signatures, indicating that it has a
GPT table.  However, it does not have a valid fake msdos partition
table, as it should.  Perhaps it was corrupted --
possibly by a program that doesn't understand GPT partition tables.
Or perhaps you deleted the GPT table, and are now using an msdos
partition table.  Is this a GPT partition table?
Yes/No? n

Error: /dev/sdf: unrecognised disk label

----------

And the output of mdadm --examine /dev/sd[a-f]

----------

/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : b377d975:86beb86c:9da9f21d:f73b2451
           Name : NAS:0  (local to host NAS)
  Creation Time : Sat Jan 23 17:57:37 2016
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 013740d6:5cc445e7:625f3257:8608daec

    Update Time : Tue Jul 26 04:09:29 2016
       Checksum : 14ba6ebd - correct
         Events : 2949004

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : b377d975:86beb86c:9da9f21d:f73b2451
           Name : NAS:0  (local to host NAS)
  Creation Time : Sat Jan 23 17:57:37 2016
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 19096ab0:3e3aac62:7afdfc97:86eeb5f6

    Update Time : Tue Jul 26 04:09:29 2016
       Checksum : b4f13acc - correct
         Events : 2949004

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : b377d975:86beb86c:9da9f21d:f73b2451
           Name : NAS:0  (local to host NAS)
  Creation Time : Sat Jan 23 17:57:37 2016
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : dc424c5a:b4845f55:373a04e0:78d96723

    Update Time : Tue Jul 26 04:09:29 2016
       Checksum : c63fe6b9 - correct
         Events : 2949004

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' == active, '.' == missing)

----------

Thank you
