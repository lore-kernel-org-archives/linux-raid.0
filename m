From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID down, dont know why!
Date: Sun, 8 Nov 2009 14:22:38 +0000
Message-ID: <20091108142238.GA11786@cthulhu.home.robinhill.me.uk>
References: <4AF6CEFD.60309@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AF6CEFD.60309@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Nov 08, 2009 at 09:00:29AM -0500, Andrew Dunn wrote:

> I just copied 4+ TiB of information to this array, restarted 5 times
> and tried to access it.... What is going on?
>=20
> What kind of logs do you need, I really need help!
>=20
=46rom the message you've posted, it looks like something has triggered
the (simultaneous) removal of four drives from the array.  I'd check the
dmesg output - it should provide some information.  I'd guess these four
drives are all attached to the same controller (are they external or
internal?), so possibly the controller reset (or for external drives, it
could be a cable issue).

You should be able to force an assembly anyway (using the --force flag)
but I'd make sure you know exactly what the issue is first, otherwise
this is likely to happen again.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr21C0ACgkQShxCyD40xBJEOgCgnS2SjUGP3IqRXT10t8iMJOxq
XdsAoNUJjx9KPgmXUob+H4HQdX55OZHd
=PDb3
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
