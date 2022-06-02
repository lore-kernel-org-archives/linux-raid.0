Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F08BC43334
	for <linux-raid@archiver.kernel.org>; Thu,  2 Jun 2022 18:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbiFBSEB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiFBSEB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Jun 2022 14:04:01 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63E0274B58
        for <linux-raid@vger.kernel.org>; Thu,  2 Jun 2022 11:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=Ek7Bg/YG3Kgx4qcE8fWjDKac4QfqMOLrPnZJJqYj8kk=; b=NnVGxfUJ+WAb90gaVtT8GKkNzI
        /EZ6elzHev5qEFqo7C3vnj001O7IGQ7RG4vxD7JSjKdOQ2bZD63LriB+vAmdMmRPipqLyS5yCGqcW
        rv7Y/QNFY/BIAqrxv+I4Gon1XIxMmRQxkhms7GZWj1+s4DGYQcgNc4+1sw4zhC95biLmMOsepT6IZ
        53pEPzgtMR6aEG3MSCAWRBxTl97kNnNIWPOnvfmjvD5nYm+tWSdt7lXMUbCYt0Oz6vrWzEScwQ2qm
        YLK3OnzFbZ0+cX7guPt7Nz+XRrpuLoK4PfEd9Z3cuzhMpYjhtnz+4F3TMs8rWmJptvqNYlgwIphNb
        0o+Xt5wA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nwpAq-00EPXy-Bi; Thu, 02 Jun 2022 12:03:57 -0600
Message-ID: <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com>
Date:   Thu, 2 Jun 2022 12:03:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-CA
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, buczek@molgen.mpg.de
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220602134509.16662-1-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: guoqing.jiang@linux.dev, song@kernel.org, linux-raid@vger.kernel.org, buczek@molgen.mpg.de
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] md: only unlock mddev from action_store
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-06-02 07:45, Guoqing Jiang wrote:
> The 07reshape5intr test is broke because of below path.
> 
>     md_reap_sync_thread
>             -> mddev_unlock
>             -> md_unregister_thread(&mddev->sync_thread)
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
>    so the parameter is renamed to reflect the change.
> 2. save some contexts (MD_RECOVERY_INTR and reshape_position) since they
>    could be changed by other processes, then restore them after get lock
>    again.
> 
> Fixes: 8b48ec23cc51a ("md: don't unregister sync_thread with reconfig_mutex held")
> Reported-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
> I suppose the previous bug still can be fixed with the change, but it is
> better to verify it. Donald, could you help to test the new code?
> 
> Thanks,
> Guoqing
> 
>  drivers/md/md.c | 24 ++++++++++++++++++------
>  drivers/md/md.h |  2 +-
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5c8efef13881..3387260dd55b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6197,7 +6197,7 @@ static void __md_stop_writes(struct mddev *mddev)
>  		flush_workqueue(md_misc_wq);
>  	if (mddev->sync_thread) {
>  		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -		md_reap_sync_thread(mddev, true);
> +		md_reap_sync_thread(mddev, false);
>  	}
>  
>  	del_timer_sync(&mddev->safemode_timer);
> @@ -9303,7 +9303,7 @@ void md_check_recovery(struct mddev *mddev)
>  			 * ->spare_active and clear saved_raid_disk
>  			 */
>  			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -			md_reap_sync_thread(mddev, true);
> +			md_reap_sync_thread(mddev, false);
>  			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>  			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
> @@ -9338,7 +9338,7 @@ void md_check_recovery(struct mddev *mddev)
>  			goto unlock;
>  		}
>  		if (mddev->sync_thread) {
> -			md_reap_sync_thread(mddev, true);
> +			md_reap_sync_thread(mddev, false);
>  			goto unlock;
>  		}
>  		/* Set RUNNING before clearing NEEDED to avoid
> @@ -9411,18 +9411,30 @@ void md_check_recovery(struct mddev *mddev)
>  }
>  EXPORT_SYMBOL(md_check_recovery);
>  
> -void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
> +void md_reap_sync_thread(struct mddev *mddev, bool unlock_mddev)
>  {
>  	struct md_rdev *rdev;
>  	sector_t old_dev_sectors = mddev->dev_sectors;
> +	sector_t old_reshape_position;
>  	bool is_reshaped = false;
> +	bool is_interrupted = false;
>  
> -	if (reconfig_mutex_held)
> +	if (unlock_mddev) {
> +		old_reshape_position = mddev->reshape_position;
> +		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> +			is_interrupted = true;
>  		mddev_unlock(mddev);
> +	}
>  	/* resync has finished, collect result */
>  	md_unregister_thread(&mddev->sync_thread);
> -	if (reconfig_mutex_held)
> +	if (unlock_mddev) {
>  		mddev_lock_nointr(mddev);
> +		/* restore the previous flag and position */
> +		mddev->reshape_position = old_reshape_position;
> +		if (is_interrupted)
> +			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +	}

Maybe instead of the ugly boolean argument we could pull
md_unregister_thread() into all the callers and explicitly unlock in the
single call site that needs it?

Logan
