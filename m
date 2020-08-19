Return-Path: <SRS0=jE/M=B5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FB7C433E1
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 13:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 043E8204FD
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 13:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgHSNxE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Aug 2020 09:53:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56854 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727773AbgHSNxD (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Aug 2020 09:53:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4A72B33C8D690AD62941;
        Wed, 19 Aug 2020 21:53:01 +0800 (CST)
Received: from [10.174.179.185] (10.174.179.185) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 21:52:51 +0800
Subject: Re: [RFC PATCH] md/raid5: set faulty when cannot record badblocks
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
References: <20200819135023.132749-1-yuyufen@huawei.com>
Message-ID: <ff506b8e-eb32-50cf-261f-5d3937e19c62@huawei.com>
Date:   Wed, 19 Aug 2020 21:52:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200819135023.132749-1-yuyufen@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.185]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 2020/8/19 21:50, Yufen Yu wrote:
> From: y00427003 <yuyufen@huawei.com>
> 

Oh, this is error name, correct is:

Yufen Yu <yuyufen@huawei.com>

> Recently, we reported a io hung on raid5 and it can be reproduced easily,
> like as:
> 
>   $ pvcreate /dev/sda /dev/sdb /dev/sdc /dev/sdd
>   $ vgcreate dm-test /dev/sda /dev/sdb /dev/sdc /dev/sdd
>   $ lvcreate --type raid5 -L 2G -i 3 -I 64 -n mylv dm-test
>   $ echo offline > /sys/block/sda/device/state
> 
>   Then issue io to trigger raid5 set sda as faulty:
>   $ dd if=/dev/mapper/dm--test-mylv of=/dev/null bs=4k count=1 iflag=direct
> 
>   After that, set another disk sdb as offline:
>   $ echo offline > /sys/block/sdb/device/state
>   $ dd if=/dev/mapper/dm--test-mylv of=/dev/null bs=8k count=1 iflag=direct
> 
> In the end, 'dd' command will hung forever and cannot return. And kernel
> will repeatly print message as:
> 
> [  105.381220] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [  105.382955] md/raid:mdX: read error not correctable (sector 8 on dm-3).
> [  105.384145] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [  105.385871] md/raid:mdX: read error not correctable (sector 8 on dm-3).
> [  105.387033] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [  105.388757] md/raid:mdX: read error not correctable (sector 8 on dm-3).
> [  105.389915] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [  105.391639] md/raid:mdX: read error not correctable (sector 8 on dm-3).
> [  105.392784] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [  105.394469] md/raid:mdX: read error not correctable (sector 8 on dm-3).
> [  105.395622] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [  105.397315] md/raid:mdX: read error not correctable (sector 8 on dm-3).
> [  105.398455] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> 
> We found that raid5 try to issue the requested read bio (sector 10248)
> repeatly, but can never complete. Since sdb is offline, raid5's bio
> issued to that disk will return error. At the same time, mddev->degraded
> is set as value 1 after setting sda offline. So, raid5_end_read_request()
> will and print "md/raid:mdX: read error not correctable" and try to set
> badblocks.
> 
> However, raid5 created by dm-raid doesn't support badblocks. Thus,
> rdev_set_badblocks() will fail and md_error() try to set the device as
> faulty. After commit fb73b357fb98("raid5: block failing device if raid
> will be failed"), the device cannot set faulty. Then, the issued bio
> neither find badblock nor know the device faulty, it will try again and
> agine but never complete.
> 
> Even without creating raid5 by dm-raid, rdev_set_badblocks() can also
> fail because badblocks count is over than MAX_BADBLOCKS. If md is degraded,
> the problem can also happend.
> 
> To fix this problem, we can set disk as faulty when badblocks is not
> supported or badblocks count is over than MAX_BADBLOCKS.
> 
> Signed-off-by: yuyufen <yuyufen@huawei.com>
> ---
>   drivers/md/raid5.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ef0fd4830803..4bc9cd9a99bb 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2704,7 +2704,9 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
>   	spin_lock_irqsave(&conf->device_lock, flags);
>   
>   	if (test_bit(In_sync, &rdev->flags) &&
> -	    mddev->degraded == conf->max_degraded) {
> +	    mddev->degraded == conf->max_degraded &&
> +		(rdev->badblocks.shift != -1 ||
> +		 rdev->badblocks.count < MAX_BADBLOCKS)) {
>   		/*
>   		 * Don't allow to achieve failed state
>   		 * Don't try to recover this device
> 
