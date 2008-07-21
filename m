From: martin f krafft <madduck@madduck.net>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
	all devices to init
Date: Mon, 21 Jul 2008 13:34:17 +0200
Message-ID: <20080721113417.GA8152@piper.oerlikon.madduck.net>
References: <20080720151140.4aa7c682@infradead.org> <20080720151339.6f4a83d8@infradead.org> <18563.50428.659101.868745@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18563.50428.659101.868745@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2008.07.21.0106 +0200]:
> The "real" solution here involves assembling arrays in userspace using
> "mdadm --incremental" from udevd, and using write-intent-bitmaps so
> that writing to an array before all the component devices are
> available can be done without requiring a full resync.  There is still
> a bit more code needed to make that work really smoothly.

It was my understanding that write-intent bitmaps slow down all
operations and are not suggested on e.g. workstations. No?

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"i think, therefore i'm single"
                                                      -- lizz winstead
=20
spamtraps: madduck.bogus@madduck.net

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiEdDkACgkQIgvIgzMMSnU2/gCgzemYso+Rg4j0NB8lZFe8Q1CF
6sQAnjMg5NNhjhS00MFFC78wI2KVm6d2
=dJ/l
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
