From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/6] md-cluster: Protect communication with mutexes
Date: Tue, 10 Nov 2015 10:31:06 +1100
Message-ID: <87mvumsqbp.fsf@notabene.neil.brown.name>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
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
> Communication can happen through multiple threads. It is possible that
> one thread steps over another threads sequence. So, we use mutexes to
> protect both the send and receive sequences.
>
> We use a new flag CLUSTER_MD_COMM_LOCKED which is used to detect
> if communication is already locked. This is useful for cases where we nee=
d to
> take and hold the token DLM lock for a while. This bit is set only
> after locking communication.

I don't understand what this flag is trying to achieve, but I'm fairly
sure it doesn't achieve it.

Maybe if it was test_and_set_bit in metadata_update_start, it might make
sense.  But then I would suggest that clearing the bit be moved to
unlock_comm()

Do you just want to use mutex_try_lock() to detect if communication is
already locked?

>
> Also, Remove stray/ununsed sb_mutex.

I already removed that it mainline - I should have mentioned.

Thanks,
NeilBrown


>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md-cluster.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index b73729b..a93734e 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -47,6 +47,7 @@ struct resync_info {
>  #define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
>  #define		MD_CLUSTER_SUSPEND_READ_BALANCING	2
>  #define		MD_CLUSTER_BEGIN_JOIN_CLUSTER		3
> +#define		MD_CLUSTER_COMM_LOCKED			4
>=20=20
>=20=20
>  struct md_cluster_info {
> @@ -54,7 +55,8 @@ struct md_cluster_info {
>  	dlm_lockspace_t *lockspace;
>  	int slot_number;
>  	struct completion completion;
> -	struct mutex sb_mutex;
> +	struct mutex recv_mutex;
> +	struct mutex send_mutex;
>  	struct dlm_lock_resource *bitmap_lockres;
>  	struct dlm_lock_resource *resync_lockres;
>  	struct list_head suspend_list;
> @@ -503,6 +505,7 @@ static void recv_daemon(struct md_thread *thread)
>  	struct cluster_msg msg;
>  	int ret;
>=20=20
> +	mutex_lock(&cinfo->recv_mutex);
>  	/*get CR on Message*/
>  	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
>  		pr_err("md/raid1:failed to get CR on MESSAGE\n");
> @@ -529,6 +532,7 @@ static void recv_daemon(struct md_thread *thread)
>  	ret =3D dlm_unlock_sync(message_lockres);
>  	if (unlikely(ret !=3D 0))
>  		pr_info("unlock msg failed return %d\n", ret);
> +	mutex_unlock(&cinfo->recv_mutex);
>  }
>=20=20
>  /* lock_comm()
> @@ -542,20 +546,22 @@ static int lock_comm(struct md_cluster_info *cinfo)
>  {
>  	int error;
>=20=20
> -	if (cinfo->token_lockres->mode =3D=3D DLM_LOCK_EX)
> -		return 0;
> +	mutex_lock(&cinfo->send_mutex);
>=20=20
>  	error =3D dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
>  	if (error)
>  		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
>  				__func__, __LINE__, error);
> +	mutex_lock(&cinfo->recv_mutex);
>  	return error;
>  }
>=20=20
>  static void unlock_comm(struct md_cluster_info *cinfo)
>  {
>  	WARN_ON(cinfo->token_lockres->mode !=3D DLM_LOCK_EX);
> +	mutex_unlock(&cinfo->recv_mutex);
>  	dlm_unlock_sync(cinfo->token_lockres);
> +	mutex_unlock(&cinfo->send_mutex);
>  }
>=20=20
>  /* __sendmsg()
> @@ -709,7 +715,8 @@ static int join(struct mddev *mddev, int nodes)
>  	init_completion(&cinfo->completion);
>  	set_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state);
>=20=20
> -	mutex_init(&cinfo->sb_mutex);
> +	mutex_init(&cinfo->send_mutex);
> +	mutex_init(&cinfo->recv_mutex);
>  	mddev->cluster_info =3D cinfo;
>=20=20
>  	memset(str, 0, 64);
> @@ -839,7 +846,12 @@ static int slot_number(struct mddev *mddev)
>=20=20
>  static int metadata_update_start(struct mddev *mddev)
>  {
> -	return lock_comm(mddev->cluster_info);
> +	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> +	int ret;
> +	if (test_and_clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state))
> +		return 0;
> +	ret =3D lock_comm(cinfo);
> +	return ret;
>  }
>=20=20
>  static int metadata_update_finish(struct mddev *mddev)
> @@ -864,6 +876,7 @@ static int metadata_update_finish(struct mddev *mddev)
>  		ret =3D __sendmsg(cinfo, &cmsg);
>  	} else
>  		pr_warn("md-cluster: No good device id found to send\n");
> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>  	unlock_comm(cinfo);
>  	return ret;
>  }
> @@ -871,6 +884,7 @@ static int metadata_update_finish(struct mddev *mddev)
>  static void metadata_update_cancel(struct mddev *mddev)
>  {
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>  	unlock_comm(cinfo);
>  }
>=20=20
> @@ -945,6 +959,7 @@ static int add_new_disk(struct mddev *mddev, struct m=
d_rdev *rdev)
>  	memcpy(cmsg.uuid, uuid, 16);
>  	cmsg.raid_slot =3D cpu_to_le32(rdev->desc_nr);
>  	lock_comm(cinfo);
> +	set_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>  	ret =3D __sendmsg(cinfo, &cmsg);
>  	if (ret)
>  		return ret;
> @@ -964,6 +979,7 @@ static int add_new_disk(struct mddev *mddev, struct m=
d_rdev *rdev)
>  static void add_new_disk_cancel(struct mddev *mddev)
>  {
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>  	unlock_comm(cinfo);
>  }
>=20=20
> --=20
> 1.8.5.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWQSy6AAoJEDnsnt1WYoG5bTAQAL8Rm4KFxNdxQ9TCGgSKBtic
VCvsrcl6os2DAdBzz0OWUut7Ness+wskl50HC9nfF5NTbZUtLVW6qk2qe2BSFTgk
tjwluWICsAnKpy5mCYUDfo6XuIBfGQnjPKlPg0DCu77ATCWktc6zR4yb9r2EgD5S
kHIosL46CTERI7mdvxJpq/znznoDY7yoMT8kenyy2OTS3nFb+jEryJl/nsnTQwU/
vPI6Fcy60LF2vU+HDcE8nMTj++AhBjry1Tt3RNgbVvyS1rrEAlBI63t+Hawvfl/t
z/qVfsZP2Hsfa1gakTizqJeO14QdwCAVf1R0Z6LDqz1n7nqSw1hWFO3c44tVoONQ
Gne76KwNUBc2lHP86gnp4nRNVINU2xiWv9ylrxykMZyX6wZE2/m5OmxKXSWh4PN9
7vsbh9O2JyKHqJ1rEn/q8Kq0tNpMSL8DL3aNoj5MXtKQ/LAX9gqi7xa4pTGNQs2F
UxgfmIQmTrUwCStFRzyMzza56EdFpY++3gZkBhxDLlaG6OGYnv3YU/NqG8m2wtgc
NBUaRK8zdhbrzXKfLCxDmopDZWbOUdaGJ7dAkmyrYgAqI7dhGVW3GZoiTSXw+8fe
f+wpseBSgwAPRrCscrj1pl582/ACJlRpcdYA98iivdByCn2wgiQBxhARbsx1H8X4
zqebS/SI4VIFpq3Wd3gq
=q/+j
-----END PGP SIGNATURE-----
--=-=-=--
