From: Seb <seb@h-k.fr>
Subject: Partitions with == or \approx same size ?
Date: Fri, 20 Jul 2007 19:54:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0707201908020.30683@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Dear all,


=46irst I'd like to thank you for the great work you've done with mdadm=
=2E
It's flexible, powerful and reasonably easy to use.

I have a question that seems both important for the redundancy of my RA=
ID6
devices and too sharp for me, my friends and the newsgroup
fr.comp.stockage . I think your understanding of the inner workings of
mdadm should allow you to already know the answer.

A 12-disks machine was recently assembled with disks coming from severa=
l
sources (Linux Ubuntu server, kernel 2.6.15, RAID6 array). All 12 disks
are S-ATA with 250=A0GB capacity.

I understand that partitions should have the same size, meaning the sam=
e
number of bytes. All 12 disks have exactly 250059350016 bytes, but the
number of blocks that can be allocated are not the same from one disk t=
o
another, ranging from 244196001 to 244198384. Small difference, but
significant nonetheless if this means that data can be lost. So I looke=
d
for a number of blocks that would be the same for all disks. But the
number of blocks cannot be imposed when creating a partition, only the
number of cylinders.

On the disks with 244196001 blocks, 'fdisk -l' says:
	Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

=46or the other half, it says:
	Units =3D cylinders of 2048 * 512 =3D 1048576 bytes

Since 16065 and 2048 have no common divisor, the smallest multiple comm=
on
to 8225280 and 1048576 is 8225280 =D7 1048576 / 512 =3D 16845373440. Th=
us
trying to have exactly the same number of bytes in each partition means
choosing a partition size that is a multiple of roughly 16=A0GB. Now th=
e
total size (250059350016) divided by this step (16845373440) is roughly
14.84. I can only have 14 steps, leading to a partition size of
235835228160 and a loss of \approx 15 GB per disk or 150=A0GB total. Th=
at's
a lot.


Now I imagine that there might be embedded in mdadm a correction
mechanism. Since each partition is divided into stripes, the number of
stripes for each disk could be the number of stripes on the smallest
partition of the array. Thus I could create partitions as big as each d=
isk
supports, and 'mdadm' would take care of the small differences. I'd hav=
e
my 150=A0GB back.

Could you tell me if such a mechanism exists in mdadm?
Or should I accept the "loss" of the 150 GB?


Thanks a lot for your help!
S=E9bastien.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
