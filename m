From: Nifty Fedora Mitch <niftyfedora@niftyegg.com>
Subject: Re: RAID5 reconstruction ?
Date: Mon, 8 Jun 2009 21:13:46 -0700
Message-ID: <20090609041346.GA2966@tosh2egg.wr.niftyegg.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com> <921ca19c0905300552g7697e4c6of8c357d9b456ad0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <921ca19c0905300552g7697e4c6of8c357d9b456ad0d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: SandeepKsinha <sandeepksinha@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, May 30, 2009 at 06:22:40PM +0530, Sujit Karataparambil wrote:
>=20
> Are you talking about hardware raid or software raid.
>=20
> I donot think hardware raid can by itself do much of the
> book keeping.
>=20
> Software Raid I think is different from having raid 0 to raid 1
> to raid 2 to raid 3 to raid 4 to raid 5.
>=20
> hope this is correct information.
>=20
> Thanks,
>=20
>=20
> On Sat, May 30, 2009 at 11:14 AM, SandeepKsinha <sandeepksinha@gmail.=
com> wrote:
> > Hi all,
> >
> > Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
> >
> > I have data of 5GB. When a disk fails and replaced with a spare dis=
k.
> > Will the reconstruction happen only for the 5GB allocated disk bloc=
ks
> > or it will happen for the whole disk size.
> >
> > Is it possible to make =A0reconstruction intelligent enough to keep=
 it optimized ?
> >
> > Sandeep.

Sandeep,

It might help if you think of your 50GB raid as a single disk with
special properties of redundancy and management.   A single disk has no
"knowledge" about the file system it contains.   As such it will not
know anything about the file system data allocation and will be "dumb"
in terms of what blocks/ stripes/ whatever  it needs to reconstruct/
repair itself with relation to the file system.

It is possible that unallocated file system regions will still be zeroe=
d
blocks and recovery is quick.  It is also possible that the RAID data
structures will remember if it has been read or written to and needs to
be recovered/ initialized.

To the best of my knowledge RAID-N from vendor to vendor; hardware .vs.=
 software
only defines the type and general patterns of redundancy.   I.E. I do
not expect that I can pull a disk set from one raid vendor and expect
another vendor to understand  and present the logical blocks in the=20
same identical way.

To set expectations the recovery of a 50GB RAID with 0.1 GB of data=20
in its file system or with 45GB of data in its filesystem will
be the same unless the specific RAID implementation keeps a score card.
More apropos the RAID does not know anything special except at initiali=
zation --
and an old RAID incontrast to a new filesystem will want to recover the
entire RAID (itself) knowing nothing about the history of the filesyste=
ms
it contains.

Others may be able to add more details for your specific RAID.

--=20
	T o m  M i t c h e l l=20
	Found me a new hat, now what?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
