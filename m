Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7696FC433EF
	for <linux-raid@archiver.kernel.org>; Sat,  6 Nov 2021 15:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49FDB61215
	for <linux-raid@archiver.kernel.org>; Sat,  6 Nov 2021 15:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhKFPlH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 Nov 2021 11:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhKFPlG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 Nov 2021 11:41:06 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B068C061570
        for <linux-raid@vger.kernel.org>; Sat,  6 Nov 2021 08:38:23 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] md: add support for REQ_NOWAIT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1636213102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RojnJCLAX9GhS1KQkESTF9u6E8CuP35gZt0J9z1iJgk=;
        b=aNZI53gaxQS6Xn7tq9m7NyJHj/2/lDE66XecxcM43X+o5URAbwDa1VwZP17Z1Z1frviHXQ
        ePpCpuwVW1loymPDLpAKoEi1deK6Ret6ni/ygmgJn8As4e6kqCcDGYsnnnbGLunj+rZgCJ
        pmHMkfBVvoTfM+UfRSg5QHK9DH52Paw=
To:     Vishal Verma <vverma@digitalocean.com>, song@kernel.org,
        linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
 <20211104045149.9599-2-vverma@digitalocean.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <c39a47d0-9984-b3c8-9803-3991552d09f5@linux.dev>
Date:   Sat, 6 Nov 2021 23:38:19 +0800
MIME-Version: 1.0
In-Reply-To: <20211104045149.9599-2-vverma@digitalocean.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/4/21 12:51 PM, Vishal Verma wrote:
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
> it for linear target") added support for REQ_NOWAIT for dm. This uses
> a similar approach to incorporate REQ_NOWAIT for md based bios.
>
> This patch was tested using t/io_uring tool within FIO. A nvme drive
> was partitioned into 2 partitions and a simple raid 0 configuration
> /dev/md0 was created.
>
> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>        937423872 blocks super 1.2 512k chunks
>
> Before patch:
>
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>
> Running top while the above runs:
>
> $ ps -eL | grep $(pidof io_uring)
>
>    38396   38396 pts/2    00:00:00 io_uring
>    38396   38397 pts/2    00:00:15 io_uring
>    38396   38398 pts/2    00:00:13 iou-wrk-38397
>
> We can see iou-wrk-38397 io worker thread created which gets created
> when io_uring sees that the underlying device (/dev/md0 in this case)
> doesn't support nowait.
>
> After patch:
>
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>
> Running top while the above runs:
>
> $ ps -eL | grep $(pidof io_uring)
>
>    38341   38341 pts/2    00:10:22 io_uring
>    38341   38342 pts/2    00:10:37 io_uring
>
> After running this patch, we don't see any io worker thread
> being created which indicated that io_uring saw that the
> underlying device does support nowait. This is the exact behaviour
> noticed on a dm device which also supports nowait.
>
> For all the other raid personalities except raid0, we would need
> to train pieces which involves make_request fn in order for them
> to correctly handle REQ_NOWAIT.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>   drivers/md/md.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5111ed966947..73089776475f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5792,6 +5792,7 @@ int md_run(struct mddev *mddev)
>   	int err;
>   	struct md_rdev *rdev;
>   	struct md_personality *pers;
> +	bool nowait = true;
>   
>   	if (list_empty(&mddev->disks))
>   		/* cannot run an array with no devices.. */
> @@ -5862,8 +5863,13 @@ int md_run(struct mddev *mddev)
>   			}
>   		}
>   		sysfs_notify_dirent_safe(rdev->sysfs_state);
> +		nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
>   	}
>   
> +	/* Set the NOWAIT flags if all underlying devices support it */
> +	if (nowait)
> +		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
> +
>   	if (!bioset_initialized(&mddev->bio_set)) {
>   		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>   		if (err)
> @@ -7007,6 +7013,14 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   	if (!mddev->thread)
>   		md_update_sb(mddev, 1);
> +	/* If the new disk does not support REQ_NOWAIT,
> +	 * disable on the whole MD.
> +	 */

The comment style is

/*
  * xxx
  */

> +	if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
> +		pr_info("%s: Disabling nowait because %s does not support nowait\n",
> +			mdname(mddev), bdevname(rdev->bdev, b));

Use %pg to print block device name will be more popular though md has 
lots of legacy code
with bdevname.

Thanks,
Guoqing
