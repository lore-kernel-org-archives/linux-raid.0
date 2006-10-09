From: martin f krafft <madduck@madduck.net>
Subject: avoiding the initial resync on --create
Date: Mon, 9 Oct 2006 14:57:00 +0200
Message-ID: <20061009125700.GA10191@piper.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I am looking at http://bugs.debian.org/251898 and wondering whether
it is save to use --assume-clean (which prevents the initial resync)
when creating RAID arrays from the Debian installer.

Please also see the following discussion on IRC:

< madduck> yeah, i am not sure --assume-clean is a good idea.
< peterS> madduck: why not?  I've tried to think of a reason it
  would fail for months, and so far I'm too stupid to think of one
< madduck> even then
< madduck> peterS: because it then assumes that it
< madduck> it's clean, period.
< peterS> yeah, so?
< peterS> the blocks you have not written will have unreliable
  contents
< madduck> in reality, the three components are not properly XORed
< peterS> but why would you care about that?
< madduck> hm. kinda true.
< peterS> the blocks you _do_ write will be correct
< peterS> even an uninitialised raid5 or raid6 seems like it would
  work perfectly well with --assume-clean

Do you have any thoughts on the issue? If Debian were to --create
its arrays with --assume-clean just before slapping a filesystem on
them and installing the system, do you see any potential problems?

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"sometimes we sit and read other people's interpretations of our
 lyrics and think, 'hey, that's pretty good.' if we liked it, we would
 keep our mouths shut and just accept the credit as if it was what we
 meant all along."
                                                        -- john lennon

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFKkccIgvIgzMMSnURAmsAAJ0X+b/JpU2GOtipL1g+Fdexs7BUMwCfRkWg
e2Rdka2svu3GKi98+wMlvls=
=C9qG
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
