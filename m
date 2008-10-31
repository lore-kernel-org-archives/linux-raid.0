From: martin f krafft <madduck@debian.org>
Subject: mdp devices on Debian (was: RFC - device names and mdadm with some
	reference to udev.)
Date: Fri, 31 Oct 2008 21:49:18 +0100
Message-ID: <20081031204918.GA9554@piper.oerlikon.madduck.net>
References: <18692.62860.863118.727187@notabene.brown> <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com> <18694.19834.523955.697048@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18694.19834.523955.697048@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2008.10.28.0023 +0100]:
> Debian doesn't get 'mdp' devices right.

Correction: it does do everything it needs, it can even boot from
them, but our installer won't let you create them. I wanted to add
that functionality at some point and then learnt that eventually,
plain md devices would become partitionable in the future, so
I dropped it.

--=20
 .''`.   martin f. krafft <madduck@debian.org>
: :'  :  proud Debian developer, author, administrator, and user
`. `'`   http://people.debian.org/~madduck - http://debiansystem.info
  `-  Debian - when you have better things to do than fixing systems
=20
windows 2000: designed for the internet.
the internet: designed for unix.

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkLb04ACgkQIgvIgzMMSnU7+QCg5NjDCT1MJkJkkNpMEgCk/PBS
+5sAoNMCeQWlhk3XCFCG0qXjlzKUar1g
=n4c5
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
