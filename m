Received: from sg-1-30.ptr.blmpb.com (sg-1-30.ptr.blmpb.com [118.26.132.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648BE330B1F
	for <linux-raid@vger.kernel.org>; Tue, 28 Oct 2025 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761657061; cv=none; b=Bq8wbYW/mkquOAd4UVdDampeCxunR0CiOTQgO4odjtqEe1zj4XPYzlzptGkZZWlwxyxVJDDw0ybFQFOgM6NxwXOAEWZB2B0UjiZgHh0QrWPkNj7CX4AtkltpG74wnGP1Oo6JVhwwxKqEskyYfOf/COmyObCGUgQ/C8VLX+auJRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761657061; c=relaxed/simple;
	bh=DW/U2R9sY4QKOW1p5qzThDA14Zx886E63JCqsM15+ow=;
	h=Content-Type:References:Date:Message-Id:Cc:Subject:Mime-Version:
	 From:In-Reply-To:To; b=qt/xGoeFapKWXapnFtXkiFcb0HavK69Dkn4RLSJys9kwiQKnWW/omdSKwUdSjdEGXz2Z9DACdSRDTjyboudmTfx6A6t64uqXnk8dbJo2qGHvUS6BqR3JRvjAxm+FymcYYKoT20GsJ0sjODcMxA9zrxol2vZBiE5jwP2omcmaIgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=LBY1t0Tj; arc=none smtp.client-ip=118.26.132.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="LBY1t0Tj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761654241;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ybOLWwBMegZP1tV3RHog61fBgl8TBeLtYAg2p7Wb5cc=;
 b=LBY1t0Tj02AH+tiPUWQNQrlk0qEelN59ttB2JfO+8PnWwp07UBEoNbL3w+7ZjuFsmtjf8F
 KmAxrcKMkKKqu2PCVVXtd7CoffWP8cO7V7v0MeKV80HKjMm095NMD17pJ/c5KxLX9ISate
 tg2W5VRKUhdqgeXsG7Zu2ctPYtWNgkZ1zN+xTnZsK+9dZpwUh1LXvZ4dseieqKsqEDd7Zs
 6sIciagCLwfOMBt1gsEtD11rYzQR/aQLKCUQQeqplhouXLS/+Guk+7zf2kU7Mrkp5JgfMw
 0K+8JGxJVJOy6t7bfLBEFW6hC6X9h1yILNJt+rGmq5ZjNs7VcDoAPg5vvM6Mcg==
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20251027072915.3014463-1-linan122@huawei.com> <20251027072915.3014463-5-linan122@huawei.com>
Date: Tue, 28 Oct 2025 20:23:56 +0800
Message-Id: <65f573d0-a17c-4381-8529-34eb8fad0006@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Tue, 28 Oct 2025 20:23:58 +0800
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26900b5df+352a9d+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH v7 4/4] md: allow configuring logical block size
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <20251027072915.3014463-5-linan122@huawei.com>
Reply-To: yukuai@fnnas.com
To: <linan122@huawei.com>, <corbet@lwn.net>, <song@kernel.org>, 
	<hare@suse.de>, <xni@redhat.com>

Hi,

=E5=9C=A8 2025/10/27 15:29, linan122@huawei.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> Previously, raid array used the maximum logical block size (LBS)
> of all member disks. Adding a larger LBS disk at runtime could
> unexpectedly increase RAID's LBS, risking corruption of existing
> partitions. This can be reproduced by:
>
> ```
>    # LBS of sd[de] is 512 bytes, sdf is 4096 bytes.
>    mdadm -CRq /dev/md0 -l1 -n3 /dev/sd[de] missing --assume-clean
>
>    # LBS is 512
>    cat /sys/block/md0/queue/logical_block_size
>
>    # create partition md0p1
>    parted -s /dev/md0 mklabel gpt mkpart primary 1MiB 100%
>    lsblk | grep md0p1
>
>    # LBS becomes 4096 after adding sdf
>    mdadm --add -q /dev/md0 /dev/sdf
>    cat /sys/block/md0/queue/logical_block_size
>
>    # partition lost
>    partprobe /dev/md0
>    lsblk | grep md0p1
> ```
>
> Simply restricting larger-LBS disks is inflexible. In some scenarios,
> only disks with 512 bytes LBS are available currently, but later, disks
> with 4KB LBS may be added to the array.
>
> Making LBS configurable is the best way to solve this scenario.
> After this patch, the raid will:
>    - store LBS in disk metadata
>    - add a read-write sysfs 'mdX/logical_block_size'
>
> Future mdadm should support setting LBS via metadata field during RAID
> creation and the new sysfs. Though the kernel allows runtime LBS changes,
> users should avoid modifying it after creating partitions or filesystems
> to prevent compatibility issues.
>
> Only 1.x metadata supports configurable LBS. 0.90 metadata inits all
> fields to default values at auto-detect. Supporting 0.90 would require
> more extensive changes and no such use case has been observed.
>
> Note that many RAID paths rely on PAGE_SIZE alignment, including for
> metadata I/O. A larger LBS than PAGE_SIZE will result in metadata
> read/write failures. So this config should be prevented.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   Documentation/admin-guide/md.rst |  7 +++
>   drivers/md/md.h                  |  1 +
>   include/uapi/linux/raid/md_p.h   |  3 +-
>   drivers/md/md-linear.c           |  1 +
>   drivers/md/md.c                  | 76 ++++++++++++++++++++++++++++++++
>   drivers/md/raid0.c               |  1 +
>   drivers/md/raid1.c               |  1 +
>   drivers/md/raid10.c              |  1 +
>   drivers/md/raid5.c               |  1 +
>   9 files changed, 91 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide=
/md.rst
> index 1c2eacc94758..0f143acd2db7 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -238,6 +238,13 @@ All md devices contain:
>        the number of devices in a raid4/5/6, or to support external
>        metadata formats which mandate such clipping.
>  =20
> +  logical_block_size
> +     Configure the array's logical block size in bytes. This attribute
> +     is only supported for 1.x meta. The value should be written before
> +     starting the array. The final array LBS will use the max value
> +     between this configuration and all combined device's LBS. Note that
> +     LBS cannot exceed PAGE_SIZE before RAID supports folio.
> +
>     reshape_position
>        This is either ``none`` or a sector number within the devices of
>        the array where ``reshape`` is up to.  If this is set, the three
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 38a7c2fab150..a6b3cb69c28c 100644
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
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_=
p.h
> index ac74133a4768..310068bb2a1d 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -291,7 +291,8 @@ struct mdp_superblock_1 {
>   	__le64	resync_offset;	/* data before this offset (from data_offset) kn=
own to be in sync */
>   	__le32	sb_csum;	/* checksum up to devs[max_dev] */
>   	__le32	max_dev;	/* size of devs[] array to consider */
> -	__u8	pad3[64-32];	/* set to 0 when writing */
> +	__le32  logical_block_size;	/* same as q->limits->logical_block_size */
> +	__u8	pad3[64-36];	/* set to 0 when writing */
>  =20
>   	/* device state information. Indexed by dev_number.
>   	 * 2 bytes per device
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 7033d982d377..50d4a419a16e 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
>  =20
>   	md_init_stacking_limits(&lim);
>   	lim.max_hw_sectors =3D mddev->chunk_sectors;
> +	lim.logical_block_size =3D mddev->logical_block_size;
>   	lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
>   	lim.max_hw_wzeroes_unmap_sectors =3D mddev->chunk_sectors;
>   	lim.io_min =3D mddev->chunk_sectors << 9;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 51f0201e4906..0961bd11f1bc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1998,6 +1998,7 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *freshest, struc
>   		mddev->layout =3D le32_to_cpu(sb->layout);
>   		mddev->raid_disks =3D le32_to_cpu(sb->raid_disks);
>   		mddev->dev_sectors =3D le64_to_cpu(sb->size);
> +		mddev->logical_block_size =3D le32_to_cpu(sb->logical_block_size);
>   		mddev->events =3D ev1;
>   		mddev->bitmap_info.offset =3D 0;
>   		mddev->bitmap_info.space =3D 0;
> @@ -2207,6 +2208,7 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>   	sb->chunksize =3D cpu_to_le32(mddev->chunk_sectors);
>   	sb->level =3D cpu_to_le32(mddev->level);
>   	sb->layout =3D cpu_to_le32(mddev->layout);
> +	sb->logical_block_size =3D cpu_to_le32(mddev->logical_block_size);
>   	if (test_bit(FailFast, &rdev->flags))
>   		sb->devflags |=3D FailFast1;
>   	else
> @@ -5935,6 +5937,67 @@ static struct md_sysfs_entry md_serialize_policy =
=3D
>   __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>          serialize_policy_store);
>  =20
> +static int mddev_set_logical_block_size(struct mddev *mddev,
> +				unsigned int lbs)
> +{
> +	int err =3D 0;
> +	struct queue_limits lim;
> +
> +	if (queue_logical_block_size(mddev->gendisk->queue) >=3D lbs) {
> +		pr_err("%s: Cannot set LBS smaller than mddev LBS %u\n",
> +		       mdname(mddev), lbs);
> +		return -EINVAL;
> +	}
> +
> +	lim =3D queue_limits_start_update(mddev->gendisk->queue);
> +	lim.logical_block_size =3D lbs;
> +	pr_info("%s: logical_block_size is changed, data may be lost\n",
> +		mdname(mddev));
> +	err =3D queue_limits_commit_update(mddev->gendisk->queue, &lim);
> +	if (err)
> +		return err;
> +
> +	mddev->logical_block_size =3D lbs;
> +	md_update_sb(mddev, 1);

This helper can't actually update superblock before array is read-write,
while this api is disallowed for running array.

Perhaps setting MD_SB_CHANGE_DEVS instead, and add comments that new lsb wi=
ll
be written to superblock until array is running.

Otherwise LGTM.

Thanks,
Kuai

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
> +	int err =3D -EBUSY;
> +
> +	/* Only 1.x meta supports configurable LBS */
> +	if (mddev->major_version =3D=3D 0)
> +		return -EINVAL;
> +
> +	if (mddev->pers)
> +		return -EBUSY;
> +
> +	err =3D kstrtouint(buf, 10, &lbs);
> +	if (err < 0)
> +		return -EINVAL;
> +
> +	err =3D mddev_lock(mddev);
> +	if (err)
> +		goto unlock;
> +
> +	err =3D mddev_set_logical_block_size(mddev, lbs);
> +
> +unlock:
> +	mddev_unlock(mddev);
> +	return err ?: len;
> +}
> +
> +static struct md_sysfs_entry md_logical_block_size =3D
> +__ATTR(logical_block_size, 0644, lbs_show, lbs_store);
>  =20
>   static struct attribute *md_default_attrs[] =3D {
>   	&md_level.attr,
> @@ -5957,6 +6020,7 @@ static struct attribute *md_default_attrs[] =3D {
>   	&md_consistency_policy.attr,
>   	&md_fail_last_dev.attr,
>   	&md_serialize_policy.attr,
> +	&md_logical_block_size.attr,
>   	NULL,
>   };
>  =20
> @@ -6087,6 +6151,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, s=
truct queue_limits *lim,
>   			return -EINVAL;
>   	}
>  =20
> +	/*
> +	 * Before RAID adding folio support, the logical_block_size
> +	 * should be smaller than the page size.
> +	 */
> +	if (lim->logical_block_size > PAGE_SIZE) {
> +		pr_err("%s: logical_block_size must not larger than PAGE_SIZE\n",
> +			mdname(mddev));
> +		return -EINVAL;
> +	}
> +	mddev->logical_block_size =3D lim->logical_block_size;
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
> @@ -6698,6 +6773,7 @@ static void md_clean(struct mddev *mddev)
>   	mddev->chunk_sectors =3D 0;
>   	mddev->ctime =3D mddev->utime =3D 0;
>   	mddev->layout =3D 0;
> +	mddev->logical_block_size =3D 0;
>   	mddev->max_disks =3D 0;
>   	mddev->events =3D 0;
>   	mddev->can_decrease_events =3D 0;
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 49477b560cc9..f3b0d91d903d 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -383,6 +383,7 @@ static int raid0_set_limits(struct mddev *mddev)
>   	lim.max_hw_sectors =3D mddev->chunk_sectors;
>   	lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
>   	lim.max_hw_wzeroes_unmap_sectors =3D mddev->chunk_sectors;
> +	lim.logical_block_size =3D mddev->logical_block_size;
>   	lim.io_min =3D mddev->chunk_sectors << 9;
>   	lim.io_opt =3D lim.io_min * mddev->raid_disks;
>   	lim.chunk_sectors =3D mddev->chunk_sectors;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 64bfe8ca5b38..167768edaec1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3212,6 +3212,7 @@ static int raid1_set_limits(struct mddev *mddev)
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors =3D 0;
>   	lim.max_hw_wzeroes_unmap_sectors =3D 0;
> +	lim.logical_block_size =3D mddev->logical_block_size;
>   	lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
>   	err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6b2d4b7057ae..71bfed3b798d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4000,6 +4000,7 @@ static int raid10_set_queue_limits(struct mddev *md=
dev)
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors =3D 0;
>   	lim.max_hw_wzeroes_unmap_sectors =3D 0;
> +	lim.logical_block_size =3D mddev->logical_block_size;
>   	lim.io_min =3D mddev->chunk_sectors << 9;
>   	lim.chunk_sectors =3D mddev->chunk_sectors;
>   	lim.io_opt =3D lim.io_min * raid10_nr_stripes(conf);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index aa404abf5d17..92473850f381 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7747,6 +7747,7 @@ static int raid5_set_limits(struct mddev *mddev)
>   	stripe =3D roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9)=
);
>  =20
>   	md_init_stacking_limits(&lim);
> +	lim.logical_block_size =3D mddev->logical_block_size;
>   	lim.io_min =3D mddev->chunk_sectors << 9;
>   	lim.io_opt =3D lim.io_min * (conf->raid_disks - conf->max_degraded);
>   	lim.features |=3D BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
