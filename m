Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9452D1932;
	Thu, 11 Sep 2025 08:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757577993; cv=none; b=HG0PHw11HpyZjWJ0OLMX0EPeMxuj4h1eMltLyBhlUTf+DhnGmW2w5WfDI0xD93BFwZOGcHRBKqToMKd2F4ErOoD3dRVto5js4C9VyyOGDcPV/hGxtP3KHw4+aDprS003CbGHETPQLyGmX2rGSnfo+NiUi4X5O6MtceUUjmYQLG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757577993; c=relaxed/simple;
	bh=Tctf7guLh0JbnxfzZRx44ezfKNWdFjKymefYous9EeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7XnuG0LcByEH8cwShY0JgieUWCJ7pZQ2NKFoHfplJBRa7Smzn4sKVzOVv0d5OQxzvwKaQVkhspwABpitH/YJRC+vGFEbdMYPwEmIvgXWn902ue6oSnFbkNMunG+1B8ftERcEaJ6acDm0WHvgHy5q8+E7imoJbr8ig7IxgKPjYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af7f6.dynamic.kabel-deutschland.de [95.90.247.246])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id A412260213B27;
	Thu, 11 Sep 2025 10:05:18 +0200 (CEST)
Message-ID: <3759cfba-93a3-4252-99a3-97219e50bdf5@molgen.mpg.de>
Date: Thu, 11 Sep 2025 10:05:18 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] md: allow configuring logical_block_size
To: Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, linan122@huawei.com,
 xni@redhat.com, hare@suse.de, martin.petersen@oracle.com,
 bvanassche@acm.org, filipe.c.maia@gmail.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250911073144.42160-1-linan666@huaweicloud.com>
 <20250911073144.42160-3-linan666@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250911073144.42160-3-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Nan,


Thank you for your patch. Some minor nits. i’d write logical block size 
without underscores in the summary and commit message body, if the 
variable is not referenced.

Am 11.09.25 um 09:31 schrieb linan666@huaweicloud.com:
> From: Li Nan <linan122@huawei.com>
> 
> Previously, raid array used the maximum logical_block_size (LBS) of
> all member disks. Adding a larger LBS during disk at runtime could

… when adding a disk …?

> unexpectedly increase RAID's LBS, risking corruption of existing
> partitions.
> 
> Simply restricting larger-LBS disks is inflexible. In some scenarios,
> only disks with 512 LBS are available currently, but later, disks with

512 bytes

> 4k LBS may be added to the array.

4 kB

> Making LBS configurable is the best way to solve this scenario.
> After this patch, the raid will:
>    - stores LBS in disk metadata.

store without 3rd person s

>    - add a read-write sysfs 'mdX/logical_block_size'.

I’d remove the the dot/period at the end of the items.

> Future mdadm should support setting LBS via metadata field during RAID
> creation and the new sysfs. Though the kernel allows runtime LBS changes,
> users should avoid modifying it after creating partitions or filesystems
> to prevent compatibility issues.
> 
> Note that many RAID paths rely on PAGE_SIZE alignment, including for
> metadata I/O. A logical_block_size larger than PAGE_SIZE will result in
> metadata reads/writes failures. So this config should be prevented.

read/write

> Only 1.x meta supports configurable logical_block_size. 0.90 meta init

initializes/init*s*

> all fields to default at auto-detect. Supporting 0.90 would require more
> extensive changes and no such use case has been observed.

It’d be great if you added a section, how you tested your patch.

> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   Documentation/admin-guide/md.rst |  7 +++
>   drivers/md/md.h                  |  1 +
>   include/uapi/linux/raid/md_p.h   |  3 +-
>   drivers/md/md-linear.c           |  1 +
>   drivers/md/md.c                  | 75 ++++++++++++++++++++++++++++++++
>   drivers/md/raid0.c               |  1 +
>   drivers/md/raid1.c               |  1 +
>   drivers/md/raid10.c              |  1 +
>   drivers/md/raid5.c               |  1 +
>   9 files changed, 90 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
> index 1c2eacc94758..f5c81fad034a 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -238,6 +238,13 @@ All md devices contain:
>        the number of devices in a raid4/5/6, or to support external
>        metadata formats which mandate such clipping.
>   
> +  logical_block_size
> +     Configures the array's logical block size in bytes. This attribute
> +     is only supported for RAID1, RAID5, RAID10 with 1.x meta. The value

