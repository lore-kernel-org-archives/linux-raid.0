From: Blair Sonnen <blair.sonnen@gmail.com>
Subject: Suggestions?: file copy to array grown by MDADM results in different md5sum value
Date: Wed, 7 Nov 2012 15:35:27 -0700
Message-ID: <8AD7F054-13FE-455E-8136-D6F91FF9CB3A@gmail.com>
References: <46B8C3E9-CD6C-41C0-9DC7-31A9D570F7A6@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_5240840E-56EF-4BFB-8E32-50F148C76F8C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46B8C3E9-CD6C-41C0-9DC7-31A9D570F7A6@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Apple-Mail=_5240840E-56EF-4BFB-8E32-50F148C76F8C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


Greetings.  I do not know where to inquire next for my issue and I would =
appreciate it if anyone could suggest something to potentially help =
regarding mdadm.  I have already submitted this bug report to mdadm on =
5/31, with no updates as of yet. =20

Please read my bug report and let me know if I should be considering =
this a potential XFS issue, or if I may have done something incorrectly =
in the process of using mdadm.  I have not tried with a different file =
system as of yet, I wanted to email the mailing list first to see if =
there are any suggestions.  I want to steer clear of anything I did =
wrong for future raid growing.  Thank you for any help you may lend and =
your time!

-Blair Sonnen
blair.sonnen@gmail.com



BUG REPORT


Bottom line: since growing my raid array, and switching raid levels =
using MDADM, I am unable to successfully copy a file to my array.  The =
resulting file always has different md5sum values from the original =
file, and is corrupted.=20

In addition to this, it appears that all files on my raid array have =
different md5sums after this procedure.

File System: XFS
mdadm --detail /dev/md127
=
--------------------------------------------------------------------------=
----------------------------------------------------------
/dev/md127:
        Version : 0.90
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : d861d754:1a1065fe:c230666b:5103eba0
         Events : 0.386680

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8      113        3      active sync   /dev/sdh1
       4       8       17        4      active sync   /dev/sdb1
       5       8       96        5      active sync   /dev/sdg
       6       8       80        6      active sync   /dev/sdf
       7       8       64        7      active sync   /dev/sde
=
--------------------------------------------------------------------------=
------------------------------------------------------------------

This raid re-arrangement was done the following way:

1) Started with 5 devices in raid 5 array, functioning correctly.=20
2) <Shutdown -h>
3) Installed 3 additional hard disks, all same manufacturer and size, =
however newer firmware. I verified the firmware was compatible via the =
manufacturers website.
4) Booted up, determined device names
5) successfully Added the drives to the array, by :<mdadm /dev/md127 =
--add /dev/sdg> etc. =20
6) successfully grew the array <mdadm --grow /dev/md127 -n 8 -l 6>, took =
a very long time as expected
7) successfully resized the file system <xfs_growfs -d /dev/md127>

Then, I started noticing problems with files on the array.  =
Specifically, the md5sums from the files on the raid array no longer =
matched the original md5sums from files copied to the array prior to the =
above commands.

I figured I would confirm the problem with the following test procedure:

1) mkdir Test_Files/
2) dd if=3D/dev/urandom bs=3D1024 count=3D5000000 of=3D5GB_Rand,
   dd if=3D/dev/zero bs=3D1024 count=3D5000000 of=3D5GB_Zero
3) md5sum test:

Original Test Files created on Boot Drive

blair@debian:~$ md5sum /home/blair/Test_Files/5GB_Rand=20
0fed0abb19ea7962830e54108631ddac  /home/blair/Test_Files/5GB_Rand

blair@debian:~$ md5sum /home/blair/Test_Files/5GB_Zero
20096e4b3b80a3896dec3d7fdf5d1bfc  /home/blair/Test_Files/5GB_Zero

4) Copied files to /dev/md127 raid array
5) md5sum test on copied files:

blair@debian:~$ md5sum /mnt/movies/Test_Files/5GB_Rand=20
419175a78977007f3d5e97dcaf414b61  /mnt/movies/Test_Files/5GB_Rand

