From: "crowston.name" <kevin@crowston.name>
Subject: Requesting help repairing a RAID-6 array
Date: Sun, 29 Mar 2020 13:45:35 -0400
Message-ID: <etPan.5e80defb.10afc736.32ba@crowston.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46ollowing the advice in=C2=A0https://raid.wiki.kernel.org/index.php/RAI=
D=5FRecovery=C2=A0I am writing to ask for help fixing a busted Linux RAID=
 array.=C2=A0

On an older computer running Linux 2.6.26.6-49.fc8 i686 I had what I thou=
ght was a RAID-6 array: 4 x 3TB drives. One of the drives was showing a l=
ot of bad blocks, so I decided to proactively replace it. I marked the dr=
ive as failed (mdadm --manage /dev/md1 --fail /dev/sdb1) and removed it (=
mdadm --manage /dev/md1 --remove /dev/sdb1), then shutdown the computer a=
nd swapped the drive.=C2=A0

Alas, when I restarted, one of the remaining drives was not added back to=
 the array, leaving me with just 2 drives (mdadm --detail in exhibit 1 be=
low). =46ortunately, it was a RAID-6 array, so two is enough. I added the=
 missing drive back (sudo mdadm --manage /dev/md1 --re-add /dev/sdd1), bu=
t it was marked as spare rebuilding rather than active. But it started to=
 recover (see /proc/mdstat in =C2=A0exhibit 2). I added the new drive as =
well and it was marked as a spare (see exhibit 3 for the output of mdadm =
--examine).=C2=A0

However, during the recovery period one of the two =E2=80=9Cgood=E2=80=9D=
 drives threw an error and the array stopped. Looking more carefully at t=
he smartctl output, I am wondered if I replaced one of the good drives by=
 mistake and left the failing one. Anyway.

I still had the =E2=80=9Cbad=E2=80=9D drive I=E2=80=99d removed, so I too=
k out the new drive and put the old one back in. I think I forgot to fail=
 and remove the new one, now that I am writing this.=C2=A0

When I rebooted, the array didn=E2=80=99t start by itself. =46rom the out=
put of mdadm --examine (exhibit 4) tt seemed that I did have two up to da=
te disks, so I did a force assemble, which seemed to work.=C2=A0

=24 mdadm --assemble --force /dev/md1 /dev/sd=5Babcd=5D1
mdadm: forcing event count in /dev/sdc1(3) from 34914 upto 34922
mdadm: clearing =46AULTY flag for device 2 in /dev/md1 for /dev/sdc1
mdadm: /dev/md1 has been started with 2 drives (out of 4) and 1 spare.

But it didn=E2=80=99t add sdb1, which was the one I=E2=80=99d failed and =
removed. So, I re-added it:

=24 mdadm --re-add /dev/md1 /dev/sdb1
mdadm: re-added /dev/sdb1

That seemed to work, except sdb was also marked as a spare (see exhibit 5=
). The system started recovering sdd again.=C2=A0

But before the recovery finished, there was another disk error. And this =
time sdc was booted from the array (see exhibit 6, the dmesg output from =
this morning). Yet sdc is apparently there and with the expected header (=
see exhibit 7). Without sdc there is nothing to recover from. I tried aga=
in to assemble the drive, but got a new error:=C2=A0

=24 mdadm --stop /dev/md1
mdadm: stopped /dev/md1

=24 mdadm --assemble /dev/md1 --force /dev/sd=5Babcd=5D1
mdadm: failed to RUN=5FARRAY /dev/md1: Input/output error

Trying to just re-add sdc doesn=E2=80=99t work either:

=24 mdadm --re-add /dev/md1 /dev/sdc1
mdadm: add new device failed for /dev/sdc1 as 5: Invalid argument

Since I have two or maybe three out of four devices from a RAID-6 array, =
this should be recoverable, but I am stuck. Reading other peoples=E2=80=99=
 online recounts, I believe it might be possible to recreate the array ra=
ther than reassembling. But following the advice in https://raid.wiki.ker=
nel.org/index.php/RAID=5FRecovery=C2=A0I am asking for help before going =
any farther.=C2=A0



Exhibits:=C2=A0

1) mdadm detail right after the replacement

sudo mdadm --detail /dev/md1
/dev/md1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 01.02.03
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0 =C2=A0Array Size : 5860532736 (5589.04 GiB 6001.19 GB)
=C2=A0 Used Dev Size : 5860532736
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0 Total Devices : 2
Preferred Minor : 1
=C2=A0 =C2=A0 Persistence : Superblock is persistent

=C2=A0 =C2=A0 Update Time : Sat Mar 14 16:01:50 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean, degraded
=C2=A0Active Devices : 2
Working Devices : 2
=C2=A0=46ailed Devices : 0
=C2=A0 Spare Devices : 0

=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 27527034:7e381d1e:61ee479=
6:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34812

=C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda1
=C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0removed
=C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0removed
=C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc1

2) /proc/mdstat right after replacement=C2=A0

