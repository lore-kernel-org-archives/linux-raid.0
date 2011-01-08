From: Matthew Gabeler-Lee <cheetah@cheetah.fastcat.org>
Subject: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sat, 8 Jan 2011 17:53:07 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org> <4D274FF9.8010004@gmail.com> <alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org> <4D285B79.9040100@gmail.com>
Reply-To: Matthew Gabeler-Lee <cheetah@cheetah.fastcat.org>, 597563@bugs.debian.org
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1371069890-1362913481-1294527255=:14736"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.597563.B597563.12945272607064@bugs.debian.org>
In-Reply-To: <4D285B79.9040100@gmail.com>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Vladimir =?UTF-8?Q?'=CF=86-coder/phcoder'?= Serbinenko <phcoder@gmail.com>
Cc: 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1371069890-1362913481-1294527255=:14736
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 8 Jan 2011, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:

> As was recommended I forward the remaining part to linux-raid mailing lis=
t.
> In short: on his system mdraid, raid5, 4 devices, metadata (presumably)
> 0.90, two devices have index 0.
> If such situation is valid please advice me on how such situation should
> be handled.
> @Matthew: could you supply mdadm -Q outputput and *last* 64K of every dis=
k?

$ sudo mdadm -QD /dev/md2
/dev/md2:
         Version : 0.90
   Creation Time : Mon Mar 27 14:04:18 2006
      Raid Level : raid5
      Array Size : 2185667136 (2084.41 GiB 2238.12 GB)
   Used Dev Size : 728555712 (694.80 GiB 746.04 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Sat Jan  8 17:40:20 2011
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 01e2f978:88d1f867:34e1e46c:f3c01470
          Events : 0.32040050

     Number   Major   Minor   RaidDevice State
        0       8       35        0      active sync   /dev/sdc3
        1       8       19        1      active sync   /dev/sdb3
        2       8        3        2      active sync   /dev/sda3
        3       8       51        3      active sync   /dev/sdd3

The actual last 64k of all the partitions in the array is all zeros.=20
So is the 64k up to the end of the "Used Dev Size".  What has some data=20
in it is the 64k after that.  I hope that has the superblock data I=20
presume you're looking for.  I.e.  dd if=3D/dev/sdX3 bs=3D1024=20
skip=3D728555712 count=3D64.

--=20
 =09-Matt
"Reality is that which, when you stop believing in it, doesn't go away".
                 -- Philip K. Dick
GPG pubkey fingerprint: A57F B354 FD30 A502 795B 9637 3EF1 3F22 A85E 2AD1
---1371069890-1362913481-1294527255=:14736
Content-Type: APPLICATION/octet-stream; name=last64k.tar.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1101081753070.14736@cheetah.fastcat.org>
Content-Description: 
Content-Disposition: attachment; filename=last64k.tar.bz2

QlpoOTFBWSZTWc8QUogACmB/3//ADkpoWf+EBEcAVH7u3kQAUAApQABABKAA
dGAJfMAB/AABw00wQyGmmRkwgGmgDCaNMmABA0OGmmCGQ00yMmEA00AYTRpk
wAIGhw00wQyGmmRkwgGmgDCaNMmABA0CpIiIyjU8U8TSMPUNRkYGQDQaGiaN
N6oeyp3Nc5jBMTeijKZdg4+U0nlMZ16M2qcWgtukxmbMYTKVERiURCSpSVjN
+KOkdOPCcEcUYxMRWzJuGUq1rl4vF4yRhFIqEcBQgQ+Pw57xm/Xu96sIzC5v
N9R19oyReKRO5RKKiQDTJgdmXjlP9ylyjSck8+EMhksksWyC8J4TkNsukqsK
SdBqtE+RUceibsc8YRvcdo850dEw5z2G8dkqM51mybqB7D26DakmCopki0Wt
F7GjtReLsM+gxSjLGHv5vh8csY545knQbmGO4xi0VLZy/JCjaNs2y7GOYqSj
WWSbWxJ1IWvVe638npfR9TunC6j5mYnDDUXPy/7xTSfY7w/sbJ0ozn1P6lp8
jCH3j7bA4Ib6o+8b549RXpNNqnTNJUazUeY5TVOI4U/DGTVlNmaSjUVJEkk1
muFp/4u5IpwoSGeIKUQA

---1371069890-1362913481-1294527255=:14736--
