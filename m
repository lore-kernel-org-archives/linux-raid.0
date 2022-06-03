Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADECC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  3 Jun 2022 06:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbiFCGYr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Jun 2022 02:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiFCGYq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Jun 2022 02:24:46 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBEF1E3CA
        for <linux-raid@vger.kernel.org>; Thu,  2 Jun 2022 23:24:44 -0700 (PDT)
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3927E61EA1928;
        Fri,  3 Jun 2022 08:24:41 +0200 (CEST)
Subject: Re: [PATCH] md: only unlock mddev from action_store
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, logang@deltatee.com
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <74ac0169-177c-96dc-5cf5-78a6889d78bc@molgen.mpg.de>
Date:   Fri, 3 Jun 2022 08:24:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20220602134509.16662-1-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 6/2/22 3:45 PM, Guoqing Jiang wrote:
> The 07reshape5intr test is broke because of below path.
> 
>      md_reap_sync_thread
>              -> mddev_unlock
>              -> md_unregister_thread(&mddev->sync_thread)
> 
> And md_check_recovery is triggered by,
> 
> mddev_unlock -> md_wakeup_thread(mddev->thread)
> 
> then mddev->reshape_position is set to MaxSector in raid5_finish_reshape
> since MD_RECOVERY_INTR is cleared in md_check_recovery, which means
> feature_map is not set with MD_FEATURE_RESHAPE_ACTIVE and superblock's
> reshape_position can't be updated accordingly.
> 
> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
> with reconfig_mutex held") fixed is related with action_store path, other
> callers which reap sync_thread didn't need to be changed, let's
> 
> 1. only unlock mddev in md_reap_sync_thread if caller is action_store,
>     so the parameter is renamed to reflect the change.
> 2. save some contexts (MD_RECOVERY_INTR and reshape_position) since they
>     could be changed by other processes, then restore them after get lock
>     again.
> 
> Fixes: 8b48ec23cc51a ("md: don't unregister sync_thread with reconfig_mutex held")
> Reported-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
> I suppose the previous bug still can be fixed with the change, but it is
> better to verify it. Donald, could you help to test the new code?

Sure. But Probably not before next week and there is a holiday in Germany on Monday.

Best
   Donald

> 
> Thanks,
> Guoqing
> 
>   drivers/md/md.c | 24 ++++++++++++++++++------
>   drivers/md/md.h |  2 +-
>   2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5c8efef13881..3387260dd55b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6197,7 +6197,7 @@ static void __md_stop_writes(struct mddev *mddev)
>   		flush_workqueue(md_misc_wq);
>   	if (mddev->sync_thread) {
>   		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -		md_reap_sync_thread(mddev, true);
> +		md_reap_sync_thread(mddev, false);
>   	}
>   
>   	del_timer_sync(&mddev->safemode_timer);
> @@ -9303,7 +9303,7 @@ void md_check_recovery(struct mddev *mddev)
>   			 * ->spare_active and clear saved_raid_disk
>   			 */
>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -			md_reap_sync_thread(mddev, true);
> +			md_reap_sync_thread(mddev, false);
>   			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
> @@ -9338,7 +9338,7 @@ void md_check_recovery(struct mddev *mddev)
>   			goto unlock;
>   		}
>   		if (mddev->sync_thread) {
> -			md_reap_sync_thread(mddev, true);
> +			md_reap_sync_thread(mddev, false);
>   			goto unlock;
>   		}
>   		/* Set RUNNING before clearing NEEDED to avoid
> @@ -9411,18 +9411,30 @@ void md_check_recovery(struct mddev *mddev)
>   }
>   EXPORT_SYMBOL(md_check_recovery);
>   
> -void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
> +void md_reap_sync_thread(struct mddev *mddev, bool unlock_mddev)
>   {
>   	struct md_rdev *rdev;
>   	sector_t old_dev_sectors = mddev->dev_sectors;
> +	sector_t old_reshape_position;
>   	bool is_reshaped = false;
> +	bool is_interrupted = false;
>   
> -	if (reconfig_mutex_held)
> +	if (unlock_mddev) {
> +		old_reshape_position = mddev->reshape_position;
> +		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> +			is_interrupted = true;
>   		mddev_unlock(mddev);
> +	}
>   	/* resync has finished, collect result */
>   	md_unregister_thread(&mddev->sync_thread);
> -	if (reconfig_mutex_held)
> +	if (unlock_mddev) {
>   		mddev_lock_nointr(mddev);
> +		/* restore the previous flag and position */
> +		mddev->reshape_position = old_reshape_position;
> +		if (is_interrupted)
> +			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +	}
> +
>   	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>   	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>   	    mddev->degraded != mddev->raid_disks) {
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 82465a4b1588..3e3ff3b20e81 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -719,7 +719,7 @@ extern struct md_thread *md_register_thread(
>   extern void md_unregister_thread(struct md_thread **threadp);
>   extern void md_wakeup_thread(struct md_thread *thread);
>   extern void md_check_recovery(struct mddev *mddev);
> -extern void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held);
> +extern void md_reap_sync_thread(struct mddev *mddev, bool unlock_mddev);
>   extern int mddev_init_writes_pending(struct mddev *mddev);
>   extern bool md_write_start(struct mddev *mddev, struct bio *bi);
>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
