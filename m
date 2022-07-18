Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EA5CCA479
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 07:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiGRHLC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 03:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiGRHLB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 03:11:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183CD17A8C;
        Mon, 18 Jul 2022 00:11:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AEC3C1F9BF;
        Mon, 18 Jul 2022 07:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658128259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJf0jR1DTn3/pMr15cURhOrPkmcvrhDTcXYu+V5pvL8=;
        b=sEwmo9E9XphkUhY/36q+nK9/df3qRMRo0mk8CYtesll0De3A1MMcjO/qjUv0KGiGSMo3pR
        I43KWWXteaO8HyEX2xJ8xnDxgKbsia6zsQtrNHwFtt8HWuQ1lB69ehlR7ZeGmKWHiuoBFh
        a9sptiGzGD6Cbz5hcDYmm9p4BsA/W6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658128259;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJf0jR1DTn3/pMr15cURhOrPkmcvrhDTcXYu+V5pvL8=;
        b=RUhJKlAfKygmTlSXpzAgfY4zd+dDb36Qv7CwAXts0+MxvMI4Oz6tb3YxcRNFEqj++MnThK
        fA0YIM6gEi4vs1Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F2C913754;
        Mon, 18 Jul 2022 07:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qznhIYMH1WJgawAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 07:10:59 +0000
Message-ID: <61d08fa6-91e4-f809-1074-d1ba2b1a3758@suse.de>
Date:   Mon, 18 Jul 2022 09:10:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 08/10] md: stop using for_each_mddev in md_exit
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-9-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> Just do a simple list_for_each_entry_safe on all_mddevs, and only grab a
> reference when we drop the lock and delete the now unused for_each_mddev
> macro.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 39 +++++++++++----------------------------
>   1 file changed, 11 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 44e4071b43148..805f2b4ed9c0d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -368,28 +368,6 @@ EXPORT_SYMBOL_GPL(md_new_event);
>   static LIST_HEAD(all_mddevs);
>   static DEFINE_SPINLOCK(all_mddevs_lock);
>   
> -/*
> - * iterates through all used mddevs in the system.
> - * We take care to grab the all_mddevs_lock whenever navigating
> - * the list, and to always hold a refcount when unlocked.
> - * Any code which breaks out of this loop while own
> - * a reference to the current mddev and must mddev_put it.
> - */
> -#define for_each_mddev(_mddev,_tmp)					\
> -									\
> -	for (({ spin_lock(&all_mddevs_lock);				\
> -		_tmp = all_mddevs.next;					\
> -		_mddev = NULL;});					\
> -	     ({ if (_tmp != &all_mddevs)				\
> -			mddev_get(list_entry(_tmp, struct mddev, all_mddevs));\
> -		spin_unlock(&all_mddevs_lock);				\
> -		if (_mddev) mddev_put(_mddev);				\
> -		_mddev = list_entry(_tmp, struct mddev, all_mddevs);	\
> -		_tmp != &all_mddevs;});					\
> -	     ({ spin_lock(&all_mddevs_lock);				\
> -		_tmp = _tmp->next;})					\
> -		)
> -
>   /* Rather than calling directly into the personality make_request function,
>    * IO requests come here first so that we can check if the device is
>    * being suspended pending a reconfiguration.
> @@ -9925,8 +9903,7 @@ void md_autostart_arrays(int part)
>   
>   static __exit void md_exit(void)
>   {
> -	struct mddev *mddev;
> -	struct list_head *tmp;
> +	struct mddev *mddev, *n;
>   	int delay = 1;
>   
>   	unregister_blkdev(MD_MAJOR,"md");
> @@ -9946,17 +9923,23 @@ static __exit void md_exit(void)
>   	}
>   	remove_proc_entry("mdstat", NULL);
>   
> -	for_each_mddev(mddev, tmp) {
> +	spin_lock(&all_mddevs_lock);
> +	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
> +		mddev_get(mddev);
> +		spin_unlock(&all_mddevs_lock);
>   		export_array(mddev);
>   		mddev->ctime = 0;
>   		mddev->hold_active = 0;
>   		/*
> -		 * for_each_mddev() will call mddev_put() at the end of each
> -		 * iteration.  As the mddev is now fully clear, this will
> -		 * schedule the mddev for destruction by a workqueue, and the
> +		 * As the mddev is now fully clear, mddev_put will schedule
> +		 * the mddev for destruction by a workqueue, and the
>   		 * destroy_workqueue() below will wait for that to complete.
>   		 */
> +		mddev_put(mddev);
> +		spin_lock(&all_mddevs_lock);
>   	}
> +	spin_unlock(&all_mddevs_lock);
> +
>   	destroy_workqueue(md_rdev_misc_wq);
>   	destroy_workqueue(md_misc_wq);
>   	destroy_workqueue(md_wq);

Having thought about it some more ... wouldn't it make sense to modify 
mddev_get() to

if (atomic_inc_not_zero(&mddev->active))
     return NULL;

to ensure we're not missing any use-after-free issues, which previously 
would have been caught by the 'for_each_mddev()' macro?

Cheers,

Hannes
