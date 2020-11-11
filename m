Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E67C4742C
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 06:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1DBC207BB
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 06:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgKKGwF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 01:52:05 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44071 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbgKKGwF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Nov 2020 01:52:05 -0500
Received: from [192.168.0.2] (ip5f5af465.dynamic.kabel-deutschland.de [95.90.244.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BF24B20646221;
        Wed, 11 Nov 2020 07:52:01 +0100 (CET)
Subject: Re: [PATCH 1/3] md: improve variable names in md_flush_request()
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
References: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
 <20201111051658.18904-2-pankaj.gupta.linux@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <ee573db1-33d0-b210-7205-4736de007488@molgen.mpg.de>
Date:   Wed, 11 Nov 2020 07:52:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201111051658.18904-2-pankaj.gupta.linux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Pankaj,


Thank you for the cleanups.

Am 11.11.20 um 06:16 schrieb Pankaj Gupta:
> From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> 
>   This patch improves readability by using better variable names
>   in flush request coalescing logic.

Please do not indent the commit message.

> Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> ---
>   drivers/md/md.c | 8 ++++----
>   drivers/md/md.h | 6 +++---
>   2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 98bac4f304ae..167c80f98533 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -639,7 +639,7 @@ static void md_submit_flush_data(struct work_struct *ws)
>   	 * could wait for this and below md_handle_request could wait for those
>   	 * bios because of suspend check
>   	 */
> -	mddev->last_flush = mddev->start_flush;
> +	mddev->prev_flush_start = mddev->start_flush;
>   	mddev->flush_bio = NULL;
>   	wake_up(&mddev->sb_wait);
>   
> @@ -660,13 +660,13 @@ static void md_submit_flush_data(struct work_struct *ws)
>    */
>   bool md_flush_request(struct mddev *mddev, struct bio *bio)
>   {
> -	ktime_t start = ktime_get_boottime();
> +	ktime_t req_start = ktime_get_boottime();
>   	spin_lock_irq(&mddev->lock);
>   	wait_event_lock_irq(mddev->sb_wait,
>   			    !mddev->flush_bio ||
> -			    ktime_after(mddev->last_flush, start),
> +			    ktime_after(mddev->prev_flush_start, req_start),
>   			    mddev->lock);
> -	if (!ktime_after(mddev->last_flush, start)) {
> +	if (!ktime_after(mddev->prev_flush_start, req_start)) {
>   		WARN_ON(mddev->flush_bio);
>   		mddev->flush_bio = bio;
>   		bio = NULL;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ccfb69868c2e..2292c847f9dd 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -495,9 +495,9 @@ struct mddev {
>   	 */
>   	struct bio *flush_bio;
>   	atomic_t flush_pending;
> -	ktime_t start_flush, last_flush; /* last_flush is when the last completed
> -					  * flush was started.
> -					  */
> +	ktime_t start_flush, prev_flush_start; /* prev_flush_start is when the previous completed
> +						* flush was started.
> +						*/

With the new variable name, the comment could even be removed. ;-)

>   	struct work_struct flush_work;
>   	struct work_struct event_work;	/* used by dm to report failure event */
>   	mempool_t *serial_info_pool;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
