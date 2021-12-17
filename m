Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FA3C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 02:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhLQC0e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 21:26:34 -0500
Received: from out0.migadu.com ([94.23.1.103]:45112 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhLQC0e (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 16 Dec 2021 21:26:34 -0500
Subject: Re: [PATCH 3/3] raid5: introduce MD_BROKEN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639707993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j44iI9/rnFGvVDnhdprxZZUC5QXpphNdCnl5ceI4pb4=;
        b=uJSZg35aUKpgACzVb5UI9CL5rMfuy5oenN8RGmFQ+gf3fLJjEuvjcyAFqf0GJP94hZihJ5
        WfNPX+nOKlxMhUvvbq4H6/WU4s39eaz0DiqGSCWDuuSCPE+Jd0NCob34WVau8vWNoDszbO
        iu0A5pLu/ecympor+fqhP1c562V8eNE=
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-4-mariusz.tkaczyk@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <3d5fe975-265f-557e-5d13-88ef6b06bcba@linux.dev>
Date:   Fri, 17 Dec 2021 10:26:27 +0800
MIME-Version: 1.0
In-Reply-To: <20211216145222.15370-4-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/16/21 10:52 PM, Mariusz Tkaczyk wrote:
> Raid456 module had allowed to achieve failed state. It was fixed by
> fb73b357fb9 ("raid5: block failing device if raid will be failed").
> This fix introduces a bug, now if raid5 fails during IO, it may result
> with a hung task without completion. Faulty flag on the device is
> necessary to process all requests and is checked many times, mainly in
> analyze_stripe().
> Allow to set faulty on drive again and set MD_BROKEN if raid is failed.
>
> As a result, this level is allowed to achieve failed state again, but
> communication with userspace (via -EBUSY status) will be preserved.
>
> This restores possibility to fail array via #mdadm --set-faulty command
> and will be fixed by additional verification on mdadm side.
>
> Reproduction steps:
>   mdadm -CR imsm -e imsm -n 3 /dev/nvme[0-2]n1
>   mdadm -CR r5 -e imsm -l5 -n3 /dev/nvme[0-2]n1 --assume-clean
>   mkfs.xfs /dev/md126 -f
>   mount /dev/md126 /mnt/root/
>
>   fio --filename=/mnt/root/file --size=5GB --direct=1 --rw=randrw
> --bs=64k --ioengine=libaio --iodepth=64 --runtime=240 --numjobs=4
> --time_based --group_reporting --name=throughput-test-job
> --eta-newline=1 &
>
>   echo 1 > /sys/block/nvme2n1/device/device/remove
>   echo 1 > /sys/block/nvme1n1/device/device/remove
>
>   [ 1475.787779] Call Trace:
>   [ 1475.793111] __schedule+0x2a6/0x700
>   [ 1475.799460] schedule+0x38/0xa0
>   [ 1475.805454] raid5_get_active_stripe+0x469/0x5f0 [raid456]
>   [ 1475.813856] ? finish_wait+0x80/0x80
>   [ 1475.820332] raid5_make_request+0x180/0xb40 [raid456]
>   [ 1475.828281] ? finish_wait+0x80/0x80
>   [ 1475.834727] ? finish_wait+0x80/0x80
>   [ 1475.841127] ? finish_wait+0x80/0x80
>   [ 1475.847480] md_handle_request+0x119/0x190
>   [ 1475.854390] md_make_request+0x8a/0x190
>   [ 1475.861041] generic_make_request+0xcf/0x310
>   [ 1475.868145] submit_bio+0x3c/0x160
>   [ 1475.874355] iomap_dio_submit_bio.isra.20+0x51/0x60
>   [ 1475.882070] iomap_dio_bio_actor+0x175/0x390
>   [ 1475.889149] iomap_apply+0xff/0x310
>   [ 1475.895447] ? iomap_dio_bio_actor+0x390/0x390
>   [ 1475.902736] ? iomap_dio_bio_actor+0x390/0x390
>   [ 1475.909974] iomap_dio_rw+0x2f2/0x490
>   [ 1475.916415] ? iomap_dio_bio_actor+0x390/0x390
>   [ 1475.923680] ? atime_needs_update+0x77/0xe0
>   [ 1475.930674] ? xfs_file_dio_aio_read+0x6b/0xe0 [xfs]
>   [ 1475.938455] xfs_file_dio_aio_read+0x6b/0xe0 [xfs]
>   [ 1475.946084] xfs_file_read_iter+0xba/0xd0 [xfs]
>   [ 1475.953403] aio_read+0xd5/0x180
>   [ 1475.959395] ? _cond_resched+0x15/0x30
>   [ 1475.965907] io_submit_one+0x20b/0x3c0
>   [ 1475.972398] __x64_sys_io_submit+0xa2/0x180
>   [ 1475.979335] ? do_io_getevents+0x7c/0xc0
>   [ 1475.986009] do_syscall_64+0x5b/0x1a0
>   [ 1475.992419] entry_SYSCALL_64_after_hwframe+0x65/0xca
>   [ 1476.000255] RIP: 0033:0x7f11fc27978d
>   [ 1476.006631] Code: Bad RIP value.
>   [ 1476.073251] INFO: task fio:3877 blocked for more than 120 seconds.
>
> Fixes: fb73b357fb9 ("raid5: block failing device if raid will be failed")
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>   drivers/md/raid5.c | 34 ++++++++++++++++------------------
>   1 file changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 1240a5c16af8..8b5561811431 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -690,6 +690,9 @@ static int has_failed(struct r5conf *conf)
>   {
>   	int degraded;
>   
> +	if (test_bit(MD_BROKEN, &conf->mddev->flags))
> +		return 1;
> +
>   	if (conf->mddev->reshape_position == MaxSector)
>   		return conf->mddev->degraded > conf->max_degraded;
>   
> @@ -2877,34 +2880,29 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
>   	unsigned long flags;
>   	pr_debug("raid456: error called\n");
>   
> -	spin_lock_irqsave(&conf->device_lock, flags);
> -
> -	if (test_bit(In_sync, &rdev->flags) &&
> -	    mddev->degraded == conf->max_degraded) {
> -		/*
> -		 * Don't allow to achieve failed state
> -		 * Don't try to recover this device
> -		 */
> -		conf->recovery_disabled = mddev->recovery_disabled;
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		return;
> -	}
> +	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n",
> +		mdname(mddev), bdevname(rdev->bdev, b));
>   
> +	spin_lock_irqsave(&conf->device_lock, flags);
>   	set_bit(Faulty, &rdev->flags);
>   	clear_bit(In_sync, &rdev->flags);
>   	mddev->degraded = raid5_calc_degraded(conf);
> +
> +	if (has_failed(conf)) {
> +		set_bit(MD_BROKEN, &mddev->flags);

What about other callers of has_failed? Do they need to set BROKEN flag?
Or set the flag in has_failed if it returns true, just FYI.

Thanks,
Guoqing
