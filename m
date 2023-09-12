Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B691ACA0EC8
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 02:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbjILCjy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbjILCjn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Sep 2023 22:39:43 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166B345AA2
        for <linux-raid@vger.kernel.org>; Mon, 11 Sep 2023 19:04:33 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rl6Mx1KXDz4f3jM5
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 10:04:29 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAXrt0sx_9ku+D+AA--.16059S3;
        Tue, 12 Sep 2023 10:04:29 +0800 (CST)
Subject: Re: [PATCH] md: do not _put wrong device
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230911105657.6816-1-mariusz.tkaczyk@linux.intel.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <04eae778-b658-6560-9e93-64d6c390e1a4@huaweicloud.com>
Date:   Tue, 12 Sep 2023 10:04:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230911105657.6816-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAXrt0sx_9ku+D+AA--.16059S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4rtF4xGrW8ArWkGFWxZwb_yoW8uFWfpr
        WxWFZIvr9rAryrGanxA398uF15Xw1FyrWkKry3Kw15AFyagw1kJ3WagFWUXw1DZayrAr4Y
        vw4UKw1DWr17ZFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/09/11 18:56, Mariusz Tkaczyk Ð´µÀ:
> Put the device which has been _get with previous md_seq_next call.
> Add guard for improper mddev_put usage(). It shouldn't be called if
> there are less than 1 for mddev->active.
> 
> I didn't convert atomic_t to refcount_t because refcount warns when 0 is
> achieved which is likely to happen for mddev->active.
> 
> It fixes [1], I'm unable to reproduce this issue now.
> 

Please add a fix tag:

Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the 
disk is freed")

> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=217798
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
> 
> There is md_seq cleanup proposed by Yu, this one should be merged
> first, because it is low risk fix for particular regression.
> 
> This is not complete fix for the problem, we need to prevent new open
> in the middle of removal, I will propose patchset separately.
> 
>   drivers/md/md.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0fe7ab6e8ab9..ffae02406175 100644
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
> @@ -8250,8 +8256,7 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>   		next_mddev = list_entry(tmp, struct mddev, all_mddevs);
>   		if (mddev_get(next_mddev))
>   			break;
> -		mddev = next_mddev;
> -		tmp = mddev->all_mddevs.next;
> +		tmp = next_mddev->all_mddevs.next;
>   	}
>   	spin_unlock(&all_mddevs_lock);
>   
> 

And looks like commit 12a6caf27324 wants to mddev_put(to_put), and with
your change, 'to_put' is not needed as well, can you also remove the
local variable 'to_put'?

Thanks,
Kuai

