From: Andreas Haumer <andreas@xss.co.at>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
     Linux
Date: Sun, 06 Jun 2004 18:30:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C346A6.1000001@xss.co.at>
References: <40498.194.60.85.4.1086343953.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40498.194.60.85.4.1086343953.squirrel@194.60.85.4>
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Robin Bowes wrote:
> On Fri, June 4, 2004 7:29, Neil Brown said:
>
>>  - Further support for partitionable arrays included "--auto=" option
>>    and "auto=" config file entry which instructs mdadm to create the necessary
>>    device files after allocating an unused array number.
>
>
> Neil,
>
> I am interpreting this to mean that I can create, for example, a large (e.g. 1TB) RAID5
> array and create smaller partitions (/home, /usr, etc) on top of the RAID5 array? Is
> this correct?
>
Hm.
Why would anyone use this, given that we can put LVM on
top of SW-RAID?

root@tolstoi:~ {593} $ vgdisplay -v
- --- Volume group ---
VG Name               sys
VG Access             read/write
VG Status             available/resizable
VG #                  0
MAX LV                256
Cur LV                8
Open LV               8
MAX LV Size           2 TB
Max PV                256
Cur PV                1
Act PV                1
VG Size               136.66 GB
PE Size               32 MB
Total PE              4373
Alloc PE / Size       4170 / 130.31 GB
Free  PE / Size       203 / 6.34 GB
VG UUID               4I7XyX-nuyy-gnJY-XciQ-hlu7-Yr03-r7eoD8

- --- Logical volume ---
LV Name                /dev/sys/swap1
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   1
# open                 1
LV Size                2 GB
Current LE             64
Allocated LE           64
Allocation             next free
Read ahead sectors     1024
Block device           58:0

- --- Logical volume ---
LV Name                /dev/sys/swap2
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   2
# open                 1
LV Size                2 GB
Current LE             64
Allocated LE           64
Allocation             next free
Read ahead sectors     1024
Block device           58:1

- --- Logical volume ---
LV Name                /dev/sys/root
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   3
# open                 1
LV Size                320 MB
Current LE             10
Allocated LE           10
Allocation             next free
Read ahead sectors     1024
Block device           58:2

- --- Logical volume ---
LV Name                /dev/sys/usr
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   4
# open                 1
LV Size                4 GB
Current LE             128
Allocated LE           128
Allocation             next free
Read ahead sectors     1024
Block device           58:3

- --- Logical volume ---
LV Name                /dev/sys/opt
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   5
# open                 1
LV Size                4 GB
Current LE             128
Allocated LE           128
Allocation             next free
Read ahead sectors     1024
Block device           58:4

- --- Logical volume ---
LV Name                /dev/sys/var
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   6
# open                 1
LV Size                4 GB
Current LE             128
Allocated LE           128
Allocation             next free
Read ahead sectors     1024
Block device           58:5

- --- Logical volume ---
LV Name                /dev/sys/tmp
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   7
# open                 1
LV Size                4 GB
Current LE             128
Allocated LE           128
Allocation             next free
Read ahead sectors     1024
Block device           58:6

- --- Logical volume ---
LV Name                /dev/sys/work
VG Name                sys
LV Write Access        read/write
LV Status              available
LV #                   8
# open                 1
LV Size                110 GB
Current LE             3520
Allocated LE           3520
Allocation             next free
Read ahead sectors     1024
Block device           58:7


- --- Physical volumes ---
PV Name (#)           /dev/md/0 (1)
PV Status             available / allocatable
Total PE / Free PE    4373 / 203

root@tolstoi:~ {595} $ mdadm --detail /dev/md/0
/dev/md/0:
        Version : 00.90.00
  Creation Time : Sun Feb 22 19:45:15 2004
     Raid Level : raid5
     Array Size : 143331712 (136.69 GiB 146.77 GB)
    Device Size : 71665856 (68.35 GiB 73.39 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun  3 16:52:42 2004
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/scsi/host0/bus0/target0/lun0/part2
       1       8       18        1      active sync   /dev/scsi/host0/bus0/target1/lun0/part2
       2       8       34        2      active sync   /dev/scsi/host0/bus0/target2/lun0/part2
           UUID : 7abbd703:643ffe8e:d6ae4d0e:1b0908aa
         Events : 0.42

root@tolstoi:~ {597} $ mount
rootfs on / type rootfs (ro)
/dev/sys/root on / type reiserfs (ro)
devfs on /dev type devfs (rw)
proc on /proc type proc (rw)
/dev/sys/usr on /usr type reiserfs (ro)
/dev/sys/opt on /opt type reiserfs (ro)
/dev/sys/var on /var type reiserfs (rw,noexec)
/dev/sys/tmp on /tmp type reiserfs (rw,noexec)
/dev/sys/work on /work type reiserfs (rw,noexec)
/dev/scsi/host0/bus0/target0/lun0/part1 on /boot type ext2 (ro)
tmpfs on /dev/shm type tmpfs (rw,noexec)


What are the advantages of a partitionable md device
compared to a SWRAID+LVM configuration?

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFAw0aWxJmyeGcXPhERAqc8AJwOJygJV6tL33Sswj5I7nKfm6IwWQCggoA4
A5GHH+GhDYHDqFBzCpm9ElA=
=q/Rp
-----END PGP SIGNATURE-----

