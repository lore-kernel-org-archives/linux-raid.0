From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID-5 degraded mode question
Date: Wed, 16 Dec 2009 21:12:38 +0000
Message-ID: <20091216211237.GA16981@cthulhu.home.robinhill.me.uk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7E75@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7E75@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 16, 2009 at 12:20:04PM -0800, Tirumala Reddy Marri wrote:

> All,
>   I have question on degraded mode RAID-5 operation md driver. If I
> understand reads from the degraded mode md would cause  parity
> calculations or rebuild of  data happens for every request.=20
>=20
For pretty much every read, yes - some will end up with all the data on
the remaining disks, but most will need to recalculate from parity.

>  Also as soon as disk failed md drivers marks that drive as faulty and
> continue operation in degraded mode right ? Is there a way to get out
> the degraded mode without adding spare drive. Assuming we have 5 disk
> system with one failed drive.
>=20
I'm not sure what you want to happen here.  The only way to get out of
degraded mode is to replace the drive in the array (if it's not actually
faulty then you can add it back, otherwise you need to add a new drive).
What were you thinking might happen otherwise?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkspTUUACgkQShxCyD40xBJg2gCgt+2xwdFx/AHU1MKd3Ja1AZeN
otAAnRM25OXRFy1tjueMIp4loOB6tNp7
=GRA0
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
