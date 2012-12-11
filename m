From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: failed raid re-create changed dev size
Date: Tue, 11 Dec 2012 14:49:49 +0000
Message-ID: <20121211144949.GB28593@cthulhu.home.robinhill.me.uk>
References: <1355216495.50c6f66f123b1@mail.inbox.lv>
 <20121211092710.GA28593@cthulhu.home.robinhill.me.uk>
 <1355236515.50c744a3720c1@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355236515.50c744a3720c1@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 11, 2012 at 04:35:15PM +0200, Andris Berzins wrote:

> Quoting "Robin Hill" <robin@robinhill.me.uk>:
> >=20
> > You will likely have lost some data though, as the new superblocks will
> > have overwritten part of the data, so make sure you run a fsck
> > afterwards (start with fsck -n though, to make sure the overall array
> > looks okay first).
>=20
> Is it possible that no data was damaged? It is LUKS partition, i
> mapped it and run "fsck -n" on underlying ext3 partition,=20
> but fsck returned immediately with status "clean".
>=20
By default fsck will just check whether the filesystem is marked as
dirty/clean and just skip running if it's clean. You'll need to use "-f"
to force it to run.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDHSAwACgkQShxCyD40xBJPLwCg0aRooksZaOiZoiULgGY77qKE
NkoAn2R3zVkHJgTI95kr4+guRw3c36yk
=EdZB
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
