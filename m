From: Ragnar =?iso-8859-15?Q?Kj=F8rstad?= <kernel@ragnark.vestdata.no>
Subject: Re: Questions about LARGE, RAID storage under Linux
Date: Wed, 21 May 2003 15:41:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030521134120.GQ7706@vestdata.no>
References: <S263852AbTETQCk/20030520160240Z+2889@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <S263852AbTETQCk/20030520160240Z+2889@vger.kernel.org>
To: "Michael S. Peek" <peek@tiem.utk.edu>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, peek@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 20, 2003 at 12:15:39PM -0400, Michael S. Peek wrote:
> I am looking at using a hardware RAID device that appears to it's SCS=
I host as
> a single large drive.  I am well aware that I can break this device d=
own into
> multiple LUNS, but if possible I need to keep it as one big drive.  I
> understand from the Linux Info Sheet, last updated in 1998 according =
to it's
> text, that Linux is able to handle partitions up to 4TB in size.

What is the Linux Info Sheet?

AFAIK linux has never had a partition-limit of 4 TB.
There is a limit in any block-device of 2^32 sectors, typically 2 TB.
Some drivers may have sign-issues, leaving you with only 2^31 sectors (=
1
TB).


> What I want to know is:
>=20
> (a) Is 4TB still the maximum limitation on a single partition size?  =
If not,
> what is the current maximum?
>=20
> (b) Would this maximum partition size still apply when using the soft=
ware RAID
> tools to combine two or more of these devices together?

I believe the 2.4 kernel is still limited to 2 TB for both scsi-devices
and virtual block-devices such as md or lvm.

I think 2.5 has an option added for large block devices. This should
allow you to use both scsi-devices and md virtual devices larger than
2TB. It may depend on changes in the actual scsi-drivers, so possible i=
t
only works for a subset of scsi-adapters. Last time I checked it didn't
enable larger LVM-volumes, so you're limited to md for virtual devices.

> What I am looking for is the ability to mount and format an external =
SCSI
> device that's 3.5TB in size.  (It's a Promise UltraTrak RM1500 w/ 15 =
x 250GB
> drives).  I want to be able to upgrade the hard drives at a later dat=
e and
> know that the Linux box to which it is attached will still be able to=
 handle
> them.  Ideally, I would like to purchase a second (or even a third) d=
evice
> later down the road and use software RAID to concatenate them togethe=
r.

I think you would want to use LVM to concatenate them together, and
AFAIK that is not yet possible. There is work in progress though.

I think your best chances of making this work in the future without
having to reformat your system is to use LVM2 with a large physical
extentsize from the start.


My information may be out of date, so take this with a grain of salt.


--=20
Ragnar Kj=F8rstad
Zet.no
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
