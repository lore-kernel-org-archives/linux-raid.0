From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/6] md-cluster: remove a disk asynchronously from cluster environment
Date: Tue, 10 Nov 2015 10:43:59 +1100
Message-ID: <87h9kuspq8.fsf@notabene.neil.brown.name>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de> <1446781819-25571-3-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-3-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.de, linux-raid@vger.kernel.org
Cc: Guoqing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 06 2015, rgoldwyn@suse.de wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>
> For cluster raid, if one disk couldn't be reach in one node, then
> other nodes would receive the REMOVE message for the disk.
>
> In receiving node, we can't call md_kick_rdev_from_array to remove
> the disk from array synchronously since the disk might still be busy
> in this node. So let's set a ClusterRemove flag on the disk, then
> let the thread to do the removal job eventually.

Thanks.
I've applied this patch.
However
1/ it isn't against mainline.
2/ While the ClusterRemove flag is (currently) only used in a cluster
   configuration, the functionality that it represents isn't necessarily
   cluster specific.  So I would prefer a more generic name (like
   AutoRemove).
3/ similarly the test on mddev_is_cluster() in md_check_recovery()
   doesn't really search much purpose.

Thanks,
NeilBrown

>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md-cluster.c |  7 +++++--
>  drivers/md/md.c         | 12 ++++++++++++
>  drivers/md/md.h         |  1 +
>  3 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 3daa464..a681706 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -443,8 +443,11 @@ static void process_remove_disk(struct mddev *mddev,=
 struct cluster_msg *msg)
>  	struct md_rdev *rdev =3D md_find_rdev_nr_rcu(mddev,
>  						   le32_to_cpu(msg->raid_slot));
>=20=20
> -	if (rdev)
> -		md_kick_rdev_from_array(rdev);
> +	if (rdev) {
> +		set_bit(ClusterRemove, &rdev->flags);
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		md_wakeup_thread(mddev->thread);
> +	}
>  	else
>  		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n",
>  			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 44d0342..32ca592 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8222,6 +8222,18 @@ void md_check_recovery(struct mddev *mddev)
>  			goto unlock;
>  		}
>=20=20
> +		if (mddev_is_clustered(mddev)) {
> +			struct md_rdev *rdev;
> +			/* kick the device if another node issued a
> +			 * remove disk.
> +			 */
> +			rdev_for_each(rdev, mddev) {
> +				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
> +						rdev->raid_disk < 0)
> +					md_kick_rdev_from_array(rdev);
> +			}
> +		}
> +
>  		if (!mddev->external) {
>  			int did_change =3D 0;
>  			spin_lock(&mddev->lock);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 2ea0035..db54341 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -172,6 +172,7 @@ enum flag_bits {
>  				 * This device is seen locally but not
>  				 * by the whole cluster
>  				 */
> +	ClusterRemove,
>  };
>=20=20
>  #define BB_LEN_MASK	(0x00000000000001FFULL)
> --=20
> 1.8.5.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWQS+/AAoJEDnsnt1WYoG5pKwP/0604hNGv7317ieGmNk2TBYK
H6LAWdDGwuurCrL9UNHxuYwFCRfGpQnu2CmM5syC3DTNpbwHHlc2nKdxMNQgR914
RsKD7zofFADcadOx4U8GnKX168gySjoBlOFIxjVzMTKwwGQKFHxCDgNa3CaXrQE8
fqznRzVEs0NrHIyH/l83mwCOWJHN4zgiZjgFnxQvss1GtBdGXKqhch4t/KZnbU6I
fkldVCDEcSoLOsEMbCABa9avBcVZ7rNc4TR2bZ1kWBkUAB9FliGbxsYKZlBtvJSU
f7WoSo9GUb2l256sD80Wsv317hbeBm8mqcHTQM991JcuxmL6qTaicFajW7vYvIXy
QbpnYPBKH+LfMZ/jfEIOL1kRCBDbX5jw/IIdZYSICGHA7vPZRKNEEg8PO2ds7khB
CnO/unSEITUhoFzpM0AXDdzN8JABA+v4ubbEHXxty8mMDyh+orfaSahqCq1LcLeY
xgkjUwj3uBalaO7wuj8a8lQ4B2Q+ehoslsadyjnm2kfFoWqusqKUuNpypjZQd3+Z
rEwxQknSQsjMRLjFsz5VktZWlDYONKHGfMGoUrXRiBgdCFEl+04f5W2kQ1otTbZG
9weABvoHscyw9Uooc6BLPnYDmhIVTAV4ekFEsJoqiJMPEGqVSib83ZmYbedjp4J8
vf2O79nhLTgAC6qinzY0
=lgyv
-----END PGP SIGNATURE-----
--=-=-=--
