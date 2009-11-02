From: martin f krafft <madduck@madduck.net>
Subject: Re: md[adm] device names
Date: Mon, 2 Nov 2009 09:24:24 +0100
Message-ID: <20091102082424.GD7626@lapse.rw.madduck.net>
References: <4AEC33A2.6050408@msgid.tls.msk.ru>
 <19182.16585.929763.745870@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19182.16585.929763.745870@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2009.11.02.0315 +0100]:
> Numbers are meaningless.  I would much rather have "/dev/md/home" or
> "/dev/md/backup" or whatever.  But as I said, old names should still
> work.

=E2=80=A6 except sysfs exposes device names =C3=A0 la md1, right? I agree w=
ith
Michael that we should either have numbers or names, but not both.
http://bugs.debian.org/553896 came in today, which is just another
instance of confusion resulting from multiple choices.

I personally don't have a problem with numbers; they are as
meaningless or -full as partition numbers, and I used stuff like
/dev/sda5 on my systems for decades without problems. The trend
these days is dm/LVM, and that gives us decent names like
/dev/mapper/home, and I see the benefit in moving towards
/dev/md/home, but it needs to be done consistently, and either one
or the other.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"if ever somethin' don't feel right to you, remember what pancho said
 to the cisco kid...  `let's win, before we are dancing at the end of
 a rope, without music.'"
                                                             -- sailor
=20
spamtraps: madduck.bogus@madduck.net

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkrulzgACgkQIgvIgzMMSnVuNwCg4Tv38W3RzI1MvWC37XU8QTpi
EM0AoIifnta7zD+QJ5opzkVdZn7aA5/o
=T6HL
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
