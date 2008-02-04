From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid1 or raid10 for /boot
Date: Mon, 4 Feb 2008 09:17:35 +0000
Message-ID: <20080204091735.GA30156@cthulhu.home.robinhill.me.uk>
References: <20080204063454.GA31046@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080204063454.GA31046@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Feb 04, 2008 at 07:34:54AM +0100, Keld J=F8rn Simonsen wrote:

> I understand that lilo and grub only can boot partitions that look like
> a normal single-drive partition. And then I understand that a plain
> raid10 has a layout which is equivalent to raid1. Can such a raid10
> partition be used with grub or lilo for booting?
> And would there be any advantages in this, for example better disk
> utilization in the raid10 driver compared with raid?
>=20
A plain RAID-10 does _not_ have a layout equivalent to RAID-1 and
_cannot_ be used for booting (well, possibly a 2-disk RAID-10 could -
I'm not sure how that'd be layed out).  RAID-10 uses striping as well as
mirroring, and the striping breaks both grub and lilo (and, AFAIK, every
other boot manager currently out there).

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHptguShxCyD40xBIRAtoSAJ4hl0kmmq/C6GWYKmthKlA6p/DhvACdEsdB
ANDBlznN/WY3Nv9AxESw9qs=
=LV6N
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