blair@debian:~$ md5sum /mnt/movies/Test_Files/5GB_Zero
5846bed2b52532719d4812172a8078ce  /mnt/movies/Test_Files/5GB_Zero

6) Copied files from md/127 array back to Boot Drive
7) md5sum test:
blair@debian:~$ md5sum /home/blair/Test_Files/Test_Files_Copy/5GB_Rand=20=

419175a78977007f3d5e97dcaf414b61  =
/home/blair/Test_Files/Test_Files_Copy/5GB_Rand

blair@debian:~$ md5sum /home/blair/Test_Files/Test_Files_Copy/5GB_Zero
5846bed2b52532719d4812172a8078ce  =
/home/blair/Test_Files/Test_Files_Copy/5GB_Zero


I am not sure what I have done in the process that would have created =
this problem.  I am filing this bug report to mdadm because I have =
successfully grown my raid in the past, using mdadm with the XFS =
filesystem. In that instance it was from 4 devices to 5 devices, both on =
raid 5 (no level switch), and growing the xfs filesystem accordingly.  =
These file problems started as soon as I executed the recent grow to 8 =
devices and level 6 as indicated above. =20

In order to install three extra drives, I installed an internal Sata =
host adapter (SYBA SY-PEX40008 PCI Express SATA II), as my board only =
had 6 Sata ports integrated.  Not sure this is relevant.  I used this =
exact adapter in another RAID installation (R6 w/ 8 dev) with no =
problems so I did not hesitate to use it again.  In addition, the file =
corruption (for lack of a better term) only works one way, when copying =
TO the RAID, not the other way around.=20

Thank you for taking the time to read this and suggest any =
troubleshooting steps/actions.  A text file of the bug report with =
further system details is attached.


--Apple-Mail=_5240840E-56EF-4BFB-8E32-50F148C76F8C
Content-Disposition: attachment;
	filename=Debian_reportbug_PCS.txt
Content-Type: text/plain;
	name="Debian_reportbug_PCS.txt"
Content-Transfer-Encoding: quoted-printable

Debian Bug report logs - #675394
mdadm: Each file copy to array grown by MDADM results in copies with =
different md5sum values


Package: mdadm; Maintainer for mdadm is Debian mdadm maintainers =
<pkg-mdadm-devel@lists.alioth.debian.org>; Source for mdadm is =
src:mdadm.
Reported by: Blair Sonnen <blair.sonnen@gmail.com>
Date: Thu, 31 May 2012 19:54:02 UTC
Severity: normal
Found in version mdadm/3.1.4-1+8efb9d1+squeeze1
Reply or subscribe to this bug.

Toggle useless messages

View this report as an mbox folder, status mbox, maintainer mbox

Message #5 received at submit@bugs.debian.org (full text, mbox):

From: Blair Sonnen <blair.sonnen@gmail.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: mdadm: Each file copy to array grown by MDADM results in copies =
with
 different md5sum values
Date: Thu, 31 May 2012 15:53:17 -0400
Package: mdadm
Version: 3.1.4-1+8efb9d1+squeeze1
Severity: normal


Bottom line: since growing my raid array, and switching raid levels =
using
MDADM, I am unable to successfully copy a file to my array.  The =
resulting file
always has different md5sum values from the original file, and is =
corrupted.

In addition to this, it appears that all files on my raid array have =
different
md5sums after this procedure.

File System: XFS
mdadm --detail /dev/md127
=
--------------------------------------------------------------------------=
----------------------------------------------------------
/dev/md127:
        Version : 0.90
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : d861d754:1a1065fe:c230666b:5103eba0
         Events : 0.386680

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8      113        3      active sync   /dev/sdh1
       4       8       17        4      active sync   /dev/sdb1
       5       8       96        5      active sync   /dev/sdg
       6       8       80        6      active sync   /dev/sdf
       7       8       64        7      active sync   /dev/sde
=
--------------------------------------------------------------------------=
------------------------------------------------------------------

This raid re-arrangement was done the following way:

