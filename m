From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] Spawn mdmon with --offroot if mdadm was launched
 with --offroot
Date: Mon, 30 Jan 2012 12:10:36 +1100
Message-ID: <20120130121036.09243aa0@notabene.brown>
References: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
	<1327504684-9219-5-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SeJ7yh3mBoaACuVmvcryEzz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327504684-9219-5-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

--Sig_/SeJ7yh3mBoaACuVmvcryEzz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jan 2012 16:18:04 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  mdadm.c |    1 +
>  mdadm.h |    2 ++
>  util.c  |   17 +++++++++++++----
>  3 files changed, 16 insertions(+), 4 deletions(-)
>=20
> diff --git a/mdadm.c b/mdadm.c
> index 78f28d5..1efa3e8 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -181,6 +181,7 @@ int main(int argc, char *argv[])
>  		 */
>  		case OffRootOpt:
>  			argv[0][0] =3D '@';
> +			__offroot =3D 1;
>  			continue;
> =20
>  		case ':':
> diff --git a/mdadm.h b/mdadm.h
> index fec93aa..d862b3e 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1383,3 +1383,5 @@ static inline int xasprintf(char **strp, const char=
 *fmt, ...) {
> =20
>  #define PROCESS_DELAYED -2
>  #define PROCESS_PENDING -3
> +
> +extern int __offroot;
> diff --git a/util.c b/util.c
> index 6985a70..4ba44e6 100644
> --- a/util.c
> +++ b/util.c
> @@ -32,6 +32,8 @@
>  #include	<dirent.h>
>  #include	<signal.h>
> =20
> +int __offroot;
> +
>  /*
>   * following taken from linux/blkpg.h because they aren't
>   * anywhere else and it isn't safe to #include linux/ * stuff.
> @@ -1622,10 +1624,17 @@ int start_mdmon(int devnum)
>  				skipped =3D 0;
> =20
>  		for (i=3D0; paths[i]; i++)
> -			if (paths[i][0])
> -				execl(paths[i], "mdmon",
> -				      devnum2devname(devnum),
> -				      NULL);
> +			if (paths[i][0]) {
> +				if (__offroot) {
> +					execl(paths[i], "mdmon", "--offroot",
> +					      devnum2devname(devnum),
> +					      NULL);

I just occurred to me that this could be:

    execl(paths[i], "@mdmon", devnum2devname(devnum));

which seems simpler... but I'll leave it as it is.

All applied - thanks.

NeilBrown


> +				} else {
> +					execl(paths[i], "mdmon",
> +					      devnum2devname(devnum),
> +					      NULL);
> +				}
> +			}
>  		exit(1);
>  	case -1: fprintf(stderr, Name ": cannot run mdmon. "
>  			 "Array remains readonly\n");


--Sig_/SeJ7yh3mBoaACuVmvcryEzz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyXuDDnsnt1WYoG5AQLvBhAAqlMUJEQvbGxQWEn9bqfkIPXsRikNgVZJ
QI97HE1NvT30yh46Wzxmyku95UqowYzSDG5MXS4icVN79mbOa2NDSwQwf0megqHw
r2AYybx8LeVOSV/L7zHrL568NjZoRrtJKbuu+y5oENlsDVXFHTYzt4Z9PKO9Xfzk
4g09AsZ2Z3rrXFGg5LAGmAGAZEl8NvOEH87LK4gdCOprEmMuujeykukAucevP3nE
jj6A5TEpH9DOVutW/jfC2GSC/xLOHv+MnAxpxbKTKfd9Q5VAsq5xNG/4tzPbObFb
UKJeL2ypQOL4gn3tUdakgVatF5c60KjzIe6vNq5fO+2KXyWqkxWcy+/gd1d6NtTk
mG7YJrC3IpHB6N12vdWjKZ8BapiK+I5f+WCV2EmzdzMzScK9mUGcW5ayRFtiIilV
IoAwKOk9n2MiTpOAo/1pKoR9Bq+Wmk0N1RVPFy97Tv7Wz/QbM65hVhuTroe7Yo5q
hoY57lTGa7I+0Wkf8P/cCH1z6O2n/qalE9zGYZnV7qhlCh7SQD2sR9zQ3C/ZCZ4y
bORoFs8YRIhZr8qrqPkx50HlpEQsKD4n9eBAXR/mOzuHHl+cy1r0t783k+OS9r77
q5yH7SuUCbAD6PSyMHc6utP2TDA+78mRKc1Ed6oYCNnKPB+rZEEI2UEtyqDOmdEx
2gxgBnX3Mig=
=QlZp
-----END PGP SIGNATURE-----

--Sig_/SeJ7yh3mBoaACuVmvcryEzz--
