From: Torsten Landschoff <torsten@debian.org>
Subject: Re: OOPS with raid1
Date: Sun, 11 May 2003 13:45:05 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030511114505.GA8087@stargate.galaxy>
References: <20030508152237.GB26189@stargate.galaxy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030508152237.GB26189@stargate.galaxy>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,=20

On Thu, May 08, 2003 at 05:22:37PM +0200, Torsten Landschoff wrote:
> pulsar:~# uname -a
> Linux pulsar 2.4.20-686-smp #1 SMP Mon Jan 13 23:06:41 EST 2003 i686
>=20
> (that's the kernel as shipped in Debian unstable's
> kernel-image-2.4.20-686-smp)

Additional info: I tried to reproduce this problem in user-mode-linux
for easier debugging. Funny enough I did not get it to break there. Both
systems I used to test this where running an SMP kernel so I'll try to=20
reproduce this without SMP on a real system now.

Greetings

	Torsten

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+vjfBdQgHtVUb5EcRAjvIAJ4kSLwxdejU5rlENziKpI5c3e+1kQCfZqfe
OOCi3r+K+I4oZJ3O4DzvLQY=
=+lxg
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