1) Started with 5 devices in raid 5 array, functioning correctly.
2) <Shutdown -h>
3) Installed 3 additional hard disks, all same manufacturer and size, =
however
newer firmware. I verified the firmware was compatible via the =
manufacturers
website.
4) Booted up, determined device names
5) successfully Added the drives to the array, by :<mdadm /dev/md127 =
--add
/dev/sdg> etc.
6) successfully grew the array <mdadm --grow /dev/md127 -n 8 -l 6>, took =
a very
long time as expected
7) successfully resized the file system <xfs_growfs -d /dev/md127>

Then, I started noticing problems with files on the array.  No need to =
get into
them specifically.

Regarding the source of the problems, the md5sums from the files on the =
raid
array no longer matched the original md5sums from files copied to the =
array
prior to the above commands.

I figured I would confirm the problem with the following test procedure:

1) mkdir Test_Files/
2) dd if=3D/dev/urandom bs=3D1024 count=3D5000000 of=3D5GB_Rand,
   dd if=3D/dev/zero bs=3D1024 count=3D5000000 of=3D5GB_Zero
3) md5sum test:

Original Test Files created on Boot Drive

blair@debian:~$ md5sum /home/blair/Test_Files/5GB_Rand=C3=82=20
0fed0abb19ea7962830e54108631ddac =C3=82 /home/blair/Test_Files/5GB_Rand

blair@debian:~$ md5sum /home/blair/Test_Files/5GB_Zero
20096e4b3b80a3896dec3d7fdf5d1bfc =C3=82 /home/blair/Test_Files/5GB_Zero

4) Copied files to /dev/md127 raid array
5) md5sum test on copied files:

blair@debian:~$ md5sum /mnt/movies/Test_Files/5GB_Rand=C3=82=20
419175a78977007f3d5e97dcaf414b61 =C3=82 /mnt/movies/Test_Files/5GB_Rand

blair@debian:~$ md5sum /mnt/movies/Test_Files/5GB_Zero
5846bed2b52532719d4812172a8078ce =C3=82 /mnt/movies/Test_Files/5GB_Zero

6) Copied files from md/127 array back to Boot Drive
7) md5sum test:

blair@debian:~$ md5sum /home/blair/Test_Files/Test_Files_Copy/5GB_Rand=C3=82=
=20
419175a78977007f3d5e97dcaf414b61
=C3=82 /home/blair/Test_Files/Test_Files_Copy/5GB_Rand

blair@debian:~$ md5sum /home/blair/Test_Files/Test_Files_Copy/5GB_Zero
5846bed2b52532719d4812172a8078ce
=C3=82 /home/blair/Test_Files/Test_Files_Copy/5GB_Zero


I am not sure what I have done in the process that would have created =
this
problem.  I am filing this bug report to mdadm because I have =
successfully
grown my raid in the past, using mdadm. In that instance it was from 4 =
devices
to 5 devices, both on raid 5 (no level switch), and growing the xfs =
filesystem
accordingly.  These file problems started as soon as I executed the =
recent grow
to 8 devices and level 6 as indicated above.  In addition, it is worth
mentioning that to install the additional drives in my array for it's =
current
configuration, I have installed a SATA host adapter (SYBA SY-PEX40008 =
PCI
Express SATA II).  This was needed because my M/b only has 6 sata ports =
on
board.  I specifically chose that hardware due to a friend successfully =
running
a similar set up with Raid 6, 8 devices, and that SYBA adapter.












-- Package-specific info:
--- mdadm.conf
DEVICE partitions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
HOMEHOST <system>
MAILADDR root

--- /etc/default/mdadm
INITRDSTART=3D'all'
AUTOSTART=3Dtrue
AUTOCHECK=3Dtrue
START_DAEMON=3Dtrue
DAEMON_OPTIONS=3D"--syslog"
VERBOSE=3Dfalse

