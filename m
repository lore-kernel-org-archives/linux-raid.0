From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Safe disk replace
Date: Tue, 4 Sep 2012 18:12:52 +0100
Message-ID: <20120904171252.GA8544@cthulhu.home.robinhill.me.uk>
References: <20120904041447.GB14445@onthe.net.au>
 <5045D7D9.9000108@hesbynett.no>
 <alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
 <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
 <alpine.DEB.2.00.1209041834220.13902@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209041834220.13902@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 04, 2012 at 06:34:39PM +0200, Mikael Abrahamsson wrote:

> On Tue, 4 Sep 2012, Robin Hill wrote:
>=20
> > I'm currently upgrading my RAID-6 arrays via hot-replacement. The
> > process I followed (to replace device YYY in array mdXX) is:
> >    - add the new disk to the array as a spare
> >    - echo want_replacement > /sys/block/mdXX/md/dev-YYY/state
>=20
> What kernel version are you using?
>=20
3.4.9 at the moment. A quick search on the list suggests that this
functionality went in at 3.3 though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBGNpQACgkQShxCyD40xBJFUACgqF1JfnrU6D1jDRrQZAKEriEF
eeAAoMErYTXWpckMcjNOgF1WVxLw5Wrr
=rzsw
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
