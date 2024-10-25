Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9ED18D647;
	Fri, 25 Oct 2024 07:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729839779; cv=none; b=dAMDpmLzBYm73PP8H3dPjr5UgcBrNmVoRAQ9mLUlsAox20uLy47rqmA/5IEa25oPmMk+3/WMyIkhVNPN2DmHTuscFtfcKG0Vd0sgeCOsX+b1frIXiLjt6/8Kq1owVEC75vYxopXtuNFEtJjUe+mgKU7HbRejgJ4qbOCCVeQbbZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729839779; c=relaxed/simple;
	bh=oQlNJzVZRWRn98aQlsoRsWVn7hYEtmIV4lw8MW7oHfw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UjLo9gnfkb8iGt8boJitb15/beBRt1OwjF5RSH7VObn0TL37ws+2ykSgZfJ2wj3DYhS69RZSd1hxy84ngBTBDHsqA2+OPvHdYiW6hWiOovYKkNdxR8m8qetWNpeup7YMTYkdnkbYodRltG+zEytVwTe3TCBCsyRR/+HBCLQNt0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+n4LfHT; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+n4LfHT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729839777; x=1761375777;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oQlNJzVZRWRn98aQlsoRsWVn7hYEtmIV4lw8MW7oHfw=;
  b=G+n4LfHTzxfLZJ7m/vYybwTUlQwzhnQIg6J0STXqcSoB0xhWb6aiKZQn
   DUeTmYN+elfVi3sY9iRi4GDuwCc1Nu/jhi858STFCbPXGUBvUQ9qhlz2I
   Dv4c1s4VF2KF0XadPNQYjBWEKZC9Lgq1h2XZ3GM7JdJ9sDGjwsnEJYxnv
   GTN7hwC4obcfSAjTE3rpoXofDQydmMmNz7BYt2gXY0JETB0A/Vaiqm9Dn
   rMOoqXuWJfv5el/MTfxJZu/4IaPhD871X9Yk3fnnOrRlMQaPstqg+84H7
   OOGWaVcpQCo9KnEQ/VywVcQ6Cog3nmQMm8OrDrKE6l8OmCMZf05UhpGHv
   A==;
X-CSE-ConnectionGUID: dIt/qIl6RO68JZS9dn4Jdw==
X-CSE-MsgGUID: lbA3MVhQSwCEwwlRwhbHGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="32361155"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="32361155"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 00:02:56 -0700
X-CSE-ConnectionGUID: OqSu2JxfRjmJ2HsmvMp3qw==
X-CSE-MsgGUID: cbEUvnhGTcSEBW+yb5ZPQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="111645714"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.20.233])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 00:02:54 -0700
Date: Fri, 25 Oct 2024 09:02:49 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH RFC 4/4] md/md-bitmap: support to build md-bitmap as
 kernel module
Message-ID: <20241025090249.000070b3@linux.intel.com>
In-Reply-To: <20241024131325.2250880-5-yukuai1@huaweicloud.com>
References: <20241024131325.2250880-1-yukuai1@huaweicloud.com>
	<20241024131325.2250880-5-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Oct 2024 21:13:25 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Now that all implementations are internal, it's sensible to build it as
> kernel module now.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/Kconfig     | 15 +++++++
>  drivers/md/Makefile    |  4 +-
>  drivers/md/md-bitmap.c | 28 +++++++++++-
>  drivers/md/md-bitmap.h |  8 +++-
>  drivers/md/md.c        | 97 +++++++++++++++++++++++++++++++++++++-----
>  drivers/md/md.h        |  1 -
>  6 files changed, 135 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 1e9db8e4acdf..452d7292b617 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -37,6 +37,21 @@ config BLK_DEV_MD
>  
>  	  If unsure, say N.
>  
> +config MD_BITMAP
> +	tristate "RAID bitmap support"

Maybe "MD RAID bitmap support"? From kernel config GUI description is
presented, it seems better to highlight that it is MD internal.

> +	default y
> +	depends on BLK_DEV_MD
> +	help
> +	  If you say Y here, support for the write intent bitmap will be
> +	  enabled. The bitmap will be used to record the data regions that

"If you say Y here" is confusing because it could be "Y" or "M".
Maybe:

"MD write intent bitmap support. The bitmap can be used to
optimize resync speed after power failure, limiting it to recorded dirty
sectors in bitmap. This feature can be added to existing MD array or MD array
can be created with bitmap via mdadm(8).
If unsure, say M."

"M" because MD is in real life is often compiled as module- shouldn't it be
always same?
We should not allow "Y" if MD is "M", perhaps we need to do more in Kconfig to
prevent this?

It is always good to refer how it can be configured and who uses it in
userspace. You can eventually add that it is MD internal module if you don't
see it enough clear.

On other think- what about recovery? Isn't it used to improve recovery speed? We
have checkpointing for recovery. If I remember correctly it is always 7
checkpoints for the array (at least for IMSM). Isn't bitmap used to improve
this? If yes, please add it here.