more /proc/mdstat=C2=A0
Personalities : =5Braid1=5D =5Braid6=5D =5Braid5=5D =5Braid4=5D=C2=A0
md0 : active raid1 sdf2=5B2=5D sde2=5B3=5D
=C2=A0 =C2=A0 =C2=A0 240973976 blocks super 1.2 =5B2/2=5D =5BUU=5D
=C2=A0 =C2=A0 =C2=A0=C2=A0
md1 : active raid6 sdb1=5B4=5D(S) sdd1=5B1=5D sda1=5B0=5D sdc1=5B5=5D
=C2=A0 =C2=A0 =C2=A0 5860532736 blocks super 1.2 level 6, 64k chunk, algo=
rithm 2 =5B4/2=5D =5BU=5F=5FU=5D
=C2=A0 =C2=A0 =C2=A0 =5B>....................=5D =C2=A0recovery =3D =C2=A0=
0.0% (1818752/2930266368) finish=3D5080.5min speed=3D9603K/sec
=C2=A0 =C2=A0 =C2=A0

3) mdadm examine right after the replacement (with one new drive)

sudo mdadm --examine /dev/sd=5Babcd=5D1
/dev/sda1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4

=C2=A0 Used Dev Size : 5860532829 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 =C2=A0 =C2=A0 Used Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 272 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 75d38a37:9fbf43a3:a45bcf82:266661ab

=C2=A0 =C2=A0 Update Time : Sat Mar 14 16:01:50 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : fe8682fb - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34812

=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K

=C2=A0 =C2=A0 Array Slot : 0 (0, failed, failed, failed, failed, 3)
=C2=A0 =C2=A0Array State : U=5F=5Fu 4 failed
mdadm: No md superblock detected on /dev/sdb1.
/dev/sdc1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4

=C2=A0 Used Dev Size : 5860532741 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 =C2=A0 =C2=A0 Used Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 360 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 52d606cb:4fc78e74:0891c48d:d2191050

=C2=A0 =C2=A0 Update Time : Sat Mar 14 16:01:50 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 12f1769e - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34812

=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K

=C2=A0 =C2=A0 Array Slot : 5 (0, failed, failed, failed, failed, 3)
=C2=A0 =C2=A0Array State : u=5F=5FU 4 failed
/dev/sdd1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4

=C2=A0 Used Dev Size : 5860532829 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 =C2=A0 =C2=A0 Used Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 272 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 10e44c8f:e72a746b:ed9d6ce6:55e7deb0

=C2=A0 =C2=A0 Update Time : Sat Mar 14 15:15:53 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 8796b72e - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34712

=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K

=C2=A0 =C2=A0 Array Slot : 1 (0, 1, failed, failed, failed, 3)
=C2=A0 =C2=A0Array State : uU=5Fu 3 failed

4) mdadm --examine after putting back the drive

/dev/sda1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0 Used Dev Size : 5860532829 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 =C2=A0 =C2=A0 Used Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 272 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 75d38a37:9fbf43a3:a45bcf82:266661ab
=C2=A0 =C2=A0 Update Time : Sun Mar 15 06:02:06 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : fe83485b - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34922
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 0 (0, empty, failed, failed, empty, failed)
=C2=A0 =C2=A0Array State : U=5F=5F=5F 3 failed
/dev/sdb1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0 Used Dev Size : 5860532741 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 =C2=A0 =C2=A0 Used Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 360 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 1e35de21:8800bfd9:dbe82508:69752cdb
=C2=A0 =C2=A0 Update Time : Sat Mar 14 13:21:22 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : d4789dec - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34678
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 4 (0, 1, failed, failed, 2, 3)
=C2=A0 =C2=A0Array State : uuUu 2 failed
/dev/sdc1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0 Used Dev Size : 5860532741 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 =C2=A0 =C2=A0 Used Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 360 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 52d606cb:4fc78e74:0891c48d:d2191050
=C2=A0 =C2=A0 Update Time : Sat Mar 14 23:12:37 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 12f2dbfc - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34914
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 5 (0, empty, failed, failed, empty, 3)
=C2=A0 =C2=A0Array State : u=5F=5FU 2 failed
/dev/sdd1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0 Used Dev Size : 5860532829 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 =C2=A0 =C2=A0 Used Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 272 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 10e44c8f:e72a746b:ed9d6ce6:55e7deb0
=C2=A0 =C2=A0 Update Time : Sun Mar 15 06:02:06 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 879087b8 - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34922
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 1 (0, empty, failed, failed, empty, failed)
=C2=A0 =C2=A0Array State : u=5F=5F=5F 3 failed

5) mdadm --describe after re-adding removed drive

mdadm -D /dev/md1
/dev/md1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.02
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0 =C2=A0Array Size : 5860532736 (5589.04 GiB 6001.19 GB)
=C2=A0 Used Dev Size : 2930266368 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0 Total Devices : 4
Preferred Minor : 1
=C2=A0 =C2=A0 Persistence : Superblock is persistent
=C2=A0 =C2=A0 Update Time : Sat Mar 28 13:14:31 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean, degraded, recovering
=C2=A0Active Devices : 2
Working Devices : 4
=C2=A0=46ailed Devices : 0
=C2=A0 Spare Devices : 2
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0Rebuild Status : 5% complete
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 27527034:7e381d1e:61ee479=
6:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34932
=C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
=C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda1
=C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0spare rebuilding =C2=A0=
 /dev/sdd1
