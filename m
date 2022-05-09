Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E13C47086
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 08:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiEIIsV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 04:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbiEIIXK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 04:23:10 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF3C1A44BE
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 01:19:08 -0700 (PDT)
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5053361E6478B;
        Mon,  9 May 2022 10:18:48 +0200 (CEST)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <b664e33f-1c7e-f618-c42e-7ca6c2416ba6@molgen.mpg.de>
Date:   Mon, 9 May 2022 10:18:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20220506113656.25010-1-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/6/22 1:36 PM, Guoqing Jiang wrote:
> From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> 
> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> doesn't reconfigure array.
> 
> And it could cause deadlock problem for raid5 as follows:
> 
> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>     idle to sync_action.
> 2. raid5 sync thread was blocked if there were too many active stripes.
> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>     which causes the number of active stripes can't be decreased.
> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>     to hold reconfig_mutex.
> 
> More details in the link:
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> 
> Let's call unregister thread between mddev_unlock and mddev_lock_nointr
> (thanks for the report from kernel test robot <lkp@intel.com>) if the
> reconfig_mutex is held, and mddev_is_locked is introduced accordingly.
> 
> Reported-by: Donald Buczek <buczek@molgen.mpg.de>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>   drivers/md/md.c | 9 ++++++++-
>   drivers/md/md.h | 5 +++++
>   2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 309b3af906ad..525f65682356 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9432,10 +9432,17 @@ void md_reap_sync_thread(struct mddev *mddev)
>   {
>   	struct md_rdev *rdev;
>   	sector_t old_dev_sectors = mddev->dev_sectors;
> -	bool is_reshaped = false;
> +	bool is_reshaped = false, is_locked = false;
>   
> +	if (mddev_is_locked(mddev)) {
> +		is_locked = true;
> +		mddev_unlock(mddev);


Hmmm. Can it be excluded, that another task is holding the mutex?

Best
Donald


> +	}
>   	/* resync has finished, collect result */
>   	md_unregister_thread(&mddev->sync_thread);
> +	if (is_locked)
> +		mddev_lock_nointr(mddev);
> +
>   	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>   	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>   	    mddev->degraded != mddev->raid_disks) {
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6ac283864533..af6f3978b62b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -549,6 +549,11 @@ static inline int mddev_trylock(struct mddev *mddev)
>   }
>   extern void mddev_unlock(struct mddev *mddev);
>   
> +static inline int mddev_is_locked(struct mddev *mddev)
> +{
> +	return mutex_is_locked(&mddev->reconfig_mutex);
> +}
> +
>   static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
>   {
>   	atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
