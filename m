From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Thu, 30 Jul 2009 08:35:54 +0100
Message-ID: <20090730073554.GA17665@cthulhu.home.robinhill.me.uk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jul 29, 2009 at 11:25:47PM -0700, Tirumala Reddy Marri wrote:

> Hi,
>   I have two 1 tera byte disks in RAID-1 configuration. When I started
> RAID-1 array initial speed was 100MBps by the time it finishes the speed
> was <50MBps. Is there is any reason for this behavior ? Isn't speed
> supposedly uniform.=20
>=20
No, the speed isn't uniform - it varies across the disk.  The
_rotational_ speed is fixed (probably 7200 rpm), but that means the
outer tracks are passing at a higher _linear_ speed (i.e. in a single
rotation, there's more disk passing across the read head), so have a
higher transfer rate.  Hard drives start writing from the outside, so
the speed drops off as you progress.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpxTVkACgkQShxCyD40xBKVNQCZAcr+0uD0DanriFxIYgbXSySN
/yAAoIDBwZfDqrFUktZBi/fD7cHX3kB6
=XQfx
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
