From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Redundancy check using "echo check > sync_action": error
	reporting?
Date: Thu, 20 Mar 2008 17:10:38 +0000
Message-ID: <20080320171038.GD28114@cthulhu.home.robinhill.me.uk>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080320163551.GG13719@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 20, 2008 at 12:35:51PM -0400, Theodore Tso wrote:

> If a mismatch is detected in a RAID-6 configuration, it should be
> possible to figure out what should be fixed (since with two hot spares
> there should be enough redundancy not only to detect an error, but to
> correct it.)  Out of curiosity, does md do this automatically, either
> when reading from a stripe, or during a resync operation?
>=20
I'm not sure about during a read (though my understanding is that the
parity is entirely ignored here, so no checking is done in any RAID
configuration).

As for during resync, not as of last time this came up, no (I've not
looked at the code but Neil was certainly opposed to trying to do this
then).  The problem is that you can only (safely) do a repair if you
know _for a fact_ that only a single block is corrupt.  Otherwise
there's a reasonable chance of further corrupting the data by
"repairing" good blocks to match the bad.  The current md code just
recalculates both parity blocks.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH4pqOShxCyD40xBIRAnzgAKDMCHNXJPGtwAdSNhvXOlmRm/qMdgCfY/mv
zaN+IwTNPENrMCqkS4HDoPs=
=p/8+
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
