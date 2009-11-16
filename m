From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: best common practice in case of degraded array with read errors
Date: Mon, 16 Nov 2009 22:07:22 +0000
Message-ID: <20091116220722.GC14699@cthulhu.home.robinhill.me.uk>
References: <alpine.DEB.1.10.0911162224530.14550@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911162224530.14550@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Nov 16, 2009 at 10:32:30PM +0100, Mikael Abrahamsson wrote:

>=20
> Hello.
>=20
> I have a 6 drive raid5. One of the drives failed on me (totally), and whe=
n=20
> I replaced it (-add a new working drive) I had several sectors on another=
=20
> drive give me UNC errors, which made md kick that drive as well, and left=
=20
> me with a non-working array (with only 4 drives).
>=20
Are you running any regular array checks?  These should verify the
readability of the drives (and accuracy of the checksums).  This type of
failure's also why I've switched to RAID6 for most of my arrays.

> What is the best common practice to handle this scenario? Right now I'm=
=20
> dd_rescue:ing the drive with read errors to a (hopefully) working drive,=
=20
> and then when I plan to --assemble --force the array to get 5 working=20
> drives (with a few zero:ed sectors where I guess I'll have corrupted=20
> files, hopefully no important metadata), and then I plan --add a 6th driv=
e=20
> and have everything sync up and be back to "normal".
>=20
> Is there a better way? I don't really understand why kicking drives out o=
f=20
> the array when there aren't enough of them to keep going makes sense, is=
=20
> there some rationale I'm missing?
>=20
Technically, the best practice is probably to recreate the array from
scratch (replacing any failed drives) and restore from backup.  Short of
that, your approach would seem to be the best option.  I've done this in
the past, though I ended up restoring pretty much everything from backup
anyway (as I had no other way of verifying the integrity of the data).

> I've also heard recommendations to write to the bad sectors on the=20
> existing drive, but that scares me as well in case I write to the wrong=
=20
> place, which is why I went the dd_rescue route (I'm also hoping that it'l=
l=20
> retry a bit more and might be able to read the bad blocks...)
>=20
I'd leave that to later.  Once you've imaged the disk you can try
SMART tests, read/write tests, etc. to verify whether there's actually a
physical problem or not (and how much of one - a bad block or two might
be acceptable, but a lot of them would point to a failing disk).  Until
then you're better putting as little trust in the disk as possible.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksBzRkACgkQShxCyD40xBJ0gQCfcuy2+9U33IdGYyPi6Xm555Ob
27MAoK8AzPQf/0NLd99GptntwRC0JR3/
=XGYE
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
