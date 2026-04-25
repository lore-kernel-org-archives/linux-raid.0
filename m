Received: from mail-108-mta3.mxroute.com (mail-108-mta3.mxroute.com [136.175.108.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E17299943
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777106696; cv=none; b=skG0O2ztAzFMNyb9UP3M5b+oli0UM3i85J5sDn+08eEwmRzwDKh7rpHzgaiFYP7XSiJKq8JB8FMc3edm6LiBP0jsmRnGArAvMaolMl8Xa/WUK9Aoi/AQw4JkQNwPk7R4fREsUf/2xtEg/Lz5oSFd7mWfqQYjMXTIfD+gKc5ws7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777106696; c=relaxed/simple;
	bh=eJXBKO7y+eD12lFE/ulR491GacHQIzUsuNJjFljDMb4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AOl0NpV4to/tskBJCXe5+X8FaMUDnc6v7G14U+frYJ2UQyMbAIRAR8dWT5bFko9tV01xaXunLLfdTFKaOQ51KoTxVjMz24KOMXcE1VNoTxv9DtjoKImE6nxrxscWXcUQlF9D5Nb7Wyv09QSunX91ZXV0/Oeeb1K4aOi3c9rPhow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=DZRsEJwL; arc=none smtp.client-ip=136.175.108.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="DZRsEJwL"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta3.mxroute.com (ZoneMTA) with ESMTPSA id 19dc3cb758f00067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 25 Apr 2026 08:39:44 +0000
X-Zone-Loop: 1b34f73e8913c7069d5248476f00d9989881642f243f
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=snGHB14rLpy9uLRWhgKjOjAK4/+HurBGVdTyGE3A30o=; b=DZRsEJwLi55Abg02FAVlh6CElr
	HrNGfKvZx8NnhWGeggljghxcpvjx2BSmYtPV+oq2TrWZxLbaa9eT89Ghd3lpb1rEJwduCbHy2AxQS
	JemYWT/9ASPG0LNKKQH0eJMVEvjDwZdDo5CziKv6j0Nk3eD3HZgNd189SqbemAT2QY76sucnpSb1N
	4CEd4s8r/YWmEy+gCfwYTQsoq5P3RAYay7V8+2r9+mMMLKasCValOIUepqT20RuSHJJ9D6DMTkWTN
	lSidILuiimdc5q00oascuQPC0u5Sc4J3oVB1reSkJR/cXKsDA0XzxA0pAru61bJX8ddtWIfWrZnOv
	bYmHmNJA==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Song Liu <song@kernel.org>,  glass.su@suse.com,  Li Nan
 <linan122@huawei.com>,  Xiao Ni <xiao@kernel.org>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 3/3] md/md-bitmap: add a none backend for bitmap grow
In-Reply-To: <20260425024615.1696892-4-yukuai@fnnas.com> (Yu Kuai's message of
	"Sat, 25 Apr 2026 10:46:15 +0800")
References: <20260425024615.1696892-1-yukuai@fnnas.com>
	<20260425024615.1696892-4-yukuai@fnnas.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Sat, 25 Apr 2026 16:39:30 +0800
Message-ID: <8qab77st.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Sat 25 Apr 2026 at 10:46, Yu Kuai <yukuai@fnnas.com> wrote:

> Add a real none bitmap backend that exposes the common bitmap 
> sysfs
> group and use it to keep bitmap/location available when an array 
> has no
> bitmap.
>
> Then switch the bitmap location sysfs path to move only between 
> none
> and the classic bitmap backend, using the no-sysfs bitmap 
> helpers while
> merging or unmerging the internal bitmap sysfs group.
>
> This restores mdadm --grow bitmap addition through 
> bitmap/location.
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>

Reviewed-by: Su Yue <glass.su@suse.com>

> ---
>  drivers/md/md-bitmap.c | 108 
>  ++++++++++++++++++++++++++++++++++++++---
>  drivers/md/md.c        |  42 +++++++++++++---
>  drivers/md/md.h        |   3 ++
>  3 files changed, 137 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index eba649703a1c..028b9ca8ce52 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -216,6 +216,7 @@ struct bitmap {
>  };
>
>  static struct workqueue_struct *md_bitmap_wq;
> +static struct attribute_group md_bitmap_internal_group;
>
>  static int __bitmap_resize(struct bitmap *bitmap, sector_t 
>  blocks,
>  			   int chunksize, bool init);
> @@ -2580,6 +2581,30 @@ static int bitmap_resize(struct mddev 
> *mddev, sector_t blocks, int chunksize)
>  	return __bitmap_resize(bitmap, blocks, chunksize, false);
>  }
>
> +static bool bitmap_none_enabled(void *data, bool flush)
> +{
> +	return false;
> +}
> +
> +static int bitmap_none_create(struct mddev *mddev)
> +{
> +	return 0;
> +}
> +
> +static int bitmap_none_load(struct mddev *mddev)
> +{
> +	return 0;
> +}
> +
> +static void bitmap_none_destroy(struct mddev *mddev)
> +{
> +}
> +
> +static int bitmap_none_get_stats(void *data, struct 
> md_bitmap_stats *stats)
> +{
> +	return -ENOENT;
> +}
> +
>  static ssize_t
>  location_show(struct mddev *mddev, char *page)
>  {
> @@ -2618,7 +2643,11 @@ location_store(struct mddev *mddev, const 
> char *buf, size_t len)
>  			goto out;
>  		}
>
> -		bitmap_destroy(mddev);
> +		sysfs_unmerge_group(&mddev->kobj, 
> &md_bitmap_internal_group);
> +		md_bitmap_destroy_nosysfs(mddev);
> +		mddev->bitmap_id = ID_BITMAP_NONE;
> +		if (!mddev_set_bitmap_ops_nosysfs(mddev))
> +			goto none_err;
>  		mddev->bitmap_info.offset = 0;
>  		if (mddev->bitmap_info.file) {
>  			struct file *f = mddev->bitmap_info.file;
> @@ -2654,16 +2683,25 @@ location_store(struct mddev *mddev, 
> const char *buf, size_t len)
>  			}
>
>  			mddev->bitmap_info.offset = offset;
> -			rv = bitmap_create(mddev);
> +			md_bitmap_destroy_nosysfs(mddev);
> +			mddev->bitmap_id = ID_BITMAP;
> +			if (!mddev_set_bitmap_ops_nosysfs(mddev))
> +				goto bitmap_err;
> +
> +			rv = md_bitmap_create_nosysfs(mddev);
>  			if (rv)
> -				goto out;
> +				goto create_err;
>
> -			rv = bitmap_load(mddev);
> +			rv = mddev->bitmap_ops->load(mddev);
>  			if (rv) {
>  				mddev->bitmap_info.offset = 0;
> -				bitmap_destroy(mddev);
> -				goto out;
> +				goto load_err;
>  			}
> +
> +			rv = sysfs_merge_group(&mddev->kobj,
> +					       &md_bitmap_internal_group);
> +			if (rv)
> +				goto merge_err;
>  		}
>  	}
>  	if (!mddev->external) {
> @@ -2679,6 +2717,22 @@ location_store(struct mddev *mddev, const 
> char *buf, size_t len)
>  	if (rv)
>  		return rv;
>  	return len;
> +
> +merge_err:
> +	mddev->bitmap_info.offset = 0;
> +load_err:
> +	md_bitmap_destroy_nosysfs(mddev);
> +create_err:
> +	mddev->bitmap_info.offset = 0;
> +	mddev->bitmap_id = ID_BITMAP_NONE;
> +	if (!mddev_set_bitmap_ops_nosysfs(mddev))
> +		rv = -ENOENT;
> +	goto out;
> +bitmap_err:
> +	rv = -ENOENT;
> +none_err:
> +	mddev->bitmap_info.offset = 0;
> +	goto out;
>  }
>
>  static struct md_sysfs_entry bitmap_location =
> @@ -2987,6 +3041,27 @@ static const struct attribute_group 
> *bitmap_groups[] = {
>  	NULL,
>  };
>
> +static const struct attribute_group *bitmap_none_groups[] = {
> +	&md_bitmap_common_group,
> +	NULL,
> +};
> +
> +static struct bitmap_operations bitmap_none_ops = {
> +	.head = {
> +		.type	= MD_BITMAP,
> +		.id	= ID_BITMAP_NONE,
> +		.name	= "none",
> +	},
> +
> +	.enabled		= bitmap_none_enabled,
> +	.create			= bitmap_none_create,
> +	.load			= bitmap_none_load,
> +	.destroy		= bitmap_none_destroy,
> +	.get_stats		= bitmap_none_get_stats,
> +
> +	.groups			= bitmap_none_groups,
> +};
> +
>  static struct bitmap_operations bitmap_ops = {
>  	.head = {
>  		.type	= MD_BITMAP,
> @@ -3033,16 +3108,33 @@ static struct bitmap_operations 
> bitmap_ops = {
>
>  int md_bitmap_init(void)
>  {
> +	int err;
> +
>  	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | 
>  WQ_UNBOUND,
>  				       0);
>  	if (!md_bitmap_wq)
>  		return -ENOMEM;
>
> -	return register_md_submodule(&bitmap_ops.head);
> +	err = register_md_submodule(&bitmap_none_ops.head);
> +	if (err)
> +		goto err_wq;
> +
> +	err = register_md_submodule(&bitmap_ops.head);
> +	if (err)
> +		goto err_none;
> +
> +	return 0;
> +
> +err_none:
> +	unregister_md_submodule(&bitmap_none_ops.head);
> +err_wq:
> +	destroy_workqueue(md_bitmap_wq);
> +	return err;
>  }
>
>  void md_bitmap_exit(void)
>  {
> -	destroy_workqueue(md_bitmap_wq);
>  	unregister_md_submodule(&bitmap_ops.head);
> +	unregister_md_submodule(&bitmap_none_ops.head);
> +	destroy_workqueue(md_bitmap_wq);
>  }
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0ef81d116191..7937b927d923 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -705,7 +705,7 @@ static void md_bitmap_sysfs_del(struct mddev 
> *mddev)
>  	sysfs_remove_group(&mddev->kobj, 
>  mddev->bitmap_ops->groups[0]);
>  }
>
> -static bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
> +bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
>  {
>  	struct md_submodule_head *head;
>
> @@ -4275,7 +4275,7 @@ bitmap_type_show(struct mddev *mddev, char 
> *page)
>
>  	xa_lock(&md_submodule);
>  	xa_for_each(&md_submodule, i, head) {
> -		if (head->type != MD_BITMAP)
> +		if (head->type != MD_BITMAP || head->id == ID_BITMAP_NONE)
>  			continue;
>
>  		if (mddev->bitmap_id == head->id)
> @@ -6535,7 +6535,7 @@ static enum md_submodule_id 
> md_bitmap_get_id_from_sb(struct mddev *mddev)
>  	return id;
>  }
>
> -static int md_bitmap_create_nosysfs(struct mddev *mddev)
> +int md_bitmap_create_nosysfs(struct mddev *mddev)
>  {
>  	enum md_submodule_id orig_id = mddev->bitmap_id;
>  	enum md_submodule_id sb_id;
> @@ -6544,8 +6544,10 @@ static int 
> md_bitmap_create_nosysfs(struct mddev *mddev)
>  	if (mddev->bitmap_id == ID_BITMAP_NONE)
>  		return -EINVAL;
>
> -	if (!mddev_set_bitmap_ops_nosysfs(mddev))
> +	if (!mddev_set_bitmap_ops_nosysfs(mddev)) {
> +		mddev->bitmap_id = orig_id;
>  		return -ENOENT;
> +	}
>
>  	err = mddev->bitmap_ops->create(mddev);
>  	if (!err)
> @@ -6559,8 +6561,10 @@ static int 
> md_bitmap_create_nosysfs(struct mddev *mddev)
>  	mddev->bitmap_ops = NULL;
>
>  	sb_id = md_bitmap_get_id_from_sb(mddev);
> -	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
> +	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id) {
> +		mddev->bitmap_id = orig_id;
>  		return err;
> +	}
>
>  	pr_info("md: %s: bitmap version mismatch, switching from %d to 
>  %d\n",
>  		mdname(mddev), orig_id, sb_id);
> @@ -6594,7 +6598,7 @@ static int md_bitmap_create(struct mddev 
> *mddev)
>  	return 0;
>  }
>
> -static void md_bitmap_destroy_nosysfs(struct mddev *mddev)
> +void md_bitmap_destroy_nosysfs(struct mddev *mddev)
>  {
>  	if (!md_bitmap_registered(mddev))
>  		return;
> @@ -6612,6 +6616,16 @@ static void md_bitmap_destroy(struct 
> mddev *mddev)
>  	md_bitmap_destroy_nosysfs(mddev);
>  }
>
> +static void md_bitmap_set_none(struct mddev *mddev)
> +{
> +	mddev->bitmap_id = ID_BITMAP_NONE;
> +	if (!mddev_set_bitmap_ops_nosysfs(mddev))
> +		return;
> +
> +	if (!mddev_is_dm(mddev) && mddev->bitmap_ops->groups)
> +		md_bitmap_sysfs_add(mddev);
> +}
> +
>  int md_run(struct mddev *mddev)
>  {
>  	int err;
> @@ -6821,6 +6835,10 @@ int md_run(struct mddev *mddev)
>  	if (mddev->sb_flags)
>  		md_update_sb(mddev, 0);
>
> +	if (IS_ENABLED(CONFIG_MD_BITMAP) && !mddev->bitmap_info.file 
> &&
> +	    !mddev->bitmap_info.offset)
> +		md_bitmap_set_none(mddev);
> +
>  	md_new_event();
>  	return 0;
>
> @@ -7766,7 +7784,8 @@ static int set_bitmap_file(struct mddev 
> *mddev, int fd)
>  {
>  	int err = 0;
>
> -	if (!md_bitmap_registered(mddev))
> +	if (!md_bitmap_registered(mddev) ||
> +	    mddev->bitmap_id == ID_BITMAP_NONE)
>  		return -EINVAL;
>
>  	if (mddev->pers) {
> @@ -7831,10 +7850,12 @@ static int set_bitmap_file(struct mddev 
> *mddev, int fd)
>
>  			if (err) {
>  				md_bitmap_destroy(mddev);
> +				md_bitmap_set_none(mddev);
>  				fd = -1;
>  			}
>  		} else if (fd < 0) {
>  			md_bitmap_destroy(mddev);
> +			md_bitmap_set_none(mddev);
>  		}
>  	}
>
> @@ -8141,12 +8162,16 @@ static int update_array_info(struct 
> mddev *mddev, mdu_array_info_t *info)
>  				mddev->bitmap_info.default_offset;
>  			mddev->bitmap_info.space =
>  				mddev->bitmap_info.default_space;
> +			mddev->bitmap_id = ID_BITMAP;
>  			rv = md_bitmap_create(mddev);
>  			if (!rv)
>  				rv = mddev->bitmap_ops->load(mddev);
>
> -			if (rv)
> +			if (rv) {
>  				md_bitmap_destroy(mddev);
> +				mddev->bitmap_info.offset = 0;
> +				md_bitmap_set_none(mddev);
> +			}
>  		} else {
>  			struct md_bitmap_stats stats;
>
> @@ -8174,6 +8199,7 @@ static int update_array_info(struct mddev 
> *mddev, mdu_array_info_t *info)
>  			}
>  			md_bitmap_destroy(mddev);
>  			mddev->bitmap_info.offset = 0;
> +			md_bitmap_set_none(mddev);
>  		}
>  	}
>  	md_update_sb(mddev, 1);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d3d4e2150dc8..52c378086046 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -934,6 +934,9 @@ extern void md_allow_write(struct mddev 
> *mddev);
>  extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, 
>  struct mddev *mddev);
>  extern void md_set_array_sectors(struct mddev *mddev, sector_t 
>  array_sectors);
>  extern int md_check_no_bitmap(struct mddev *mddev);
> +bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev);
> +int md_bitmap_create_nosysfs(struct mddev *mddev);
> +void md_bitmap_destroy_nosysfs(struct mddev *mddev);
>  extern int md_integrity_register(struct mddev *mddev);
>  extern int strict_strtoul_scaled(const char *cp, unsigned long 
>  *res, int scale);