--- /proc/mdstat:
Personalities : [raid6] [raid5] [raid4]=20
md127 : active (auto-read-only) raid6 sdi1[0] sde[7] sdf[6] sdg[5] =
sdb1[4] sdh1[3] sdd1[2] sdc1[1]
      8790815616 blocks level 6, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]
     =20
unused devices: <none>

--- /proc/partitions:
major minor  #blocks  name

   8        0   78150744 sda
   8        1     995998 sda1
   8        2   77154626 sda2
   8       16 1465138584 sdb
   8       17 1465136001 sdb1
   8       32 1465138584 sdc
   8       33 1465136001 sdc1
   8       48 1465138584 sdd
   8       49 1465136001 sdd1
   8       64 1465138584 sde
   8       80 1465138584 sdf
   8       96 1465138584 sdg
   8      112 1465138584 sdh
   8      113 1465136001 sdh1
   8      128 1465138584 sdi
   8      129 1465136001 sdi1
   9      127 8790815616 md127

--- LVM physical volumes:
LVM does not seem to be used.
--- mount output
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=3D0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=3D0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=3D5,mode=3D620)
rootfs on / type rootfs (rw)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc =
(rw,noexec,nosuid,nodev)
nfsd on /proc/fs/nfsd type nfsd (rw)

--- initrd.img-2.6.32-5-486:
43166 blocks
cde2eead1adb1d2a7b553e58a32b349b  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/raid6_pq.ko
652959e384d9f3b453bb2679744e8d31  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/raid10.ko
ff4818ff6bfab791a6d0a9a1173766ad  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/raid0.ko
9a9b55e75344433ed9b6252c7d1d6290  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/raid1.ko
2eb77cd53f0054b7e8975df6e33c4183  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/md-mod.ko
5dfba6c670ae84e9bb9b28025e96502a  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/dm-mod.ko
89770d89c5d6188b32dc3025da281e1f  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/multipath.ko
b6e7d734c092c5ea3604bf8c8b11f5f9  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/raid456.ko
1fe0c6d8380ca23dd0ffe4d140681b35  =
./lib/modules/2.6.32-5-486/kernel/drivers/md/linear.ko
131215a85bfd126336cd7469ecd95b9f  ./etc/mdadm/mdadm.conf
f4fbd9099399ab08ba9b9f6c71d77595  ./scripts/local-top/mdadm
3bb9b360390f261c11e3e2b9f1880dc8  ./sbin/mdadm

--- initrd's /conf/conf.d/md:
MD_HOMEHOST=3D'debian'
MD_DEVPAIRS=3D'/dev/md127:raid6'
MD_LEVELS=3D'raid6'
MD_DEVS=3Dall
MD_MODULES=3D'raid456'

--- /proc/modules:
raid456 40393 1 - Live 0xf83dc000
md_mod 66091 1 raid456, Live 0xf83b1000
async_raid6_recov 4062 1 raid456, Live 0xf838f000
async_pq 2575 2 raid456,async_raid6_recov, Live 0xf8384000
raid6_pq 77468 2 async_raid6_recov,async_pq, Live 0xf8368000
async_xor 1906 3 raid456,async_raid6_recov,async_pq, Live 0xf834c000
async_memcpy 846 2 raid456,async_raid6_recov, Live 0xf8332000
async_tx 1278 5 =
raid456,async_raid6_recov,async_pq,async_xor,async_memcpy, Live =
0xf8329000

--- /var/log/syslog:

--- volume detail:
/dev/sda is not recognised by mdadm.
/dev/sda1 is not recognised by mdadm.
/dev/sda2 is not recognised by mdadm.
/dev/sdb is not recognised by mdadm.
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f57687c - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--
/dev/sdc is not recognised by mdadm.
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f576886 - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--
/dev/sdd is not recognised by mdadm.
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f576898 - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       97        2      active sync

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--
/dev/sde:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f576841 - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8        0        7      active sync   /dev/sda

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--
/dev/sdf:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f57684f - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       16        6      active sync   /dev/sdb

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--
/dev/sdg:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f57685d - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       32        5      active sync   /dev/sdc

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--
/dev/sdh is not recognised by mdadm.
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f576835 - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       3        1        3      active sync

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--
/dev/sdi is not recognised by mdadm.
/dev/sdi1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d861d754:1a1065fe:c230666b:5103eba0
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9f57686f - correct
         Events : 386680

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       3       65        0      active sync

   0     0       3       65        0      active sync
   1     1       8       81        1      active sync
   2     2       8       97        2      active sync
   3     3       3        1        3      active sync
   4     4       8       65        4      active sync
   5     5       8       32        5      active sync   /dev/sdc
   6     6       8       16        6      active sync   /dev/sdb
   7     7       8        0        7      active sync   /dev/sda
