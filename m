From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] md-cluster: update comments for MD_CLUSTER_SEND_LOCKED_ALREADY
Date: Wed, 09 Dec 2015 08:17:34 +1100
Message-ID: <87bna0skr5.fsf@notabene.neil.brown.name>
References: <1449253972-26997-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449253972-26997-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 05 2015, Guoqing Jiang wrote:

> 1. fix unbalanced parentheses.
> 2. add more description about that MD_CLUSTER_SEND_LOCKED_ALREADY
>    will be cleared after set it in add_new_disk.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Applied, thanks.

NeilBrown

> ---
>  drivers/md/md-cluster.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index ad3ec7d..0ded8e9 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -53,11 +53,12 @@ struct resync_info {
>   * accomodate lock and hold. See next comment.
>   */
>  #define		MD_CLUSTER_SEND_LOCK			4
> -/* If cluster operations must lock the communication channel,
> - * so as to perform extra operations (and no other operation
> - * is allowed on the MD, such as adding a disk. Token needs
> - * to be locked and held until the operation completes with
> - * a md_update_sb(), which would eventually release the lock.
> +/* If cluster operations (such as adding a disk) must lock the
> + * communication channel, so as to perform extra operations
> + * (update metadata) and no other operation is allowed on the
> + * MD. Token needs to be locked and held until the operation
> + * completes witha md_update_sb(), which would eventually release
> + * the lock.
>   */
>  #define		MD_CLUSTER_SEND_LOCKED_ALREADY		5
>=20=20
> @@ -1021,6 +1022,18 @@ static int add_new_disk(struct mddev *mddev, struc=
t md_rdev *rdev)
>  		unlock_comm(cinfo);
>  	else {
>  		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
> +		/* Since MD_CHANGE_DEVS will be set in add_bound_rdev which
> +		 * will run soon after add_new_disk, the below path will be
> +		 * invoked:
> +		 *   md_wakeup_thread(mddev->thread)
> +		 *	-> conf->thread (raid1d)
> +		 *	-> md_check_recovery -> md_update_sb
> +		 *	-> metadata_update_start/finish
> +		 * MD_CLUSTER_SEND_LOCKED_ALREADY will be cleared eventually.
> +		 *
> +		 * For other failure cases, metadata_update_cancel and
> +		 * add_new_disk_cancel also clear below bit as well.
> +		 * */
>  		set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
>  		wake_up(&cinfo->wait);
>  	}
> --=20
> 2.1.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ0juAAoJEDnsnt1WYoG5Ey8QAJLxx4cjFyWvQS1u/3RfIfZ/
3MqkJMllXYU0t5u4gh4QPS1S22/sOIBdA9M6y41h8+S71d8tCzVRdQsWLYpzogTg
AYXbV8sv+M8NBeTJFwqw+m/12k7pyed7MAWgNuG7eTqg4g1nkGut1BvrOUYdEc1Y
n+l7aocWBLXxtJLUNYbADT1Zm+A+pv+j+XzTnCShQpsTSmZTXBM6uRwvHx0C7eI2
e+KARaLMPiNmeHT/DMqzEOzI1RbNXk+wj3XuEPLjJ1uXsl+qtmXEpt4R4n6UfpSt
t6prQyAdUl8N4sQmaSkgupTgbO6S9uhxm6qPX6spAvpajc5ZR264JEF2BDHVRQ/O
gVb8ZAnu6wG9zwPVK2tKnJfPci5vbYPs/NWks+5CaD5bWg149HE0Nm+Wob72/c8L
Hcv3bQnMQ23GR5BPvoDrz8ktQVqyDH4odQCqkpNrXEkBpDdfV1tsrAoBKOV12bsK
PZmhryfMDuiKSITer1RZaoxNp9tQ675SkKecqYGMvy2hG29uHWNrRBXY/zmtsx9F
OyKNY7go7o/dqFvW0PERMkY93S+Wbfh0nfvotmylHgIctmqUWqTJvOyNg+qY6q9s
+PtzaeD5Jq/JQzt+95lWI5i9+ThALmLB4HIw6jWOCgxsBq3/XwgM9t02bX/rT6PW
ilvC9x1hwX1Oh4rlmP2+
=g1QX
-----END PGP SIGNATURE-----
--=-=-=--
