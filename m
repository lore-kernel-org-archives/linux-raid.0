Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECBFCA0ECF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 13:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjILNZk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 09:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjILNZi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 09:25:38 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D34D10CE
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 06:25:34 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RlPTj2mCJz4f3kKy
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 21:25:29 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgB3BdXEZgBlPYYmAQ--.49395S3;
        Tue, 12 Sep 2023 21:25:25 +0800 (CST)
Subject: Re: [PATCH v2] md: do not _put wrong device in md_seq_next
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, AceLan Kao <acelan@gmail.com>,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5a71d6a0-c971-1e28-110d-a6ad2f81cda0@huaweicloud.com>
Date:   Tue, 12 Sep 2023 21:25:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgB3BdXEZgBlPYYmAQ--.49395S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4UKrWDurWUZF4xCr1xKrg_yoW5tryUpa
        yfXFZxAr4DJryrAan8AayDuF15Xw1vqrWkKry3Kw15AF13Kr18Z3Wagr4UXr1vvay8Wrn0
        vw42gw17Wr129FDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/09/12 21:01, Mariusz Tkaczyk Ð´µÀ:
> During working on changes proposed by Kuai [1], I determined that
> mddev->active is continusly decremented for array marked by MD_CLOSING.
> It brought me to md_seq_next() changed by [2]. I determined the regression
> here, if mddev_get() fails we updated mddev pointer and as a result we
> _put failed device.

This mddev is decremented while there is another mddev increased, that's
why AceLan said that single array can't reporduce the problem.

And because mddev->active is leaked, then del_gendisk() will never be
called for the mddev while closing the array, that's why user will
always see this array, cause infiniate loop open -> stop array -> close
for systemd-shutdown.
> 
> I isolated the change in md_seq_next() and tested it- issue is no longer
> reproducible but I don't see the root cause in this scenario. The bug
> is obvious so I proceed with fixing. I will submit MD_CLOSING patches
> separatelly.
> 
> Put the device which has been _get with previous md_seq_next() call.
> Add guard for inproper mddev_put usage(). It shouldn't be called if
> there are less than 1 for mddev->active.
> 
> I didn't convert atomic_t to refcount_t because refcount warns when 0 is
> achieved which is likely to happen for mddev->active.
> 

LGTM,
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> [1] https://lore.kernel.org/linux-raid/028a21df-4397-80aa-c2a5-7c754560f595@gmail.com/T/#m6a534677d9654a4236623661c10646d45419ee1b
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=217798
> 
> Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the disk is freed")
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: AceLan Kao <acelan@gmail.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>   drivers/md/md.c | 20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0fe7ab6e8ab9..bb654ff62765 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -618,6 +618,12 @@ static void mddev_delayed_delete(struct work_struct *ws);
>   
>   void mddev_put(struct mddev *mddev)
>   {
> +	/* Guard for ambiguous put. */
> +	if (unlikely(atomic_read(&mddev->active) < 1)) {
> +		pr_warn("%s: active refcount is lower than 1\n", mdname(mddev));
> +		return;
> +	}
> +
>   	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
>   		return;
>   	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
> @@ -8227,19 +8233,16 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>   {
>   	struct list_head *tmp;
>   	struct mddev *next_mddev, *mddev = v;
> -	struct mddev *to_put = NULL;
>   
>   	++*pos;
> -	if (v == (void*)2)
> +	if (v == (void *)2)
>   		return NULL;
>   
>   	spin_lock(&all_mddevs_lock);
> -	if (v == (void*)1) {
> +	if (v == (void *)1)
>   		tmp = all_mddevs.next;
> -	} else {
> -		to_put = mddev;
> +	else
>   		tmp = mddev->all_mddevs.next;
> -	}
>   
>   	for (;;) {
>   		if (tmp == &all_mddevs) {
> @@ -8250,12 +8253,11 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>   		next_mddev = list_entry(tmp, struct mddev, all_mddevs);
>   		if (mddev_get(next_mddev))
>   			break;
> -		mddev = next_mddev;
> -		tmp = mddev->all_mddevs.next;
> +		tmp = next_mddev->all_mddevs.next;
>   	}
>   	spin_unlock(&all_mddevs_lock);
>   
> -	if (to_put)
> +	if (v != (void *)1)
>   		mddev_put(mddev);
>   	return next_mddev;
>   
> 

