From: Luca Berra <bluca@comedia.it>
Subject: Re: Partitions with == or \approx same size ?
Date: Sat, 21 Jul 2007 11:25:08 +0200
Message-ID: <20070721092507.GC18424@percy.comedia.it>
References: <Pine.LNX.4.58.0707201908020.30683@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707201908020.30683@ybpnyubfg.ybpnyqbznva>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 20, 2007 at 07:54:54PM +0200, Seb wrote:
>
>Dear all,
>
>
>First I'd like to thank you for the great work you've done with mdadm.
>It's flexible, powerful and reasonably easy to use.
>
>I have a question that seems both important for the redundancy of my R=
AID6
>devices and too sharp for me, my friends and the newsgroup
>fr.comp.stockage . I think your understanding of the inner workings of
>mdadm should allow you to already know the answer.
>
>A 12-disks machine was recently assembled with disks coming from sever=
al
>sources (Linux Ubuntu server, kernel 2.6.15, RAID6 array). All 12 disk=
s
>are S-ATA with 250=A0GB capacity.
>
>I understand that partitions should have the same size, meaning the sa=
me
>number of bytes. All 12 disks have exactly 250059350016 bytes, but the
>number of blocks that can be allocated are not the same from one disk =
to
>another, ranging from 244196001 to 244198384. Small difference, but
>significant nonetheless if this means that data can be lost. So I look=
ed
>for a number of blocks that would be the same for all disks. But the
>number of blocks cannot be imposed when creating a partition, only the
>number of cylinders.

since we are living with machines based on a 1980 design,
the usable size of a partitioned device is rounded to disk geometry,
and geometry is read from the partition table (if there is one)
oh, geometry has no real meaning in modern disk drives.


>On the disks with 244196001 blocks, 'fdisk -l' says:
>	Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
this disk has 255 head and 63 sectors per track
usable space is
int(size/H/S/512)*H*S*512-S*512   # the subtraction here is to account
                                  # for space used by partition table
int (250059350016/255/63/512) =3D 30401
30401*255*63*512-63*512 =3D 250056705024
250056705024 / 1024 =3D 244196001 *BINGO*

>For the other half, it says:
>	Units =3D cylinders of 2048 * 512 =3D 1048576 bytes
this one might be 128H 16S, or any other combination for that matter,
let's see
int (250059350016/1048576) =3D 238475
238475 * 1048576 =3D 250059161600
your resulting space is 244198384K
244198384 * 1024 =3D 250059145216
250059161600 - 250059145216 =3D 16384 (space used by partition)
16384k is 32 sectors...
so geometry for this one is 238475 Cyl, 64 Heads, 32 Sectors

best thing you can do is make all disk have the same apparent geometry.
usually if you zap partition tables and reboot all disks should come up
with similar geometry.
another issue is to partition your drives with sfdisk, using -C, -H, -S
options to force a geometry.

L.


--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
