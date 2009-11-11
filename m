From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 09:16:09 +0000
Message-ID: <20091111091609.GB9137@cthulhu.home.robinhill.me.uk>
References: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
 <20091111034629287.IYTI6968@cdptpa-omta02.mail.rr.com>
 <70ed7c3e0911102122l3565cfat7a35a8a649237f56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0911102122l3565cfat7a35a8a649237f56@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 11, 2009 at 08:22:26AM +0300, Majed B. wrote:

> Hello Leslie,
>=20
> If you have a temporary space for your data, I'd suggest you move it
> out and go for an internal bitmap solution. It certainly beats the
> patch work you're going to have to do on the startup scripts (and
> every time you update mdadm, or the distro).
>=20
There should be no need to move the data off - you can add an internal
bitmap using the --grow option.  An internal bitmap does have more of an
overhead than an external one though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr6gNgACgkQShxCyD40xBJpvQCeMpZzd7CECKNwx0bUlzNPsr8/
0WYAoODOd3LSUbswSeJam/1kgdBLtj7x
=YWfu
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