=C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0removed
=C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc1
=C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0spare =C2=A0 /dev/sdb=
1


6) dmesg =7C grep =E2=80=9Cmd=22

md: raid1 personality registered for level 1
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
pata=5Famd 0000:00:08.0: version 0.3.10
scsi6 : pata=5Famd
scsi7 : pata=5Famd
ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata9: PATA max UDMA/100 cmd 0xbc00 ctl 0xb800 bmdma 0xac00 irq 16
ata10: PATA max UDMA/100 cmd 0xb400 ctl 0xb000 bmdma 0xac08 irq 16
md: md1 stopped.
md: md0 stopped.
md: bind<sde2>
md: bind<sdf2>
raid1: raid set md0 active with 2 out of 2 mirrors
md: md1 stopped.
md: bind<sdd1>
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: kicking non-fresh sdc1 from array=21
md: unbind<sdc1>
md: export=5Frdev(sdc1)
raid5: not enough operational devices for md1 (3/4 failed)
raid5: failed to run raid set md1
md: pers->run() failed ...
md: md1 stopped.
md: unbind<sda1>
md: export=5Frdev(sda1)
md: unbind<sdb1>
md: export=5Frdev(sdb1)
md: unbind<sdd1>
md: export=5Frdev(sdd1)
md: md1 stopped.
md: bind<sdd1>
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: kicking non-fresh sdc1 from array=21
md: unbind<sdc1>
md: export=5Frdev(sdc1)
raid5: not enough operational devices for md1 (3/4 failed)
raid5: failed to run raid set md1
md: pers->run() failed ...
md: md1 stopped.
md: unbind<sda1>
md: export=5Frdev(sda1)
md: unbind<sdb1>
md: export=5Frdev(sdb1)
md: unbind<sdd1>
md: export=5Frdev(sdd1)
md: md1 stopped.
md: bind<sdd1>
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: kicking non-fresh sdc1 from array=21
md: unbind<sdc1>
md: export=5Frdev(sdc1)
raid5: not enough operational devices for md1 (3/4 failed)
raid5: failed to run raid set md1
md: pers->run() failed ...
md1: ADD=5FNEW=5FDISK not supported
md1: ADD=5FNEW=5FDISK not supported
md1: ADD=5FNEW=5FDISK not supported
md1: ADD=5FNEW=5FDISK not supported

7) mdadm --examine after sdc removed from array

mdadm --examine /dev/sd=5Babcd=5D1
/dev/sda1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0Avail Dev Size : 5860532829 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 Used Dev Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 272 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 75d38a37:9fbf43a3:a45bcf82:266661ab
=C2=A0 =C2=A0 Update Time : Sat Mar 28 17:24:51 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : fe970bf7 - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34946
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 0 (0, 1, failed, failed, empty, failed)
=C2=A0 =C2=A0Array State : Uu=5F=5F 3 failed
/dev/sdb1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0Avail Dev Size : 5860532741 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 Used Dev Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 360 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 1e35de21:8800bfd9:dbe82508:69752cdb
=C2=A0 =C2=A0 Update Time : Sat Mar 28 17:24:51 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : d4874d07 - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34946
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 4 (0, 1, failed, failed, empty, failed)
=C2=A0 =C2=A0Array State : uu=5F=5F 3 failed
/dev/sdc1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x0
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0Avail Dev Size : 5860532741 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 Used Dev Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 360 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 52d606cb:4fc78e74:0891c48d:d2191050
=C2=A0 =C2=A0 Update Time : Sat Mar 28 16:21:33 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 1304f0be - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34940
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 5 (0, empty, failed, failed, empty, 3)
=C2=A0 =C2=A0Array State : u=5F=5FU 2 failed
/dev/sdd1:
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
=C2=A0 =C2=A0 =46eature Map : 0x2
=C2=A0 =C2=A0 =C2=A0Array UUID : 27527034:7e381d1e:61ee4796:be882bf6
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : 1
=C2=A0 Creation Time : =46ri Oct 24 18:40:59 2014
=C2=A0 =C2=A0 =C2=A0Raid Level : raid6
=C2=A0 =C2=A0Raid Devices : 4
=C2=A0Avail Dev Size : 5860532829 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 =C2=A0Array Size : 11721065472 (5589.04 GiB 6001.19 GB)
=C2=A0 Used Dev Size : 5860532736 (2794.52 GiB 3000.59 GB)
=C2=A0 =C2=A0 Data Offset : 272 sectors
=C2=A0 =C2=A0Super Offset : 8 sectors
Recovery Offset : 4140298240 sectors
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
=C2=A0 =C2=A0 Device UUID : 10e44c8f:e72a746b:ed9d6ce6:55e7deb0
=C2=A0 =C2=A0 Update Time : Sat Mar 28 17:24:51 2020
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 7e6c3b57 - correct
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 34946
=C2=A0 =C2=A0 =C2=A0Chunk Size : 64K
=C2=A0 =C2=A0 Array Slot : 1 (0, 1, failed, failed, empty, failed)
=C2=A0 =C2=A0Array State : uU=5F=5F 3 failed


Other potentially useful info:

