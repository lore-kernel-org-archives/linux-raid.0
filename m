Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1558BC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 12 Feb 2022 01:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354533AbiBLBSF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Feb 2022 20:18:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbiBLBSE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Feb 2022 20:18:04 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AC5D83
        for <linux-raid@vger.kernel.org>; Fri, 11 Feb 2022 17:18:02 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644628680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGESVA1NlACHaB/DHq0sXa1CttB4VYWbHO7jgdGqltQ=;
        b=FUUioP0rRMRkr30X+UYM3aEudDinkReACA2kpifZVM7uASt1jizcu2qlO23fIm6FB8cueR
        FoQFcc+87CTaKcupB5vsuWodi06gMWWwIcIvBwIhriKMc15QaEfQx2KfX3y3fAZy33FZws
        KzadKxtn+btUhAx37x4X5GCXsSk7f4g=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-3-mariusz.tkaczyk@linux.intel.com>
Message-ID: <eee13686-e553-eaa2-6c72-452e8cc7edce@linux.dev>
Date:   Sat, 12 Feb 2022 09:17:57 +0800
MIME-Version: 1.0
In-Reply-To: <20220127153912.26856-3-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 1/27/22 11:39 PM, Mariusz Tkaczyk wrote:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f888ef197765..fda8473f96b8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2983,10 +2983,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>   
>   	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>   		md_error(rdev->mddev, rdev);
> -		if (test_bit(Faulty, &rdev->flags))
> -			err = 0;
> -		else
> +
> +		if (test_bit(MD_BROKEN, &rdev->mddev->flags))
>   			err = -EBUSY;
> +		else
> +			err = 0;

Again, it is weird to check MD_BROKEN which is for mddev in rdev 
specific function from
my understanding.

