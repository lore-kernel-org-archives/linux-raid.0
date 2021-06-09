Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8172AC47095
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 06:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B0461183
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 06:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhFIGeS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Jun 2021 02:34:18 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:38815 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231508AbhFIGeS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 9 Jun 2021 02:34:18 -0400
Received: from [192.168.0.3] (ip5f5aef16.dynamic.kabel-deutschland.de [95.90.239.22])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 326B061E646EF;
        Wed,  9 Jun 2021 08:32:23 +0200 (CEST)
Subject: Re: [RESEND] md: adding a new flag MD_DELETING
To:     Lidong Zhong <lidong.zhong@suse.com>
Cc:     linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
References: <20210605152917.21806-1-lidong.zhong@suse.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <d11cfc0a-d908-3134-d21d-38fe29c85ac5@molgen.mpg.de>
Date:   Wed, 9 Jun 2021 08:32:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210605152917.21806-1-lidong.zhong@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Lidong,


Am 05.06.21 um 17:29 schrieb Lidong Zhong:

I’d use imperative mood in the commit message summary [1]: md:

> Add new flag MD_DELETING


> The mddev data structure is freed in mddev_delayed_delete(), which is
> schedualed after the array is deconfigured completely when stopping. So

scheduled

> there is a race window between md_open() and do_md_stop(), which leads
> to /dev/mdX can still be opened by userspace even it's not accessible
> any more. As a result, a DeviceDisappeared event will not be able to be
> monitored by mdadm in monitor mode. This patch tries to fix it by adding
> this new flag MD_DELETING.
> 
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> ---
>   drivers/md/md.c | 4 +++-
>   drivers/md/md.h | 2 ++
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 49f897fbb89b..e8fa100a0777 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6456,6 +6456,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
>   		md_clean(mddev);
>   		if (mddev->hold_active == UNTIL_STOP)
>   			mddev->hold_active = 0;
> +		set_bit(MD_DELETING, &mddev->flags);
>   	}
>   	md_new_event(mddev);
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> @@ -7843,7 +7844,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>   	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
>   		goto out;
>   
> -	if (test_bit(MD_CLOSING, &mddev->flags)) {
> +	if (test_bit(MD_CLOSING, &mddev->flags) ||
> +	    (test_bit(MD_DELETING, &mddev->flags) && mddev->pers == NULL)) {
>   		mutex_unlock(&mddev->open_mutex);
>   		err = -ENODEV;
>   		goto out;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index fb7eab58cfd5..b70f8885da7a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -262,6 +262,8 @@ enum mddev_flags {
>   	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
>   				 * I/O in case an array member is gone/failed.
>   				 */
> +	MD_DELETING,		/* If set, we are deleting the array, do not open
> +				 * it then */
>   };
>   
>   enum mddev_sb_flags {


Kind regards,

Paul


[1]: https://chris.beams.io/posts/git-commit/
