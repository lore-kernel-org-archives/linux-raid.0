From: Michel Wilson <michel@crondor.net>
Subject: Re: mkraid hangs system
Date: Thu, 13 May 2004 09:38:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040513073815.GA7220@aeon.hgd.net>
References: <20040512190053.GB7006@percy.comedia.it> <200405122225.i4CMPK60008990@socrates.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200405122225.i4CMPK60008990@socrates.Berkeley.EDU>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 12, 2004 at 03:27:28PM -0700, Arnab Chowdry wrote:
> >you could dd if=3D/dev/zero of=3D/dev/your/disk,
>=20
> Oddly enough, dd hangs as well. I guess that means it's not a RAID proble=
m.
> Very strange though, and I don't have a good intuition about why it's
> happening.
>=20
> dd if=3D/dev/zero of=3D/dev/hde=20
> dd if=3D/dev/zero of=3D/dev/hdg
> dd if=3D/dev/zero of=3D/dev/hdi
> dd if=3D/dev/zero of=3D/dev/hdk
>=20
> All of the above hang the system after a few seconds. I'm sorry is this is
> now off-topic, but maybe some of you experts have some intuition about why
> this might happen? All four of the drives can't have "gone bad" or
> something.
>=20
> -Arnab
>=20
You can try running one of those commands in the background (append a &,
or press ^Z and run 'bg') and then look at the output of 'vmstat 1'.
This will show you the amount of data written per second through the
block layer. If nothing is written, something is indeed wrong.
--=20
Michel Wilson     michel@crondor.net
PGP key ID        0xD2CB4B7E

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAoyXnL2ru+9LLS34RApufAJ0WpP8jvqfs+nRNkWUdfsCKWxFiDwCgtqii
+x6/eJoBpDkugMPAaNlnckw=
=w6uD
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
