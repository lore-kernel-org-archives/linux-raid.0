From: Derek Vadala <derek@cynicism.com>
Subject: Re: just how dangerous is this??
Date: Tue, 28 May 2002 17:55:07 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0205281741370.18572-100000@gecko.roadtoad.net>
References: <20020528215101.E20621@unthought.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020528215101.E20621@unthought.net>
To: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Cc: Danilo Godec <danci@agenda.si>, James Fillman <jfillman@cucbc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 May 2002, [iso-8859-1] Jakob =D8stergaard wrote:

> Either it reconstructs it "right" or it does it "wrong".  It seems in
> his case it did it right.  Lucky him.
>=20
> Hoever, the persistent superblocks will overwrite the last few KB of =
his
> *filesystem* on each partition.   So things *may* seem to work, but t=
he
> system will fail horribly later.  After an fsck the RAID suprblocks w=
ill
> be damaged.  After another mkraid the filesystem will be damaged agai=
n.

You should be able to pre-plan by creating initial ext2 file systems th=
at
are smaller than the partition size. You can do this by specifying the
number of blocks in the file system when you run mke2fs.=20

mke2fs [options] device blocks

You should be able to calculate the eventual location of the md superbl=
ock
and select an appropriate block size for each partition to insure that =
the
superlbock and the filesystem do not overlap.=20

Even if you've had sucess thus far, it's likely that problems will aris=
e
as the filesystem fills up-- when the last blocks are allocated, and th=
ey
overlap the md superblock.

This probably isn't worth the effort unless you are doing multiple
installs with the same partition layout and hardware, but it seems that=
 it
might be the case here.

I think the formula should be something like:

blocks - (blocks % 64) - 64 =3D md offset

That's for 1k blocks... ( like from fdisk -l)

I'm a bit lazy to double check, but I think that formula works.

Then when creating a filesystem divide by block size and create a file
system that's the right size...=20

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
