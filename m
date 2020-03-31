From: Daniel Jones <dj@iowni.com>
Subject: Requesting assistance recovering RAID-5 array
Date: Mon, 30 Mar 2020 18:04:45 -0600
Message-ID: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've ended up my array in an unpleasant condition and am unsure how to
best attempt recovery.  Any assistance from this list would be greatly
appreciated.

The short version: I have a 4 device RAID-5 array currently degraded
to 3 devices. The superblock is missing from 3 out of 4 drives. I've
also lost track of which device was originally /dev/sd[bcde] and doubt
they are in their original order.

How did I end up here?

1) Dec 2018: Created RAID-5 array on three HDDs on Centos7

2) Jul 2019: Added fourth HDD to array.

3) Mar 22 2020: One drive in array failed (originally /dev/sdb). **Due
to outgoing email issue I was not aware of this until (4a) below.**

4) Yesterday: Blissfully unaware of (3) did a planned upgrade of
Mobo/CPU/Boot-HDD in chassis. This went poorly as follows.

  a) After connecting the four drives to the new mobo I noted that
BIOS would not recognize the drive in bay #4.

  b) After booting into "new" system mdadm did not recognize the array.
     Shut down, replaced various SATA/power cables, at some point bay
#4 was recognized.
     Array still not recognized by mdadm.

  c) Put old Mobo/CPU/boot-HDD back into chassis to try to recover to
"last known good" state. Still using reconfigured SATA/power cables.
     The drive in bay #4 is still recognized.
     Due to all the part swapping I doubt the disks still match their
original sdb/sdc/sdd/sde mapping.

  d) After booting into "old" system mdadm does not recognize the array.

     ** Discover that the superblock appears overwritten on three out
of the four drives. **

     Find anecdotal reports online of superblock deletion when moving
arrays between motherboards:

       https://serverfault.com/questions/580761/is-mdadm-raid-toast
       https://forum.openmediavault.org/index.php?thread/11625-raid5-missin=
g-superblocks-after-restart/
(see comments by Nordmann)
       Note that Nordmann claims "Sometimes it occurs that one single
drive out of the array doesnt get affected"

  e) Give up for the day.

4) Today: Looked at things fresh today.

  a) Discovered the Mar-22 drive failure in /var/spool/mail/root.
Working assumption is that the bay #4 drive is one that was /dev/sdb
at the time of failure.
  b) Collected the information posted below.

So, here is my current situation as I see it.

  A four-disk RAID-5 array that degraded to three-disk a week ago with
the failure of what was then /dev/sdb.
  Due to the moving of cables I am no longer confident that
/dev/sd[bcde] are still what they once were.
  I suspect the orginal failed /dev/sdb is the bay #4 drive, not
completely sure.
  Three of the four disks have erased superblocks for unknown reasons.
  Doing a full 'dd' backup of the four disks is not feasible, but if I
can get them to assemble and mount one time I can copy off the data I
need.
  I think the best chance at data recovery is to do a --create to
replace the missing superblocks, but am unsure of the best way in
light of the degraded state of the array.

The only "good news" I have at this point is that I've done nothing at
this time to intentionally overwrite anything.

Information:

Here is the mdadm failure message from 3/22:

        Date: Sun, 22 Mar 2020 13:12:50 -0600 (MDT)This is an
automatically generated mail message from mdadm running on hulk
        A Fail event had been detected on md device /dev/md/0.
        It could be related to component device /dev/sdb.
        Faithfully yours, etc.
        P.S. The /proc/mdstat file currently contains the following:
        Personalities : [raid6] [raid5] [raid4]
        md0 : active raid5 sdd[3] sde[4] sdc[1] sdb[0](F)
              29298914304 blocks super 1.2 level 5, 512k chunk,
algorithm 2 [4/3] [_UUU]
              [=3D=3D=3D=3D=3D=3D=3D=3D>............]  check =3D 40.2%
(3927650944/9766304768) finish=3D1271.6min speed=3D76523K/sec
              bitmap: 0/73 pages [0KB], 65536KB chunk

Followed shortly by:

        Date: Sun, 22 Mar 2020 13:21:20 -0600 (MDT)
        This is an automatically generated mail message from mdadm
running on hulk
        A DegradedArray event had been detected on md device /dev/md/0.
        Faithfully yours, etc.
        P.S. The /proc/mdstat file currently contains the following:
        Personalities : [raid6] [raid5] [raid4]
        md0 : active raid5 sdc[1] sde[4] sdd[3]
              29298914304 blocks super 1.2 level 5, 512k chunk,
algorithm 2 [4/3] [_UUU]
              bitmap: 2/73 pages [8KB], 65536KB chunk


Actions today:

# cat /proc/mdstat
Personalities :
md0 : inactive sdc[1](S)
      9766306304 blocks super 1.2

unused devices: <none>


#  mdadm --stop /dev/md0
mdadm: stopped /dev/md0


