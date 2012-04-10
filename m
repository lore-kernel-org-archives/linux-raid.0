From: NeilBrown <neilb@suse.de>
Subject: Re: resync after a power failure
Date: Tue, 10 Apr 2012 10:16:39 +1000
Message-ID: <20120410101639.0fe75d71@notabene.brown>
References: <CAGmni9oU47YiVGLirunYdhUFxJv8U3GJMtWvUuHEXt7dv0LtbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7Gm9+5AmMXGew9KJgQawnjR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9oU47YiVGLirunYdhUFxJv8U3GJMtWvUuHEXt7dv0LtbQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7Gm9+5AmMXGew9KJgQawnjR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Apr 2012 20:13:44 -0300 Salatiel Filho <salatiel.filho@gmail.com>
wrote:

> Is resync needed after a power failure if the raid was mounted read only ?
>=20

No, and it should not happen.
You will only get resync after a power failure if there was a write in the
last 200msecs or so.

(this is with 'md' software RAID).

NeilBrown

--Sig_/7Gm9+5AmMXGew9KJgQawnjR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4N75znsnt1WYoG5AQKgfA/+IqU5NG5GgW6lHiBWg/6alb8cSrOQWpiF
zx9PRv/c0ikjmppigpiwWF6EGSlR0ieBA3t8wDcLZxrOxNhRh2KQ835IbrVo1CPw
9aNzU+9VbCFIoA4vY86ro+WgUSRXGH30l+Z9SnULennAI/aV3FuJdLQvR7fkjOHz
SpOpt4TGwP/wKoMx4+iC1DfzagLwVuO5mSdaUXA6xcS+PeyeojSn4WHkVW7s/xoq
bv8HtCHidsVlm99suaMiDuYEecrNpNHZAADJpIp4Y016XKKsPKy0V8jir3dQ+Q0D
qbYirbVWcsTO6sa/xcotZpl/q7lobaC6PKjuXuR7CAkeYUbb2Lxw9CutGz5r5+Gs
/usGiY7h2oZLnxYfvNjcHvpc/oNS9qwwDAYOhOj4+4YFV1Vu6jKHj1oFA8DuC2fM
fHkFH/86p2dNhBke67oI8273rDdGF7VlQrmMMk3JBKbxC/5yztHp7x42YYCzYtHA
8TDkMJ3QfUpgLe3dT7ZM3EklHLTFg1yhPzDsA/khTMn0rb4f2CobBw5hvc+hz8NX
SX5S1grzwLDo+7UlToRBtpvyUrLQKTr9UaCQXA2dL3BSW1DdL6X2nrfcXJfqw6ci
XGtPaFA4RK51wBncLCj0HAmmW8QvHqTMPt2zmtYfHygecShJDRGRsl0DKOy4jFoG
nlaq11HQ1JQ=
=KVJ0
-----END PGP SIGNATURE-----

--Sig_/7Gm9+5AmMXGew9KJgQawnjR--
