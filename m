From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Stupid question regarding RAID-1 access pattern
Date: Wed, 6 Jan 2010 23:10:04 +0000
Message-ID: <20100106231004.GA4351@cthulhu.home.robinhill.me.uk>
References: <4B44EB58.2090400@northarc.com>
 <20100106213723.GA12318@cthulhu.home.robinhill.me.uk>
 <a43edf1b1001061413p6d3689f0u9be7bc35c8892cd5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a43edf1b1001061413p6d3689f0u9be7bc35c8892cd5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jan 06, 2010 at 04:13:55PM -0600, Billy Crook wrote:

> On Wed, Jan 6, 2010 at 15:37, Robin Hill <robin@robinhill.me.uk> wrote:
> > I doubt this would help much really. =A0If you're reading sequential da=
ta
> > then it's pretty much as quick to keep reading as to seek to the next
> > chunk.
>=20
> Could it hurt [performance]?  SSDs will only become more common, and
> they haven't any seek penalty.
>=20
Probably not, with SSDs, but we've already got RAID10 which, if I'm not
mistaken, does pretty much what you're describing (if not, can you
provide some diagrams of what the layout you're thinking of would look
like).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktFGEwACgkQShxCyD40xBIK4gCg4KUn+do4l7ay/4OnYocdfIyU
82AAoNCdeOfy8QFqiZBqHVPrJmdnq3wm
=KbKy
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
