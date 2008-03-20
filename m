From: Andre Noll <maan@systemlinux.org>
Subject: Re: Redundancy check using "echo check > sync_action": error reporting?
Date: Thu, 20 Mar 2008 19:57:05 +0100
Message-ID: <20080320185705.GH29734@skl-net.de>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <20080320173906.GN32242@skl-net.de> <20080320180241.GJ13719@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrvsYIebpInmECXG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080320180241.GJ13719@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Cc: Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--lrvsYIebpInmECXG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:02, Theodore Tso wrote:
> On Thu, Mar 20, 2008 at 06:39:06PM +0100, Andre Noll wrote:
> > On 12:35, Theodore Tso wrote:
> >=20
> > > If a mismatch is detected in a RAID-6 configuration, it should be
> > > possible to figure out what should be fixed
> >=20
> > It can be figured out under the assumption that exactly one drive has
> > bad data and all other ones have good data. But that seems to be an
> > assumption that is hard to verify in reality.
>=20
> True, but it's what ECC memory does.  :-)   And most people agree that
> it's a useful thing to do with memory. =20
>=20
> If you do ECC syndrome checking on every read, and follow that up with
> periodic scrubbing so that you catch (and correct) errors quickly, it
> is a reasonable assumption to make.
>=20
> Obviously a warning should be given when you do this kind of ECC
> fixups, and if there is an increasing number of ECC fixups that are
> being done, that should set off alarms that maybe there is a hardware
> problem that needs to be addressed.

I agree, but not everybody likes the idea to do this kind of error
correction also for hard disks in raid6 [1]. In case of a hard power
failure it may well happen that any given subset of the disks in
the array is up to date and all others are not. So in practice the
situation for hard disks is different from memory modules.

OTOH, it's probably the best thing one can do, so I'd vote for
implementing this feature.

Andre

[1] http://www.mail-archive.com/linux-raid@vger.kernel.org/msg09863.html
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--lrvsYIebpInmECXG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH4rOBWto1QDEAkw8RAgDGAJ4lfQhHsNa+daDIzfrzJmm1ArUTTwCfXJOw
8b5KJ738G53IgPCXMife+6M=
=3yOe
-----END PGP SIGNATURE-----

--lrvsYIebpInmECXG--
