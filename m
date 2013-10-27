From: NeilBrown <neilb@suse.de>
Subject: Re: changing parameters of a running array?
Date: Mon, 28 Oct 2013 10:02:39 +1100
Message-ID: <20131028100239.082b5c0d@notabene.brown>
References: <526A2034.2050103@msgid.tls.msk.ru>
	<20131025111248.8fcd1cb5912e51c54f67f733@bbaw.de>
	<526D4D26.90808@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t1Kd_rEgAsYZWI=ro4zpdEa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526D4D26.90808@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/t1Kd_rEgAsYZWI=ro4zpdEa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Oct 2013 21:28:06 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> 25.10.2013 13:12, Lars T=C3=A4uber wrote:
> > Hi Michael,
> >
> > Fri, 25 Oct 2013 11:39:32 +0400
> > Michael Tokarev <mjt@tls.msk.ru> =3D=3D> linux-raid <linux-raid@vger.ke=
rnel.org> :
> >> Hello.
> >>
> >> Is there a way to change some parameters - like preferred minor,
> >> array name, homehost, guuid and the like - of a _running_ array?
> >> I understand these can be changed using --assemble --update=3Dfoo,
> >> but how about, say, root array which is being assembled from
> >> within an initrd with limited functionality?
> >>
> >> What I'm trying to achieve is to make a clone of a (remote)
> >> running system, in order to upgrade hdds.  For this, a new
> >> set of drives are inserted, new set of filesystems is created,
> >> current filesystems are copied to new hdds and on the next
> >> reboot the system should boot from the new hdds.  But since
> >> I can't create arrays with the same names/minors as currently
> >> running ones, and I want to preserve the naming scheme, I
> >> need to ensure the new arrays will be named correctly after
> >> the reboot.  But since the system is remote, this is a bit
> >> difficult to achieve for the root device.
> >>
> >> And similarly, I can't --update a NON-running array without
> >> --assemble, so I can't fix the names before reboot while the
> >> old arrays are still running.
> >>
> >> Maybe the easiest way is to write a small (perl) program
> >> which will read the superblock of a non-running array, update
> >> it and write it back.  This at least will allow me to perform
> >> tasks before reboot.  But this way it becomes risky - if the
> >> first reboot will happen with the old drives still in place,
> >> havoc might happen, since more than one array will have the
> >> same name...
> >>
> >> So a better route will be to create new arrays with temp
> >> names, reboot, change names on the newly running system,
> >> and remove old arrays.  The question is how to change
> >> some params on a running system.
> >>
> >
> > it depends on the distribution you're running. But you might not need t=
o change these parameters while the system is running.
>=20
> It doesn't.  One thing is the name forcible used to assemble
> an array -- this one indeed depends on the initrd/initramfs
> in use.  And another thing is the name recorded in the array
> superblock -- this does not and should not chage behind my
> back.  It should only change explicitly.  And that's exactly
> what I'm talking about -- how to explicitly change some
> params when the array is in use.

I'm sorry but that isn't possible.  The only options I can think of are:
 - boot of some other media and then update the metadata
 - hack the initrd to assemble with --update=3D to update whatever  needs
   updating.

NeilBrown

--Sig_/t1Kd_rEgAsYZWI=ro4zpdEa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUm2bjznsnt1WYoG5AQJ/NBAAneWqfM9mVLU7Zg6xRim5b7n1i387bvzg
5IYxVrA0jamChO4zw/h9SzjaXJAiz8BQg9Hpy0nsHCW+baaY8LeBUTSwc6G1iHrX
LbD/rDyPKNQpMSWP3vToicPOOBV6cEl2JYhqvnWjJ5LbD/mIGpDIpBBEjCqigPHU
WubEVaRXT0JGBeKv+5mIodMVW9U1CG2tNa211FNh1w3fEo49XIEJwaNTr+lSOA5O
/uJ8cTD3J9KupqFYpfF+PRHwZCqR7MZpK8GbKeRLxVgtE7BQ/tRQYL46O0IWKCdQ
+behORkQqkjzVCkQOA/a5XW5I/4r+1o78lgNS9LKrvtmqaTTukJ4IRyk93Twmuys
HZIG5+2ldT6ZwkPoFsv7G7lYfvUqXpNGEhxmSxRpgyUPBFtq07X4H4MITQ6a42FV
su/rJ5zvCtrMO4mMODqqO+VeA0aXD1MU086StF3aYPV5QaZbewB32mJYbiMYDvlp
JcDwoMmugNEva5hY4VEb4LFL78ZKoy2pXn+kHVOkudBmeG70lyzXvKqO6ulriEK6
y3/uox5ox+bMPM8t7xxRiXYnB/Wopu2XSfElDEXM0wIJEylAGX8AhyFow1l9PsY0
gPiPekOk7NQmiMJDA6QdvkR4PPN4waAvEp8dmyds6amOVKYCJ3gIRtMDPjir9zDh
03982PzyEds=
=bZoM
-----END PGP SIGNATURE-----

--Sig_/t1Kd_rEgAsYZWI=ro4zpdEa--
