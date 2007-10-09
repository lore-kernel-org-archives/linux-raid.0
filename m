From: Nagilum <nagilum@nagilum.org>
Subject: Help RAID5 reshape Oops / backup-file
Date: Tue, 09 Oct 2007 20:58:47 +0200
Message-ID: <20071009205847.92uypld0g0s000wo@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_48yyc9yd2c8w";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_48yyc9yd2c8w
Content-Type: multipart/mixed;
	boundary="=_2qweqab7fce8"
Content-Transfer-Encoding: 7bit

This message is in MIME format.

--=_2qweqab7fce8
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
During the process of reshaping a Raid5 from 3 (/dev/sd[a-c]) to 5
devices (/dev/sd[a-e]) the system was accidentally shut down.
I know I was stupid I should have used a --backup-file but stupid me didn't.
Thanks for not rubbing it any further. :(
Ok, here is what I have:

nas:~# uname -a
Linux nas 2.6.18-5-amd64 #1 SMP Thu Aug 30 01:14:54 UTC 2007 x86_64 GNU/Linu=
x
nas:~# mdadm --version
mdadm - v2.5.6 - 9 November 2006
nas:~# mdadm -Q --detail /dev/md0
/dev/md0:
          Version : 00.91.03
    Creation Time : Sat Sep 15 21:11:41 2007
       Raid Level : raid5
      Device Size : 488308672 (465.69 GiB 500.03 GB)
     Raid Devices : 5
    Total Devices : 5
Preferred Minor : 0
      Persistence : Superblock is persistent

      Update Time : Mon Oct  8 23:59:27 2007
            State : active, degraded, Not Started
   Active Devices : 3
Working Devices : 5
   Failed Devices : 0
    Spare Devices : 2

           Layout : left-symmetric
       Chunk Size : 16K

    Delta Devices : 2, (3->5)

             UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
           Events : 0.470134

      Number   Major   Minor   RaidDevice State
         0       8        0        0      active sync   /dev/sda
         1       8       16        1      active sync   /dev/sdb
         2       8       32        2      active sync   /dev/sdc
         3       0        0        3      removed
         4       0        0        4      removed

         5       8       48        -      spare   /dev/sdd
         6       8       64        -      spare   /dev/sde


nas:~# mdadm -E /dev/sd[a-e]
/dev/sda:
            Magic : a92b4efc
          Version : 00.91.00
             UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
    Creation Time : Sat Sep 15 21:11:41 2007
       Raid Level : raid5
      Device Size : 488308672 (465.69 GiB 500.03 GB)
       Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
     Raid Devices : 5
    Total Devices : 5
Preferred Minor : 0

    Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
    Delta Devices : 2 (3->5)

      Update Time : Mon Oct  8 23:59:27 2007
            State : clean
   Active Devices : 5
Working Devices : 5
   Failed Devices : 0
    Spare Devices : 0
         Checksum : f425054d - correct
           Events : 0.470134

           Layout : left-symmetric
       Chunk Size : 16K

        Number   Major   Minor   RaidDevice State
this     0       8        0        0      active sync   /dev/sda

     0     0       8        0        0      active sync   /dev/sda
     1     1       8       16        1      active sync   /dev/sdb
     2     2       8       32        2      active sync   /dev/sdc
     3     3       8       64        3      active sync   /dev/sde
     4     4       8       48        4      active sync   /dev/sdd
/dev/sdb:
            Magic : a92b4efc
          Version : 00.91.00
             UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
    Creation Time : Sat Sep 15 21:11:41 2007
       Raid Level : raid5
      Device Size : 488308672 (465.69 GiB 500.03 GB)
       Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
     Raid Devices : 5
    Total Devices : 5
Preferred Minor : 0

    Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
    Delta Devices : 2 (3->5)

      Update Time : Mon Oct  8 23:59:27 2007
            State : clean
   Active Devices : 5
Working Devices : 5
   Failed Devices : 0
    Spare Devices : 0
         Checksum : f425055f - correct
           Events : 0.470134

           Layout : left-symmetric
       Chunk Size : 16K

        Number   Major   Minor   RaidDevice State
this     1       8       16        1      active sync   /dev/sdb

     0     0       8        0        0      active sync   /dev/sda
     1     1       8       16        1      active sync   /dev/sdb
     2     2       8       32        2      active sync   /dev/sdc
     3     3       8       64        3      active sync   /dev/sde
     4     4       8       48        4      active sync   /dev/sdd
/dev/sdc:
            Magic : a92b4efc
          Version : 00.91.00
             UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
    Creation Time : Sat Sep 15 21:11:41 2007
       Raid Level : raid5
      Device Size : 488308672 (465.69 GiB 500.03 GB)
       Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
     Raid Devices : 5
    Total Devices : 5
Preferred Minor : 0

    Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
    Delta Devices : 2 (3->5)

      Update Time : Mon Oct  8 23:59:27 2007
            State : clean
   Active Devices : 5
Working Devices : 5
   Failed Devices : 0
    Spare Devices : 0
         Checksum : f4250571 - correct
           Events : 0.470134

           Layout : left-symmetric
       Chunk Size : 16K

        Number   Major   Minor   RaidDevice State
this     2       8       32        2      active sync   /dev/sdc

     0     0       8        0        0      active sync   /dev/sda
     1     1       8       16        1      active sync   /dev/sdb
     2     2       8       32        2      active sync   /dev/sdc
     3     3       8       64        3      active sync   /dev/sde
     4     4       8       48        4      active sync   /dev/sdd
/dev/sdd:
            Magic : a92b4efc
          Version : 00.91.00
             UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
    Creation Time : Sat Sep 15 21:11:41 2007
       Raid Level : raid5
      Device Size : 488308672 (465.69 GiB 500.03 GB)
       Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
     Raid Devices : 5
    Total Devices : 5
Preferred Minor : 0

    Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
    Delta Devices : 2 (3->5)

      Update Time : Mon Oct  8 23:59:27 2007
            State : clean
   Active Devices : 5
Working Devices : 5
   Failed Devices : 0
    Spare Devices : 0
         Checksum : f42505b9 - correct
           Events : 0.470134

           Layout : left-symmetric
       Chunk Size : 16K

        Number   Major   Minor   RaidDevice State
this     5       8       48       -1      spare   /dev/sdd

     0     0       8        0        0      active sync   /dev/sda
     1     1       8       16        1      active sync   /dev/sdb
     2     2       8       32        2      active sync   /dev/sdc
     3     3       8       64        3      active sync   /dev/sde
     4     4       8       48        4      active sync   /dev/sdd
/dev/sde:
            Magic : a92b4efc
          Version : 00.91.00
             UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
    Creation Time : Sat Sep 15 21:11:41 2007
       Raid Level : raid5
      Device Size : 488308672 (465.69 GiB 500.03 GB)
       Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
     Raid Devices : 5
    Total Devices : 5
Preferred Minor : 0

    Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
    Delta Devices : 2 (3->5)

      Update Time : Mon Oct  8 23:59:27 2007
            State : clean
   Active Devices : 5
Working Devices : 5
   Failed Devices : 0
    Spare Devices : 0
         Checksum : f42505db - correct
           Events : 0.470134

           Layout : left-symmetric
       Chunk Size : 16K

        Number   Major   Minor   RaidDevice State
this     6       8       64       -1      spare   /dev/sde

     0     0       8        0        0      active sync   /dev/sda
     1     1       8       16        1      active sync   /dev/sdb
     2     2       8       32        2      active sync   /dev/sdc
     3     3       8       64        3      active sync   /dev/sde
     4     4       8       48        4      active sync   /dev/sdd

nas:~# mdadm /dev/md0 -r /dev/sde
mdadm: hot remove failed for /dev/sde: No such device
nas:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : inactive sda[0] sdd[5](S) sde[6](S) sdc[2] sdb[1]
        2441543360 blocks super 0.91

unused devices: <none>

So reshaping was almost done.
The way I imagine how reshaping works you'd basically have an already
remapped area growing from the start of the drives (which grows during
remapping) and some not-yet-remapped-area which spans from the end of
the drives towards wherever remapping is currently reading data from.
At the beginning of the processing it equals the start of the drives
but it shrinks faster than the remapped area grows. So there is a
growing gap between the two areas which contains still original
unmapped data.
The point is, as soon as this area grows large enough the backup-file
should become unneeded.
Ok, now if mdadm wants me to provide that file I should also be able
to re-create it using the "Reshape pos'n" and the drive geometry (and
dd).
Now the question is how to do it?
I also have build mdadm-2.6.3 which appears to see things more clearly:

nas:~/mdadm-2.6.3# ./mdadm -A /dev/md0 /dev/sd[a-e]
mdadm: Failed to restore critical section for reshape, sorry.

So if I could create the backup file I should be able to continue..
Any help would be greatly appreciated!
Alexander.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D




----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..



----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_2qweqab7fce8
Content-Type: multipart/signed;
	boundary="=_6vrsz6cxvukg";
	protocol="application/pgp-signature";
	micalg="pgp-sha1";
	name=""
Content-Transfer-Encoding: 7bit

Received: from scorpio.tis (scorpio.tis [10.1.1.4]) by cakebox.homeunix.net
	(Horde MIME library) with HTTP; Tue, 09 Oct 2007 20:50:46 +0200
Message-ID: <20071009205046.637lfenu2sk84kw0@cakebox.homeunix.net>
X-Priority: 3 (Normal)
Date: Tue, 09 Oct 2007 20:50:46 +0200
From: Nagilum <nagilum@nagilum.org>
To: Majordomo@vger.kernel.org
Subject: Help RAID5 reshape Oops / backup-file
MIME-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_6vrsz6cxvukg";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit


--=_6vrsz6cxvukg
Content-Type: text/plain;
	charset=ISO-8859-2;
	delsp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
During the process of reshaping a Raid5 from 3 (/dev/sd[a-c]) to 5
devices (/dev/sd[a-e]) the system was accidentally shut down.
I know I was stupid I should have used a --backup-file but stupid me didn't.
Thanks for not rubbing it any further. :(
Ok, here is what I have:

nas:~# uname -a
Linux nas 2.6.18-5-amd64 #1 SMP Thu Aug 30 01:14:54 UTC 2007 x86_64 GNU/Linu=
x
nas:~# mdadm --version
mdadm - v2.5.6 - 9 November 2006
nas:~# mdadm -Q --detail /dev/md0
/dev/md0:
         Version : 00.91.03
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
     Device Size : 488308672 (465.69 GiB 500.03 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Oct  8 23:59:27 2007
           State : active, degraded, Not Started
  Active Devices : 3
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 16K

   Delta Devices : 2, (3->5)

            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
          Events : 0.470134

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       0        0        3      removed
        4       0        0        4      removed

        5       8       48        -      spare   /dev/sdd
        6       8       64        -      spare   /dev/sde


nas:~# mdadm -E /dev/sd[a-e]
/dev/sda:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
     Device Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

   Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
   Delta Devices : 2 (3->5)

     Update Time : Mon Oct  8 23:59:27 2007
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f425054d - correct
          Events : 0.470134

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     0       8        0        0      active sync   /dev/sda

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
    4     4       8       48        4      active sync   /dev/sdd
/dev/sdb:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
     Device Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

   Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
   Delta Devices : 2 (3->5)

     Update Time : Mon Oct  8 23:59:27 2007
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f425055f - correct
          Events : 0.470134

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     1       8       16        1      active sync   /dev/sdb

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
    4     4       8       48        4      active sync   /dev/sdd
/dev/sdc:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
     Device Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

   Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
   Delta Devices : 2 (3->5)

     Update Time : Mon Oct  8 23:59:27 2007
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f4250571 - correct
          Events : 0.470134

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     2       8       32        2      active sync   /dev/sdc

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
    4     4       8       48        4      active sync   /dev/sdd
/dev/sdd:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
     Device Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

   Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
   Delta Devices : 2 (3->5)

     Update Time : Mon Oct  8 23:59:27 2007
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f42505b9 - correct
          Events : 0.470134

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     5       8       48       -1      spare   /dev/sdd

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
    4     4       8       48        4      active sync   /dev/sdd
/dev/sde:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
     Device Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

   Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
   Delta Devices : 2 (3->5)

     Update Time : Mon Oct  8 23:59:27 2007
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f42505db - correct
          Events : 0.470134

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     6       8       64       -1      spare   /dev/sde

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
    4     4       8       48        4      active sync   /dev/sdd

nas:~# mdadm /dev/md0 -r /dev/sde
mdadm: hot remove failed for /dev/sde: No such device
nas:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : inactive sda[0] sdd[5](S) sde[6](S) sdc[2] sdb[1]
       2441543360 blocks super 0.91

unused devices: <none>

So reshaping was almost done.
The way I imagine how reshaping works you'd basically have an already =20
remapped area growing from the start of the drives (which grows during =20
remapping) and some not-yet-remapped-area which spans from the end of =20
the drives towards wherever remapping is currently reading data from. =20
At the beginning of the processing it equals the start of the drives =20
but it shrinks faster than the remapped area grows. So there is a =20
growing gap between the two areas which contains still original =20
unmapped data.
The point is, as soon as this area grows large enough the backup-file =20
should become unneeded.
Ok, now if mdadm wants me to provide that file I should also be able =20
to re-create it using the "Reshape pos'n" and the drive geometry (and =20
dd).
Now the question is how to do it?
I also have build mdadm-2.6.3 which appears to see things more clearly:

nas:~/mdadm-2.6.3# ./mdadm -A /dev/md0 /dev/sd[a-e]
mdadm: Failed to restore critical section for reshape, sorry.

So if I could create the backup file I should be able to continue..
Any help would be greatly appreciated!
Alexander.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D




----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_6vrsz6cxvukg
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHC82FAKWN2UY+sLwRAsqXAJ9thI9A41ny80V7ib2hqNd75fZyZgCgr1QD
eRcCHjV81wPv0pOd7/eguaQ=
=vYFv
-----END PGP SIGNATURE-----

--=_6vrsz6cxvukg--

--=_2qweqab7fce8--

--=_48yyc9yd2c8w
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHC89nAKWN2UY+sLwRAuTcAJ9UYrNH0d3SydvmAxnPSF9s/7g6HgCdEAPL
ZsbY8/bLCzLcpnsPNAkqDm8=
=sgv7
-----END PGP SIGNATURE-----

--=_48yyc9yd2c8w--
