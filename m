From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Building new RAID5 results in removed and failed devices
Date: Thu, 24 Jun 2010 22:38:48 +0100
Message-ID: <20100624213848.GA17419@cthulhu.home.robinhill.me.uk>
References: <4C23BF79.2070009@gmx.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C23BF79.2070009@gmx.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jun 24, 2010 at 10:26:33PM +0200, Markus Krainz wrote:

> 1. I delete my old array md0
> 2. Then I create a new one as md1
> 3. The new md1 is not ok and shows removed, faulty and spare devices.
> 5. I tried this serveral times now, but i always get the same issue.
>=20
> I am at my wits end and would very much appreciate your advice. Thank=20
> you in advance.
>=20
<--snip-->
>      Number   Major   Minor   RaidDevice State
>         0       8       49        0      active sync   /dev/sdd1
>         2       8       17        1      spare rebuilding   /dev/sdb1
>=20
<--snip-->
>         2       8       17        -      spare   /dev/sdb1
>         3       8       49        -      faulty spare   /dev/sdd1
>=20
Looks like it started doing the initial synchronisation as normal, but
hid a read error on sdd1 which caused the array to fail.  sdd1 is left
as faulty, and sdb1 is spare as the rebuild didn't complete.  I'd
recommend testing sdd1 (SMART tests, read tests, write tests) before
trying to use it any further.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkwj0GgACgkQShxCyD40xBKOFACfe0od5/mV2kPnfyPOGRT6G7tD
RJoAoKEjNhWKTzSAcg55hClnRK3z/Si6
=cEfm
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
