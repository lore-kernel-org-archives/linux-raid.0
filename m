Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042B3C38142
	for <linux-raid@archiver.kernel.org>; Mon, 23 Jan 2023 13:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjAWNS1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Jan 2023 08:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjAWNS0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 Jan 2023 08:18:26 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1427211EBB
        for <linux-raid@vger.kernel.org>; Mon, 23 Jan 2023 05:18:23 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1E25660027FD2;
        Mon, 23 Jan 2023 14:18:20 +0100 (CET)
Message-ID: <2480c4f0-dd0a-764e-6f04-d70dfb018501@molgen.mpg.de>
Date:   Mon, 23 Jan 2023 14:18:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] md: Factor out is_md_suspended helper
To:     Xiao Ni <xni@redhat.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
References: <20230121013937.97576-1-xni@redhat.com>
 <20230121013937.97576-2-xni@redhat.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230121013937.97576-2-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Xiao,


Thank you for the patch.

Am 21.01.23 um 02:39 schrieb Xiao Ni:
> This helper function will be used in next patch. It's easy for
> understanding.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 775f1dde190a..d3627aad981a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -380,6 +380,13 @@ EXPORT_SYMBOL_GPL(md_new_event);
>   static LIST_HEAD(all_mddevs);
>   static DEFINE_SPINLOCK(all_mddevs_lock);
>   
> +static bool is_md_suspended(struct mddev *mddev)
> +{
> +	if (mddev->suspended)
> +		return true;
> +	else
> +		return false;

suspended seems to be an integer, so this could be written as:

     return !!mddev->suspended;

or

     return (mddev->suspended) ? true : false;


Kind regards,

Paul


> +}
>   /* Rather than calling directly into the personality make_request function,
>    * IO requests come here first so that we can check if the device is
>    * being suspended pending a reconfiguration.
> @@ -389,7 +396,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
>    */
>   static bool is_suspended(struct mddev *mddev, struct bio *bio)
>   {
> -	if (mddev->suspended)
> +	if (is_md_suspended(mddev))
>   		return true;
>   	if (bio_data_dir(bio) != WRITE)
>   		return false;
> @@ -434,7 +441,7 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>   		goto check_suspended;
>   	}
>   
> -	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
> +	if (atomic_dec_and_test(&mddev->active_io) && is_md_suspended(mddev))
>   		wake_up(&mddev->sb_wait);
>   }
>   EXPORT_SYMBOL(md_handle_request);
> @@ -6217,7 +6224,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
>   static void mddev_detach(struct mddev *mddev)
>   {
>   	md_bitmap_wait_behind_writes(mddev);
> -	if (mddev->pers && mddev->pers->quiesce && !mddev->suspended) {
> +	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
>   		mddev->pers->quiesce(mddev, 1);
>   		mddev->pers->quiesce(mddev, 0);
>   	}
> @@ -8529,7 +8536,7 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
>   		return true;
>   	wait_event(mddev->sb_wait,
>   		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
> -		   mddev->suspended);
> +		   is_md_suspended(mddev));
>   	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
>   		percpu_ref_put(&mddev->writes_pending);
>   		return false;
> @@ -9257,7 +9264,7 @@ void md_check_recovery(struct mddev *mddev)
>   		wake_up(&mddev->sb_wait);
>   	}
>   
> -	if (mddev->suspended)
> +	if (is_md_suspended(mddev))
>   		return;
>   
>   	if (mddev->bitmap)
