From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: adjust parse_size() to the unsigned size variable
Date: Thu, 20 Sep 2012 12:31:56 +1000
Message-ID: <20120920123156.4f1fb8fb@notabene.brown>
References: <20120914141245.18725.59647.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Rd3Hqa.JF1WS0pA2MeIp12C"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120914141245.18725.59647.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/Rd3Hqa.JF1WS0pA2MeIp12C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Sep 2012 16:12:45 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> An error in parse_size() should be reported by 0, not -1,
> because -1 is changed to the max value of unsigned long long
> during calculations of size (e.g. at mdadm.c:412).
>=20
> A negative value of size should be reported as error
> (e.g. size equal -1 has been changed to the max value of
> unsigned long long so far).
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  mdadm.h |    2 +-
>  util.c  |    9 +++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/mdadm.h b/mdadm.h
> index 9feccc6..f202ffa 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1156,7 +1156,7 @@ extern unsigned long bitmap_sectors(struct bitmap_s=
uper_s *bsb);
>  extern int md_get_version(int fd);
>  extern int get_linux_version(void);
>  extern int mdadm_version(char *version);
> -extern long long parse_size(char *size);
> +extern unsigned long long parse_size(char *size);
>  extern int parse_uuid(char *str, int uuid[4]);
>  extern int parse_layout_10(char *layout);
>  extern int parse_layout_faulty(char *layout);
> diff --git a/util.c b/util.c
> index a92a663..c63a232 100644
> --- a/util.c
> +++ b/util.c
> @@ -188,13 +188,13 @@ int mdadm_version(char *version)
>  	return (a*1000000)+(b*1000)+c;
>  }
> =20
> -long long parse_size(char *size)
> +unsigned long long parse_size(char *size)
>  {
>  	/* parse 'size' which should be a number optionally
>  	 * followed by 'K', 'M', or 'G'.
>  	 * Without a suffix, K is assumed.
>  	 * Number returned is in sectors (half-K)
> -	 * -1 returned on error.
> +	 * 0 returned on error.
>  	 */
>  	char *c;
>  	long long s =3D strtoll(size, &c, 10);
> @@ -214,9 +214,10 @@ long long parse_size(char *size)
>  			s *=3D 1024 * 1024 * 2;
>  			break;
>  		}
> -	}
> +	} else
> +		s =3D 0;
>  	if (*c)
> -		s =3D -1;
> +		s =3D 0;
>  	return s;
>  }
> =20

Applied, Thanks.

NeilBrown

--Sig_/Rd3Hqa.JF1WS0pA2MeIp12C
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqAHDnsnt1WYoG5AQKt/w//UE2tZAWoi44mGp2oMDTIjxNvYod9Q+gH
EisN1NjspCSue2ofN6/I/HQR6zZK98KzWmHDTf12vs4a5Bii0sEImwh2o2fCgYFt
ieFrtcqO8HpwbpRBM/X1k5mY3wOYlXtomoM/vM8lR0kHSIskmh6ZSMYEhx9Lp8fv
IU88ARj3mDDtlFIVpNGav1WXnGCuKGUtDNQcd/KBQT5xxWy8Jm0E5Pp6BJMirViG
FZh0Dc9k97JD8ZqW25xMC26w4vnxKZ+IgKzYcPgfOKd+s6y/B1322IJh3FxZCJ4C
MtIGtsuzdVRTRYSA5aPdVRFiBtPaBeDiM0AUTjZerj1UmHd/8KdCHUBxJ6RZLrqh
ZJoeTYF30C+AQhtWapJDZjZ+cA+wx0WMqoShHOjBgMKesYnfewf9vTsbl6g3XE6Z
S1OU+CbUQGKqOgSLOpHOdOcsbo8gn76uJmixGpXec7M98Lea6fnzOlSv0yukxcK9
iGZ/9SlfXRNQKPbII3HFtJhLwhNQQO/KRqAtDFNsh5JUbcI5muiedj3QEOcef31a
XBVP8oOnWMsTrgsZ3/94YcUR8de3qx9Uq9hBDCKfJBEaTibKMWfHGdAUWYnCH4/G
fBy+4Zq5YLI/rfMQpGigby798UcWn9Doj9AB7Bt1LH/AgRvs/ptzoC5GUdf3MWA1
ceavCcSpuWU=
=m2qF
-----END PGP SIGNATURE-----

--Sig_/Rd3Hqa.JF1WS0pA2MeIp12C--