>   	} else if (cmd_match(buf, "remove")) {
>   		if (rdev->mddev->pers) {
>   			clear_bit(Blocked, &rdev->flags);
> @@ -7441,7 +7442,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
>   		err =  -ENODEV;
>   	else {
>   		md_error(mddev, rdev);
> -		if (!test_bit(Faulty, &rdev->flags))
> +		if (test_bit(MD_BROKEN, &mddev->flags))
>   			err = -EBUSY;

Ditto.

>   	}
>   	rcu_read_unlock();
> @@ -7987,12 +7988,14 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   	if (!mddev->pers->sync_request)
>   		return;
>   
> -	if (mddev->degraded)
> +	if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	sysfs_notify_dirent_safe(rdev->sysfs_state);
>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_wakeup_thread(mddev->thread);
> +	if (!test_bit(MD_BROKEN, &mddev->flags)) {
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		md_wakeup_thread(mddev->thread);
> +	}
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	md_new_event();
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index bc3f2094d0b6..1eb7d0e88cb2 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -234,34 +234,42 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>   				int is_new);
>   struct md_cluster_info;
>   
> -/* change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added */
> +/**
> + * enum mddev_flags - md device flags.
> + * @MD_ARRAY_FIRST_USE: First use of array, needs initialization.
> + * @MD_CLOSING: If set, we are closing the array, do not open it then.
> + * @MD_JOURNAL_CLEAN: A raid with journal is already clean.
> + * @MD_HAS_JOURNAL: The raid array has journal feature set.
> + * @MD_CLUSTER_RESYNC_LOCKED: cluster raid only, which means node, already took
> + *			       resync lock, need to release the lock.
> + * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
> + *			    calls to md_error() will never cause the array to
> + *			    become failed.
> + * @MD_HAS_PPL:  The raid array has PPL feature set.
> + * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
> + * @MD_ALLOW_SB_UPDATE: md_check_recovery is allowed to update the metadata
> + *			 without taking reconfig_mutex.
> + * @MD_UPDATING_SB: md_check_recovery is updating the metadata without
> + *		     explicitly holding reconfig_mutex.
> + * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
> + *		   array is ready yet.
> + * @MD_BROKEN: This is used to stop writes and mark array as failed.
> + *
> + * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
> + */
>   enum mddev_flags {
> -	MD_ARRAY_FIRST_USE,	/* First use of array, needs initialization */
> -	MD_CLOSING,		/* If set, we are closing the array, do not open
> -				 * it then */
> -	MD_JOURNAL_CLEAN,	/* A raid with journal is already clean */
> -	MD_HAS_JOURNAL,		/* The raid array has journal feature set */
> -	MD_CLUSTER_RESYNC_LOCKED, /* cluster raid only, which means node
> -				   * already took resync lock, need to
> -				   * release the lock */
> -	MD_FAILFAST_SUPPORTED,	/* Using MD_FAILFAST on metadata writes is
> -				 * supported as calls to md_error() will
> -				 * never cause the array to become failed.
> -				 */
> -	MD_HAS_PPL,		/* The raid array has PPL feature set */
> -	MD_HAS_MULTIPLE_PPLS,	/* The raid array has multiple PPLs feature set */
> -	MD_ALLOW_SB_UPDATE,	/* md_check_recovery is allowed to update
> -				 * the metadata without taking reconfig_mutex.
> -				 */
> -	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
> -				 * without explicitly holding reconfig_mutex.
> -				 */
> -	MD_NOT_READY,		/* do_md_run() is active, so 'array_state'
> -				 * must not report that array is ready yet
> -				 */
> -	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
> -				 * I/O in case an array member is gone/failed.
> -				 */

People have to scroll up to see the meaning of each flag with the 
change, I would
suggest move these comments on top of each flag if you really hate 
previous style,
but just my personal flavor.

> +	MD_ARRAY_FIRST_USE,
> +	MD_CLOSING,
> +	MD_JOURNAL_CLEAN,
> +	MD_HAS_JOURNAL,
> +	MD_CLUSTER_RESYNC_LOCKED,
> +	MD_FAILFAST_SUPPORTED,
> +	MD_HAS_PPL,
> +	MD_HAS_MULTIPLE_PPLS,
> +	MD_ALLOW_SB_UPDATE,
> +	MD_UPDATING_SB,
> +	MD_NOT_READY,
> +	MD_BROKEN,
>   };
>   
>   enum mddev_sb_flags {
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7dc8026cf6ee..b222bafa1196 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1615,30 +1615,37 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>   	seq_printf(seq, "]");
>   }
>   
> +/**
> + * raid1_error() - RAID1 error handler.
> + * @mddev: affected md device.
> + **@rdev: member device to remove.*

It is confusing, rdev is removed in raid1_remove_disk only.

> + *
> + * Error on @rdev is raised and it is needed to be removed from @mddev.
> + * If there are more than one active member, @rdev is always removed.
> + *
> + * If it is the last active member, it depends on &mddev->fail_last_dev:
> + * - if is on @rdev is removed.
> + * - if is off, @rdev is not removed, but recovery from it is disabled (@rdev is
> + *   very likely to fail).
> + * In both cases, &MD_BROKEN will be set in &mddev->flags.
> + */
>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
>   	char b[BDEVNAME_SIZE];
>   	struct r1conf *conf = mddev->private;
>   	unsigned long flags;
>   
> -	/*
> -	 * If it is not operational, then we have already marked it as dead
> -	 * else if it is the last working disks with "fail_last_dev == false",
> -	 * ignore the error, let the next level up know.
> -	 * else mark the drive as failed
> -	 */
>   	spin_lock_irqsave(&conf->device_lock, flags);
> -	if (test_bit(In_sync, &rdev->flags) && !mddev->fail_last_dev
> -	    && (conf->raid_disks - mddev->degraded) == 1) {
> -		/*
> -		 * Don't fail the drive, act as though we were just a
> -		 * normal single drive.
> -		 * However don't try a recovery from this drive as
> -		 * it is very likely to fail.
> -		 */
> -		conf->recovery_disabled = mddev->recovery_disabled;
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		return;
> +
> +	if (test_bit(In_sync, &rdev->flags) &&
> +	    (conf->raid_disks - mddev->degraded) == 1) {
> +		set_bit(MD_BROKEN, &mddev->flags);
> +
> +		if (!mddev->fail_last_dev) {
> +			conf->recovery_disabled = mddev->recovery_disabled;
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +			return;
> +		}
>   	}
>   	set_bit(Blocked, &rdev->flags);
>   	if (test_and_clear_bit(In_sync, &rdev->flags))
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dde98f65bd04..7471e20d7cd6 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1945,26 +1945,37 @@ static int enough(struct r10conf *conf, int ignore)
>   		_enough(conf, 1, ignore);
>   }
>   
> +/**
> + * raid10_error() - RAID10 error handler.
> + * @mddev: affected md device.
> + * @rdev: member device to remove.

Ditto.

Thanks,
Guoqing