=24 more /proc/mdstat=C2=A0
Personalities : =5Braid1=5D =5Braid6=5D =5Braid5=5D =5Braid4=5D=C2=A0
md0 : active raid1 sdf2=5B2=5D sde2=5B3=5D
=C2=A0 =C2=A0 =C2=A0 240973976 blocks super 1.2 =5B2/2=5D =5BUU=5D
=C2=A0 =C2=A0 =C2=A0=C2=A0
md1 : inactive sda1=5B0=5D sdb1=5B4=5D(S) sdd1=5B1=5D
=C2=A0 =C2=A0 =C2=A0 8790799104 blocks super 1.2
=C2=A0 =C2=A0 =C2=A0 =C2=A0
unused devices: <none>

=24 ls -=46 /sys/block/md1/md
array=5Fstate =C2=A0component=5Fsize =C2=A0dev-sdb1/	layout	metadata=5Fve=
rsion =C2=A0raid=5Fdisks	 =C2=A0 =C2=A0resync=5Fstart
chunk=5Fsize =C2=A0 dev-sda1/	 =C2=A0 =C2=A0 dev-sdd1/	level	new=5Fdev		 =
=C2=A0reshape=5Fposition =C2=A0safe=5Fmode=5Fdelay

=24 more /sys/block/md1/md/dev-sd*/state
::::::::::::::
/sys/block/md1/md/dev-sda1/state
::::::::::::::
in=5Fsync
::::::::::::::
/sys/block/md1/md/dev-sdb1/state
::::::::::::::
spare
::::::::::::::
/sys/block/md1/md/dev-sdd1/state
::::::::::::::
spare



=24 foreach i ( /dev/sd=5Babcd=5D )
foreach=3F /usr/sbin/smartctl -a =24i
foreach=3F end
smartctl version 5.38 =5Bi386-redhat-linux-gnu=5D Copyright (C) 2002-8 Br=
uce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START O=46 IN=46ORMATION SECTION =3D=3D=3D
Device Model: =C2=A0 =C2=A0 ST3000DM001-1CH166
Serial Number: =C2=A0 =C2=A0Z1=4650Y21
=46irmware Version: CC29
User Capacity: =C2=A0 =C2=A03,000,592,982,016 bytes
Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database =5Bfor det=
ails use: -P showall=5D
ATA Version is: =C2=A0 9
ATA Standard is: =C2=A0Not recognized. Minor revision code: 0x1f
Local Time is: =C2=A0 =C2=A0Sun Mar 29 13:40:29 2020 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START O=46 READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status: =C2=A0(0x00)	Offline data collection acti=
vity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0)	The previous =
self-test routine completed
					without error or no self-test has ever=C2=A0
					been run.
Total time to complete Offline=C2=A0
data collection: 		 ( 600) seconds.
Offline data collection
capabilities: 			 (0x73) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					No Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x0003)	Sav=
es SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01)	Error logging=
 supported.
					General Purpose Logging supported.
Short self-test routine=C2=A0
recommended polling time: 	 ( =C2=A0 1) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 ( =C2=A0 2) minutes.
SCT capabilities: 	 =C2=A0 =C2=A0 =C2=A0 (0x3085)	SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID=23 ATTRIBUTE=5FNAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=46LAG =C2=A0 =C2=
=A0 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED =C2=A0WHEN=5F=46A=
ILED RAW=5FVALUE
=C2=A0 1 Raw=5FRead=5FError=5FRate =C2=A0 =C2=A0 0x000f =C2=A0 119 =C2=A0=
 099 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 230220376
=C2=A0 3 Spin=5FUp=5FTime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003=
 =C2=A0 093 =C2=A0 093 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0=
 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A0 4 Start=5FStop=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 73
=C2=A0 5 Reallocated=5FSector=5FCt =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 010 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =
=C2=A0 =C2=A0 0
=C2=A0 7 Seek=5FError=5FRate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 08=
4 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 258429136
=C2=A0 9 Power=5FOn=5FHours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 046 =C2=A0 046 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 48061
=C2=A010 Spin=5FRetry=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A012 Power=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 73
183 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
184 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 099 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
187 Reported=5FUncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
188 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
189 High=5F=46ly=5FWrites =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 057 =C2=
=A0 057 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 43
190 Airflow=5FTemperature=5FCel 0x0022 =C2=A0 070 =C2=A0 049 =C2=A0 045 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 30 (Lifetime Min/Max 14/31)
191 G-Sense=5FError=5FRate =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 0
192 Power-Off=5FRetract=5FCount 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 49
193 Load=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 049 =C2=
=A0 049 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 103886
194 Temperature=5FCelsius =C2=A0 =C2=A0 0x0022 =C2=A0 030 =C2=A0 051 =C2=A0=
 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 30 (0 12 0 0)
197 Current=5FPending=5FSector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 0
198 Offline=5FUncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 00=
0 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0=
 =C2=A0 0
199 UDMA=5FCRC=5FError=5FCount =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =
=C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
240 Head=5F=46lying=5FHours =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0=
 253 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0=
- =C2=A0 =C2=A0 =C2=A0 199767518916884
241 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 29356695670
242 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 42508156065

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num =C2=A0Test=5FDescription =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours) =C2=
=A0LBA=5Fof=5Ffirst=5Ferror
=23 1 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 45557 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -

