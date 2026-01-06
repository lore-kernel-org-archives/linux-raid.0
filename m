Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4BF1DF256
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 08:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767689488; cv=none; b=sjLgSDDU582r1tAblKQ4jKnWg4vpDkTvm6ZyEIz0zGIUXg6/EsTnACoTP065qJZfpHiXVU3rSTWtpbtQzo6l14Y/aHhIiZYmMWOhabGz67hogYaaUvveSeHnIKFO8m99sl3IF3zDgwvYE6OAgC1rb6+e+ExXriaBFZ5dqOJD9xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767689488; c=relaxed/simple;
	bh=vg4x5rg9MWQMgZBYErziBFvc19LQeHZ4d9LwIqo+G4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tKx7BZG5+aFlQv3zXTYkj+RUcAta+Gcbd2DvvDLOUCeTkeYZ0VB4o9bbf8VdKvVYxbpklKxHpeSumkSF+rrcNCfumxdEdYl2U5Vz0wc4TU9Y/AyUrspHfSMrMdwKoynNPuYLpPU34zDpcolsx/RTEFWW2wvsETMiCPIUJD+M5n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dllHM0HcnzYQtwr
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 16:50:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4A2D940562
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 16:51:23 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfUGzVxpd09HCw--.57617S3;
	Tue, 06 Jan 2026 16:51:19 +0800 (CST)
Message-ID: <cc63c254-f581-bca1-e4b8-115fe048b35e@huaweicloud.com>
Date: Tue, 6 Jan 2026 16:51:18 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 11/11] md: fix abnormal io_opt from member disks
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: colyli@fnnas.com
References: <20260103154543.832844-1-yukuai@fnnas.com>
 <20260103154543.832844-12-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260103154543.832844-12-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfUGzVxpd09HCw--.57617S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw43Xw4kWF13WF13Xw1DZFb_yoWrGryxpF
	W7XFy3Jr47JFySkay7AayDCFyavrs7GrZ2kry3A3yxZwnIyr1xKFWSgFy5Jr93JFn8uw1U
	Xw4rKF4Duw1DC3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07URwZ
	7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/3 23:45, Yu Kuai 写道:
> It's reported that mtp3sas can report abnormal io_opt, for consequence,
> md array will end up with abnormal io_opt as well, due to the
> lcm_not_zero() from blk_stack_limits().
> 
> Some personalities will configure optimal IO size, and it's indicate that
> users can get the best IO bandwidth if they issue IO with this size, and
> we don't want io_opt to be covered by member disks with abnormal io_opt.
> 
> Fix this problem by adding a new mddev flags MD_STACK_IO_OPT to indicate
> that io_opt configured by personalities is preferred over member disks
> or not.
> 
> Reported-by: Filippo Giunchedi <filippo@debian.org>
> Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1121006
> Reported-by: Coly Li <colyli@fnnas.com>
> Closes: https://lore.kernel.org/all/20250817152645.7115-1-colyli@kernel.org/
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c     | 35 ++++++++++++++++++++++++++++++++++-
>   drivers/md/md.h     |  5 ++++-
>   drivers/md/raid1.c  |  2 +-
>   drivers/md/raid10.c |  4 ++--
>   4 files changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7292aedef01b..b46b05cd28fb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6192,11 +6192,17 @@ static const struct kobj_type md_ktype = {
>   
>   int mdp_major = 0;
>   
> +static bool rdev_is_mddev(struct md_rdev *rdev)
> +{
> +	return rdev->bdev->bd_disk->fops == &md_fops;
> +}
> +
>   /* stack the limit for all rdevs into lim */
>   int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>   		unsigned int flags)
>   {
>   	struct md_rdev *rdev;
> +	unsigned int io_opt = lim->io_opt;
>   
>   	rdev_for_each(rdev, mddev) {
>   		queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offset,
> @@ -6204,6 +6210,9 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>   		if ((flags & MDDEV_STACK_INTEGRITY) &&
>   		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
>   			return -EINVAL;
> +
> +		if (rdev_is_mddev(rdev))
> +			set_bit(MD_STACK_IO_OPT, &mddev->flags);
>   	}
>   
>   	/*
> @@ -6217,14 +6226,24 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>   	}
>   	mddev->logical_block_size = lim->logical_block_size;
>   
> +	/*
> +	 * If all member disks are not mdraid array, and the personality
> +	 * already configures io_opt, keep this io_opt and ignore io_opt from
> +	 * member disks.
> +	 */
> +	if (!test_bit(MD_STACK_IO_OPT, &mddev->flags) && io_opt)
> +		lim->io_opt = io_opt;
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
>   
>   /* apply the extra stacking limits from a new rdev into mddev */
> -int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
> +int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
> +			 bool io_opt_configured)
>   {
>   	struct queue_limits lim;
> +	unsigned int io_opt = 0;
>   
>   	if (mddev_is_dm(mddev))
>   		return 0;
> @@ -6237,6 +6256,18 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   
>   	lim = queue_limits_start_update(mddev->gendisk->queue);
> +
> +	/*
> +	 * Keep the old io_opt if no member disks are from md array, and
> +	 * the personality configure it's own io_opt.
> +	 */
> +	if (!test_bit(MD_STACK_IO_OPT, &mddev->flags)) {
> +		if (rdev_is_mddev(rdev))
> +			set_bit(MD_STACK_IO_OPT, &mddev->flags);
> +		else if (io_opt_configured)
> +			io_opt = lim.io_opt;
> +	}
> +
>   	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>   				mddev->gendisk->disk_name);
>   

This looks problematic. When member disks are a mix of RAID and mtp3sas
—— even though this usage scenario is unlikely —— the opt parameter of
mtp3sas will still affect the entire mddev.

-- 
Thanks,
Nan

