Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BFB330663
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768202923; cv=none; b=e3PZ0auEoAweVSPOEyXy4c75+CyjPZz3EtEbc1j5o16reQ50N7RTdOXgT/bx7IjLn7IdRAhIjf8jzlSUr3Yj8ovoR/uyPH+8zNwPIbBvS4hniEDc3Ua3PubFRNZRAx23pezZd49LrbHYb4e1k3o/uI8X+seZK51VdDrpU8HOb64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768202923; c=relaxed/simple;
	bh=/TOhTd5EHT+fDkaNqhqh374vwRPO9KZbTlYowaELGVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=I24AxRn7H5DUIBxy8nzHW+VQu+ueqeFK5UH9SqoZoHeo1Jp0pD6HOsj+sgM+3zpK8u442dqM8eGpyWLg4A06LEWuoZr4O37bEvr4Z0aQ6H1mtEbfyQtINMIZ/7IELxCHJADQTmV4q42lPaL2iVlrDC9F8N//hbWhblPmkSelnOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dqP9J59hgzKHMdb
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 15:27:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5856C4058D
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 15:28:37 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgDXOPmhomRp6bAQDg--.7862S3;
	Mon, 12 Jan 2026 15:28:34 +0800 (CST)
Message-ID: <72f9e14c-077e-030f-8f2c-da0ebc4e7d63@huaweicloud.com>
Date: Mon, 12 Jan 2026 15:28:33 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 11/11] md: fix abnormal io_opt from member disks
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
References: <20260112042857.2334264-1-yukuai@fnnas.com>
 <20260112042857.2334264-12-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260112042857.2334264-12-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOPmhomRp6bAQDg--.7862S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WF1kAw1fAr4fArWfZw43Jrb_yoW7CrWDpF
	4qqa43Cr47J34fKFyUAayDCFyavws7KrZ2kry3A3yfu3W3tr97KFWaqFW5tr93ZFZ8Z3WU
	Xw15GFsrCa4xGFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1_MaU
	UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/12 12:28, Yu Kuai 写道:
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
>   drivers/md/md.c     | 28 +++++++++++++++++++++++++++-
>   drivers/md/md.h     |  3 ++-
>   drivers/md/raid1.c  |  2 +-
>   drivers/md/raid10.c |  4 ++--
>   4 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 731ec800f5cb..6c0fb09c26dc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6200,18 +6200,33 @@ static const struct kobj_type md_ktype = {
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
> +	bool io_opt_configured = lim->io_opt;
>   
>   	rdev_for_each(rdev, mddev) {
> +		unsigned int io_opt = lim->io_opt;
> +
>   		queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offset,
>   					mddev->gendisk->disk_name);
>   		if ((flags & MDDEV_STACK_INTEGRITY) &&
>   		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
>   			return -EINVAL;
> +
> +		/*
> +		 * If member disk is not mdraid array, keep the io_opt
> +		 * from personality and ignore io_opt from member disk.
> +		 */
> +		if (!rdev_is_mddev(rdev) && io_opt_configured)
> +			lim->io_opt = io_opt;
>   	}
>   
>   	/*
> @@ -6230,9 +6245,11 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>   EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
>   
>   /* apply the extra stacking limits from a new rdev into mddev */
> -int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
> +int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
> +			 bool io_opt_configured)
>   {
>   	struct queue_limits lim;
> +	unsigned int io_opt;
>   
>   	if (mddev_is_dm(mddev))
>   		return 0;
> @@ -6245,6 +6262,8 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   
>   	lim = queue_limits_start_update(mddev->gendisk->queue);
> +	io_opt = lim.io_opt;
> +
>   	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>   				mddev->gendisk->disk_name);
>   
> @@ -6255,6 +6274,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   		return -ENXIO;
>   	}
>   
> +	/*
> +	 * If member disk is not mdraid array, keep the io_opt from
> +	 * personality and ignore io_opt from member disk.
> +	 */
> +	if (!rdev_is_mddev(rdev) && io_opt_configured)
> +		lim.io_opt = io_opt;
> +
>   	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
>   }
>   EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ddf989f2a139..80c527b3777d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -1041,7 +1041,8 @@ int do_md_run(struct mddev *mddev);
>   #define MDDEV_STACK_INTEGRITY	(1u << 0)
>   int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>   		unsigned int flags);
> -int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
> +int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
> +			 bool io_opt_configured);
>   void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
>   
>   extern const struct block_device_operations md_fops;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 1a957dba2640..f3f3086f27fa 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1944,7 +1944,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   	for (mirror = first; mirror <= last; mirror++) {
>   		p = conf->mirrors + mirror;
>   		if (!p->rdev) {
> -			err = mddev_stack_new_rdev(mddev, rdev);
> +			err = mddev_stack_new_rdev(mddev, rdev, false);
>   			if (err)
>   				return err;
>   
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 2c6b65b83724..a6edc91e7a9a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2139,7 +2139,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   			continue;
>   		}
>   
> -		err = mddev_stack_new_rdev(mddev, rdev);
> +		err = mddev_stack_new_rdev(mddev, rdev, true);
>   		if (err)
>   			return err;
>   		p->head_position = 0;
> @@ -2157,7 +2157,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   		clear_bit(In_sync, &rdev->flags);
>   		set_bit(Replacement, &rdev->flags);
>   		rdev->raid_disk = repl_slot;
> -		err = mddev_stack_new_rdev(mddev, rdev);
> +		err = mddev_stack_new_rdev(mddev, rdev, true);
>   		if (err)
>   			return err;
>   		conf->fullsync = 1;

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

