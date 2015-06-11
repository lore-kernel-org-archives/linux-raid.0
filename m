From: Roman Mamedov <rm@romanrm.net>
Subject: Re: write performance of HW RAID VS MD RAID
Date: Thu, 11 Jun 2015 05:27:29 +0500
Message-ID: <20150611052729.258dddfa@natsu>
References: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D_C/Pir6tNMw60Eh9_/YRAy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

--Sig_/D_C/Pir6tNMw60Eh9_/YRAy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jun 2015 15:27:07 -0700
Ming Lin <mlin@kernel.org> wrote:

> Hi NeilBrown,
>=20
> As you may already see, I run a lot of tests with 10 HDDs for the patchset
> "simplify block layer based on immutable biovecs"
>=20
> Here is the summary.
> http://minggr.net/pub/20150608/fio_results/summary.log
>=20
> MD RAID6 read performance is OK.
> But write performance is much lower than HW RAID6.
>=20
> Is it a known issue?

Did you tune the stripe_cache_size for the array? Try 32768.
https://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-t=
ransfer/

--=20
With respect,
Roman

--Sig_/D_C/Pir6tNMw60Eh9_/YRAy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlV41fEACgkQTLKSvz+PZwipsQCfSFQy1ZY8L4fbfuBpAui4sJvA
urAAn0k7uIeqSa3sQASsOBjQWESGyVrj
=mUnO
-----END PGP SIGNATURE-----

--Sig_/D_C/Pir6tNMw60Eh9_/YRAy--