The part below should go to the Documentation because these are implementation
details that are not needed to take a decision about enabling/disabling the
module.
Please consider adding Documentation entry.

For the code- lgtm.

Great job Kuai! I love your contribution. 
Thanks,
Mariusz

> need
> +	  to be resynced after a power failure, preventing a full disk
> resync.
> +	  The bitmap size ranges from 4K to 132K, depending on the array
> size.
> +	  Each bit corresponds to 2 bytes of data and is managed in
> +	  self-maintained memory. All bits are protected by a disk-level
> +	  spinlock.
> +
> +	  If unsure, say Y.
> +
>  config MD_AUTODETECT
>  	bool "Autodetect RAID arrays during kernel boot"
>  	depends on BLK_DEV_MD=y
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 476a214e4bdc..387670f766b7 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -27,14 +27,14 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
>  dm-verity-y	+= dm-verity-target.o
>  dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
>  
> -md-mod-y	+= md.o md-bitmap.o
> +md-mod-y	+= md.o
>  raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
>  
>  # Note: link order is important.  All raid personalities
>  # and must come before md.o, as they each initialise
>  # themselves, and md.o may use the personalities when it
>  # auto-initialised.
> -
> +obj-$(CONFIG_MD_BITMAP)		+= md-bitmap.o
>  obj-$(CONFIG_MD_RAID0)		+= raid0.o
>  obj-$(CONFIG_MD_RAID1)		+= raid1.o
>  obj-$(CONFIG_MD_RAID10)		+= raid10.o
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index f68eb79e739d..148a479d32c0 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -212,6 +212,8 @@ struct bitmap {
>  	int cluster_slot;
>  };
>  
> +static struct workqueue_struct *md_bitmap_wq;
> +
>  static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>  			   int chunksize, bool init);
>  
> @@ -2970,6 +2972,9 @@ static struct attribute_group md_bitmap_group = {
>  };
>  
>  static struct bitmap_operations bitmap_ops = {
> +	.version		= 1,
> +	.owner			= THIS_MODULE,
> +
>  	.enabled		= bitmap_enabled,
>  	.create			= bitmap_create,
>  	.resize			= bitmap_resize,
> @@ -3001,7 +3006,26 @@ static struct bitmap_operations bitmap_ops = {
>  	.group			= &md_bitmap_group,
>  };
>  
> -void mddev_set_bitmap_ops(struct mddev *mddev)
> +static int __init bitmap_init(void)
> +{
> +	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM |
> WQ_UNBOUND,
> +				       0);
> +	if (!md_bitmap_wq)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&bitmap_ops.list);
> +	register_md_bitmap(&bitmap_ops);
> +	return 0;
> +}
> +
> +static void __exit bitmap_exit(void)
>  {
> -	mddev->bitmap_ops = &bitmap_ops;
> +	destroy_workqueue(md_bitmap_wq);
> +	unregister_md_bitmap(&bitmap_ops);
>  }
> +
> +module_init(bitmap_init);
> +module_exit(bitmap_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Bitmap for MD");
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 0c19983453c7..9d1bf3c43125 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -71,6 +71,10 @@ struct md_bitmap_stats {
>  };
>  
>  struct bitmap_operations {
> +	int version;
> +	struct module *owner;
> +	struct list_head list;
> +
>  	bool (*enabled)(struct mddev *mddev);
>  	int (*create)(struct mddev *mddev, int slot);
>  	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
> @@ -110,7 +114,7 @@ struct bitmap_operations {
>  	struct attribute_group *group;
>  };
>  
> -/* the bitmap API */
> -void mddev_set_bitmap_ops(struct mddev *mddev);
> +void register_md_bitmap(struct bitmap_operations *op);
> +void unregister_md_bitmap(struct bitmap_operations *op);
>  
>  #endif
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d16a3d0f2b90..09fac65b83b8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -83,6 +83,9 @@ static const char *action_name[NR_SYNC_ACTIONS] = {
>  static LIST_HEAD(pers_list);
>  static DEFINE_SPINLOCK(pers_lock);
>  
> +static LIST_HEAD(bitmap_list);
> +static DEFINE_SPINLOCK(bitmap_lock);
> +
>  static const struct kobj_type md_ktype;
>  
>  const struct md_cluster_operations *md_cluster_ops;
> @@ -100,7 +103,6 @@ static struct workqueue_struct *md_wq;
>   * workqueue whith reconfig_mutex grabbed.
>   */
>  static struct workqueue_struct *md_misc_wq;
> -struct workqueue_struct *md_bitmap_wq;
>  
>  static int remove_and_add_spares(struct mddev *mddev,
>  				 struct md_rdev *this);
> @@ -630,15 +632,96 @@ static void active_io_release(struct percpu_ref *ref)
>  
>  static void no_op(struct percpu_ref *r) {}
>  
> +void register_md_bitmap(struct bitmap_operations *op)
> +{
> +	pr_info("md: bitmap version %d registered\n", op->version);
> +
> +	spin_lock(&bitmap_lock);
> +	list_add_tail(&op->list, &bitmap_list);
> +	spin_unlock(&bitmap_lock);
> +}
> +EXPORT_SYMBOL_GPL(register_md_bitmap);
> +
> +void unregister_md_bitmap(struct bitmap_operations *op)
> +{
> +	pr_info("md: bitmap version %d unregistered\n", op->version);
> +
> +	spin_lock(&bitmap_lock);
> +	list_del_init(&op->list);
> +	spin_unlock(&bitmap_lock);
> +}
> +EXPORT_SYMBOL_GPL(unregister_md_bitmap);
> +
> +static struct bitmap_operations *__find_bitmap(int version)
> +{
> +	struct bitmap_operations *op;
> +
> +	list_for_each_entry(op, &bitmap_list, list)
> +		if (op->version == version) {
> +			if (try_module_get(op->owner))
> +				return op;
> +			else
> +				return NULL;
> +		}
> +
> +	return NULL;
> +}
> +
> +static struct bitmap_operations *find_bitmap(int version)
> +{
> +	struct bitmap_operations *op = NULL;
> +
> +	spin_lock(&bitmap_lock);
> +	op = __find_bitmap(version);
> +	spin_unlock(&bitmap_lock);
> +
> +	if (op)
> +		return op;
> +
> +	if (request_module("md-bitmap") != 0)
> +		return NULL;
> +
> +	spin_lock(&bitmap_lock);
> +	op = __find_bitmap(version);
> +	spin_unlock(&bitmap_lock);
> +
> +	return op;
> +}
> +
> +/* TODO: support more versions */
> +static int mddev_set_bitmap_ops(struct mddev *mddev)
> +{
> +	struct bitmap_operations *op = find_bitmap(1);
> +
> +	if (!op)
> +		return -ENODEV;
> +
> +	mddev->bitmap_ops = op;
> +	return 0;
> +}
> +
> +static void mddev_clear_bitmap_ops(struct mddev *mddev)
> +{
> +	module_put(mddev->bitmap_ops->owner);
> +	mddev->bitmap_ops = NULL;
> +}
> +
>  int mddev_init(struct mddev *mddev)
>  {
> +	int ret = mddev_set_bitmap_ops(mddev);
> +
> +	if (ret)
> +		return ret;
>  
>  	if (percpu_ref_init(&mddev->active_io, active_io_release,
> -			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
> +			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> +		mddev_clear_bitmap_ops(mddev);
>  		return -ENOMEM;
> +	}
>  
>  	if (percpu_ref_init(&mddev->writes_pending, no_op,
>  			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> +		mddev_clear_bitmap_ops(mddev);
>  		percpu_ref_exit(&mddev->active_io);
>  		return -ENOMEM;
>  	}
> @@ -666,7 +749,6 @@ int mddev_init(struct mddev *mddev)
>  	mddev->resync_min = 0;
>  	mddev->resync_max = MaxSector;
>  	mddev->level = LEVEL_NONE;
> -	mddev_set_bitmap_ops(mddev);
>  
>  	INIT_WORK(&mddev->sync_work, md_start_sync);
>  	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
> @@ -677,6 +759,7 @@ EXPORT_SYMBOL_GPL(mddev_init);
>  
>  void mddev_destroy(struct mddev *mddev)
>  {
> +	mddev_clear_bitmap_ops(mddev);
>  	percpu_ref_exit(&mddev->active_io);
>  	percpu_ref_exit(&mddev->writes_pending);
>  }
> @@ -9898,11 +9981,6 @@ static int __init md_init(void)
>  	if (!md_misc_wq)
>  		goto err_misc_wq;
>  
> -	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM |
> WQ_UNBOUND,
> -				       0);
> -	if (!md_bitmap_wq)
> -		goto err_bitmap_wq;
> -
>  	ret = __register_blkdev(MD_MAJOR, "md", md_probe);
>  	if (ret < 0)
>  		goto err_md;
> @@ -9921,8 +9999,6 @@ static int __init md_init(void)
>  err_mdp:
>  	unregister_blkdev(MD_MAJOR, "md");
>  err_md:
> -	destroy_workqueue(md_bitmap_wq);
> -err_bitmap_wq:
>  	destroy_workqueue(md_misc_wq);
>  err_misc_wq:
>  	destroy_workqueue(md_wq);
> @@ -10229,7 +10305,6 @@ static __exit void md_exit(void)
>  	spin_unlock(&all_mddevs_lock);
>  
>  	destroy_workqueue(md_misc_wq);
> -	destroy_workqueue(md_bitmap_wq);
>  	destroy_workqueue(md_wq);
>  }
>  
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 5eaac1d84523..28347fb3af18 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -972,7 +972,6 @@ struct mdu_array_info_s;
>  struct mdu_disk_info_s;
>  
>  extern int mdp_major;
> -extern struct workqueue_struct *md_bitmap_wq;
>  void md_autostart_arrays(int part);
>  int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
>  int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);

