Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC031E871;
	Wed,  5 Mar 2025 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138342; cv=none; b=OromxGbyigm7mhhzN2Pvya5uOqSSw39jvrYNMUhRKAVOk82/hah0eqzdzAeX34R4d7h3/K8D287e9kpkEBCgGuQvY5eCuNyrFNLXl7QkR5fvlnT9T47egBkjKcjhSkNV9GY6ss3cUqt9uygmzqMvzwHskj29I/VLTzqkJAk8R74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138342; c=relaxed/simple;
	bh=7zGBp5nobDpT7BzWB3JCkToVWeitQxdtp4rU1mt4mRY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=I4kDkMbOu/0dM9035mM+gUiJ+n0L6Yjk4YU3KSvaGSePmSpUxM4ld0A/NrDIBG/RaWfbSTLNNE/icao87zab8NjUaFNFfhNu/bfaD/ugzjqjWxl9wOQ9dhEg3QhDh28v0sLJUB3t5CPacNyC1Cnh3IMgSvtA34yD/BKKSlnSscI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z6w552CLrz4f3kpQ;
	Wed,  5 Mar 2025 09:31:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 667021A058E;
	Wed,  5 Mar 2025 09:32:15 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgCH2sScqcdnMjv+FQ--.25772S3;
	Wed, 05 Mar 2025 09:32:13 +0800 (CST)
Subject: Re: [PATCH v3] md: fix mddev uaf while iterating all_mddevs list
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, hare@suse.de,
 axboe@kernel.dk, logang@deltatee.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, hch@lst.de,
 guillaume@morinfr.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250220124348.845222-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f6628f78-a084-d3af-430c-d1765f88779e@huaweicloud.com>
Date: Wed, 5 Mar 2025 09:32:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220124348.845222-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCH2sScqcdnMjv+FQ--.25772S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1UXryDCr4rur47JFyDAwb_yoWrXFWDpF
	WYqFWfGr48Xr93XF4DGa1kuFy5uw18Kr4DKry7Ka1rCr1UGwnxWw1Sgr15Xa4j9ayfWrn8
	Ka17Jr98Zr47WwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUpwZcUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/02/20 20:43, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> While iterating all_mddevs list from md_notify_reboot() and md_exit(),
> list_for_each_entry_safe is used, and this can race with deletint the
> next mddev, causing UAF:
> 
> t1:
> spin_lock
> //list_for_each_entry_safe(mddev, n, ...)
>   mddev_get(mddev1)
>   // assume mddev2 is the next entry
>   spin_unlock
>              t2:
>              //remove mddev2
>              ...
>              mddev_free
>              spin_lock
>              list_del
>              spin_unlock
>              kfree(mddev2)
>   mddev_put(mddev1)
>   spin_lock
>   //continue dereference mddev2->all_mddevs
> 
> The old helper for_each_mddev() actually grab the reference of mddev2
> while holding the lock, to prevent from being freed. This problem can be
> fixed the same way, however, the code will be complex.
> 
> Hence switch to use list_for_each_entry, in this case mddev_put() can free
> the mddev1 and it's not safe as well. Refer to md_seq_show(), also factor
> out a helper mddev_put_locked() to fix this problem.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: f26514342255 ("md: stop using for_each_mddev in md_notify_reboot")
> Fixes: 16648bac862f ("md: stop using for_each_mddev in md_exit")
> Reported-by: Guillaume Morin <guillaume@morinfr.org>
> Closes: https://lore.kernel.org/all/Z7Y0SURoA8xwg7vn@bender.morinfr.org/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 22 +++++++++++++---------
>   1 file changed, 13 insertions(+), 9 deletions(-)
> 
Applied to md-6.15
Thanks

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 827646b3eb59..f501bc5f68f1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -629,6 +629,12 @@ static void __mddev_put(struct mddev *mddev)
>   	queue_work(md_misc_wq, &mddev->del_work);
>   }
>   
> +static void mddev_put_locked(struct mddev *mddev)
> +{
> +	if (atomic_dec_and_test(&mddev->active))
> +		__mddev_put(mddev);
> +}
> +
>   void mddev_put(struct mddev *mddev)
>   {
>   	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
> @@ -8461,9 +8467,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
>   	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
>   		status_unused(seq);
>   
> -	if (atomic_dec_and_test(&mddev->active))
> -		__mddev_put(mddev);
> -
> +	mddev_put_locked(mddev);
>   	return 0;
>   }
>   
> @@ -9895,11 +9899,11 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>   static int md_notify_reboot(struct notifier_block *this,
>   			    unsigned long code, void *x)
>   {
> -	struct mddev *mddev, *n;
> +	struct mddev *mddev;
>   	int need_delay = 0;
>   
>   	spin_lock(&all_mddevs_lock);
> -	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
> +	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
>   		if (!mddev_get(mddev))
>   			continue;
>   		spin_unlock(&all_mddevs_lock);
> @@ -9911,8 +9915,8 @@ static int md_notify_reboot(struct notifier_block *this,
>   			mddev_unlock(mddev);
>   		}
>   		need_delay = 1;
> -		mddev_put(mddev);
>   		spin_lock(&all_mddevs_lock);
> +		mddev_put_locked(mddev);
>   	}
>   	spin_unlock(&all_mddevs_lock);
>   
> @@ -10245,7 +10249,7 @@ void md_autostart_arrays(int part)
>   
>   static __exit void md_exit(void)
>   {
> -	struct mddev *mddev, *n;
> +	struct mddev *mddev;
>   	int delay = 1;
>   
>   	unregister_blkdev(MD_MAJOR,"md");
> @@ -10266,7 +10270,7 @@ static __exit void md_exit(void)
>   	remove_proc_entry("mdstat", NULL);
>   
>   	spin_lock(&all_mddevs_lock);
> -	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
> +	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
>   		if (!mddev_get(mddev))
>   			continue;
>   		spin_unlock(&all_mddevs_lock);
> @@ -10278,8 +10282,8 @@ static __exit void md_exit(void)
>   		 * the mddev for destruction by a workqueue, and the
>   		 * destroy_workqueue() below will wait for that to complete.
>   		 */
> -		mddev_put(mddev);
>   		spin_lock(&all_mddevs_lock);
> +		mddev_put_locked(mddev);
>   	}
>   	spin_unlock(&all_mddevs_lock);
>   
> 