SMART Selective self-test log data structure revision number 1
=C2=A0SPAN =C2=A0MIN=5FLBA =C2=A0MAX=5FLBA =C2=A0CURRENT=5FTEST=5FSTATUS
=C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
Selective self-test flags (0x0):
=C2=A0 After scanning selected spans, do NOT read-scan remainder of disk.=

If Selective self-test is pending on power-up, resume after 0 minute dela=
y.

smartctl version 5.38 =5Bi386-redhat-linux-gnu=5D Copyright (C) 2002-8 Br=
uce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START O=46 IN=46ORMATION SECTION =3D=3D=3D
Device Model: =C2=A0 =C2=A0 ST3000DM001-1CH166
Serial Number: =C2=A0 =C2=A0W1=4642Z54
=46irmware Version: CC27
User Capacity: =C2=A0 =C2=A03,000,592,982,016 bytes
Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database =5Bfor det=
ails use: -P showall=5D
ATA Version is: =C2=A0 9
ATA Standard is: =C2=A0Not recognized. Minor revision code: 0x1f
Local Time is: =C2=A0 =C2=A0Sun Mar 29 13:40:29 2020 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START O=46 READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status: =C2=A0(0x00)	Offline data collection acti=
vity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0)	The previous =
self-test routine completed
					without error or no self-test has ever=C2=A0
					been run.
Total time to complete Offline=C2=A0
data collection: 		 ( 584) seconds.
Offline data collection
capabilities: 			 (0x73) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					No Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x0003)	Sav=
es SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01)	Error logging=
 supported.
					General Purpose Logging supported.
Short self-test routine=C2=A0
recommended polling time: 	 ( =C2=A0 1) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 ( =C2=A0 2) minutes.
SCT capabilities: 	 =C2=A0 =C2=A0 =C2=A0 (0x3085)	SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID=23 ATTRIBUTE=5FNAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=46LAG =C2=A0 =C2=
=A0 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED =C2=A0WHEN=5F=46A=
ILED RAW=5FVALUE
=C2=A0 1 Raw=5FRead=5FError=5FRate =C2=A0 =C2=A0 0x000f =C2=A0 115 =C2=A0=
 094 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 94431168
=C2=A0 3 Spin=5FUp=5FTime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003=
 =C2=A0 093 =C2=A0 093 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0=
 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A0 4 Start=5FStop=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 85
=C2=A0 5 Reallocated=5FSector=5FCt =C2=A0 0x0033 =C2=A0 098 =C2=A0 098 =C2=
=A0 010 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =
=C2=A0 =C2=A0 2040
=C2=A0 7 Seek=5FError=5FRate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 07=
1 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 99051200434
=C2=A0 9 Power=5FOn=5FHours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 041 =C2=A0 041 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 52413
=C2=A010 Spin=5FRetry=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A012 Power=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 85
183 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
184 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 099 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
187 Reported=5FUncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 077 =C2=A0 077=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 23
188 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 099=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 1
189 High=5F=46ly=5FWrites =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 097 =C2=
=A0 097 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 3
190 Airflow=5FTemperature=5FCel 0x0022 =C2=A0 068 =C2=A0 043 =C2=A0 045 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 In=5Fthe=5Fpast 32 (0 13 33 15)
191 G-Sense=5FError=5FRate =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 0
192 Power-Off=5FRetract=5FCount 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 59
193 Load=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 039 =C2=
=A0 039 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 122262
194 Temperature=5FCelsius =C2=A0 =C2=A0 0x0022 =C2=A0 032 =C2=A0 057 =C2=A0=
 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 32 (0 12 0 0)
197 Current=5FPending=5FSector =C2=A00x0012 =C2=A0 078 =C2=A0 075 =C2=A0 =
000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 3632
198 Offline=5FUncorrectable =C2=A0 0x0010 =C2=A0 078 =C2=A0 075 =C2=A0 00=
0 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0=
 =C2=A0 3632
199 UDMA=5FCRC=5FError=5FCount =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =
=C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
240 Head=5F=46lying=5FHours =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0=
 253 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0=
- =C2=A0 =C2=A0 =C2=A0 187586991669585
241 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 39144200179
242 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 33632585895

SMART Error Log Version: 1
ATA Error Count: 23 (device log contains only the most recent five errors=
)
	CR =3D Command Register =5BHEX=5D
	=46R =3D =46eatures Register =5BHEX=5D
	SC =3D Sector Count Register =5BHEX=5D
	SN =3D Sector Number Register =5BHEX=5D
	CL =3D Cylinder Low Register =5BHEX=5D
	CH =3D Cylinder High Register =5BHEX=5D
	DH =3D Device/Head Register =5BHEX=5D
	DC =3D Device Command Register =5BHEX=5D
	ER =3D Error register =5BHEX=5D
	ST =3D Status register =5BHEX=5D
Powered=5FUp=5FTime is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It =22wraps=22 after 49.710 days.

