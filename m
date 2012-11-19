From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Keep track on which kernel the test suite has run
Date: Mon, 19 Nov 2012 11:10:14 +1100
Message-ID: <20121119111014.659eb4d4@notabene.brown>
References: <1352538883-24288-1-git-send-email-g.esp@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y0m3ufw/Wo=3YakjtWifXlw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1352538883-24288-1-git-send-email-g.esp@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/y0m3ufw/Wo=3YakjtWifXlw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 10 Nov 2012 10:14:43 +0100 Gilles Espinasse <g.esp@free.fr> wrote:

> Signed-off-by: Gilles Espinasse <g.esp@free.fr>
> ---
>  test |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/test b/test
> index 3f8515f..352c1e1 100755
> --- a/test
> +++ b/test
> @@ -21,6 +21,8 @@ logdir=3D"$testdir/logs"
>  logsave=3D0
>  exitonerror=3D1
> =20
> +echo "Testing on linux-$(uname -r) kernel"
> +
>  # Check whether to run multipath tests
>  modprobe multipath 2> /dev/null
>  if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat ; then

Applied,
Thanks,
NeilBrown

--Sig_/y0m3ufw/Wo=3YakjtWifXlw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKl45jnsnt1WYoG5AQKFBg/9Gri+3/huN7Dd3ZGYQmNRZJiDe0+ztv/s
RVQv1gduDXO96lPJoIwmT7ffXZFs4i14uzAWUoJOvTEq69n2OvOPN2S5GIFidYe1
NsaFbdB01znRy0hKmBhFQ28o6OOt8baYBlf7cGO6O2yJ5hT7gSW+cfK4kiSyHq0L
5WHgBzBi8gQJ07iAVb9fbrz7zpiRVl3gQsX9B3z3T6WiA7xaIhwb8xFTfq0U4YMm
8U7Bhta346wrXiwMYNp2XMAEoHukDUJTGxLPIOvzkJJEH6PTOLmhLQ0Xa+olnhbF
P57JgjS0qeiO51UCKPVfFFs4jFLAejJvws+FBJCn1mqLbFcaQs/fAIWji6snpIdw
eDclQCGLzJLsN0IQSJdZZVnZwLUBtPqkM3TKZzx2H+/qxm3BYbgmhHo8ieTkes8P
8juzwxrSN3JhQGMkW2yHWAIBickpU1jQyuAc5pjVqhdh1tCnxnFT69ovC9PvRKpt
B7qJJvmjxTNaS+SewWxEndPbSiZhZG9oTsrg9eBj0/uWMhnKOqXyVIWDF86qiZXv
Wip2XMZbAz9fN5hYCxy48R5X2S4L0djK9AKUoASQCTCkgB6iYqCUcxpa1e3J0+6x
k1A1nVoxXQiYxK/SHB6OFGjmZ037CT6YASL7JBO4ehMHri99+Egl2BlY08tSlOJj
WYoXJMEqpDo=
=wxyW
-----END PGP SIGNATURE-----

--Sig_/y0m3ufw/Wo=3YakjtWifXlw--
