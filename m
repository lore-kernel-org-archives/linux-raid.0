Received: from mail-108-mta84.mxroute.com (mail-108-mta84.mxroute.com [136.175.108.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F5C1779B8
	for <linux-raid@vger.kernel.org>; Tue, 18 Feb 2025 03:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850176; cv=none; b=fNsHvUAvT/CJFBAZJKTtxiv8iMDeRmHy6Keebu2hAjsHUtgE6ummRa1Ej8ij6ucr/Uk7DIXRjDkscyTp5J2z7kpMEfulnjktT4aWwZ/eWr1HZ+EO7NQdEUelCO7OX89y/CCJ7SJc3Y2LDGxM8BkoUpDUSl2bcJYrcvUWkSx6w8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850176; c=relaxed/simple;
	bh=UMb4+aFxMbquMvlxFby4LyKkJKijizTX+6HIQOeItpA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tdw3MW5t5WiGzm71v8WoerV4DijMA7UU33xghAoHheHxDb1Ig3Fe4Lju+Zx4qKKtK0m6JAwBoJKeC6nrPgyHWq+7VOi6hmE9/rHB5XjcHdbyLPfuzsOMA3gTem1sr6NhFXzxpayHYtXXpnXtfNCXTD2DFTHYifI0633pWoK+mAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=XXclZVOs; arc=none smtp.client-ip=136.175.108.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="XXclZVOs"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta84.mxroute.com (ZoneMTA) with ESMTPSA id 195172208bf000310e.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 18 Feb 2025 03:37:41 +0000
X-Zone-Loop: de1dac1012e64b2b6fac2182cc17b4061e7d12ace406
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pcNEJUXstr2iXp5Ip0XOYc8QKaMXHVJikJqjpPxPeRE=; b=XXclZVOsEaJcMtAo9/y2TSv4Tx
	MAGeuF7tnvB02fEDerYmdt1MlhVNvla2LrVfrReaYwyA81FVaf/ZXDrF1DsrTdgpyjwb8FAKwY23u
	NrWQOUFXVlP1BbMPrE4Vb6e9GrOY3Jbrg+uxxsgDyfOPmgmesA1myn8dqKGY6iaSwLm5mMOVFmZ3m
	+kDWA6KEfnIL0fdbUtHECkaOIXrMhgOTS2N6BAPFyE6fsq0M/kM33abnEZ/xR8yIwKlDTqR8jnGLB
	rNeL6tcg+w31o/AVDeF5DHrVk/Oeauq5C0btoMWESULByk2J++EX0Db/X4naF91KLcuNkstO54Vig
	6h5UjtLQ==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org,  yukuai3@huawei.com,  linux-raid@vger.kernel.org,
  linux-kernel@vger.kernel.org,  yi.zhang@huawei.com,  yangerkun@huawei.com
Subject: Re: [PATCH md-6.15 7/7] md: switch md-cluster to use md_submodle_head
In-Reply-To: <20250215092225.2427977-8-yukuai1@huaweicloud.com> (Yu Kuai's
	message of "Sat, 15 Feb 2025 17:22:25 +0800")
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
	<20250215092225.2427977-8-yukuai1@huaweicloud.com>
User-Agent: mu4e 1.12.7; emacs 29.4
Date: Tue, 18 Feb 2025 11:37:32 +0800
Message-ID: <v7t76hz7.fsf@damenly.org>
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
> To make code cleaner, and prepare to add kconfig for bitmap.
>
> Also remove the unsed global variables pers_lock, md_cluster_ops 
> and
> md_cluster_mod, and exported symbols 
> register_md_cluster_operations(),
> unregister_md_cluster_operations() and md_cluster_ops.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>
Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>  drivers/md/md-cluster.c | 14 ++++++++++----
>  drivers/md/md-cluster.h |  3 ---
>  drivers/md/md.c         | 41 
>  ++++++-----------------------------------
>  drivers/md/md.h         |  2 +-
>  4 files changed, 17 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 6fd436a1d373..94221d964d4f 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1612,7 +1612,14 @@ static int gather_bitmaps(struct md_rdev 
> *rdev)
>  	return err;
>  }
>
> -static const struct md_cluster_operations cluster_ops = {
> +static struct md_cluster_operations cluster_ops = {
> +	.head = {
> +		.type	= MD_CLUSTER,
> +		.id	= ID_CLUSTER,
> +		.name	= "cluster",
> +		.owner	= THIS_MODULE,
> +	},
> +
>  	.join   = join,
>  	.leave  = leave,
>  	.slot_number = slot_number,
> @@ -1642,13 +1649,12 @@ static int __init cluster_init(void)
>  {
>  	pr_warn("md-cluster: support raid1 and raid10 (limited 
>  support)\n");
>  	pr_info("Registering Cluster MD functions\n");
> -	register_md_cluster_operations(&cluster_ops, THIS_MODULE);
> -	return 0;
> +	return register_md_submodule(&cluster_ops.head);
>  }
>
>  static void cluster_exit(void)
>  {
> -	unregister_md_cluster_operations();
> +	unregister_md_submodule(&cluster_ops.head);
>  }
>
>  module_init(cluster_init);
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index 4e842af11fb4..8fb06d853173 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -37,9 +37,6 @@ struct md_cluster_operations {
>  	void (*update_size)(struct mddev *mddev, sector_t 
>  old_dev_sectors);
>  };
>
> -extern int register_md_cluster_operations(const struct 
> md_cluster_operations *ops,
> -		struct module *module);
> -extern int unregister_md_cluster_operations(void);
>  extern int md_setup_cluster(struct mddev *mddev, int nodes);
>  extern void md_cluster_stop(struct mddev *mddev);
>  extern void md_reload_sb(struct mddev *mddev, int raid_disk);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d94c9aa8c3aa..4d93cc1aaabc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -81,13 +81,8 @@ static const char 
> *action_name[NR_SYNC_ACTIONS] = {
>
>  static DEFINE_XARRAY(md_submodule);
>
> -static DEFINE_SPINLOCK(pers_lock);
> -
>  static const struct kobj_type md_ktype;
>
> -static const struct md_cluster_operations *md_cluster_ops;
> -static struct module *md_cluster_mod;
> -
>  static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
>  static struct workqueue_struct *md_wq;
>
> @@ -7452,11 +7447,12 @@ static int update_raid_disks(struct 
> mddev *mddev, int raid_disks)
>
>  static int get_cluster_ops(struct mddev *mddev)
>  {
> -	spin_lock(&pers_lock);
> -	mddev->cluster_ops = md_cluster_ops;
> -	if (mddev->cluster_ops && !try_module_get(md_cluster_mod))
> +	xa_lock(&md_submodule);
> +	mddev->cluster_ops = xa_load(&md_submodule, ID_CLUSTER);
> +	if (mddev->cluster_ops &&
> +	    !try_module_get(mddev->cluster_ops->head.owner))
>  		mddev->cluster_ops = NULL;
> -	spin_unlock(&pers_lock);
> +	xa_unlock(&md_submodule);
>
>  	return mddev->cluster_ops == NULL ? -ENOENT : 0;
>  }
> @@ -7467,7 +7463,7 @@ static void put_cluster_ops(struct mddev 
> *mddev)
>  		return;
>
>  	mddev->cluster_ops->leave(mddev);
> -	module_put(md_cluster_mod);
> +	module_put(mddev->cluster_ops->head.owner);
>  	mddev->cluster_ops = NULL;
>  }
>
> @@ -8559,31 +8555,6 @@ void unregister_md_submodule(struct 
> md_submodule_head *msh)
>  }
>  EXPORT_SYMBOL_GPL(unregister_md_submodule);
>
> -int register_md_cluster_operations(const struct 
> md_cluster_operations *ops,
> -				   struct module *module)
> -{
> -	int ret = 0;
> -	spin_lock(&pers_lock);
> -	if (md_cluster_ops != NULL)
> -		ret = -EALREADY;
> -	else {
> -		md_cluster_ops = ops;
> -		md_cluster_mod = module;
> -	}
> -	spin_unlock(&pers_lock);
> -	return ret;
> -}
> -EXPORT_SYMBOL(register_md_cluster_operations);
> -
> -int unregister_md_cluster_operations(void)
> -{
> -	spin_lock(&pers_lock);
> -	md_cluster_ops = NULL;
> -	spin_unlock(&pers_lock);
> -	return 0;
> -}
> -EXPORT_SYMBOL(unregister_md_cluster_operations);
> -
>  int md_setup_cluster(struct mddev *mddev, int nodes)
>  {
>  	int ret = get_cluster_ops(mddev);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 873f33e2a1f6..dd6a28f5d8e6 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -603,7 +603,7 @@ struct mddev {
>  	mempool_t *serial_info_pool;
>  	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
>  	struct md_cluster_info		*cluster_info;
> -	const struct md_cluster_operations *cluster_ops;
> +	struct md_cluster_operations *cluster_ops;
>  	unsigned int			good_device_nr;	/* good device num 
>  within cluster raid */
>  	unsigned int			noio_flag; /* for memalloc scope API 
>  */
