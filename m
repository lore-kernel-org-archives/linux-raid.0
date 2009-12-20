From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Booting from RAID1
Date: Sun, 20 Dec 2009 09:37:44 -0600
Message-ID: <67.C8.01567.DC44E2B4@cdptpa-omtalb.mail.rr.com>
References: <4877c76c0912200115q4c91512cj119ff23f7d662d16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912200115q4c91512cj119ff23f7d662d16@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Evans' <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >> Oh, and you'll also very likely want grub to read the /boot
> >> filesystem, which is why it must be on a partition followed by the
> >> raid header, instead of a partition containing a raid header and r=
aid
> >> protected partition. =A0That use is OK since grub operates read-on=
ly.
> >
> > =A0 =A0 =A0 =A0I think I follow you, here. =A0IOW, partition the dr=
ive, create the
> md
> > target, and then format the RAID array, right? =A0Or are you saying=
 one
> should
> > format the partition and then create the RAID array on top of it?
> >
> >
>=20
> It works much more cleanly if you create the RAID array first, and
> then use the container it provides;=20

	Now I definitely don't follow you.  Are you saying one should create
an array from the raw drive, partition it, format the first partition, =
then
create secondary arrays from the second and third partition, and finall=
y
format the second and third array?

> this way the end of your file-system does not overlap the raid super-
> block.

	I can follow that - there's a danger of wiping or moving the mdadm
superblock if it is contained in the filesystem, but it seems to me
partitioning the drive and then creating the array from a partition, as=
 I
first suggested, will accomplish that just fine.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
