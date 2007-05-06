From: martin f krafft <madduck@madduck.net>
Subject: Re: what does md do if it finds an inconsistency?
Date: Sun, 6 May 2007 11:06:42 +0200
Message-ID: <20070506090642.GA22083@lapse.madduck.net>
References: <20070506004539.GA17736@lapse.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070506004539.GA17736@lapse.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach martin f krafft <madduck@madduck.net> [2007.05.06.0245 +0200]:
> With the check feature of the recent md feature, the question popped
> up what happens when an inconsistency is found. Does it fix it? If
> so, which disk it assumes to be wrong if an inconsistency is found?

What I meant was of course

  echo repair > sycn_action

I am unsure what happens:

  piper:/sys/block/md7/md# cat mismatch_cnt
  128
  piper:/sys/block/md7/md# echo repair > sync_action
  piper:/sys/block/md7/md# cat sync_action
  idle
  piper:/sys/block/md7/md# cat mismatch_cnt
  128=20

If I do this again, then mismatch_cnt goes to 0. Not the first time.

md7 : active raid10 sda2[0] sdc2[2] sdb2[1]
      1373376 blocks 64K chunks 2 near-copies [3/3] [UUU]

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"the thought of suicide is a great consolation: by means of it one
 gets successfully through many a bad night."
                                                 - friedrich nietzsche

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGPZqiIgvIgzMMSnURAlpiAKCOcxh1DsyQUenQoF8dYqhygZZcwQCdEmWJ
1ZcGRERYQW39dfxWLvdOeac=
=jV/y
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
