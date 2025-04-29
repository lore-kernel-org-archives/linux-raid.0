Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88101FE457
	for <linux-raid@vger.kernel.org>; Tue, 29 Apr 2025 01:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745891707; cv=none; b=TVo9/y4FI+X0LZ1O5ixi31ORDWqbDYHhrA7ySJrlIdS9roXQEECQFg1CZGt7zAu8CEQ23m8I9nmFSIhmmjIOonm9VoOu69W4oyE3tVBFP4FUHXwKw5LaCil3Aqic3gFSAVGSAsWdi5xosNE0vSOnXAnienVDhXrGCdt95zTq/Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745891707; c=relaxed/simple;
	bh=W6ISL170CKvSBH7FhTa0m/IX/9jx7szsyr+9UkQHIXo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hb1YaxJ0MMc6GiPZYFa2XLKq/QtSz+XYmVQ1KzJNjJ4RaHkq7FAvWft7DBJ+fk0AnHO4GsNv4h8eLu/j5Uz1qLoIN+bFiLKWQAFXuI1Op3ISp1rmo+c/0YfC8OXWadYf9+WblivSYeul/WXLW3BnOBTVW+Q+PFXNcqSOioUhLso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zmk024LQQz4f3jqb
	for <linux-raid@vger.kernel.org>; Tue, 29 Apr 2025 09:54:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7EE6E1A0C12
	for <linux-raid@vger.kernel.org>; Tue, 29 Apr 2025 09:55:00 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHa19yMRBooAOCKw--.56812S3;
	Tue, 29 Apr 2025 09:55:00 +0800 (CST)
Subject: Re: [PATCH v2 1/3] md: replace MD_DELETED with MD_CLOSING
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai1@huaweicloud.com, ncroxon@redhat.com,
 mtkaczyk@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250428082641.45027-1-xni@redhat.com>
 <20250428082641.45027-2-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7b0cf0b5-dde1-2f88-eecd-706b16355d1e@huaweicloud.com>
Date: Tue, 29 Apr 2025 09:54:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250428082641.45027-2-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa19yMRBooAOCKw--.56812S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4UuF4kAw1DJF45GFWUXFb_yoWrurWDpa
	yxJFZ0vw4Ut345WayUt3WDWFyrZw13tFWqkry3Cas5Aa45Ww18JF4ruFWDJr1DGayrAF4Y
	q3W7ta1Du3W0gF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUQo7NUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/04/28 16:26, Xiao Ni Ð´µÀ:
> Before commit 12a6caf27324 ("md: only delete entries from all_mddevs when
> the disk is freed") MD_CLOSING is cleared in ioctl path. Now MD_CLOSING
> will keep until mddev is freed. So MD_CLOSING can be used to check if the
> array is stopping.
> 
> This patch also removes the ->hold_active check in md_clean function.
> ->hold_active is used to avoid mddev is released on the last close before
> adding disks to mddev. udev rule will open/close array once it's created.
> The array can be closed without ->hold_active support. But it should not
> work again when stopping an array. So remove the check ->hold_active in
> md_clean function.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> v2 removes ->hold_active check in md_clean
>   drivers/md/md.c | 24 +++++++-----------------
>   drivers/md/md.h |  2 --
>   2 files changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9daa78c5fe33..e14253433c49 100644
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
> @@ -6360,15 +6357,10 @@ static void md_clean(struct mddev *mddev)
>   	mddev->persistent = 0;
>   	mddev->level = LEVEL_NONE;
>   	mddev->clevel[0] = 0;
> -	/*
> -	 * Don't clear MD_CLOSING, or mddev can be opened again.
> -	 * 'hold_active != 0' means mddev is still in the creation
> -	 * process and will be used later.
> -	 */
> -	if (mddev->hold_active)
> -		mddev->flags = 0;
> -	else
> -		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
> +	/* UNTIL_STOP is cleared here */
> +	mddev->hold_active = 0;
> +	/* Don't clear MD_CLOSING, or mddev can be opened again. */
> +	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);

This should be a seperate patch, and following code can be removed as
well.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fce27cec67ad..2594b579a488 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6734,8 +6734,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
                 export_array(mddev);

                 md_clean(mddev);
-               if (mddev->hold_active == UNTIL_STOP)
-                       mddev->hold_active = 0;
         }
         md_new_event();
         sysfs_notify_dirent_safe(mddev->sysfs_state);

Thanks,
Kuai

>   	mddev->sb_flags = 0;
>   	mddev->ro = MD_RDWR;
>   	mddev->metadata_type[0] = 0;
> @@ -6595,8 +6587,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		export_array(mddev);
>   
>   		md_clean(mddev);
> -		if (mddev->hold_active == UNTIL_STOP)
> -			mddev->hold_active = 0;
>   	}
>   	md_new_event();
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> @@ -8999,7 +8989,7 @@ void md_do_sync(struct md_thread *thread)
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

