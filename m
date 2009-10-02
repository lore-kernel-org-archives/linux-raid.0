From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 16:59:19 +0100
Message-ID: <20091002155919.GB22207@cthulhu.home.robinhill.me.uk>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
 <887103.5263.qm@web38801.mail.mud.yahoo.com>
 <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
 <20091002151504.GA22207@cthulhu.home.robinhill.me.uk>
 <babafd2f0910020846o22e7dd30l4a7be554770d0904@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0910020846o22e7dd30l4a7be554770d0904@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Oct 02, 2009 at 08:46:47AM -0700, Ben DJ wrote:

> keld@dkuug.dk,robin@robinhill.me.uk
>=20
>=20
> Hi,
>=20
> 2009/10/2 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> > if the raid type happens to be the same layout as  a non-raid partition=
, it
> > works. raid10,n2 default layout (ver 0.90) is equivalent with non-raid,
> > as the raid superblock is in the end of the partition.
>=20
> That makes sense, thanks. Not clear whether that's "officially
> supported" or "just lucky".
>=20
> Just to be ccertain, which metadata version, 0.90(default) or 1.0?
> According to the man page,
>=20
> 	0, 0.90, default
> 		 Use  the original 0.90 format superblock.  This format limits
> arrays to 28 component devices and limits
> 		 component devices of levels 1 and greater to 2 terabytes.
>=20
> 	1, 1.0, 1.1, 1.2
> 		 Use the new version-1 format superblock.  This has few
> restrictions.  The different sub-versions  store
> 		 the  superblock  at  different  locations on the device, either at
> the end (for 1.0), at the start (for
> 		 1.1) or 4K from the start (for 1.2).
>=20
> it's v 1.0 that specifically states the super block is "at the end".
> Will either/both work?
>=20
Either 0.90 or 1.0 will work (both are held at the end)- 0.90 allows for
kernel auto-assembly, but is a legacy format.  Any modern Linux
distribution will use an initrd which can assemble arrays with any
superblock, so current advice would be to use 1.0.

> On Fri, Oct 2, 2009 at 8:15 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > The main reason is that RAID-1 works across any number of disks (as
> > they're all identical) whereas RAID-10,nX working is an artifact of how
> > that layout works for X drives (they end up being identical to RAID-1).
>=20
> As X is a variable, according to the man page,
>=20
>   "The number is the number of copies of each datablock.  2 is normal,
> 3 can be useful.
>    This number  can  be  at most equal to the number of devices in the
> array.  It does
>    not need to divide evenly into that number (e.g. it is perfectly
> legal to have an 'n2'
>    layout for an array with an odd number of devices)."
>=20
> does "RAID-10,nX working is an artifact" hold true for any X?
>=20
Yes - RAID-10,nX for X disks will result in (effectively) a RAID-1
layout.

> If I've a 4-drive RAID-10 array that I want to have a bootable-/boot
> on, should X best be "normmal" 2, "useful" 3, or "unmentioned" 4?  As
> usual it seems that performance, redundancy/robustness, and space
> utilization, as well as just being able to boot, all have a part to
> play.
>=20
For a boot partition I'd stick with RAID-1, then use RAID-10,f2 for
other partitions.  There's no real advantage in using RAID-10,n4 over
RAID-1 (it's a different code-path so there may be slight differences
one way or the other, but nothing that will matter for a boot
partition anyway), and just makes the setup more unusual.

It's up to you though - RAID-10,n4 and a four-way RAID-1 will have the
same on-disk layout, so either will work fine.  Oh - one other thing is
that RAID-1 is expandable (you can add other partitions later) whereas
RAID-10 is not currently.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrGI1cACgkQShxCyD40xBI1GQCcCth2bracdZz1jjFufRzI2oad
S3AAn1AH8E4IyT0Wi8w1TM4wGnuPSMnY
=3mla
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