# mdadm -E /dev/sd[bcde]
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 423d9a8e:636a5f08:56ecbd90:282e478b
           Name : hulk:0  (local to host hulk)
  Creation Time : Wed Dec 26 14:13:35 2018
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 19532612608 sectors (9313.88 GiB 10000.70 GB)
     Array Size : 29298914304 KiB (27941.62 GiB 30002.09 GB)
  Used Dev Size : 19532609536 sectors (9313.87 GiB 10000.70 GB)
    Data Offset : 261120 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D261040 sectors, after=3D3072 sectors
          State : clean
    Device UUID : 31fa9d90:a407908d:d4d7c7cc:e362b8a5

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Mar 29 15:43:14 2020
  Bad Block Log : 512 entries available at offset 48 sectors
       Checksum : d01e7462 - correct
         Events : 103087

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

# gdisk -l /dev/sdb
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdb: 19532873728 sectors, 9.1 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): A0CB08EC-4CA4-4A87-8848-5ED928708E84
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 19532873694
Partitions will be aligned on 2048-sector boundaries
Total free space is 19532873661 sectors (9.1 TiB)

Number  Start (sector)    End (sector)  Size       Code  Name

# gdisk -l /dev/sdc
GPT fdisk (gdisk) version 0.8.10

Caution: invalid backup GPT header, but valid main header; regenerating
backup header from main header.

Caution! After loading partitions, the CRC doesn't check out!
Warning! Main partition table CRC mismatch! Loaded backup partition table
instead of main partition table!

Warning! One or more CRCs don't match. You should repair the disk!

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

***************************************************************************=
*
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but dis=
k
verification and recovery are STRONGLY recommended.
***************************************************************************=
*
Disk /dev/sdc: 19532873728 sectors, 9.1 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): C41898B6-A81D-41B9-BE14-F2AB6D71D8EF
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 19532873694
Partitions will be aligned on 2048-sector boundaries
Total free space is 19532873661 sectors (9.1 TiB)

Number  Start (sector)    End (sector)  Size       Code  Name

# gdisk -l /dev/sdd
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdd: 19532873728 sectors, 9.1 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): A0CB08EC-4CA4-4A87-8848-5ED928708E84
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 19532873694
Partitions will be aligned on 2048-sector boundaries
Total free space is 19532873661 sectors (9.1 TiB)

Number  Start (sector)    End (sector)  Size       Code  Name

# gdisk -l /dev/sde
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sde: 19532873728 sectors, 9.1 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): FB0B481A-6258-4F61-BA60-6AAC8F663DA8
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 19532873694
Partitions will be aligned on 2048-sector boundaries
Total free space is 19532873661 sectors (9.1 TiB)

Number  Start (sector)    End (sector)  Size       Code  Name

# lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
NAME                   SIZE FSTYPE            TYPE MOUNTPOINT
sda                  238.5G                   disk
=E2=94=9C=E2=94=80sda1                 500M xfs               part /boot
=E2=94=94=E2=94=80sda2                 238G LVM2_member       part
  =E2=94=9C=E2=94=80centos_hulk-root    50G xfs               lvm  /
  =E2=94=9C=E2=94=80centos_hulk-swap     2G swap              lvm  [SWAP]
  =E2=94=94=E2=94=80centos_hulk-home 185.9G xfs               lvm  /home
sdb                    9.1T                   disk
sdc                    9.1T linux_raid_member disk
sdd                    9.1T                   disk
sde                    9.1T                   disk


# smartctl -H -i -l scterc /dev/sdb
smartctl 7.0 2018-12-30 r4883
[x86_64-linux-3.10.0-1062.18.1.el7.x86_64] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    *removed*
LU WWN Device Id: 5 000cca 26ccc09f6
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Mar 30 17:21:04 2020 MDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

# smartctl -H -i -l scterc /dev/sdc
smartctl 7.0 2018-12-30 r4883
[x86_64-linux-3.10.0-1062.18.1.el7.x86_64] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    *removed*
LU WWN Device Id: 5 000cca 273dd833e
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Mar 30 17:21:24 2020 MDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

# smartctl -H -i -l scterc /dev/sdd
smartctl 7.0 2018-12-30 r4883
[x86_64-linux-3.10.0-1062.18.1.el7.x86_64] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    *removed*
LU WWN Device Id: 5 000cca 273e1f716
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Mar 30 17:21:43 2020 MDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

# smartctl -H -i -l scterc /dev/sde
smartctl 7.0 2018-12-30 r4883
[x86_64-linux-3.10.0-1062.18.1.el7.x86_64] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    *removed*
LU WWN Device Id: 5 000cca 267d8594f
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Mar 30 17:21:58 2020 MDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


I am genuinely over my head at this point and unsure how to proceed.
My logic tells me the best choice is to attempt a --create to try to
rebuild the missing superblocks, but I'm not clear if I should try
devices=3D4 (the true size of the array) or devices=3D3 (the size it was
last operating in).  I'm also not sure of what device order to use
since I have likely scrambled /dev/sd[bcde] and am concerned about
what happens when I bring the previously disable drive back into the
array.

Can anybody provide any guidance?

Thanks,
DJ
