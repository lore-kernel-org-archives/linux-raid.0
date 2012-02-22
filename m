From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Use MDMON_DIR for pid files created in Monitor.c
Date: Thu, 23 Feb 2012 09:12:14 +1100
Message-ID: <20120223091214.3babc1b1@notabene.brown>
References: <1328183102-9377-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h=+qrtRjdUZrWY5EhLAQm5y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1328183102-9377-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/h=+qrtRjdUZrWY5EhLAQm5y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  2 Feb 2012 12:45:02 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Other parts of mdadm/mdmon place .pid/.sock files in MDMON_DIR. This
> makes Monitor.c consistent with the rest.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  Monitor.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 77f22aa..7ed5282 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -294,8 +294,10 @@ static int check_one_sharer(int scan)
>  	int pid, rv;
>  	FILE *fp;
>  	char dir[20];
> +	char path[100];
>  	struct stat buf;
> -	fp =3D fopen("/var/run/mdadm/autorebuild.pid", "r");
> +	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
> +	fp =3D fopen(path, "r");
>  	if (fp) {
>  		if (fscanf(fp, "%d", &pid) !=3D 1)
>  			pid =3D -1;
> @@ -317,12 +319,12 @@ static int check_one_sharer(int scan)
>  		fclose(fp);
>  	}
>  	if (scan) {
> -		if (mkdir("/var/run/mdadm", S_IRWXU) < 0 &&
> +		if (mkdir(MDMON_DIR, S_IRWXU) < 0 &&
>  		    errno !=3D EEXIST) {
>  			fprintf(stderr, Name ": Can't create "
>  				"autorebuild.pid file\n");
>  		} else {
> -			fp =3D fopen("/var/run/mdadm/autorebuild.pid", "w");
> +			fp =3D fopen(path, "w");
>  			if (!fp)
>  				fprintf(stderr, Name ": Cannot create"
>  					" autorebuild.pid"


Applied (at last).
Thanks,
NeilBrown

--Sig_/h=+qrtRjdUZrWY5EhLAQm5y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0VoPjnsnt1WYoG5AQLMSA//XNPS9MlCKVI2+ZeUhB8Y/Z1hlb+0vuHo
bcG0KI61wV/aLxQavSEm4kzJB5e7Updiz7ZjbI43BN4zsMgmzttJ9agWPkSG6xf7
w7fPF1iSBMnstnortm+UYcd96QkdA+Kr3PBYXP8v3Av60n5ng7pQPil3ZhAwJbmU
UdADnpIlpnwBxtY2fDHH61+nk5Y73o68nECDA+jtdh6+h3QcAXYo8CT+CNcTngFm
lsjxA6L1KQ6eXjgo8TOU8oDLr16/kd4IvN8NuKKEgbetgch8sF/SsbkPClLuVYTY
9huKn0Dkjd/fp+L87N8bOnhZ+Aa0k3+z8TDR+m/GJ+Abor5q0Cg525fkHI5smOml
WiVJ/tCidEYNrDMaVDKiEGmjCb/FJoWJY8W6ARI01t05F2o0Mw0SUDyVJ4m7qpgp
sdjJ86minnfqLmvgbuIsNSQZnwIsOw6t4HtTYCR2mOIcpAPxBmVdRajTuPd4Gq8v
vikavcdfKZjw7sEYkh7D8rPSWD6OpcG1r/FgIbZYKGSwsc0E/6+yrbq6iKU05SlC
PApwkYFst1GBFYva7Ukf7xuQRl0l+KIOXjFcul6WGQH5Ox19raCWmSeA0LJDL4vM
PCjx+17LY0Jj+kG2TepKFQs4WRLyErOYoHMNIXlpNqVC3i1Zy+2X/K4sKoN2L+Ia
4D4WNoIP93I=
=ZDU+
-----END PGP SIGNATURE-----

--Sig_/h=+qrtRjdUZrWY5EhLAQm5y--
