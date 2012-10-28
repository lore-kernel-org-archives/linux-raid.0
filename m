From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/5] md: Increase the frequency of recording checkpoint
 of recovery.
Date: Mon, 29 Oct 2012 08:41:47 +1100
Message-ID: <20121029084147.2d292bc5@notabene.brown>
References: <201210271028177376247@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iTcJKz5paKTCFe6OoURx+6y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210271028177376247@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/iTcJKz5paKTCFe6OoURx+6y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Oct 2012 10:28:20 +0800 majianpeng <majianpeng@gmail.com> wrote:

> With the hard disk capacity of larger,the entire recovery process
> becomes longer.So it should increase the frequency.
> Supposed the speed of recovery is 100MB/s(i think for HDD is good).
> The total time of recovery 4TB hdd is about 666 minutes.So change the
> frequency from 16 to 64 times,it's about 10mins.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 01e25bd..ba328ee 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7446,7 +7446,7 @@ void md_do_sync(struct md_thread *thread)
>  		if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>  		    ((mddev->curr_resync > mddev->curr_resync_completed &&
>  		      (mddev->curr_resync - mddev->curr_resync_completed)
> -		      > (max_sectors >> 4)) ||
> +		      > (max_sectors >> 6)) ||
>  		     (j - mddev->curr_resync_completed)*2
>  		     >=3D mddev->resync_max - mddev->curr_resync_completed
>  			    )) {

I don't like this - the number '6' is completely arbitrary.

The original '4' was never about number of minutes.  It was a fraction of t=
he
total effort needed.
I wanted to make sure you only repeated at most 10% of the required effort
(one order of magnitude).  >>4 is about 6% and easy to calculate.

If you want it to be about time (which I don't object to), then make it abo=
ut
time.  Keep track of the last time we updated curr_resync_completed, and if
that is more than a few minutes ago, update it again.
This is what I said last time - if you want something to be based on time,
test the time.
If 'echo idle > sync_action' doesn't work (Which it seems it doesn't), then
it is OK to just do it in the kernel.

NeilBrown

--Sig_/iTcJKz5paKTCFe6OoURx+6y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI2mmznsnt1WYoG5AQKurw//Vz+h3BZ7iO7dGBNHD4c8YL9wiXduL4JC
Kg1GnTYXLjBIfJUkbtw9e+9lbUV8Bg9A2jVWetYZnschZCIS5eUBfZRK919OvKgc
QF3x9Bg6HJTJRjL1GxSw88TnQjVonn7mxrdQaVS01co53Sf9dnUFmokxXk24hsa5
eh8CBv4Jky2XngIDmPoVfPr5Bn9UJ2tm7jWl3ZCBiPGThPVHA5OkmgQ1kFYJ2Ihs
IpvL9SD7cbCILRm5n0BJ4bOPXI7xHWy4pDd8cForcpk85XdhwB0iqdHaDhZ2fE+Y
IKt/gdCie0iMMYmmcb1k1m2ahhQyZOPpJTxj4/Axt20bZiYD9AYROCVsaPj83SEX
/HqbrUuskKwZw6Ya5z57ajKu646hmJGuOKaQP7gSMwzpzPmowW5dFnTpWM5Y7R65
0MBRHUGmZp1CICJfeqC4Ew+CCNJvLkTjNb1QaLYa2Xl/toeg/72CI1lI2/8xPVSI
PvqtjzXBgX75EUEhYm6k7TbsECtkukfGsU6iwxGazRFXENoF36hmxOK87h09wL8S
Ec3YYQYUYX6tUJi50JAWIfIetApMZy+6miOjrc8ihlzXBZTWzMExBIEGX78EHE5l
n9qVs07x4C/Y74kAALKI/HkJjArarASTwDEyVqr1goGnMsyaC8Ab6z8CvkOZcMlx
KTM3uh2VAjA=
=+kZx
-----END PGP SIGNATURE-----

--Sig_/iTcJKz5paKTCFe6OoURx+6y--
