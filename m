Received: from mail-108-mta217.mxroute.com (mail-108-mta217.mxroute.com [136.175.108.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D281714C0
	for <linux-raid@vger.kernel.org>; Tue, 18 Feb 2025 03:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850136; cv=none; b=YTVPamK9ZKoXjfCN8KaO7b5BLPOkgT5HuLPFTsMUQ0sUSuGNBZUr/iMckX+QeqP/Sj2lhFR5jnUq2pOWIPKXpD5Wu+yE1pBTpNWtsNdfXmkiwQ18BuLVQExQVXUgB4wk8t0wZRMCZUualrlgOME9PaHERnu7Yx/94nzVb92/kYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850136; c=relaxed/simple;
	bh=SjH2wKbhyp7j5RNjOm1yv7rZPPIAReqfrpQNTXysipQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AYpRzg4wW6Bz+ukxOu8Dm9ht5AbMCHa/GfuaiaRRh2qVBfZtckQ0hLzHe98jHDlWAzjuO7XABtrKDl41+9kPyKLQuNjhjlPaA0S3YVMwshheWb7sacpX6GjeYi9ZHaCQuCWFdTxEt2MVifeynmcAw1Q0uZ1Ge0u+NpjZtMBu2DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=DT2XRaUX; arc=none smtp.client-ip=136.175.108.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="DT2XRaUX"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta217.mxroute.com (ZoneMTA) with ESMTPSA id 19517217a8b000310e.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 18 Feb 2025 03:37:04 +0000
X-Zone-Loop: 372a0ca110c214ef3f32b283a013a77af697ab76c34a
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XXgUNqOqGy0X+/pew+wiikQ3YM2rEIXdDR+8AJcYBiU=; b=DT2XRaUXR3VVHFFJqMVKA5PwrR
	oxF1FKzyJuaSVslUAZZnjXl/V9f9aot55ys2wR3JoxJ7DmpoCceys4oLUmcFFPQPI8KUmNjwD2ukJ
	WGxMpdt2bYvafUiXl+vIuSmhVBurAjYiLkGuFe1XMyLhJzkd+sfO1YpQxku6UgpufLmk58ZW7q84T
	a3THzTfQXVYoXwnnpjaJoNThE5jUfwQ4UnW2fKHdjQMzvnD0UXQdCVOwirct5Vinnr33SaFfimlKy
	jHhJR1yKCbo2ZvntS8Ti1/qz4yXgVs38PBE7as7eB2O8k83+fTYey6GMLrRP7F+BJ5LbRj0QsEacg
	46ASOxSg==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org,  yukuai3@huawei.com,  linux-raid@vger.kernel.org,
  linux-kernel@vger.kernel.org,  yi.zhang@huawei.com,  yangerkun@huawei.com
Subject: Re: [PATCH md-6.15 6/7] md: don't export md_cluster_ops
In-Reply-To: <20250215092225.2427977-7-yukuai1@huaweicloud.com> (Yu Kuai's
	message of "Sat, 15 Feb 2025 17:22:24 +0800")
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
	<20250215092225.2427977-7-yukuai1@huaweicloud.com>
User-Agent: mu4e 1.12.7; emacs 29.4
Date: Tue, 18 Feb 2025 11:36:55 +0800
Message-ID: <1pvv7wko.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Sat 15 Feb 2025 at 17:22, Yu Kuai <yukuai1@huaweicloud.com> 
wrote:

> From: Yu Kuai <yukuai3@huawei.com>
>
> Add a new field 'cluster_ops' and initialize it 
> md_setup_cluster(), so
> that the gloable variable 'md_cluter_ops' doesn't need to be 
> exported.
> Also prepare to switch md-cluster to use md_submod_head.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c |  6 +--
>  drivers/md/md.c        | 94 
>  ++++++++++++++++++++++++------------------
>  drivers/md/md.h        |  3 +-
>  drivers/md/raid1-10.c  |  4 +-
>  drivers/md/raid1.c     | 10 ++---
>  drivers/md/raid10.c    | 18 ++++----
>  6 files changed, 76 insertions(+), 59 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 71aa7dc80e26..9ac23e02b606 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -944,7 +944,7 @@ static int md_bitmap_read_sb(struct bitmap 
> *bitmap)
>  				bmname(bitmap), err);
>  			goto out_no_sb;
>  		}
> -		bitmap->cluster_slot = 
> md_cluster_ops->slot_number(bitmap->mddev);
> +		bitmap->cluster_slot = 
> bitmap->mddev->cluster_ops->slot_number(bitmap->mddev);
>  		goto re_read;
>  	}
>
> @@ -2023,7 +2023,7 @@ static void md_bitmap_free(void *data)
>  		sysfs_put(bitmap->sysfs_can_clear);
>
>  	if (mddev_is_clustered(bitmap->mddev) && 
>  bitmap->mddev->cluster_info &&
> -		bitmap->cluster_slot == 
> md_cluster_ops->slot_number(bitmap->mddev))
> +		bitmap->cluster_slot == 
> bitmap->mddev->cluster_ops->slot_number(bitmap->mddev))
>  		md_cluster_stop(bitmap->mddev);
>
>  	/* Shouldn't be needed - but just in case.... */
> @@ -2231,7 +2231,7 @@ static int bitmap_load(struct mddev 
> *mddev)
>  		mddev_create_serial_pool(mddev, rdev);
>
>  	if (mddev_is_clustered(mddev))
> -		md_cluster_ops->load_bitmaps(mddev, 
> mddev->bitmap_info.nodes);
> +		mddev->cluster_ops->load_bitmaps(mddev, 
> mddev->bitmap_info.nodes);
>
>  	/* Clear out old bitmap info first:  Either there is none, or 
>  we
>  	 * are resuming after someone else has possibly changed 
>  things,
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 498ae11e3f6e..d94c9aa8c3aa 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -85,8 +85,7 @@ static DEFINE_SPINLOCK(pers_lock);
>
>  static const struct kobj_type md_ktype;
>
> -const struct md_cluster_operations *md_cluster_ops;
> -EXPORT_SYMBOL(md_cluster_ops);
> +static const struct md_cluster_operations *md_cluster_ops;
>  static struct module *md_cluster_mod;
>
>  static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
> @@ -2663,11 +2662,11 @@ void md_update_sb(struct mddev *mddev, 
> int force_change)
>  			force_change = 1;
>  		if (test_and_clear_bit(MD_SB_CHANGE_CLEAN, 
>  &mddev->sb_flags))
>  			nospares = 1;
> -		ret = md_cluster_ops->metadata_update_start(mddev);
> +		ret = mddev->cluster_ops->metadata_update_start(mddev);
>  		/* Has someone else has updated the sb */
>  		if (!does_sb_need_changing(mddev)) {
>  			if (ret == 0)
> -				md_cluster_ops->metadata_update_cancel(mddev);
> +				mddev->cluster_ops->metadata_update_cancel(mddev);
>  			bit_clear_unless(&mddev->sb_flags, 
>  BIT(MD_SB_CHANGE_PENDING),
>  							 BIT(MD_SB_CHANGE_DEVS) |
>  							 BIT(MD_SB_CHANGE_CLEAN));
> @@ -2807,7 +2806,7 @@ void md_update_sb(struct mddev *mddev, int 
> force_change)
>  	/* if there was a failure, MD_SB_CHANGE_DEVS was set, and we 
>  re-write super */
>
>  	if (mddev_is_clustered(mddev) && ret == 0)
> -		md_cluster_ops->metadata_update_finish(mddev);
> +		mddev->cluster_ops->metadata_update_finish(mddev);
>
>  	if (mddev->in_sync != sync_req ||
>  	    !bit_clear_unless(&mddev->sb_flags, 
>  BIT(MD_SB_CHANGE_PENDING),
> @@ -2966,7 +2965,7 @@ state_store(struct md_rdev *rdev, const 
> char *buf, size_t len)
>  		else {
>  			err = 0;
>  			if (mddev_is_clustered(mddev))
> -				err = md_cluster_ops->remove_disk(mddev, rdev);
> +				err = mddev->cluster_ops->remove_disk(mddev, 
> rdev);
>
>  			if (err == 0) {
>  				md_kick_rdev_from_array(rdev);
> @@ -3076,7 +3075,7 @@ state_store(struct md_rdev *rdev, const 
> char *buf, size_t len)
>  			 * by this node eventually
>  			 */
>  			if (!mddev_is_clustered(rdev->mddev) ||
> -			    (err = md_cluster_ops->gather_bitmaps(rdev)) == 0) 
> {
> +			    (err = mddev->cluster_ops->gather_bitmaps(rdev)) 
> == 0) {
>  				clear_bit(Faulty, &rdev->flags);
>  				err = add_bound_rdev(rdev);
>  			}
> @@ -6994,7 +6993,7 @@ int md_add_new_disk(struct mddev *mddev, 
> struct mdu_disk_info_s *info)
>  				set_bit(Candidate, &rdev->flags);
>  			else if (info->state & (1 << MD_DISK_CLUSTER_ADD)) {
>  				/* --add initiated by this node */
> -				err = md_cluster_ops->add_new_disk(mddev, rdev);
> +				err = mddev->cluster_ops->add_new_disk(mddev, 
> rdev);
>  				if (err) {
>  					export_rdev(rdev, mddev);
>  					return err;
> @@ -7011,14 +7010,14 @@ int md_add_new_disk(struct mddev *mddev, 
> struct mdu_disk_info_s *info)
>  		if (mddev_is_clustered(mddev)) {
>  			if (info->state & (1 << MD_DISK_CANDIDATE)) {
>  				if (!err) {
> -					err = md_cluster_ops->new_disk_ack(mddev,
> -						err == 0);
> +					err = mddev->cluster_ops->new_disk_ack(
> +							mddev, err == 0);
>  					if (err)
>  						md_kick_rdev_from_array(rdev);
>  				}
>  			} else {
>  				if (err)
> -					md_cluster_ops->add_new_disk_cancel(mddev);
> + 
> mddev->cluster_ops->add_new_disk_cancel(mddev);
>  				else
>  					err = add_bound_rdev(rdev);
>  			}
> @@ -7098,10 +7097,9 @@ static int hot_remove_disk(struct mddev 
> *mddev, dev_t dev)
>  		goto busy;
>
>  kick_rdev:
> -	if (mddev_is_clustered(mddev)) {
> -		if (md_cluster_ops->remove_disk(mddev, rdev))
> -			goto busy;
> -	}
> +	if (mddev_is_clustered(mddev) &&
> +	    mddev->cluster_ops->remove_disk(mddev, rdev))
> +		goto busy;
>
>  	md_kick_rdev_from_array(rdev);
>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> @@ -7404,7 +7402,7 @@ static int update_size(struct mddev 
> *mddev, sector_t num_sectors)
>  	rv = mddev->pers->resize(mddev, num_sectors);
>  	if (!rv) {
>  		if (mddev_is_clustered(mddev))
> -			md_cluster_ops->update_size(mddev, old_dev_sectors);
> +			mddev->cluster_ops->update_size(mddev, 
> old_dev_sectors);
>  		else if (!mddev_is_dm(mddev))
>  			set_capacity_and_notify(mddev->gendisk,
>  						mddev->array_sectors);
> @@ -7452,6 +7450,27 @@ static int update_raid_disks(struct mddev 
> *mddev, int raid_disks)
>  	return rv;
>  }
>
> +static int get_cluster_ops(struct mddev *mddev)
> +{
> +	spin_lock(&pers_lock);
> +	mddev->cluster_ops = md_cluster_ops;
> +	if (mddev->cluster_ops && !try_module_get(md_cluster_mod))
>
It was little confusing here to me. But the logic is clear after
PATCH 7. So:

Reviewed-by: Su Yue <glass.su@suse.com>
> +		mddev->cluster_ops = NULL;
> +	spin_unlock(&pers_lock);
> +
> +	return mddev->cluster_ops == NULL ? -ENOENT : 0;
> +}
> +
> +static void put_cluster_ops(struct mddev *mddev)
> +{
> +	if (!mddev->cluster_ops)
> +		return;
> +
> +	mddev->cluster_ops->leave(mddev);
> +	module_put(md_cluster_mod);
> +	mddev->cluster_ops = NULL;
> +}
> +
>  /*
>   * update_array_info is used to change the configuration of an
>   * on-line array.
> @@ -7560,16 +7579,15 @@ static int update_array_info(struct 
> mddev *mddev, mdu_array_info_t *info)
>
>  			if (mddev->bitmap_info.nodes) {
>  				/* hold PW on all the bitmap lock */
> -				if (md_cluster_ops->lock_all_bitmaps(mddev) <= 0) 
> {
> +				if (mddev->cluster_ops->lock_all_bitmaps(mddev) <= 
> 0) {
>  					pr_warn("md: can't change bitmap to none since 
>  the array is in use by more than one node\n");
>  					rv = -EPERM;
> -					md_cluster_ops->unlock_all_bitmaps(mddev);
> +					mddev->cluster_ops->unlock_all_bitmaps(mddev);
>  					goto err;
>  				}
>
>  				mddev->bitmap_info.nodes = 0;
> -				md_cluster_ops->leave(mddev);
> -				module_put(md_cluster_mod);
> +				put_cluster_ops(mddev);
>  				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
>  			}
>  			mddev->bitmap_ops->destroy(mddev);
> @@ -7853,7 +7871,7 @@ static int md_ioctl(struct block_device 
> *bdev, blk_mode_t mode,
>
>  	case CLUSTERED_DISK_NACK:
>  		if (mddev_is_clustered(mddev))
> -			md_cluster_ops->new_disk_ack(mddev, false);
> +			mddev->cluster_ops->new_disk_ack(mddev, false);
>  		else
>  			err = -EINVAL;
>  		goto unlock;
> @@ -8568,19 +8586,20 @@ 
> EXPORT_SYMBOL(unregister_md_cluster_operations);
>
>  int md_setup_cluster(struct mddev *mddev, int nodes)
>  {
> -	int ret;
> -	if (!md_cluster_ops)
> +	int ret = get_cluster_ops(mddev);
> +
> +	if (ret) {
>  		request_module("md-cluster");
> -	spin_lock(&pers_lock);
> +		ret = get_cluster_ops(mddev);
> +	}
> +
>  	/* ensure module won't be unloaded */
> -	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
> +	if (ret) {
>  		pr_warn("can't find md-cluster module or get its 
>  reference.\n");
> -		spin_unlock(&pers_lock);
> -		return -ENOENT;
> +		return ret;
>  	}
> -	spin_unlock(&pers_lock);
>
> -	ret = md_cluster_ops->join(mddev, nodes);
> +	ret = mddev->cluster_ops->join(mddev, nodes);
>  	if (!ret)
>  		mddev->safemode_delay = 0;
>  	return ret;
> @@ -8588,10 +8607,7 @@ int md_setup_cluster(struct mddev *mddev, 
> int nodes)
>
>  void md_cluster_stop(struct mddev *mddev)
>  {
> -	if (!md_cluster_ops)
> -		return;
> -	md_cluster_ops->leave(mddev);
> -	module_put(md_cluster_mod);
> +	put_cluster_ops(mddev);
>  }
>
>  static int is_mddev_idle(struct mddev *mddev, int init)
> @@ -8984,7 +9000,7 @@ void md_do_sync(struct md_thread *thread)
>  	}
>
>  	if (mddev_is_clustered(mddev)) {
> -		ret = md_cluster_ops->resync_start(mddev);
> +		ret = mddev->cluster_ops->resync_start(mddev);
>  		if (ret)
>  			goto skip;
>
> @@ -9011,7 +9027,7 @@ void md_do_sync(struct md_thread *thread)
>  	 *
>  	 */
>  	if (mddev_is_clustered(mddev))
> -		md_cluster_ops->resync_start_notify(mddev);
> +		mddev->cluster_ops->resync_start_notify(mddev);
>  	do {
>  		int mddev2_minor = -1;
>  		mddev->curr_resync = MD_RESYNC_DELAYED;
> @@ -9795,7 +9811,7 @@ void md_reap_sync_thread(struct mddev 
> *mddev)
>  	 * call resync_finish here if MD_CLUSTER_RESYNC_LOCKED is set 
>  by
>  	 * clustered raid */
>  	if (test_and_clear_bit(MD_CLUSTER_RESYNC_LOCKED, 
>  &mddev->flags))
> -		md_cluster_ops->resync_finish(mddev);
> +		mddev->cluster_ops->resync_finish(mddev);
>  	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> @@ -9803,13 +9819,13 @@ void md_reap_sync_thread(struct mddev 
> *mddev)
>  	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>  	/*
> -	 * We call md_cluster_ops->update_size here because sync_size 
> could
> +	 * We call mddev->cluster_ops->update_size here because 
> sync_size could
>  	 * be changed by md_update_sb, and MD_RECOVERY_RESHAPE is 
>  cleared,
>  	 * so it is time to update size across cluster.
>  	 */
>  	if (mddev_is_clustered(mddev) && is_reshaped
>  				      && !test_bit(MD_CLOSING, &mddev->flags))
> -		md_cluster_ops->update_size(mddev, old_dev_sectors);
> +		mddev->cluster_ops->update_size(mddev, old_dev_sectors);
>  	/* flag recovery needed just to double check */
>  	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  	sysfs_notify_dirent_safe(mddev->sysfs_completed);
> @@ -10035,7 +10051,7 @@ static void check_sb_changes(struct 
> mddev *mddev, struct md_rdev *rdev)
>  			if (rdev2->raid_disk == -1 && role != 
>  MD_DISK_ROLE_SPARE &&
>  			    !(le32_to_cpu(sb->feature_map) &
>  			      MD_FEATURE_RESHAPE_ACTIVE) &&
> -			    !md_cluster_ops->resync_status_get(mddev)) {
> +			    !mddev->cluster_ops->resync_status_get(mddev)) {
>  				/*
>  				 * -1 to make raid1_add_disk() set conf->fullsync
>  				 * to 1. This could avoid skipping sync when the
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index f9e0f0d390f1..873f33e2a1f6 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -320,6 +320,7 @@ extern int rdev_set_badblocks(struct md_rdev 
> *rdev, sector_t s, int sectors,
>  extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t 
>  s, int sectors,
>  				int is_new);
>  struct md_cluster_info;
> +struct md_cluster_operations;
>
>  /**
>   * enum mddev_flags - md device flags.
> @@ -602,6 +603,7 @@ struct mddev {
>  	mempool_t *serial_info_pool;
>  	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
>  	struct md_cluster_info		*cluster_info;
> +	const struct md_cluster_operations *cluster_ops;
>  	unsigned int			good_device_nr;	/* good device num 
>  within cluster raid */
>  	unsigned int			noio_flag; /* for memalloc scope API 
>  */
>
> @@ -947,7 +949,6 @@ static inline void rdev_dec_pending(struct 
> md_rdev *rdev, struct mddev *mddev)
>  	}
>  }
>
> -extern const struct md_cluster_operations *md_cluster_ops;
>  static inline int mddev_is_clustered(struct mddev *mddev)
>  {
>  	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 4378d3250bd7..4a51b151a981 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -287,8 +287,8 @@ static inline bool 
> raid1_should_read_first(struct mddev *mddev,
>  		return true;
>
>  	if (mddev_is_clustered(mddev) &&
> -	    md_cluster_ops->area_resyncing(mddev, READ, this_sector,
> -					   this_sector + len))
> +	    mddev->cluster_ops->area_resyncing(mddev, READ, 
> this_sector,
> +					       this_sector + len))
>  		return true;
>
>  	return false;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c4bfd190c698..f7761a19482f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1468,7 +1468,7 @@ static void raid1_write_request(struct 
> mddev *mddev, struct bio *bio,
>  	bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);
>
>  	if (mddev_is_clustered(mddev) &&
> -	     md_cluster_ops->area_resyncing(mddev, WRITE,
> +	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
>  		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
>
>  		DEFINE_WAIT(w);
> @@ -1479,7 +1479,7 @@ static void raid1_write_request(struct 
> mddev *mddev, struct bio *bio,
>  		for (;;) {
>  			prepare_to_wait(&conf->wait_barrier,
>  					&w, TASK_IDLE);
> -			if (!md_cluster_ops->area_resyncing(mddev, WRITE,
> +			if (!mddev->cluster_ops->area_resyncing(mddev, WRITE,
>  							bio->bi_iter.bi_sector,
>  							bio_end_sector(bio)))
>  				break;
> @@ -3039,9 +3039,9 @@ static sector_t raid1_sync_request(struct 
> mddev *mddev, sector_t sector_nr,
>  		conf->cluster_sync_low = mddev->curr_resync_completed;
>  		conf->cluster_sync_high = conf->cluster_sync_low + 
>  CLUSTER_RESYNC_WINDOW_SECTORS;
>  		/* Send resync message */
> -		md_cluster_ops->resync_info_update(mddev,
> -				conf->cluster_sync_low,
> -				conf->cluster_sync_high);
> +		mddev->cluster_ops->resync_info_update(mddev,
> +						       conf->cluster_sync_low,
> +						       conf->cluster_sync_high);
>  	}
>
>  	/* For a user-requested sync, we read all readable devices and 
>  do a
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5823329841ba..e68aa4b134ee 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1356,9 +1356,9 @@ static void raid10_write_request(struct 
> mddev *mddev, struct bio *bio,
>  	int error;
>
>  	if ((mddev_is_clustered(mddev) &&
> -	     md_cluster_ops->area_resyncing(mddev, WRITE,
> -					    bio->bi_iter.bi_sector,
> -					    bio_end_sector(bio)))) {
> +	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
> +						bio->bi_iter.bi_sector,
> +						bio_end_sector(bio)))) {
>  		DEFINE_WAIT(w);
>  		/* Bail out if REQ_NOWAIT is set for the bio */
>  		if (bio->bi_opf & REQ_NOWAIT) {
> @@ -1368,7 +1368,7 @@ static void raid10_write_request(struct 
> mddev *mddev, struct bio *bio,
>  		for (;;) {
>  			prepare_to_wait(&conf->wait_barrier,
>  					&w, TASK_IDLE);
> -			if (!md_cluster_ops->area_resyncing(mddev, WRITE,
> +			if (!mddev->cluster_ops->area_resyncing(mddev, WRITE,
>  				 bio->bi_iter.bi_sector, bio_end_sector(bio)))
>  				break;
>  			schedule();
> @@ -3717,7 +3717,7 @@ static sector_t raid10_sync_request(struct 
> mddev *mddev, sector_t sector_nr,
>  			conf->cluster_sync_low = mddev->curr_resync_completed;
>  			raid10_set_cluster_sync_high(conf);
>  			/* Send resync message */
> -			md_cluster_ops->resync_info_update(mddev,
> +			mddev->cluster_ops->resync_info_update(mddev,
>  						conf->cluster_sync_low,
>  						conf->cluster_sync_high);
>  		}
> @@ -3750,7 +3750,7 @@ static sector_t raid10_sync_request(struct 
> mddev *mddev, sector_t sector_nr,
>  		}
>  		if (broadcast_msg) {
>  			raid10_set_cluster_sync_high(conf);
> -			md_cluster_ops->resync_info_update(mddev,
> +			mddev->cluster_ops->resync_info_update(mddev,
>  						conf->cluster_sync_low,
>  						conf->cluster_sync_high);
>  		}
> @@ -4544,7 +4544,7 @@ static int raid10_start_reshape(struct 
> mddev *mddev)
>  		if (ret)
>  			goto abort;
>
> -		ret = md_cluster_ops->resize_bitmaps(mddev, newsize, 
> oldsize);
> +		ret = mddev->cluster_ops->resize_bitmaps(mddev, newsize, 
> oldsize);
>  		if (ret) {
>  			mddev->bitmap_ops->resize(mddev, oldsize, 0, false);
>  			goto abort;
> @@ -4835,7 +4835,7 @@ static sector_t reshape_request(struct 
> mddev *mddev, sector_t sector_nr,
>  				conf->cluster_sync_low = sb_reshape_pos;
>  		}
>
> -		md_cluster_ops->resync_info_update(mddev, 
> conf->cluster_sync_low,
> +		mddev->cluster_ops->resync_info_update(mddev, 
> conf->cluster_sync_low,
>  							  conf->cluster_sync_high);
>  	}
>
> @@ -4980,7 +4980,7 @@ static void 
> raid10_update_reshape_pos(struct mddev *mddev)
>  	struct r10conf *conf = mddev->private;
>  	sector_t lo, hi;
>
> -	md_cluster_ops->resync_info_get(mddev, &lo, &hi);
> +	mddev->cluster_ops->resync_info_get(mddev, &lo, &hi);
>  	if (((mddev->reshape_position <= hi) && 
>  (mddev->reshape_position >= lo))
>  	    || mddev->reshape_position == MaxSector)
>  		conf->reshape_progress = mddev->reshape_position;
