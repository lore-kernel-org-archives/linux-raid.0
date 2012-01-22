From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] Add --initrd argument to mdmon
Date: Sun, 22 Jan 2012 22:22:04 +1100
Message-ID: <20120122222204.3156a3a7@notabene.brown>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
	<1326797330-4488-4-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v=vU/Gxmv1+142Tzyp4PZ9F"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326797330-4488-4-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

--Sig_/v=vU/Gxmv1+142Tzyp4PZ9F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2012 11:48:49 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  mdmon.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>=20
> diff --git a/mdmon.c b/mdmon.c
> index a65c4a4..139bd85 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -276,6 +276,12 @@ void usage(void)
>  	exit(2);
>  }
> =20
> +/*
> + * Option values that don't have a short version, to avoid clashing\
> + * with ascii values

The purpose of the trailing slosh (back slash) is ....?

> + */
> +#define INITRD_OPT	0x100

Can we make this an enum just like in mdadm??

> +
>  static int mdmon(char *devname, int devnum, int must_fork, int takeover);
> =20
>  int main(int argc, char *argv[])
> @@ -283,6 +289,7 @@ int main(int argc, char *argv[])
>  	char *container_name =3D NULL;
>  	int devnum;
>  	char *devname;
> +	char *c;
>  	int status =3D 0;
>  	int opt;
>  	int all =3D 0;
> @@ -291,6 +298,7 @@ int main(int argc, char *argv[])
>  		{"all", 0, NULL, 'a'},
>  		{"takeover", 0, NULL, 't'},
>  		{"help", 0, NULL, 'h'},
> +		{"initrd", 0, NULL, INITRD_OPT},
>  		{NULL, 0, NULL, 0}
>  	};
> =20
> @@ -304,6 +312,11 @@ int main(int argc, char *argv[])
>  			container_name =3D optarg;
>  			takeover =3D 1;
>  			break;
> +		case INITRD_OPT:
> +			c =3D argv[0];
> +			c[0] =3D '@';
> +			continue;

And can we use
                        argv[0][0] =3D '@';

here too?

Otherwise looks good.

Thanks,
NeilBrown

> +		=09
>  		case 'h':
>  		default:
>  			usage();


--Sig_/v=vU/Gxmv1+142Tzyp4PZ9F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTxvxXDnsnt1WYoG5AQLVKw/6A9Gq09lqcrrYrXLVMQar5EBD2qj+l6N4
8GiUbtpEA5bflUX7jK7eJP7ulj2I/XnxvrEF64klnoTvvhkzn8Dz5VPPFYAILSjW
ZRcA6WAk3uMxwUxlle/MAhDLV/Cm258XpBhqr2O2q6x5OwMWABqLF9k7KvJ8CCV6
5oPg/esiOW6ZLR+eBIw9KJBbWt1v+Gy8uC7+mNnas7p58PcR5SR3RGE7WByyaQGL
+3plcxaRdDfsDiq/FpZua2KrxDtTMhCobX0yRgjvAYBygbO0Mdyoj1WPAut/924z
6m6NgavWhi+rq1VaxJf8En2OOjzNQ34ldxQ4lX1IwwRdpbguUCyuARPtAD9FqIxL
3oYDBFJIwGQxRpIkGNPWTbKloxjSkgCdNu/gwMIqlau1LE/FAwlGu4PeNr/oDrJZ
FDrLKu1LmXE3CqCAstx443uUc4t1zcrB6P79Qt2Ear/xAOoMC1TaPIcDRnjy1P1P
te8Mpd0zyO71A5llP+J87OhluM6i7OIl6VBGqscQEeD79+0F/GC4z0BTNEE1Bqy2
DWbiVSUVXTDox5s+PNA94gOGaiC6seobVUtWigr2UoFqmcoYEyg2llAkZ+io79oz
7LT4NYoPAfesNM1eo7dNWVw0dG74/k/Wdw6iqrUzuOeO1DmwHJ3vvU8QfLSPRW4Y
5/zhTR5MxCA=
=dvRh
-----END PGP SIGNATURE-----

--Sig_/v=vU/Gxmv1+142Tzyp4PZ9F--