--

--- /proc/cmdline
BOOT_IMAGE=3D/boot/vmlinuz-2.6.32-5-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro quiet

--- grub2:
set root=3D'(/dev/sda,msdos2)'
set root=3D'(/dev/sda,msdos2)'
set root=3D'(/dev/sda,msdos2)'
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.32-5-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro  quiet
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.32-5-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro single=20
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.32-3-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro  quiet
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.32-3-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro single=20
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.32-trunk-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro  quiet
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.32-trunk-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro single=20
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.26-2-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro  quiet
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.26-2-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro single=20
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.18-6-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro  quiet
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.18-6-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro single=20
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.18-5-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro  quiet
	set root=3D'(/dev/sda,msdos2)'
	linux	/boot/vmlinuz-2.6.18-5-486 =
root=3DUUID=3D596fda6f-bd70-4c31-8752-42afec929eab ro single=20

--- grub legacy:
kernel		/boot/vmlinuz-2.6.32-trunk-486 =
root=3DUUID=3D"596fda6f-bd70-4c31-8752-42afec929eab ro=20
kernel		/boot/vmlinuz-2.6.32-trunk-486 root=3D/dev/hda2 ro =
single
kernel		/boot/vmlinuz-2.6.26-2-486 root=3D/dev/hda2 ro=20
kernel		/boot/vmlinuz-2.6.26-2-486 root=3D/dev/hda2 ro single
kernel		/boot/vmlinuz-2.6.18-6-486 root=3D/dev/hda2 ro=20
kernel		/boot/vmlinuz-2.6.18-6-486 root=3D/dev/hda2 ro single
kernel		/boot/vmlinuz-2.6.18-5-486 root=3D/dev/hda2 ro=20
kernel		/boot/vmlinuz-2.6.18-5-486 root=3D/dev/hda2 ro single

--- udev:
ii  udev           164-3          /dev/ and hotplug management daemon
4a574fcd059040d33ea18a8aa605a184  /lib/udev/rules.d/64-md-raid.rules

--- /dev:
brw-rw---- 1 root disk 9, 127 May 22 23:38 /dev/md127

