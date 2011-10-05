From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] Set correct reshape restart position
Date: Wed, 5 Oct 2011 14:17:19 +1100
Message-ID: <20111005141719.4dcde7f6@notabene.brown>
References: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
	<20111004155404.27434.89339.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QDO8DBm07T6IePVrrLSbgxe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111004155404.27434.89339.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/QDO8DBm07T6IePVrrLSbgxe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Oct 2011 17:54:04 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> This patch version is simplified compared to previous one.
> There is no use of freeze_reshape flag in start_reshape(). It is assumed
> that for reshape starting condition reshape_progress field contains
> 0 value /correct start position/. For reshape restart case, it contains
> correct restart position. This approach doesn't make start_reshape()
> difficult to read/manage and /imho/ kernel changes to change mdstat
> reporting behavior are not necessary.
>=20
> Setting correct position allows user to see it in the mdstat during
> reshape restart and reshape process is not reported as resync.

Applied, thanks.

NeilBrown


>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 076375a..44505b3 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -696,15 +696,19 @@ static int subarray_set_num(char *container, struct=
 mdinfo *sra, char *name, int
>  	return rc;
>  }
> =20
> -int start_reshape(struct mdinfo *sra, int already_running)
> +int start_reshape(struct mdinfo *sra, int already_running, int data_disk=
s)
>  {
>  	int err;
> +	unsigned long long sync_max_to_set;
> +
>  	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
> -	err =3D sysfs_set_num(sra, NULL, "suspend_hi", 0);
> -	err =3D err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
> +	err =3D sysfs_set_num(sra, NULL, "suspend_hi", sra->reshape_progress);
> +	err =3D err ?: sysfs_set_num(sra, NULL, "suspend_lo",
> +				   sra->reshape_progress);
> +	sync_max_to_set =3D sra->reshape_progress / data_disks;
>  	if (!already_running)
> -		sysfs_set_num(sra, NULL, "sync_min", 0);
> -	err =3D err ?: sysfs_set_num(sra, NULL, "sync_max", 0);
> +		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
> +	err =3D err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
>  	if (!already_running)
>  		err =3D err ?: sysfs_set_str(sra, NULL, "sync_action", "reshape");
> =20
> @@ -2241,7 +2245,8 @@ started:
>  		}
>  	}
> =20
> -	err =3D start_reshape(sra, restart);
> +	err =3D start_reshape(sra, restart,
> +			    info->array.raid_disks - reshape.parity);
>  	if (err) {
>  		fprintf(stderr,=20
>  			Name ": Cannot %s reshape for %s\n",


--Sig_/QDO8DBm07T6IePVrrLSbgxe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi8w/G5fc6gV+Wb0RAiGlAKCKXbkyKpTLby0NOkhrDGSp4ZLNnACgjzG6
qSZ2G8oVobtzA2PBsaXtCUg=
=7le1
-----END PGP SIGNATURE-----

--Sig_/QDO8DBm07T6IePVrrLSbgxe--
