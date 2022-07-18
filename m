Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFC4CCA479
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 07:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiGRHTL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 03:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbiGRHTI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 03:19:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4FF63DB;
        Mon, 18 Jul 2022 00:19:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F412E3476D;
        Mon, 18 Jul 2022 07:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658128744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Qlhf9RDC9+P1dUjKbkTpu9mABQtBPjpqZyVqgLnyPE=;
        b=bVCwE72hyrM13oBWrYan81mxqVXGY7KwumU8R5Vj56EeudqyAyl/CT/R9r+KDKBGYTgY4r
        JHwutUisJ11LN+ox5FbAPWm5lXK7wP5/bwE8huPyXf2tC0ynZBM1kg2w4slQH4clG2llqS
        Z5TTMj0WimTkd3xEBD+h4X05AYGqyEU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658128744;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Qlhf9RDC9+P1dUjKbkTpu9mABQtBPjpqZyVqgLnyPE=;
        b=L86h1sjjfZ8DEnZHp6DaVc7DBXIO8ptp3G51nG5wZCt1SruSptIxAQ1DDAQAMPvXIKDt+G
        T5aDDmOxKvib+sCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E256013A37;
        Mon, 18 Jul 2022 07:19:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RDiTNmcJ1WK8bgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 07:19:03 +0000
Message-ID: <dc52a1b9-f007-e42b-0ef0-0de2387aa2f5@suse.de>
Date:   Mon, 18 Jul 2022 09:19:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 10/10] md: simplify md_open
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-11-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> Now that devices are on the all_mddevs list until the gendisk is freed,
> there can't be any duplicates.  Remove the global list lookup and just
> grab a reference.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 42 +++++++++++++++---------------------------
>   1 file changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 08cf21ad4c2d7..9b1e61b4bac8b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7785,45 +7785,33 @@ static int md_set_read_only(struct block_device *bdev, bool ro)
>   
>   static int md_open(struct block_device *bdev, fmode_t mode)
>   {
> -	/*
> -	 * Succeed if we can lock the mddev, which confirms that
> -	 * it isn't being stopped right now.
> -	 */
> -	struct mddev *mddev = mddev_find(bdev->bd_dev);
> +	struct mddev *mddev;
>   	int err;
>   
> +	spin_lock(&all_mddevs_lock);
> +	mddev = mddev_get(bdev->bd_disk->private_data);
> +	spin_unlock(&all_mddevs_lock);
>   	if (!mddev)
>   		return -ENODEV;
>   
> -	if (mddev->gendisk != bdev->bd_disk) {
> -		/* we are racing with mddev_put which is discarding this
> -		 * bd_disk.
> -		 */
> -		mddev_put(mddev);
> -		/* Wait until bdev->bd_disk is definitely gone */
> -		if (work_pending(&mddev->del_work))
> -			flush_workqueue(md_misc_wq);
> -		return -EBUSY;
> -	}
> -	BUG_ON(mddev != bdev->bd_disk->private_data);
> -
> -	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
> +	err = mutex_lock_interruptible(&mddev->open_mutex);
> +	if (err)
>   		goto out;
>   
> -	if (test_bit(MD_CLOSING, &mddev->flags)) {
> -		mutex_unlock(&mddev->open_mutex);
> -		err = -ENODEV;
> -		goto out;
> -	}
> +	err = -ENODEV;
> +	if (test_bit(MD_CLOSING, &mddev->flags))
> +		goto out_unlock;
>   
> -	err = 0;
>   	atomic_inc(&mddev->openers);
>   	mutex_unlock(&mddev->open_mutex);
>   
>   	bdev_check_media_change(bdev);
> - out:
> -	if (err)
> -		mddev_put(mddev);
> +	return 0;
> +
> +out_unlock:
> +	mutex_unlock(&mddev->open_mutex);
> +out:
> +	mddev_put(mddev);
>   	return err;
>   }
>   

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