/dev/disk/by-id:
total 0
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS04X49 -> =
../../sdd
lrwxrwxrwx 1 root root 10 May 22 23:38 ata-ST31500341AS_9VS04X49-part1 =
-> ../../sdd1
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS0E33Q -> =
../../sdc
lrwxrwxrwx 1 root root 10 May 22 23:38 ata-ST31500341AS_9VS0E33Q-part1 =
-> ../../sdc1
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS0FTMY -> =
../../sdh
lrwxrwxrwx 1 root root 10 May 22 23:38 ata-ST31500341AS_9VS0FTMY-part1 =
-> ../../sdh1
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS0GJHT -> =
../../sdi
lrwxrwxrwx 1 root root 10 May 22 23:38 ata-ST31500341AS_9VS0GJHT-part1 =
-> ../../sdi1
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS42W38 -> =
../../sdb
lrwxrwxrwx 1 root root 10 May 22 23:38 ata-ST31500341AS_9VS42W38-part1 =
-> ../../sdb1
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS4M87N -> =
../../sdg
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS4MM5K -> =
../../sdf
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST31500341AS_9VS4NDHW -> =
../../sde
lrwxrwxrwx 1 root root  9 May 22 23:38 ata-ST380013AS_5JV9KQLK -> =
../../sda
lrwxrwxrwx 1 root root 10 May 22 23:38 ata-ST380013AS_5JV9KQLK-part1 -> =
../../sda1
lrwxrwxrwx 1 root root 10 May 22 23:38 ata-ST380013AS_5JV9KQLK-part2 -> =
../../sda2
lrwxrwxrwx 1 root root 11 May 22 23:38 =
md-uuid-d861d754:1a1065fe:c230666b:5103eba0 -> ../../md127
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS04X49 =
-> ../../sdd
lrwxrwxrwx 1 root root 10 May 22 23:38 =
scsi-SATA_ST31500341AS_9VS04X49-part1 -> ../../sdd1
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS0E33Q =
-> ../../sdc
lrwxrwxrwx 1 root root 10 May 22 23:38 =
scsi-SATA_ST31500341AS_9VS0E33Q-part1 -> ../../sdc1
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS0FTMY =
-> ../../sdh
lrwxrwxrwx 1 root root 10 May 22 23:38 =
scsi-SATA_ST31500341AS_9VS0FTMY-part1 -> ../../sdh1
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS0GJHT =
-> ../../sdi
lrwxrwxrwx 1 root root 10 May 22 23:38 =
scsi-SATA_ST31500341AS_9VS0GJHT-part1 -> ../../sdi1
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS42W38 =
-> ../../sdb
lrwxrwxrwx 1 root root 10 May 22 23:38 =
scsi-SATA_ST31500341AS_9VS42W38-part1 -> ../../sdb1
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS4M87N =
-> ../../sdg
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS4MM5K =
-> ../../sdf
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST31500341AS_9VS4NDHW =
-> ../../sde
lrwxrwxrwx 1 root root  9 May 22 23:38 scsi-SATA_ST380013AS_5JV9KQLK -> =
../../sda
lrwxrwxrwx 1 root root 10 May 22 23:38 =
scsi-SATA_ST380013AS_5JV9KQLK-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 May 22 23:38 =
scsi-SATA_ST380013AS_5JV9KQLK-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c5000dd12e84 -> =
../../sdd
lrwxrwxrwx 1 root root 10 May 22 23:38 wwn-0x5000c5000dd12e84-part1 -> =
../../sdd1
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c5001069e9ee -> =
../../sdc
lrwxrwxrwx 1 root root 10 May 22 23:38 wwn-0x5000c5001069e9ee-part1 -> =
../../sdc1
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c500107888c7 -> =
../../sdi
lrwxrwxrwx 1 root root 10 May 22 23:38 wwn-0x5000c500107888c7-part1 -> =
../../sdi1
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c50010791e72 -> =
../../sdh
lrwxrwxrwx 1 root root 10 May 22 23:38 wwn-0x5000c50010791e72-part1 -> =
../../sdh1
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c500208be7f5 -> =
../../sdb
lrwxrwxrwx 1 root root 10 May 22 23:38 wwn-0x5000c500208be7f5-part1 -> =
../../sdb1
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c5002cc50273 -> =
../../sdg
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c5002cd61f65 -> =
../../sdf
lrwxrwxrwx 1 root root  9 May 22 23:38 wwn-0x5000c5002cd99289 -> =
../../sde

/dev/disk/by-label:
total 0
lrwxrwxrwx 1 root root 10 May 22 23:38 root -> ../../sda2

