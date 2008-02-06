From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 06 Feb 2008 11:11:51 +0100
Message-ID: <47A987E7.9000902@rabbit.us>
References: <200802051142.19625.admin@domeny.pl> <18344.49968.584648.904844@notabene.brown> <200802061055.03979.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802061055.03979.admin@domeny.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marcin Krol wrote:
> Tuesday 05 February 2008 21:12:32 Neil Brown napisa=C5=82(a):
>=20
>>> % mdadm --zero-superblock /dev/sdb1
>>> mdadm: Couldn't open /dev/sdb1 for write - not zeroing
>> That's weird.
>> Why can't it open it?
>=20
> Hell if I know. First time I see such a thing.=20
>=20
>> Maybe you aren't running as root (The '%' prompt is suspicious).
>=20
> I am running as root, the "%" prompt is the obfuscation part (I have
> configured bash to display IP as part of prompt).
>=20
>> Maybe the kernel has  been told to forget about the partitions of
>> /dev/sdb.
>=20
> But fdisk/cfdisk has no problem whatsoever finding the partitions .
>=20
>> mdadm will sometimes tell it to do that, but only if you try to
>> assemble arrays out of whole components.
>=20
>> If that is the problem, then
>>    blockdev --rereadpt /dev/sdb
>=20
> I deleted LVM devices that were sitting on top of RAID and reinstalle=
d mdadm.
>=20
> % blockdev --rereadpt /dev/sdf
> BLKRRPART: Device or resource busy
>=20
> % mdadm /dev/md2 --fail /dev/sdf1
> mdadm: set /dev/sdf1 faulty in /dev/md2
>=20
> % blockdev --rereadpt /dev/sdf
> BLKRRPART: Device or resource busy
>=20
> % mdadm /dev/md2 --remove /dev/sdf1
> mdadm: hot remove failed for /dev/sdf1: Device or resource busy
>=20
> lsof /dev/sdf1 gives ZERO results.
>=20

What does this say:

	dmsetup table

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
