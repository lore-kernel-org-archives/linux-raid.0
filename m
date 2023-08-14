Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BABC04A94
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 12:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjHNMhe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjHNMhQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 08:37:16 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A5810C6
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 05:37:12 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RPYnG1tbZz4f3npg
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 20:37:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3hqn0H9pkCj3HAg--.43429S3;
        Mon, 14 Aug 2023 20:37:09 +0800 (CST)
Subject: Re: [PATCH v5 2/3] md/raid1: free the r1bio firstly before waiting
 for blocked rdev
To:     Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org,
        djeffery@redhat.com, dan.j.williams@intel.com, neilb@suse.de,
        akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230814085108.991040-1-xueshi.hu@smartx.com>
 <20230814085108.991040-3-xueshi.hu@smartx.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2ee5d414-90e7-8b3d-71d4-5074936e0413@huaweicloud.com>
Date:   Mon, 14 Aug 2023 20:37:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230814085108.991040-3-xueshi.hu@smartx.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3hqn0H9pkCj3HAg--.43429S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw48Cr15ArWkGF1fGryUZFb_yoW8XF18pa
        12gFy0vrZ8GrWYgF1DJFWDuFyrua9aqryxCrW8Cw18ZF42vryDK3WUXa45Wrn8uF9xC39r
        J3Z093yDCayjvFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbPEf5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/08/14 16:51, Xueshi Hu Ð´µÀ:
> Raid1 reshape will change mempool and r1conf::raid_disks which are
> necessary when freeing r1bio. allow_barrier() make an concurrent
> raid1_reshape() possible. So, free the in-flight r1bio firstly before
> waiting blocked rdev.
> 
> Fixes: 6bfe0b499082 ("md: support blocking writes to an array on device failure")

LGTM

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> ---
>   drivers/md/raid1.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index dbbee0c14a5b..5f17f30a00a9 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1374,6 +1374,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		return;
>   	}
>   
> + retry_write:
>   	r1_bio = alloc_r1bio(mddev, bio);
>   	r1_bio->sectors = max_write_sectors;
>   
> @@ -1389,7 +1390,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	 */
>   
>   	disks = conf->raid_disks * 2;
> - retry_write:
>   	blocked_rdev = NULL;
>   	rcu_read_lock();
>   	max_sectors = r1_bio->sectors;
> @@ -1469,7 +1469,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		for (j = 0; j < i; j++)
>   			if (r1_bio->bios[j])
>   				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
> -		r1_bio->state = 0;
> +		free_r1bio(r1_bio);
>   		allow_barrier(conf, bio->bi_iter.bi_sector);
>   
>   		if (bio->bi_opf & REQ_NOWAIT) {
> 