/dev/disk/by-path:
total 0
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:00:11.0-scsi-0:0:0:0 -> =
../../sda
lrwxrwxrwx 1 root root 10 May 22 23:38 =
pci-0000:00:11.0-scsi-0:0:0:0-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 May 22 23:38 =
pci-0000:00:11.0-scsi-0:0:0:0-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:00:11.0-scsi-1:0:0:0 -> =
../../sdb
lrwxrwxrwx 1 root root 10 May 22 23:38 =
pci-0000:00:11.0-scsi-1:0:0:0-part1 -> ../../sdb1
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:00:11.0-scsi-2:0:0:0 -> =
../../sdc
lrwxrwxrwx 1 root root 10 May 22 23:38 =
pci-0000:00:11.0-scsi-2:0:0:0-part1 -> ../../sdc1
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:00:11.0-scsi-3:0:0:0 -> =
../../sdd
lrwxrwxrwx 1 root root 10 May 22 23:38 =
pci-0000:00:11.0-scsi-3:0:0:0-part1 -> ../../sdd1
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:00:14.1-scsi-0:0:0:0 -> =
../../sdh
lrwxrwxrwx 1 root root 10 May 22 23:38 =
pci-0000:00:14.1-scsi-0:0:0:0-part1 -> ../../sdh1
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:00:14.1-scsi-0:0:1:0 -> =
../../sdi
lrwxrwxrwx 1 root root 10 May 22 23:38 =
pci-0000:00:14.1-scsi-0:0:1:0-part1 -> ../../sdi1
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:04:04.0-scsi-0:0:0:0 -> =
../../sde
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:04:04.0-scsi-2:0:0:0 -> =
../../sdf
lrwxrwxrwx 1 root root  9 May 22 23:38 pci-0000:04:04.0-scsi-3:0:0:0 -> =
../../sdg

/dev/disk/by-uuid:
total 0
lrwxrwxrwx 1 root root 10 May 22 23:38 =
596fda6f-bd70-4c31-8752-42afec929eab -> ../../sda2
lrwxrwxrwx 1 root root 10 May 22 23:38 =
9c436947-cffd-4096-aa08-4ef38ca6be71 -> ../../sda1
lrwxrwxrwx 1 root root 11 May 22 23:38 =
d47152d5-4d59-4782-a530-ad57146fc9df -> ../../md127

/dev/md:
total 0

Auto-generated on Thu, 24 May 2012 23:31:26 -0400
by mdadm bugscript 3.1.4-1+8efb9d1+squeeze1

-- System Information:
Debian Release: 6.0.5
  APT prefers stable
  APT policy: (500, 'stable')
Architecture: i386 (i686)

Kernel: Linux 2.6.32-5-486
Locale: LANG=3Den_US.UTF-8, LC_CTYPE=3Den_US.UTF-8 (charmap=3DUTF-8)
Shell: /bin/sh linked to /bin/dash

Versions of packages mdadm depends on:
ii  debconf                 1.5.36.1         Debian configuration =
management sy
ii  libc6                   2.11.3-3         Embedded GNU C Library: =
Shared lib
ii  lsb-base                3.2-23.2squeeze1 Linux Standard Base 3.2 =
init scrip
ii  makedev                 2.3.1-89         creates device files in =
/dev
ii  udev                    164-3            /dev/ and hotplug =
management daemo

Versions of packages mdadm recommends:
ii  exim4-daemon-light [mail 4.72-6+squeeze2 lightweight Exim MTA (v4) =
daemon
ii  module-init-tools        3.12-2+b1       tools for managing Linux =
kernel mo

mdadm suggests no packages.

-- debconf information:
* mdadm/autostart: true
* mdadm/mail_to: root
  mdadm/initrdstart_msg_errmd:
* mdadm/initrdstart: all
  mdadm/initrdstart_msg_errconf:
  mdadm/initrdstart_notinconf: false
  mdadm/initrdstart_msg_errexist:
  mdadm/initrdstart_msg_intro:
* mdadm/autocheck: true
  mdadm/initrdstart_msg_errblock:
* mdadm/start_daemon: true



Send a report that this bug log contains spam.

Debian bug tracking system administrator <owner@bugs.debian.org>. Last =
modified: Wed Nov 7 22:24:51 2012; Machine Name: beach.debian.org
Debian Bug tracking system
Copyright (C) 1999 Darren O. Benham, 1997,2003 nCipher Corporation Ltd, =
1994-97 Ian Jackson.=

--Apple-Mail=_5240840E-56EF-4BFB-8E32-50F148C76F8C
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii








 






--Apple-Mail=_5240840E-56EF-4BFB-8E32-50F148C76F8C--