metadata

> +     should be written before starting the array. The final array LBS
> +     will use the max value between this configuration and all rdev's LBS.

Should rdev be explained in the documentation?

> +     Note that LBS cannot exceed PAGE_SIZE.

How can PAGE_SIZE be determined? To be clear, that the implementation 
disallows this:

Not, LBS values larger than PAGE_SIZE are rejected.

> +
>     reshape_position
>        This is either ``none`` or a sector number within the devices of
>        the array where ``reshape`` is up to.  If this is set, the three
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index afb25f727409..b0147b98c8d3 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -432,6 +432,7 @@ struct mddev {
>   	sector_t			array_sectors; /* exported array size */
>   	int				external_size; /* size managed
>   							* externally */
> +	unsigned int			logical_block_size;
>   	__u64				events;
>   	/* If the last 'event' was simply a clean->dirty transition, and
>   	 * we didn't write it to the spares, then it is safe and simple
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
> index ac74133a4768..310068bb2a1d 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -291,7 +291,8 @@ struct mdp_superblock_1 {
>   	__le64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
>   	__le32	sb_csum;	/* checksum up to devs[max_dev] */
>   	__le32	max_dev;	/* size of devs[] array to consider */
> -	__u8	pad3[64-32];	/* set to 0 when writing */
> +	__le32  logical_block_size;	/* same as q->limits->logical_block_size */
> +	__u8	pad3[64-36];	/* set to 0 when writing */
>   
>   	/* device state information. Indexed by dev_number.
>   	 * 2 bytes per device
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 5d9b08115375..da8babb8da59 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
>   
>   	md_init_stacking_limits(&lim);
>   	lim.max_hw_sectors = mddev->chunk_sectors;
> +	lim.logical_block_size = mddev->logical_block_size;
>   	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 40f56183c744..e0184942c8ec 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1963,6 +1963,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
>   		mddev->layout = le32_to_cpu(sb->layout);
>   		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
>   		mddev->dev_sectors = le64_to_cpu(sb->size);
> +		mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
>   		mddev->events = ev1;
>   		mddev->bitmap_info.offset = 0;
>   		mddev->bitmap_info.space = 0;
> @@ -2172,6 +2173,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
>   	sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
>   	sb->level = cpu_to_le32(mddev->level);
>   	sb->layout = cpu_to_le32(mddev->layout);
> +	sb->logical_block_size = cpu_to_le32(mddev->logical_block_size);
>   	if (test_bit(FailFast, &rdev->flags))
>   		sb->devflags |= FailFast1;
>   	else
> @@ -5900,6 +5902,66 @@ static struct md_sysfs_entry md_serialize_policy =
>   __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>          serialize_policy_store);
>   
> +static int mddev_set_logical_block_size(struct mddev *mddev,
> +				unsigned int lbs)
> +{
> +	int err = 0;
> +	struct queue_limits lim;
> +
> +	if (queue_logical_block_size(mddev->gendisk->queue) >= lbs) {
> +		pr_err("%s: incompatible logical_block_size %u, can not set\n",

Please also log `queue_logical_block_size(mddev->gendisk->queue)`.

> +		       mdname(mddev), lbs);
> +		return -EINVAL;
> +	}
> +
> +	lim = queue_limits_start_update(mddev->gendisk->queue);
> +	lim.logical_block_size = lbs;
> +	pr_info("%s: logical_block_size is changed, data may be lost\n",
> +		mdname(mddev));

Please print the values, and maybe make it a warning as data loss is 
possible?

> +	err = queue_limits_commit_update(mddev->gendisk->queue, &lim);
> +	if (err)
> +		return err;
> +
> +	mddev->logical_block_size = lbs;
> +	return 0;
> +}
> +
> +static ssize_t
> +lbs_show(struct mddev *mddev, char *page)
> +{
> +	return sprintf(page, "%u\n", mddev->logical_block_size);
> +}
> +
> +static ssize_t
> +lbs_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +	unsigned int lbs;
> +	int err = -EBUSY;
> +
> +	/* Only 1.x meta supports configurable LBS */

metadata

> +	if (mddev->major_version == 0)
> +		return -EINVAL;
> +
> +	if (mddev->pers)
> +		return -EBUSY;
> +
> +	err = kstrtouint(buf, 10, &lbs);
> +	if (err < 0)
> +		return -EINVAL;
> +
> +	err = mddev_lock(mddev);
> +	if (err)
> +		goto unlock;
> +
> +	err = mddev_set_logical_block_size(mddev, lbs);
> +
> +unlock:
> +	mddev_unlock(mddev);
> +	return err ?: len;

No idea, if a space should be added before the colon :.

> +}
> +
> +static struct md_sysfs_entry md_logical_block_size =
> +__ATTR(logical_block_size, S_IRUGO|S_IWUSR, lbs_show, lbs_store);
>   
>   static struct attribute *md_default_attrs[] = {
>   	&md_level.attr,
> @@ -5933,6 +5995,7 @@ static struct attribute *md_redundancy_attrs[] = {
>   	&md_scan_mode.attr,
>   	&md_last_scan_mode.attr,
>   	&md_mismatches.attr,
> +	&md_logical_block_size.attr,
>   	&md_sync_min.attr,
>   	&md_sync_max.attr,
>   	&md_sync_io_depth.attr,
> @@ -6052,6 +6115,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>   			return -EINVAL;
>   	}
>   
> +	/*
> +	 * Before RAID adding folio support, the logical_block_size
> +	 * should be smaller than the page size.
> +	 */
> +	if (lim->logical_block_size > PAGE_SIZE) {
> +		pr_err("%s: logical_block_size must not larger than PAGE_SIZE\n",

1.  not *be* larger
2.  Please print the value of PAGE_SIZE.

> +			mdname(mddev));
> +		return -EINVAL;
> +	}
> +	mddev->logical_block_size = lim->logical_block_size;
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
> @@ -6690,6 +6764,7 @@ static void md_clean(struct mddev *mddev)
>   	mddev->chunk_sectors = 0;
>   	mddev->ctime = mddev->utime = 0;
>   	mddev->layout = 0;
> +	mddev->logical_block_size = 0;
>   	mddev->max_disks = 0;
>   	mddev->events = 0;
>   	mddev->can_decrease_events = 0;
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f1d8811a542a..705889a09fc1 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -382,6 +382,7 @@ static int raid0_set_limits(struct mddev *mddev)
>   	md_init_stacking_limits(&lim);
>   	lim.max_hw_sectors = mddev->chunk_sectors;
>   	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
> +	lim.logical_block_size = mddev->logical_block_size;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.io_opt = lim.io_min * mddev->raid_disks;
>   	lim.chunk_sectors = mddev->chunk_sectors;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d0f6afd2f988..de0c843067dc 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3223,6 +3223,7 @@ static int raid1_set_limits(struct mddev *mddev)
>   
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
> +	lim.logical_block_size = mddev->logical_block_size;
>   	lim.features |= BLK_FEAT_ATOMIC_WRITES;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c3cfbb0347e7..68c8148386b0 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4005,6 +4005,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
>   
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
> +	lim.logical_block_size = mddev->logical_block_size;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.chunk_sectors = mddev->chunk_sectors;
>   	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c32ffd9cffce..ff0daa22df65 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7747,6 +7747,7 @@ static int raid5_set_limits(struct mddev *mddev)
>   	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
>   
>   	md_init_stacking_limits(&lim);
> +	lim.logical_block_size = mddev->logical_block_size;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
>   	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;