Error 23 occurred at disk power-on lifetime: 51758 hours (2156 days + 14 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 18 ff ff ff ef 00 =C2=A047d+05:32:03.461 =C2=A0READ DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A047d+05:32:03.460 =C2=A0READ NATIVE M=
AX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A047d+05:32:03.460 =C2=A0IDENTI=46Y DE=
VICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A047d+05:32:03.460 =C2=A0SET =46EATURE=
S =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A047d+05:32:03.459 =C2=A0READ NATIVE M=
AX ADDRESS EXT

Error 22 occurred at disk power-on lifetime: 51758 hours (2156 days + 14 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 18 ff ff ff ef 00 =C2=A047d+05:31:59.731 =C2=A0READ DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A047d+05:31:59.730 =C2=A0READ NATIVE M=
AX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A047d+05:31:59.730 =C2=A0IDENTI=46Y DE=
VICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A047d+05:31:59.729 =C2=A0SET =46EATURE=
S =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A047d+05:31:59.729 =C2=A0READ NATIVE M=
AX ADDRESS EXT

Error 21 occurred at disk power-on lifetime: 51758 hours (2156 days + 14 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 18 ff ff ff ef 00 =C2=A047d+05:31:56.010 =C2=A0READ DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A047d+05:31:56.009 =C2=A0READ NATIVE M=
AX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A047d+05:31:56.008 =C2=A0IDENTI=46Y DE=
VICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A047d+05:31:56.008 =C2=A0SET =46EATURE=
S =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A047d+05:31:55.983 =C2=A0READ NATIVE M=
AX ADDRESS EXT

Error 20 occurred at disk power-on lifetime: 51758 hours (2156 days + 14 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 18 ff ff ff ef 00 =C2=A047d+05:31:51.976 =C2=A0READ DMA EXT
=C2=A0 35 00 08 ff ff ff ef 00 =C2=A047d+05:31:51.973 =C2=A0WRITE DMA EXT=

=C2=A0 35 00 08 ff ff ff ef 00 =C2=A047d+05:31:51.965 =C2=A0WRITE DMA EXT=

=C2=A0 35 00 08 ff ff ff ef 00 =C2=A047d+05:31:51.940 =C2=A0WRITE DMA EXT=

=C2=A0 35 00 08 ff ff ff ef 00 =C2=A047d+05:31:51.934 =C2=A0WRITE DMA EXT=


Error 19 occurred at disk power-on lifetime: 51184 hours (2132 days + 16 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 00 ff ff ff ef 00 =C2=A023d+08:05:26.236 =C2=A0READ DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A023d+08:05:26.235 =C2=A0READ NATIVE M=
AX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A023d+08:05:26.234 =C2=A0IDENTI=46Y DE=
VICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A023d+08:05:26.234 =C2=A0SET =46EATURE=
S =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A023d+08:05:26.234 =C2=A0READ NATIVE M=
AX ADDRESS EXT

SMART Self-test log structure revision number 1
Num =C2=A0Test=5FDescription =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours) =C2=
=A0LBA=5Fof=5Ffirst=5Ferror
=23 1 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 49924 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -
=23 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0 =
=C2=A0 =C2=A0 00% =C2=A0 =C2=A0 47925 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -

SMART Selective self-test log data structure revision number 1
=C2=A0SPAN =C2=A0MIN=5FLBA =C2=A0MAX=5FLBA =C2=A0CURRENT=5FTEST=5FSTATUS
=C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
Selective self-test flags (0x0):
=C2=A0 After scanning selected spans, do NOT read-scan remainder of disk.=

If Selective self-test is pending on power-up, resume after 0 minute dela=
y.

smartctl version 5.38 =5Bi386-redhat-linux-gnu=5D Copyright (C) 2002-8 Br=
uce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START O=46 IN=46ORMATION SECTION =3D=3D=3D
Device Model: =C2=A0 =C2=A0 ST3000DM001-1CH166
Serial Number: =C2=A0 =C2=A0W1=4642=46W6
=46irmware Version: CC27
User Capacity: =C2=A0 =C2=A03,000,592,982,016 bytes
Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database =5Bfor det=
ails use: -P showall=5D
ATA Version is: =C2=A0 9
ATA Standard is: =C2=A0Not recognized. Minor revision code: 0x1f
Local Time is: =C2=A0 =C2=A0Sun Mar 29 13:40:33 2020 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START O=46 READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status: =C2=A0(0x00)	Offline data collection acti=
vity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0)	The previous =
self-test routine completed
					without error or no self-test has ever=C2=A0
					been run.
Total time to complete Offline=C2=A0
data collection: 		 ( 584) seconds.
Offline data collection
capabilities: 			 (0x73) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					No Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x0003)	Sav=
es SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01)	Error logging=
 supported.
					General Purpose Logging supported.
Short self-test routine=C2=A0
recommended polling time: 	 ( =C2=A0 1) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 ( =C2=A0 2) minutes.
SCT capabilities: 	 =C2=A0 =C2=A0 =C2=A0 (0x3085)	SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID=23 ATTRIBUTE=5FNAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=46LAG =C2=A0 =C2=
=A0 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED =C2=A0WHEN=5F=46A=
ILED RAW=5FVALUE
=C2=A0 1 Raw=5FRead=5FError=5FRate =C2=A0 =C2=A0 0x000f =C2=A0 111 =C2=A0=
 099 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 230196590
=C2=A0 3 Spin=5FUp=5FTime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003=
 =C2=A0 093 =C2=A0 093 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0=
 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A0 4 Start=5FStop=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 90
=C2=A0 5 Reallocated=5FSector=5FCt =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 010 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =
=C2=A0 =C2=A0 0
=C2=A0 7 Seek=5FError=5FRate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 06=
2 =C2=A0 059 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 786257890871
=C2=A0 9 Power=5FOn=5FHours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 040 =C2=A0 040 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 53248
=C2=A010 Spin=5FRetry=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A012 Power=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 89
183 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 097 =C2=A0 097=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 3
184 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 099 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
187 Reported=5FUncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 070 =C2=A0 070=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 30
188 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 099=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 4
189 High=5F=46ly=5FWrites =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 0
190 Airflow=5FTemperature=5FCel 0x0022 =C2=A0 069 =C2=A0 044 =C2=A0 045 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 In=5Fthe=5Fpast 31 (0 11 31 14)
191 G-Sense=5FError=5FRate =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 0
192 Power-Off=5FRetract=5FCount 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 61
193 Load=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 038 =C2=
=A0 038 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 125375
194 Temperature=5FCelsius =C2=A0 =C2=A0 0x0022 =C2=A0 031 =C2=A0 056 =C2=A0=
 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 31 (0 12 0 0)
197 Current=5FPending=5FSector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 120
198 Offline=5FUncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 00=
0 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0=
 =C2=A0 120
199 UDMA=5FCRC=5FError=5FCount =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 198 =
=C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 19
240 Head=5F=46lying=5FHours =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0=
 253 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0=
- =C2=A0 =C2=A0 =C2=A0 251483220132801
241 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 35688407725
242 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 59345299664

SMART Error Log Version: 1
ATA Error Count: 30 (device log contains only the most recent five errors=
)
	CR =3D Command Register =5BHEX=5D
	=46R =3D =46eatures Register =5BHEX=5D
	SC =3D Sector Count Register =5BHEX=5D
	SN =3D Sector Number Register =5BHEX=5D
	CL =3D Cylinder Low Register =5BHEX=5D
	CH =3D Cylinder High Register =5BHEX=5D
	DH =3D Device/Head Register =5BHEX=5D
	DC =3D Device Command Register =5BHEX=5D
	ER =3D Error register =5BHEX=5D
	ST =3D Status register =5BHEX=5D
Powered=5FUp=5FTime is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It =22wraps=22 after 49.710 days.

Error 30 occurred at disk power-on lifetime: 53242 hours (2218 days + 10 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 98 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A006:02:38.768 =C2=A0REA=
D DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:38.767 =C2=A0REA=
D NATIVE MAX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:38.767 =C2=A0IDE=
NTI=46Y DEVICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:38.766 =C2=A0SET=
 =46EATURES =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:38.766 =C2=A0REA=
D NATIVE MAX ADDRESS EXT

Error 29 occurred at disk power-on lifetime: 53242 hours (2218 days + 10 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 98 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A006:02:33.929 =C2=A0REA=
D DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:33.928 =C2=A0REA=
D NATIVE MAX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:33.928 =C2=A0IDE=
NTI=46Y DEVICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:33.927 =C2=A0SET=
 =46EATURES =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:33.927 =C2=A0REA=
D NATIVE MAX ADDRESS EXT

Error 28 occurred at disk power-on lifetime: 53242 hours (2218 days + 10 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 98 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A006:02:29.073 =C2=A0REA=
D DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:29.072 =C2=A0REA=
D NATIVE MAX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:29.072 =C2=A0IDE=
NTI=46Y DEVICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:29.072 =C2=A0SET=
 =46EATURES =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:29.072 =C2=A0REA=
D NATIVE MAX ADDRESS EXT

Error 27 occurred at disk power-on lifetime: 53242 hours (2218 days + 10 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 98 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A006:02:24.108 =C2=A0REA=
D DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:24.107 =C2=A0REA=
D NATIVE MAX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:24.107 =C2=A0IDE=
NTI=46Y DEVICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:24.107 =C2=A0SET=
 =46EATURES =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:24.106 =C2=A0REA=
D NATIVE MAX ADDRESS EXT

Error 26 occurred at disk power-on lifetime: 53242 hours (2218 days + 10 =
hours)
=C2=A0 When the command that caused the error occurred, the device was ac=
tive or idle.

=C2=A0 After command completion occurred, registers were:
=C2=A0 ER ST SC SN CL CH DH
=C2=A0 -- -- -- -- -- -- --
=C2=A0 40 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D 26=
8435455

=C2=A0 Commands leading to the command that caused the error were:
=C2=A0 CR =46R SC SN CL CH DH DC =C2=A0 Powered=5FUp=5FTime =C2=A0Command=
/=46eature=5FName
=C2=A0 -- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0-------------=
-------
=C2=A0 25 00 98 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A006:02:19.301 =C2=A0REA=
D DMA EXT
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:19.300 =C2=A0REA=
D NATIVE MAX ADDRESS EXT
=C2=A0 ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:19.300 =C2=A0IDE=
NTI=46Y DEVICE
=C2=A0 ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A006:02:19.300 =C2=A0SET=
 =46EATURES =5BSet transfer mode=5D
=C2=A0 27 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A006:02:19.299 =C2=A0REA=
D NATIVE MAX ADDRESS EXT

SMART Self-test log structure revision number 1
Num =C2=A0Test=5FDescription =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours) =C2=
=A0LBA=5Fof=5Ffirst=5Ferror
=23 1 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 50745 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -
=23 2 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 10763 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -

SMART Selective self-test log data structure revision number 1
=C2=A0SPAN =C2=A0MIN=5FLBA =C2=A0MAX=5FLBA =C2=A0CURRENT=5FTEST=5FSTATUS
=C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
Selective self-test flags (0x0):
=C2=A0 After scanning selected spans, do NOT read-scan remainder of disk.=

If Selective self-test is pending on power-up, resume after 0 minute dela=
y.

smartctl version 5.38 =5Bi386-redhat-linux-gnu=5D Copyright (C) 2002-8 Br=
uce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START O=46 IN=46ORMATION SECTION =3D=3D=3D
Device Model: =C2=A0 =C2=A0 ST3000DM001-1CH166
Serial Number: =C2=A0 =C2=A0Z1=465083S
=46irmware Version: CC29
User Capacity: =C2=A0 =C2=A03,000,592,982,016 bytes
Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database =5Bfor det=
ails use: -P showall=5D
ATA Version is: =C2=A0 9
ATA Standard is: =C2=A0Not recognized. Minor revision code: 0x1f
Local Time is: =C2=A0 =C2=A0Sun Mar 29 13:40:33 2020 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START O=46 READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status: =C2=A0(0x00)	Offline data collection acti=
vity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0)	The previous =
self-test routine completed
					without error or no self-test has ever=C2=A0
					been run.
Total time to complete Offline=C2=A0
data collection: 		 ( 584) seconds.
Offline data collection
capabilities: 			 (0x73) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					No Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x0003)	Sav=
es SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01)	Error logging=
 supported.
					General Purpose Logging supported.
Short self-test routine=C2=A0
recommended polling time: 	 ( =C2=A0 1) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 ( =C2=A0 2) minutes.
SCT capabilities: 	 =C2=A0 =C2=A0 =C2=A0 (0x3085)	SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID=23 ATTRIBUTE=5FNAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=46LAG =C2=A0 =C2=
=A0 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED =C2=A0WHEN=5F=46A=
ILED RAW=5FVALUE
=C2=A0 1 Raw=5FRead=5FError=5FRate =C2=A0 =C2=A0 0x000f =C2=A0 117 =C2=A0=
 099 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 153985440
=C2=A0 3 Spin=5FUp=5FTime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003=
 =C2=A0 093 =C2=A0 093 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0=
 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A0 4 Start=5FStop=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 70
=C2=A0 5 Reallocated=5FSector=5FCt =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 010 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =
=C2=A0 =C2=A0 0
=C2=A0 7 Seek=5FError=5FRate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 08=
4 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 250274127
=C2=A0 9 Power=5FOn=5FHours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 046 =C2=A0 046 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 48024
=C2=A010 Spin=5FRetry=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =
=C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
=C2=A012 Power=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 70
183 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 099 =C2=A0 099=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 1
184 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 099 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
187 Reported=5FUncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 100=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
188 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 099=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 2
189 High=5F=46ly=5FWrites =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 0
190 Airflow=5FTemperature=5FCel 0x0022 =C2=A0 070 =C2=A0 052 =C2=A0 045 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 30 (Lifetime Min/Max 15/31)
191 G-Sense=5FError=5FRate =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 0
192 Power-Off=5FRetract=5FCount 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000 =C2=
=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 48
193 Load=5FCycle=5FCount =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 048 =C2=
=A0 048 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 104813
194 Temperature=5FCelsius =C2=A0 =C2=A0 0x0022 =C2=A0 030 =C2=A0 048 =C2=A0=
 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 30 (0 13 0 0)
197 Current=5FPending=5FSector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 0
198 Offline=5FUncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 00=
0 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0=
 =C2=A0 0
199 UDMA=5FCRC=5FError=5FCount =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =
=C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=
=A0 =C2=A0 =C2=A0 0
240 Head=5F=46lying=5FHours =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0=
 253 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0=
- =C2=A0 =C2=A0 =C2=A0 116372138930355
241 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 36713708761
242 Unknown=5FAttribute =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 253=
 =C2=A0 000 =C2=A0 =C2=A0Old=5Fage =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=
=A0 =C2=A0 =C2=A0 25220463092

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num =C2=A0Test=5FDescription =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours) =C2=
=A0LBA=5Fof=5Ffirst=5Ferror
=23 1 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 45524 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -

SMART Selective self-test log data structure revision number 1
=C2=A0SPAN =C2=A0MIN=5FLBA =C2=A0MAX=5FLBA =C2=A0CURRENT=5FTEST=5FSTATUS
=C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
=C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00=
 =C2=A0Not=5Ftesting
Selective self-test flags (0x0):
=C2=A0 After scanning selected spans, do NOT read-scan remainder of disk.=

If Selective self-test is pending on power-up, resume after 0 minute dela=
y.






Kevin Crowston
206 Meadowbrook Dr.
Syracuse, NY 13210 USA
Phone: +1 (315) 464-0272
=46ax: +1 (815) 550-2155
