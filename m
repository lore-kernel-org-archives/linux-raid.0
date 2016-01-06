From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] raid5-cache: correctly handle stripe with enough journal space
Date: Wed, 06 Jan 2016 12:54:28 +1100
Message-ID: <871t9vxyjv.fsf@notabene.neil.brown.name>
References: <9ab2f48aab9ddc9aa7ac2b9b6a594a97c2d82f5f.1451954517.git.shli@fb.com> <8bafb456f68b960bebaff8b742021d565554d5d4.1451954517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8bafb456f68b960bebaff8b742021d565554d5d4.1451954517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 05 2016, Shaohua Li wrote:

> If there are spaces in journal, we do nothing. Likely a typo merging
> recent io_unit mempool patch.

Very likely.

I think the same effect as your patch can be achieved with

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 55a905e56e8a..6d2b4789a928 100644
=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -500,7 +500,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe=
_head *sh)
 		spin_unlock(&log->no_space_stripes_lock);
=20
 		r5l_wake_reclaim(log, reserve);
=2D
+	} else {
 		ret =3D r5l_log_stripe(log, sh, data_pages, parity_pages);
 		if (ret) {
 			spin_lock_irq(&log->io_list_lock);

Are you OK with me just merging that into the offending patch?

Thanks,
NeilBrown

>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 55a905e..d242a36 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -494,19 +494,19 @@ int r5l_write_stripe(struct r5l_log *log, struct st=
ripe_head *sh)
>  	mutex_lock(&log->io_mutex);
>  	/* meta + data */
>  	reserve =3D (1 + write_disks) << (PAGE_SHIFT - 9);
> -	if (!r5l_has_free_space(log, reserve)) {
> -		spin_lock(&log->no_space_stripes_lock);
> -		list_add_tail(&sh->log_list, &log->no_space_stripes);
> -		spin_unlock(&log->no_space_stripes_lock);
> -
> -		r5l_wake_reclaim(log, reserve);
> -
> +	if (r5l_has_free_space(log, reserve)) {
>  		ret =3D r5l_log_stripe(log, sh, data_pages, parity_pages);
>  		if (ret) {
>  			spin_lock_irq(&log->io_list_lock);
>  			list_add_tail(&sh->log_list, &log->no_mem_stripes);
>  			spin_unlock_irq(&log->io_list_lock);
>  		}
> +	} else {
> +		spin_lock(&log->no_space_stripes_lock);
> +		list_add_tail(&sh->log_list, &log->no_space_stripes);
> +		spin_unlock(&log->no_space_stripes_lock);
> +
> +		r5l_wake_reclaim(log, reserve);
>  	}
>=20=20
>  	mutex_unlock(&log->io_mutex);
> --=20
> 2.4.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjHPUAAoJEDnsnt1WYoG5BLwQAICdbm5e9tnO1dNCe4ksPrPM
UahH9SEhIjlTUnSS2be+Go+Q2yojDVuwkqXKfd/NtqSYJbbOLRZnBg7wcNuJ1RfZ
omECgB2W8hpQ4cjOmALLIYQ1yhLljxhj2TetxV2c6/+zcnIerh+nwLmfE/iVSaY/
dtd2a1ShWoDT8Hm4Z19UOXdRz38gb45Z5Ns7JVaIHFfyXK28UGpzz/0keqZgueVC
Ufy/xJWrdi41w6Tao4DMnLywRA0M+5WZ/pNIxA3PSaEKtJqNAx9ryMTGjwXVdwlU
2LUdpuExr3UkP7uN3CcMp/INbafKSWz9SCiQAo4G4Tl2BBUhF9fm2iMMfO6D3UTg
fUMIqm20mrVuVVewfMGcoEej5d9MZTAeK1qxgKOfCNVQwYaYziNacrVm0rjGCaVN
TrZb0lZIYrnsGu9CjmAyo4L60C9z+MQ2PIjtsehpU0R+eomwVn0vefFOg0VvVEoV
1jCaVYltuLsBLtrqc/lv44y8M+fARAXLh4ereG0jSxZ4hxVqd1aoSCh3m5Q7Q5vI
EJYF4qV1K0Er+gRVu+h7bR5QOTXmtXbFqn8osvQrIamsE9+JTBBiCf0R4U1etS9u
TB5/1MJPaUfOayBEAPoqjNAsAY76vaPkJ9fkBl8m7L8VeXuQkOsKaB+er5N1ggY/
bz7xEpTTuKAWmJxNWgnp
=HeYQ
-----END PGP SIGNATURE-----
--=-=-=--
