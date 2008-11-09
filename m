From: martin f krafft <madduck@madduck.net>
Subject: Re: zeroing superblocks on running systems
Date: Sun, 9 Nov 2008 11:21:27 +0100
Message-ID: <20081109102127.GB11914@piper.oerlikon.madduck.net>
References: <20081108192716.GA16878@piper.oerlikon.madduck.net> <c02075aed88c4e7e7bdf30a31cff0418.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c02075aed88c4e7e7bdf30a31cff0418.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach NeilBrown <neilb@suse.de> [2008.11.08.2127 +0100]:
> Do we want '--zero-superblock-die-die-die' which would avoid the
> O_EXCL for you?  We cannot use "--force" as that means "write zeros
> even if it doesn't look like a real superblock".
> .... though I'm not really sure that is useful to keep.

I don't think we want an option with "die-die-die" in the name for
good reasons. There is probably nothing you can do for me, I'll just
have to reboot one day...

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
humpty was pushed.
=20
spamtraps: madduck.bogus@madduck.net

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkWuaMACgkQIgvIgzMMSnVObACgsN0agxbolVXdmeJSY22s9Ykv
GSgAn0tL7NNSVhw9JSpaoN3ejr1CU4Zp
=a6dt
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
