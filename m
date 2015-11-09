From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/6] md-cluster: Avoid the resync ping-pong
Date: Tue, 10 Nov 2015 10:39:33 +1100
Message-ID: <87k2pqspxm.fsf@notabene.neil.brown.name>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de> <1446781819-25571-2-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-2-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.de, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 06 2015, rgoldwyn@suse.de wrote:

> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> If a RESYNCING message with (0,0) has been sent before, do not send it
> again. This avoids a resync ping pong between the nodes. We read
> the bitmap lockresource's LVB to figure out the previous value
> of the RESYNCING message.

This seems like a bandaid more than a real fix, but maybe I'm wrong.
I'll apply it for now.  If I end of figuring out that there is some
other issue I discuss it then.

>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md-cluster.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index a93734e..3daa464 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -898,8 +898,16 @@ static int resync_start(struct mddev *mddev)
>  static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t=
 hi)
>  {
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> +	struct resync_info ri;
>  	struct cluster_msg cmsg =3D {0};
>=20=20
> +	/* do not send zero again, if we have sent before */
> +	if (hi =3D=3D 0) {
> +		memcpy(&ri, cinfo->bitmap_lockres->lksb.sb_lvbptr, sizeof(struct resyn=
c_info));
> +		if (le64_to_cpu(ri.hi) =3D=3D 0)
> +			return 0;

I feel this would look so much better as:
        if (hi =3D=3D 0) {=20
               struct resync_info ri;
               memcpy(&ri, cinfo->bitmap_lockres->lksb.sb_lvbptr,
                      sizeof(ri));
        }

so if you happened to resend it like that I'd probably remove what I
have already applied and use this instead.
(make variable more local, use sizeof(var) instead of sizeof(type), and
wrap the long line)

Thanks,
NeilBrown

> +	}
> +
>  	add_resync_info(mddev, cinfo->bitmap_lockres, lo, hi);
>  	/* Re-acquire the lock to refresh LVB */
>  	dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
> --=20
> 1.8.5.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWQS61AAoJEDnsnt1WYoG5uUsP/A4MbC8bLrm3J+eZEh8dSpFm
n51c7nntJHhGxqxEHNDFh/uy/wsGYvo5sD1wMlMev0x2F72Frg0DRlNb18tOtQaC
8GXlyQjnt5IaayhZHaXLpcs/5u0t0Ns/cZKr9dx0YqZsOvioOJLKZuNXWCfbESAK
YO6xdPN+bwnii1xN27ZK2XxCMAW+sdtMdaB5aRkYK7P8JfZN4f3Y4XFl28jO0GmR
kOmPwO6wjiFc1qCfpNB3/HBJmI2GSisD/82ZuHaaEf+sy9V+0srsGusikyimhztJ
ghYb0JYyrH2WRTjq9B7ZKzlzlON1KqiI8hRiqmRBxTMUj0nvcmPuTcRVMeKjZb21
oQFCIvkVjbfkGnhyhgrI73b9BviaVX7/r/NZ55f6IrPmtrV/u5SXBFc4KMy+7V39
VbRKhdlKmhcSdZjgsACz2xMjdYvm35z2BJj65Qu9mdKz2jqzmqtuk3kAfbcYfCfz
Vay+NG+Q2ktmumD/GsiuPZD9j30K/9e1uGDdUjgokVBJ+Ds61bYTtAQzcmA+vwTJ
i2mtxp83lfz8V9HiajTyOujLS2QKdxQaFaGStCPqJd08xB/JocjZTlwfbTcZSUvS
e2Hx6g+5yBy+Mbq9lx4bRHk91VswcDtJ63/Byv5SuoAH9xiaVcRuEGkocfIHXJyA
38bDU0NKmFpoBUgJzLRt
=0UWP
-----END PGP SIGNATURE-----
--=-=-=--
