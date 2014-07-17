From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow: Do not try to restart if reshape is running
Date: Thu, 17 Jul 2014 14:11:01 +1000
Message-ID: <20140717141101.7318564a@notabene.brown>
References: <20140716102034.18952.74271.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/t__qt_NfuySOcsYiB_9GtH."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140716102034.18952.74271.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/t__qt_NfuySOcsYiB_9GtH.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jul 2014 12:20:34 +0200 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Grow process did not check if reshape is already started
> when deciding about restarting.
> Sync_action should be checked in this case, and if
> reshape is running - restart flag should not be set.
> Otherwise, Grow process will fail to write data to
> sysfs, and reshape will not be continued.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  Grow.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index a2f4f14..9ba7f76 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2822,6 +2822,7 @@ static int reshape_array(char *container, int fd, c=
har *devname,
>  	unsigned long long array_size;
>  	int done;
>  	struct mdinfo *sra =3D NULL;
> +	char buf[20];
> =20
>  	/* when reshaping a RAID0, the component_size might be zero.
>  	 * So try to fix that up.
> @@ -2869,7 +2870,9 @@ static int reshape_array(char *container, int fd, c=
har *devname,
>  		goto release;
>  	}
> =20
> -	if (st->ss->external && restart && (info->reshape_progress =3D=3D 0)) {
> +	if (st->ss->external && restart && (info->reshape_progress =3D=3D 0) &&
> +		!((sysfs_get_str(info, NULL, "sync_action", buf, sizeof(buf)) > 0) &&
> +		(strncmp(buf, "reshape", 7) =3D=3D 0))) {
>  		/* When reshape is restarted from '0', very begin of array
>  		 * it is possible that for external metadata reshape and array
>  		 * configuration doesn't happen.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Applied, thanks.

Though I reindented it so that it was more obvious that the '!' applied tot
he 'strncmp' as well.

NeilBrown

--Sig_/t__qt_NfuySOcsYiB_9GtH.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8dM1Tnsnt1WYoG5AQLa6w/9F0CGwxPyFcORwB0y9/TsUCkFd8q+An7R
PFo838nFJtSp05bwcfNBIm3S2fvAcQtsvEAEGdMFEWV+xOESbDHOnVAQlbImw7JA
UgpsC0yOnamPJjp8Gijb4futWnegpviUdxY6bntJQp6Z4frkRmtNXM1TN9c/5UYL
gtoAdZYWQh3Ch8wWGhOWljdapsKK/Zt4Yg2iPRUKsckC6lycPu7UdAHKqxST71/0
hAT5xZOyd7qZ7VWoST38jK24OQa30TJmoFGC26xJMuK/Z/zJ2J536UrwyyYhaJdh
dJw/Gy9d2+leIov2LYYvatQ3Te2KrKG+s/KJztxmxVaYHKQa6wDLIC4UzRsgfz4r
HYT2ANhSV6vqro4cSNCXZHAMIxzDt71kuGJWMXOncYoKSAzzM9pr1KncMmNDgkRc
Gb6Dl6wHwqVODPgTRtGhJxJRJurliJTRkL0y5givt/C02JwzqYSSId0+0iV4xkyK
vHfVzEHddcWbAYa9D2azeqnTVf3fACEmJb22Zt50bpEsRWFwSaI36aLaFdSAd+i7
27uV4veNMNGtohtkoKv42YRsLLZBWtJOkWFDNQErfflQOpGjSlcGSK+9ctCBEmjC
oUFtILJ0zCN5Fm4qP8UfjPYvXtKR/ER4Bg66jVtjaVEHrpkAbc326waNsN8wL9yy
fpGVosb03f0=
=RYph
-----END PGP SIGNATURE-----

--Sig_/t__qt_NfuySOcsYiB_9GtH.--
