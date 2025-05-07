Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E1D200BB8
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 06:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746598860; cv=none; b=rVTQNB0x+3GFjBGJCs/abDljlLmMDwSKZF6uhTLK8RyhUEYwriC9mJY0PmIR0g6lNrmjdGs1dubdD3DdqDbsjId/mcpIvaU55he7C6QssAyYYJo3z/6oXTsG9l6k+kCMeW91pqgzy9MFUqtyo8Q7YldN0jhhD2RoVC+IFhBmDxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746598860; c=relaxed/simple;
	bh=FVtCaU7wbl61Z932xWrSpm0NCbsnzdqaRDShGj2jOI0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TpowcUb1HYDSmNkRCmDMf3H8PNm+3C5/4Ka2CZWq+lo+Dd9W91AAwE1RwJY7fjm3EolIibA5/7Arh9MUA0V47U41L6Y9xW/cJ7x6QnCPdSWgfLplBLHaPFrLy2WqIryujxa6/g9PtdWQf6EKn6cUQ8FOY//e7oZv+6d7dM7v5dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZslWP46YkzKHMjV
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 14:20:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5BDE31A0904
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 14:20:48 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2C++xpo60G3Lg--.51024S3;
	Wed, 07 May 2025 14:20:48 +0800 (CST)
Subject: Re: [PATCH 2/3] md: replace MD_DELETED with MD_CLOSING
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai1@huaweicloud.com, ncroxon@redhat.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250507021415.14874-1-xni@redhat.com>
 <20250507021415.14874-3-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <09d3eb78-d2c9-5c04-bec5-5aae4a19cf83@huaweicloud.com>
Date: Wed, 7 May 2025 14:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250507021415.14874-3-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2C++xpo60G3Lg--.51024S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXrWrGrW8Ww4UKrWDuF18uFg_yoW5AFWfp3
	y8JFWY9w4Utry5WayUJa4DWFy5Xw1FkFWqkFy3Cas5Aa45Xr15XF15u398Jr1DGa1fZF1Y
	q3WrJa98Zw40gr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/07 10:14, Xiao Ni Ð´µÀ:
> Before commit 12a6caf27324 ("md: only delete entries from all_mddevs when
> the disk is freed") MD_CLOSING is cleared in ioctl path. Now MD_CLOSING
> will keep until mddev is freed. So MD_CLOSING can be used to check if the
> array is stopping.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 9 +++------
>   drivers/md/md.h | 2 --
>   2 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9b9950ed6ee9..c226747be9e3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -599,7 +599,7 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
>   {
>   	lockdep_assert_held(&all_mddevs_lock);
>   
> -	if (test_bit(MD_DELETED, &mddev->flags))
> +	if (test_bit(MD_CLOSING, &mddev->flags))
>   		return NULL;
>   	atomic_inc(&mddev->active);
>   	return mddev;

I noticed that MD_CLOSING can be set temporarily in following case:

sysfs:
         if (st == readonly || st == read_auto || st == inactive ||
         ©®   (err && st == clear))
                 clear_bit(MD_CLOSING, &mddev->flags);

ioctl:
         if (cmd == STOP_ARRAY_RO || (err && cmd == STOP_ARRAY))
                 clear_bit(MD_CLOSING, &mddev->flags);


And we should still allow mmdev_get() to pass in these cases.

Thanks,
Kuai

> @@ -613,9 +613,6 @@ static void __mddev_put(struct mddev *mddev)
>   	    mddev->ctime || mddev->hold_active)
>   		return;
>   
> -	/* Array is not configured at all, and not held active, so destroy it */
> -	set_bit(MD_DELETED, &mddev->flags);
> -
>   	/*
>   	 * Call queue_work inside the spinlock so that flush_workqueue() after
>   	 * mddev_find will succeed in waiting for the work to be done.
> @@ -3312,7 +3309,7 @@ static bool md_rdev_overlaps(struct md_rdev *rdev)
>   
>   	spin_lock(&all_mddevs_lock);
>   	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> -		if (test_bit(MD_DELETED, &mddev->flags))
> +		if (test_bit(MD_CLOSING, &mddev->flags))
>   			continue;
>   		rdev_for_each(rdev2, mddev) {
>   			if (rdev != rdev2 && rdev->bdev == rdev2->bdev &&
> @@ -8992,7 +8989,7 @@ void md_do_sync(struct md_thread *thread)
>   			goto skip;
>   		spin_lock(&all_mddevs_lock);
>   		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
> -			if (test_bit(MD_DELETED, &mddev2->flags))
> +			if (test_bit(MD_CLOSING, &mddev2->flags))
>   				continue;
>   			if (mddev2 == mddev)
>   				continue;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1cf00a04bcdd..a9dccb3d84ed 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -338,7 +338,6 @@ struct md_cluster_operations;
>    * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
>    *		   array is ready yet.
>    * @MD_BROKEN: This is used to stop writes and mark array as failed.
> - * @MD_DELETED: This device is being deleted
>    *
>    * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
>    */
> @@ -353,7 +352,6 @@ enum mddev_flags {
>   	MD_HAS_MULTIPLE_PPLS,
>   	MD_NOT_READY,
>   	MD_BROKEN,
> -	MD_DELETED,
>   };
>   
>   enum mddev_sb_flags {
> 

