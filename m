Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A55C43334
	for <linux-raid@archiver.kernel.org>; Tue,  7 Jun 2022 09:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiFGJqU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiFGJqS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Jun 2022 05:46:18 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96383E64DC
        for <linux-raid@vger.kernel.org>; Tue,  7 Jun 2022 02:46:16 -0700 (PDT)
Subject: Re: [PATCH 2/2] md: unlock mddev before reap sync_thread in
 action_store
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654595174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7lz+rG+vdoAnxNmOym0XrimmiH+k4s1+ihyiTUx0bE=;
        b=QhmhITLs/VjnF1/K4D5NLeCxnowYLxkl2nX5FL2ZagIRjqAYwOMYveLtshSOpx5f37VsRw
        cTDIiI4iyHNhObgtSsxXNjPcvRFY9M0hnSPe9iN8H67UWkzFnUgbIp3j6kqlWjBJQyrQ9c
        s62DzHnhYP5FZOvsicDnnWabR8blJ7g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     buczek@molgen.mpg.de, logang@deltatee.com,
        linux-raid@vger.kernel.org
References: <20220607020357.14831-1-guoqing.jiang@linux.dev>
 <20220607020357.14831-3-guoqing.jiang@linux.dev>
Message-ID: <008f7fe2-b2f6-56bd-913d-966fe7386874@linux.dev>
Date:   Tue, 7 Jun 2022 17:46:09 +0800
MIME-Version: 1.0
In-Reply-To: <20220607020357.14831-3-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Pls hold on, I will verify it with latest kernel.

Thanks,
Guoqing

On 6/7/22 10:03 AM, Guoqing Jiang wrote:
> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
> with reconfig_mutex held") fixed is related with action_store path, other
> callers which reap sync_thread didn't need to be changed.
>
> Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
> bug with belows.
>
> 1. unlock mddev before md_reap_sync_thread in action_store.
> 2. save reshape_position before unlock, then restore it to ensure position
>     not changed accidentally by others.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>   drivers/md/dm-raid.c |  1 +
>   drivers/md/md.c      | 12 ++++++++++--
>   2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 9526ccbedafb..d43b8075c055 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3725,6 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>   	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>   		if (mddev->sync_thread) {
>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +			md_unregister_thread(&mddev->sync_thread);
>   			md_reap_sync_thread(mddev);
>   		}
>   	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2e83a19e3aba..4d70672f8ea8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4830,6 +4830,12 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>   			if (work_pending(&mddev->del_work))
>   				flush_workqueue(md_misc_wq);
>   			if (mddev->sync_thread) {
> +				sector_t save_rp = mddev->reshape_position;
> +
> +				mddev_unlock(mddev);
> +				md_unregister_thread(&mddev->sync_thread);
> +				mddev_lock_nointr(mddev);
> +				mddev->reshape_position = save_rp;
>   				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>   				md_reap_sync_thread(mddev);
>   			}
> @@ -6197,6 +6203,7 @@ static void __md_stop_writes(struct mddev *mddev)
>   		flush_workqueue(md_misc_wq);
>   	if (mddev->sync_thread) {
>   		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		md_unregister_thread(&mddev->sync_thread);
>   		md_reap_sync_thread(mddev);
>   	}
>   
> @@ -9303,6 +9310,7 @@ void md_check_recovery(struct mddev *mddev)
>   			 * ->spare_active and clear saved_raid_disk
>   			 */
>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +			md_unregister_thread(&mddev->sync_thread);
>   			md_reap_sync_thread(mddev);
>   			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> @@ -9338,6 +9346,7 @@ void md_check_recovery(struct mddev *mddev)
>   			goto unlock;
>   		}
>   		if (mddev->sync_thread) {
> +			md_unregister_thread(&mddev->sync_thread);
>   			md_reap_sync_thread(mddev);
>   			goto unlock;
>   		}
> @@ -9417,8 +9426,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	sector_t old_dev_sectors = mddev->dev_sectors;
>   	bool is_reshaped = false;
>   
> -	/* resync has finished, collect result */
> -	md_unregister_thread(&mddev->sync_thread);
> +	/* sync_thread should be unregistered, collect result */
>   	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>   	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>   	    mddev->degraded != mddev->raid_disks) {

