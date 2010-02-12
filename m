From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Linux mdadm superblock question.
Date: Fri, 12 Feb 2010 09:06:33 +0000
Message-ID: <20100212090632.GA17020@cthulhu.home.robinhill.me.uk>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
 <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Feb 11, 2010 at 05:52:41PM -0800, Michael Evans wrote:

> On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
> > Hi,
> >
> > I may be converting a host to ext4 and was curious, is 0.90 still the o=
nly
> > superblock version for mdadm/raid-1 that you can boot from without havi=
ng to
> > create an initrd/etc?
> >
> > Are there any benefits to using a superblock > 0.90 for a raid-1 boot v=
olume
> > < 2TB?
> >
> > Justin.
>=20
> You need the superblock at the end of the partition:  If you read the
> manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also
> NOT 1.2; those use the same superblock layout but different
> locations).
>=20
You also need it to be auto-assembled by the kernel, which is only
version 0.90.

As for benefits, there's a number of benefits of 1.x over 0.90 - I don't
think any of them are terribly important for a small boot partition
though.  There's also benefits to having an initrd anyway.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkt1GhgACgkQShxCyD40xBJftQCcDO5P2rIRkeceaGXGKmQKs8Wz
MUUAn00pUXrV5xDWByxzupnAf/idk5ed
=OZSd
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
