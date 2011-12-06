From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm, bitmap and split-brain
Date: Tue, 6 Dec 2011 15:45:22 +1100
Message-ID: <20111206154522.13235bf4@notabene.brown>
References: <4ED14BEF.2060301@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5yY3A0_/TC3azfEhJl0CuQc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ED14BEF.2060301@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ronal Andadinata <randadinata@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5yY3A0_/TC3azfEhJl0CuQc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Nov 2011 03:28:31 +0700 Ronal Andadinata <randadinata@gmail.com>
wrote:

> Hi,
>=20
> I'm wondering, in the case of raid1 array with internal bitmap, it goes=20
> like this :
> 1. Machine A has 1 raid1 array with Disk1 dan Disk2
> 2. Dettach Disk2 from Machine A, put it on Machine B
> 3. Machine A runs normally, Machine B runs on normally on different place.
> 4. Detach Disk2 from Machine B, put it back on Machine A, re-add Disk2=20
> to md1
>=20
> If this were raid1 without bitmap, Disk2 will be overwritten from=20
> scratch with contents of Disk1, what happen if the array has bitmap ?=20
> Would there be partial sync ? Would the two disk be identical with only=20
> using partial sync ?

It might fail to re-add, or it might do a partial resync and probably leave
the two devices different so corruption would likely appear.

Just don't do this.  If you want to use disk2 on a different machine,
assemble it with=20
   --update=3Duuid
the first time so it gets a different uuid and can never become confused wi=
th
the old array.

NeilBrown


--Sig_/5yY3A0_/TC3azfEhJl0CuQc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt2d4jnsnt1WYoG5AQKGFRAAkNDvi4L4UY4OLjz5WgKFnDAsKBwDRIw+
Cl4+nlU5bm8WbEADIKSUyXhfSG3ZiFlB9264dPKUvRP9nglMomxBqziK9bXB0ORf
Z+kCc0XDlMqLGpPUdvf5Bz0tCgrDbYS6I4bkz09vXRZVwij1iHSuJ31lcKrANV/u
E1rlywlb9OWwD8v/iHxhflGBMzNzfxGdVaawOmimHY7IGmnD0hPZyAC3pmiVRxaZ
CMiMNgzeF77bY4/Jrb6AWje7DQtUbj8LFmHKVgYSc/PD39avoDUib+xeUcylnT5d
yEo/sYDXhHh9qWbBOTd3zdwDa7+y3Wj6BDUawH6lR0/QnxoYAd1iOK0YPYOByBzO
/d9ypTtbpBDc7cc54uAFFu4cvFxGYO0PJjcndYYEgc1KApDCpf1EVAVMYaVIB9Yd
qnmGFi2dOky8ryybW7+VLZbdE4Z5VY25CFuynGqHX1iJ/vdFOphgwZ2R6eOA5O8l
LXAicnaUVw2QD8A1ZFAh71uTjoIMOiA+7tIfgPwaIQWBKao4D3cMKm0/e+HYtXtY
wUL/9OnqW/cDL5BTsiATk3QUj4vp+0nPBpp/HHsyYvbEqmbFSTEoDc+LK5borx3V
A3PHi30IPgLU5aVepxvH/9mszfV6bTtzRKmPA8S8cDPv0gdJLDBNR7p1vUkyi1Zk
ri08jgtWKDs=
=jzdj
-----END PGP SIGNATURE-----

--Sig_/5yY3A0_/TC3azfEhJl0CuQc--
