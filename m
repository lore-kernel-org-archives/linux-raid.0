From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 6 Feb 2008 10:55:03 +0100
Message-ID: <200802061055.03979.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <18344.49968.584648.904844@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18344.49968.584648.904844@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tuesday 05 February 2008 21:12:32 Neil Brown napisa=C5=82(a):

> > % mdadm --zero-superblock /dev/sdb1
> > mdadm: Couldn't open /dev/sdb1 for write - not zeroing
>=20
> That's weird.
> Why can't it open it?

Hell if I know. First time I see such a thing.=20

> Maybe you aren't running as root (The '%' prompt is suspicious).

I am running as root, the "%" prompt is the obfuscation part (I have
configured bash to display IP as part of prompt).

> Maybe the kernel has  been told to forget about the partitions of
> /dev/sdb.

But fdisk/cfdisk has no problem whatsoever finding the partitions .

> mdadm will sometimes tell it to do that, but only if you try to
> assemble arrays out of whole components.

> If that is the problem, then
>    blockdev --rereadpt /dev/sdb

I deleted LVM devices that were sitting on top of RAID and reinstalled =
mdadm.

% blockdev --rereadpt /dev/sdf
BLKRRPART: Device or resource busy

% mdadm /dev/md2 --fail /dev/sdf1
mdadm: set /dev/sdf1 faulty in /dev/md2

% blockdev --rereadpt /dev/sdf
BLKRRPART: Device or resource busy

% mdadm /dev/md2 --remove /dev/sdf1
mdadm: hot remove failed for /dev/sdf1: Device or resource busy

lsof /dev/sdf1 gives ZERO results.

arrrRRRGH

Regards,
Marcin Krol
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
