From: Andre Noll <maan@systemlinux.org>
Subject: Re: Redundancy check using "echo check > sync_action": error reporting?
Date: Thu, 20 Mar 2008 18:39:06 +0100
Message-ID: <20080320173906.GN32242@skl-net.de>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dPW7zu3hTOhZvCDO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080320163551.GG13719@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Cc: Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--dPW7zu3hTOhZvCDO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:35, Theodore Tso wrote:

> If a mismatch is detected in a RAID-6 configuration, it should be
> possible to figure out what should be fixed

It can be figured out under the assumption that exactly one drive has
bad data and all other ones have good data. But that seems to be an
assumption that is hard to verify in reality.

> Out of curiosity, does md do this automatically, either
> when reading from a stripe, or during a resync operation?

Nope, md does no such thing.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--dPW7zu3hTOhZvCDO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH4qE6Wto1QDEAkw8RAlBmAJ9drNoO61HvOgPY0UY84GhmhQXeAgCfScP8
c6n4NwijN+jRekoJAd5cANk=
=M9sG
-----END PGP SIGNATURE-----

--dPW7zu3hTOhZvCDO--
