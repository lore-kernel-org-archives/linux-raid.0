From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
 reboot
Date: Tue, 23 Dec 2008 08:36:17 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-81106596-1230039377=:4817"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: bug-parted@gnu.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-81106596-1230039377=:4817
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Kernel =3D 2.6.27.10
Parted =3D 1.8.8.git.2008.03.24-11.1

Can anyone help explain the problem here?

After a reboot:

p34:~# mount /dev/sda1 /r1
mount: you must specify the filesystem type

(from dmesg)
[   75.325551] XFS: bad magic number
[   75.325557] XFS: SB validate failed

p34:~# xfs_repair -n /dev/sda1
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......
=2E........................................................................=
=2E......< no go >

So I re-did what I did before the reboot, this time though I removed the=20
old partition and created a new one just as I did before.

p34:~# parted /dev/sda
GNU Parted 1.8.8
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p=20
Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 13.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      17.4kB  13.0TB  13.0TB  xfs

(parted) rm 1
(parted) print=20
Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 13.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End  Size  File system  Name  Flags

(parted) q=20
Information: You may need to update /etc/fstab.

p34:~# od -c -N 2000 /dev/sda
0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000700 001  \0   =EE   =FE   =FF   =FF 001  \0  \0  \0   =FF   =FF   =FF  =
 =FF  \0  \0
0000720  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0000760  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0   U   =AA
0001000   E   F   I       P   A   R   T  \0  \0 001  \0   \  \0  \0  \0
0001020   ; 213   #   =CB  \0  \0  \0  \0 001  \0  \0  \0  \0  \0  \0  \0
0001040   =FF   =FF   a   =E9 005  \0  \0  \0   "  \0  \0  \0  \0  \0  \0  =
\0
0001060   =DE   =FF   a   =E9 005  \0  \0  \0   =EF   *   w   p   =EA   =A3=
  \a   @
0001100   =A9   =B2   =DE 212 225   #   =BD 206 002  \0  \0  \0  \0  \0  \0=
  \0
0001120 200  \0  \0  \0 200  \0  \0  \0 206   =D2   T   =AB  \0  \0  \0  \0
0001140  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0003720


p34:~# parted /dev/sda
GNU Parted 1.8.8
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p=20
Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 13.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End  Size  File system  Name  Flags

(parted) mklabel gpt=20
Warning: The existing disk label on /dev/sda will be destroyed and all data=
 on
this disk will be lost. Do you want to continue?
parted: invalid token: gpt
Yes/No? yes=20
New disk label type?  [gpt]?=20
(parted) p=20
Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 13.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End  Size  File system  Name  Flags

(parted) mkpart=20
Partition name?  []?=20
File system type?  [ext2]? xfs=20
Start? 0=20
End? 13T=20
(parted) p=20
Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 13.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      17.4kB  13.0TB  13.0TB  xfs

(parted) quit=20
Information: You may need to update /etc/fstab.

p34:~# mount /dev/sda1 /r1
p34:~# df -h
/dev/sda1              12T  2.2T  9.8T  18% /r1

Is this normal?  Now everything is fine etc, how come this information is=
=20
not kept across reboots?  Are partitions broken > 10T?

p34:~# od -c -N 200000 /dev/sda| grep -E '^.*X*F*S.*$'
0042000   X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0   =BD   ,   ?   =F7

p34:~# od -c -N 200000 /dev/sda| nl | grep -E '^.*X*F*S.*$'
     20  0042000   X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0   =BD   , =
  ?   =F7

How come the information is 'lost' after a reboot?

I have done this same process with ext3 and no issues when the partition is
less than 6TiB, am I hitting some kind of bug here with parted or XFS?

Justin.

---1463747160-81106596-1230039377=:4817--
