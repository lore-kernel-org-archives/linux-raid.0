Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F814A8B;
	Fri, 26 Dec 2025 03:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766718281; cv=none; b=ORVmfThhGUcWZ8QXt/G4K3l0h7+6DQr2B3X6l+Mp+HjDxN5y5t5vc42LVFwtpF3IFPtKYLZRKy8XqzOpZZ8G05fXNGDKCVj545OzgczKxBBrsc5lo/sufraMqmRPkhgRvf1svg7EI7SXAAv+DL8Oa2Q+TVHVCFrRfYLvphaduWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766718281; c=relaxed/simple;
	bh=H/V0MKwq2EIRDrIlrdhNVnr6PKWuGrkJE8aVLkE+AaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NwIE+Owm7IQrE6cZUFyFC7GbNCbgCUaCyaErvMMzMS3A5BKVdo8mEeAQxPJLIvu+88/7uAVJyrbxsOTjehCOPmP77Sezx8abTpyVfEfzsboPwPF1UcTLd5qvo9lbcAWYk8hMB7f2hhcvGuPyDxaRJ99tYvIQ6nM4b2O7b4L9jtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dcr6c5PP6zYQtGV;
	Fri, 26 Dec 2025 11:03:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1AB3B40573;
	Fri, 26 Dec 2025 11:04:34 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHZ_dA+01pfGkHBg--.3274S3;
	Fri, 26 Dec 2025 11:04:33 +0800 (CST)
Message-ID: <223a9fac-243d-9ba5-e7da-03999f0a1c75@huaweicloud.com>
Date: Fri, 26 Dec 2025 11:04:32 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 01/11] md: merge mddev has_superblock into mddev_flags
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, filippo@debian.org, colyli@fnnas.com
References: <20251124063203.1692144-1-yukuai@fnnas.com>
 <20251124063203.1692144-2-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251124063203.1692144-2-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHZ_dA+01pfGkHBg--.3274S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw18AF18JrW5tw4kuw4rKrg_yoW8tw15pa
	92kFyYkr4UAryYg3W7Ca4DCa4Fq3W0kayvkFW3Z3s3XFy5Xry5Grn0gas8t3s8KF4rAF4D
	X3W5Kr15uFn7ur7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxUwGQDUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/24 14:31, Yu Kuai 写道:
> There is not need to use a separate field in struct mddev, there are no
> functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 6 +++---
>   drivers/md/md.h | 3 ++-
>   2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7b5c5967568f..b49fdee11a03 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6462,7 +6462,7 @@ int md_run(struct mddev *mddev)
>   	 * the only valid external interface is through the md
>   	 * device.
>   	 */
> -	mddev->has_superblocks = false;
> +	clear_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
>   	rdev_for_each(rdev, mddev) {
>   		if (test_bit(Faulty, &rdev->flags))
>   			continue;
> @@ -6475,7 +6475,7 @@ int md_run(struct mddev *mddev)
>   		}
>   
>   		if (rdev->sb_page)
> -			mddev->has_superblocks = true;
> +			set_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
>   
>   		/* perform some consistency tests on the device.
>   		 * We don't want the data to overlap the metadata,
> @@ -9085,7 +9085,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
>   	rcu_read_unlock();
>   	if (did_change)
>   		sysfs_notify_dirent_safe(mddev->sysfs_state);
> -	if (!mddev->has_superblocks)
> +	if (!test_bit(MD_HAS_SUPERBLOCK, &mddev->flags))
>   		return;
>   	wait_event(mddev->sb_wait,
>   		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6985f2829bbd..b4c9aa600edd 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -340,6 +340,7 @@ struct md_cluster_operations;
>    *		   array is ready yet.
>    * @MD_BROKEN: This is used to stop writes and mark array as failed.
>    * @MD_DELETED: This device is being deleted
> + * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
>    *
>    * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
>    */
> @@ -356,6 +357,7 @@ enum mddev_flags {
>   	MD_BROKEN,
>   	MD_DO_DELETE,
>   	MD_DELETED,
> +	MD_HAS_SUPERBLOCK,
>   };
>   
>   enum mddev_sb_flags {
> @@ -623,7 +625,6 @@ struct mddev {
>   	/* The sequence number for sync thread */
>   	atomic_t sync_seq;
>   
> -	bool	has_superblocks:1;
>   	bool	fail_last_dev:1;
>   	bool	serialize_policy:1;
>   };

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>


-- 
Thanks,
Nan

