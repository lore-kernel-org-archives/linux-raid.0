From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm problem
Date: Mon, 06 Dec 2004 10:14:40 +0000
Message-ID: <41B43110.3020101@dgreaves.com>
References: <41B42870.7050207@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41B42870.7050207@skynet.be>
Sender: linux-raid-owner@vger.kernel.org
To: jym@skynet.be
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jean-Yves Mert=E8s wrote:

> Hello!
>
> I do not know if I may receive any support about mdadm through this=20
> e-mail address. If not, please, could you forward this message to the=
=20
> appropriate box if one exists.
>
> I am currently trying to migrate a Linux partition (Mandrake 10) to=20
> RAID 1. To this purpose I have installed mdadm V1.8.1.

This is an experimental version:

This is a "development" release of mdadm.  It should *not* be
considered stable and should be used primarily for testing.
The current "stable" version is 1.8.0.


> The first attempt was to configure an equally-sized partition of my=20
> second disk (/dev/hdb) as part of a degraded RAID 1 device.=20
> Unfortunately, starting the array fails. The following shows pieces o=
f=20
> information that should help  understanding the case:
>
> The command I use is:
> mdadm -C /dev/md0 --metadata=3D1 --level=3Draid1 --raid-devices=3D2 m=
issing=20
> /dev/hdb5 -v
>
> To which mdadm answers:
> mdadm: /dev/hdb5 appears to contain an ext2fs file system
>    size=3D4843912K  mtime=3DThu Dec  2 17:11:54 2004
> mdadm: /dev/hdb5 appears to be part of a raid array:
>    level=3D1 devices=3D2 ctime=3DSat Dec  4 18:28:46 2004
> mdadm: size set to 4843904K
> Continue creating array? y
> VERS =3D 9000
> mdadm: ADD_NEW_DISK for /dev/hdb5 failed: Invalid argument

_possibly_ because

Version 1 superblocks requires 2.6.10 or a recent 2.6.10-rc snapshot


Try agin with 1.8.0 and if you have probs then yell :)

HTH
David
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
