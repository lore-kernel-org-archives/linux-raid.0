From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] raid1: Rewrite the implementation of iobarrier.
Date: Mon, 26 Aug 2013 17:49:56 +1000
Message-ID: <20130826174956.7beea63a@notabene.brown>
References: <201308191958041664556@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xL_obv7_dAt05s.+iiMwUYv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201308191958041664556@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/xL_obv7_dAt05s.+iiMwUYv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Aug 2013 19:58:07 +0800 majianpeng <majianpeng@gmail.com> wrote:

> @@ -846,10 +859,57 @@ static void lower_barrier(struct r1conf *conf)
>  	wake_up(&conf->wait_barrier);
>  }
> =20
> -static void wait_barrier(struct r1conf *conf)
> +static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
>  {
> +	sector_t sector =3D 0;
>  	spin_lock_irq(&conf->resync_lock);
> -	if (conf->barrier) {
> +	if (conf->barrier || unlikely(conf->freeze_array)) {
> +		if (unlikely(!conf->freeze_array && bio) &&

I forgot to mention this bit.
If we need to test freeze_array here, then maybe that test should have been
added in the previous patch which introduced "freeze_array"?

And I think the field should be "array_frozen".  "freeze_array" sounds like
an action so it is a suitable name for a function, but not for a variable.

Also I think you probably mean "likely" rather than "unlikely" the second
time???
I rather avoid "likely" and "unlikely" calls unless they will really
make an important difference.


NeilBrown


--Sig_/xL_obv7_dAt05s.+iiMwUYv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhsIpDnsnt1WYoG5AQIXEg//RL+9CBEiHVEGObQx4eYr5Da+Wy1+NWkI
9gFGNXgqLSXvrMa06uWqByB9dUCp2ocaFk0inww7h7k9YqGfs7s6DEFYUWreN1pz
c9iroKs60kAv67sFpKDL37ohalp5CWA9LARbKeHd/yo2ebPYXrE00mpSsg07G75J
n9EGzYiJG428PZgcXCDprxeT90orxkzZ1QxdJg8geGqivZ5QCNJNuvnDNdliekar
BoDglCm8IzLek0Y/FfsIJJn4mazE4Wg6XfJ9y1kJ+UvM4lRg0cEBdI2kc8CBrlrg
41BRS+620UrCVO2sMc1H2/bnIUU1Zg1+ct5oadN83WdnYheGBRdJbSn5Iv5T/adE
80bc0T04ufE5tJdtrjG34M6L/XgKaF1nMpB7O+6c9mTFJAPZjtjbgpAGW5z66IuM
mo78uH4A3kZEzzZgh7YwvpoN4UkJAPdwV0p7lJu026W1gyQIl+ofw95ArLSzUtTk
BP4wL5kBxqMVze/UT2z4CsPgeezEVopjSfqEmIqq8R0emnyiUYrX/Cmnd0nqjrkO
Y70VLKHvk78RyHnI+4uOO4MoK90GPFh55cSxj/5N++LlahppOipa4oU61op+CQD4
ECKLHRyj/Ihwe54P8ceFj14U1FeOp7Ar3yEp4xwCVtZEi5CMUHtdq1z96BtGWIGN
KJQQR8QXO1o=
=FuWq
-----END PGP SIGNATURE-----

--Sig_/xL_obv7_dAt05s.+iiMwUYv--
