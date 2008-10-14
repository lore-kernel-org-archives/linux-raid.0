From: "David Lethe" <david@santools.com>
Subject: RE: Distributed spares
Date: Tue, 14 Oct 2008 10:18:26 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C02447570@34093-C3-EVS3.exchange.rackspace.com>
References: <2cda01c92e01$12827a4c$3e01a8c0@exchange.rackspace.com> <20081014143755.GB3689@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20081014143755.GB3689@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Billy Crook <billycrook@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Keld J=F8rn Simonsen [mailto:keld@dkuug.dk]
> Sent: Tuesday, October 14, 2008 9:38 AM
> To: David Lethe
> Cc: Martin K. Petersen; Billy Crook; Justin Piszcz; Bill Davidsen; Ne=
il
> Brown; Linux RAID
> Subject: Re: Distributed spares
>=20
> On Tue, Oct 14, 2008 at 08:30:00AM -0500, David Lethe wrote:
> >
> >
> > Good to know. Could yo tell me if this is actually true for normal
> > state-of-the art SATA disks, or only true for more expensive disks?
> > Do you have a good reference for it.
> >
> >
> > read the manual for any disk drive... They go into error detection,
> correction recovery algorithms and capability in  great detail.
>=20
> I don't get any manual when I buy a disk. Maybe you do - as you are
> doing raid systems for your work.
>=20
> I will see if I can dig upsome manuals on the net for the disks I hav=
e,
> just to have some sense of what is state-of-the art.
>=20
> best regards
> keld

The manuals are all online.  There are typically several to choose from=
=2E  Installation=20
Manuals are standard, but are pretty worthless.  Look for programming/i=
nterface specification
manuals.   They are not always online where you can find them easy, it =
depends on the manufacturer.

They're typically several hundred pages long.   Also firmware specifica=
tions go into algorithms
in great detail, but unless you have NDA then you won't get them.  (And=
 people like me who have NDAs,
are not allowed to share them).

In any event, manuals are important. They reveal such things like the d=
uty cycles for most of the
Consumer class disks you get with PCs & at the retails are 2400 hours. =
 i.e, 100 days x 24 hrs/day,=20
Unlike enterprise class disks that are rated for 24x7x5 years.   (So di=
sks are not all the same). Enterprise class
drives have more ECC bits and smarter algorithms for automated recovery=
, and extended online/offline diagnostic
capability.  Some drives also have a limited number of start/stop cycle=
s.   Choose disks wisely!

David



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
