From: "David Lethe" <david@santools.com>
Subject: RE: Distributed spares
Date: Tue, 14 Oct 2008 08:20:50 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C0244733C@34093-C3-EVS3.exchange.rackspace.com>
References: <48F3C2A1.3080607@tmr.com><alpine.DEB.1.10.0810131810570.16807@p34.internal.lan><a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com><20081013232921.GB22265@rap.rap.dk> <yq11vyjcwoi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <yq11vyjcwoi.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, =?iso-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Billy Crook <billycrook@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Tuesday, October 14, 2008 5:12 AM
> To: Keld J=F8rn Simonsen
> Cc: Billy Crook; Justin Piszcz; Bill Davidsen; Neil Brown; Linux RAID
> Subject: Re: Distributed spares
>=20
> >>>>> "Keld" =3D=3D Keld J=F8rn Simonsen <keld@dkuug.dk> writes:
>=20
> Keld> I have also been thinking a little on this. My idea is that if
> Keld> bit errors develop on disks, then there is first maybe one bit
> Keld> error, and the crc check on the disk sectors then finds and
> Keld> corrects these.
>=20
> Keld> If you rewrite such bit errors, then that bit error will be
> Keld> corrected, and you prevent the one-bit error from developing to
> Keld> a two-bit error that is not correctable by the CRC.
>=20
> I think you are assuming that disks are much simpler than they
> actually are.
>=20
> A modern disk drive protects a 512-byte sector with a pretty strong
> ECC that's capable of correcting errors up to ~50 bytes.  Yes, that's
> bytes.
>=20
> Also, many drive firmwares will internally keep track of problematic
> media areas and rewrite or reallocate affected blocks.  That includes
> stuff like rewriting sectors that are susceptible to bleed due to
> being adjacent to write hot spots.
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Martin is absolutely correct.  Enterprise class drives have come a long=
 way. They will scan and
fix blocks (but certainly not 100% of them) in background.  The $99 dis=
k drives you get at
the local computer retailer now even have limited BGMS / repair capabil=
ity.

If you run the built-in diags on disk drives, you can be presented with=
 a list of known bad blocks,
or when you boot a disk drive, sometimes you can get a bad block displa=
y in POST.

How about a baby step?  When you run offline or online tests, or even w=
hen you run media scans,
you get a list of known defects.  How about a program that rewrites a R=
AID1/3/5/6 stripe, and
you just pass it the physical device name and known block number?   =20

As for checking out a disk ..

The prior poster's idea about putting the RAID in degraded mode for pur=
poses of checking out a disk is,=20
=46rankly, nuts. NEVER degrade anything.   Just use the hotspare and do=
 a hot clone of the disk in question
to the hotspare, then make that disk the new hot spare and repeat..

Equate this to a "Rotating the Tires" mode.

David @ santools com
http://www.santools.com/smart/unix/manual

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
