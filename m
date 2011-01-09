From: Matthew Gabeler-Lee <cheetah@fastcat.org>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sat, 08 Jan 2011 22:09:08 -0500
Message-ID: <4D2926D4.7010300@fastcat.org>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org> <4D274FF9.8010004@gmail.com> <alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org> <4D285B79.9040100@gmail.com> <alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org> <4D28F48C.1030806@gmail.com> <4D28F58F.7000401@fastcat.org> <4D28F95F.4090509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D28F95F.4090509@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= <phcoder@gmail.com>
Cc: 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/8/2011 18:55, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:
> I have a hypothesis. Does last partition on any device span, s.t. it
> leaves less than 64K after it until the end of device? If so then GRU=
B
> sees the same metadata sector as the one at the end of device and as =
at
> the end of partition. With 1.x metadata sector contains its own locat=
ion
> on the device. With 0.90 I can see no such field. Is there a way to
> check for such condition with 0.90?
I created the last partition on each disk running as close to the end o=
f the=20
disk as fdisk would allow.  Since the partitions were created on cylind=
er=20
boundaries, however, it looks like the last partition ends 2MB before t=
he=20
end of the physical device.  Reading the data between the end of the la=
st=20
partition and the end of the disk gives all zeros for three of the four=
=20
disks, but /dev/sdb gives what looks like it might have an mdraid super=
block=20
in it:

$ sudo fdisk -lu /dev/sdb

Disk /dev/sdb: 750.2 GB, 750156374016 bytes
255 heads, 63 sectors/track, 91201 cylinders, total 1465149168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x994d834b

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *          63     4016249     2008093+  fd  Linux raid auto=
detect
/dev/sdb2         4016250     8032499     2008125   fd  Linux raid auto=
detect
/dev/sdb3         8032500  1465144064   728555782+  fd  Linux raid auto=
detect
$ sudo dd if=3D/dev/sdb bs=3D512 skip=3D1465144064 2>/dev/null | hd
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
*
00260000  fc 4e 2b a9 00 00 00 00  5a 00 00 00 03 00 00 00  |.N+.....Z.=
=2E.....|
00260010  00 00 00 00 a2 f7 64 93  e8 36 28 44 01 00 00 00  |......d..6=
(D....|
00260020  80 f3 0e 00 03 00 00 00  02 00 00 00 00 00 00 00  |..........=
=2E.....|
00260030  00 00 00 00 d5 95 46 d7  a0 b3 8d 7d 48 9e 5f 3b  |......F...=
=2E}H._;|
00260040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
*
00260080  6f 90 65 49 01 00 00 00  02 00 00 00 03 00 00 00  |o.eI......=
=2E.....|
00260090  00 00 00 00 01 00 00 00  eb 34 81 5b 52 25 90 00  |.........4=
=2E[R%..|
002600a0  00 00 00 00 52 25 90 00  00 00 00 00 ff ff ff ff  |....R%....=
=2E.....|
002600b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
*
00260200  00 00 00 00 08 00 00 00  01 00 00 00 00 00 00 00  |..........=
=2E.....|
00260210  06 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
00260220  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
*
00260280  01 00 00 00 08 00 00 00  11 00 00 00 01 00 00 00  |..........=
=2E.....|
00260290  06 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
002602a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
*
00260300  02 00 00 00 08 00 00 00  30 00 00 00 02 00 00 00  |........0.=
=2E.....|
00260310  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
*
00260f80  02 00 00 00 08 00 00 00  30 00 00 00 02 00 00 00  |........0.=
=2E.....|
00260f90  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
=2E.....|
*
0027e000

mdadm seems to confirm this.  mdadm --examine /dev/sd[acd] gives "no md=
=20
superblock", but on /dev/sdb, I get this (note that the device size at =
least=20
is bogus, since the disk itself is only 750GB):

$ sudo mdadm --examine /dev/sdb
/dev/sdb:
           Magic : a92b4efc
         Version : 0.90.03
            UUID : 9364f7a2:d74695d5:7d8db3a0:3b5f9e48
   Creation Time : Mon Mar 27 14:03:04 2006
      Raid Level : raid1
   Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
      Array Size : 979840 (957.04 MiB 1003.36 MB)
    Raid Devices : 2
   Total Devices : 3
Preferred Minor : 0

     Update Time : Thu Jan  8 00:34:39 2009
           State : clean
  Active Devices : 2
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 1
        Checksum : 5b8134eb - correct
          Events : 9446738


       Number   Major   Minor   RaidDevice State
this     2       8       48        2      spare   /dev/sdd

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       48        2      spare   /dev/sdd

--=20
	-Matt
"Reality is that which, when you stop believing in it, doesn't go away"=
=2E
                 -- Philip K. Dick
GPG pubkey fingerprint: A57F B354 FD30 A502 795B 9637 3EF1 3F22 A85E 2A=
D1

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
