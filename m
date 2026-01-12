Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D91C8634F
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 02:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768185958; cv=none; b=OiCw0lRKP52vAIcybwKvjiypXUwPTN1l5ps9Ddoy48TdxEDibUqmTADf1clF9+jO3uQAwlBiQnAamf6CD23OeF2JoY1gk/h2GPApgCfdDL31w4JyotbHP63o5+KzCx3V/29Nb2iC/5VDB5JlTr1q1uOmJ61vPOiUjHNJ3RIAP1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768185958; c=relaxed/simple;
	bh=Og4UAs/2Z8TbwyHH9rmZKZP/+fsNZjCXyByBw/0UVtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gN4BGjZp7Zd/+iHnioiOMMvOx+eFIRTPFywNkJ86QeAYBxzU6Xt9UGl6yHz311omQwMttbJw2n6255ElQooiLTcU+78UJYpnQZ7rcnwZO278yeHuAIMN9FYpsCZ7VnnCj+udx6PJXuY10ONFMJJrN76xt41+R36iF6Bk72fOBAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dqGv273YnzKHMLN
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 10:45:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 526B640539
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 10:45:51 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgDXOPlbYGRp7Qj5DQ--.3522S3;
	Mon, 12 Jan 2026 10:45:48 +0800 (CST)
Message-ID: <f499cb3b-f4b8-efa0-03b4-d3ac2a682991@huaweicloud.com>
Date: Mon, 12 Jan 2026 10:45:47 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 11/11] md: fix abnormal io_opt from member disks
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
References: <20260111182651.2097070-1-yukuai@fnnas.com>
 <20260111182651.2097070-12-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260111182651.2097070-12-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOPlbYGRp7Qj5DQ--.3522S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw43Xw4kWF13WF13Xw1DZFb_yoW5Gry3pF
	W7WFyYvr47AF1Skw43AF4DuF90qws3GrWI9ry3A39xZr1Yvr17GFWSqF98XF93XFyUu3W7
	Jr4rKF4Duw1jy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07URwZ
	7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/12 2:26, Yu Kuai 写道:
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
> index 731ec800f5cb..5a10c922107b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6200,11 +6200,17 @@ static const struct kobj_type md_ktype = {
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
> @@ -6212,6 +6218,9 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>   		if ((flags & MDDEV_STACK_INTEGRITY) &&
>   		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
>   			return -EINVAL;
> +
> +		if (rdev_is_mddev(rdev))
> +			set_bit(MD_STACK_IO_OPT, &mddev->flags);
>   	}
>   

We only intend to do lcm_not_zero() with the mddev's opt, so would this
modification be more reasonable?


@@ -6204,6 +6210,11 @@ int mddev_stack_rdev_limits(struct mddev *mddev, 
struct queue_limits *lim,
                 if ((flags & MDDEV_STACK_INTEGRITY) &&
                     !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
                         return -EINVAL;
+
+               if (rdev_is_mddev(rdev))
+                       io_opt = lim->io_opt;
+               else if (io_opt)
+                       lim->io_opt = io_opt;
         }

-- 
Thanks,
Nan

