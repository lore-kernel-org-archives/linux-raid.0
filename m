Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD622C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 07:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiGRHRq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 03:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiGRHRp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 03:17:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4735211804;
        Mon, 18 Jul 2022 00:17:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D89E320B9F;
        Mon, 18 Jul 2022 07:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658128662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8YjGkP2dF7w9Z+RkdTMHfIkrh2x1k7ZwHIsR9wB5fCc=;
        b=CrU7uGbcrhH7nIg7MvMN5og8AogC/ZULA60qxBb2weaWstsqtE4Aw2aoEmTDwKKVCHCwZ7
        /vKc3iNLvY7bu7Q2kVeHyKoDJYFtAF1oaV/AwshdIC66BUFPPmRdaUc/OFQN0A67b6c0Se
        lDELws0ivSVLwHwC2znYFVE5zEhBEzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658128662;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8YjGkP2dF7w9Z+RkdTMHfIkrh2x1k7ZwHIsR9wB5fCc=;
        b=jf9QCPrrvFTJJNVWbuc2ycVUq8WY2w3DKMXDOEDbk34HeCw9Xp/36Wixi0GoWTX3RsQUw0
        DtpeQdXqCJeTIEAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C446913A37;
        Mon, 18 Jul 2022 07:17:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id w2toLxYJ1WIubgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 07:17:42 +0000
Message-ID: <b8521a53-fb41-279c-dc43-580e8d0de045@suse.de>
Date:   Mon, 18 Jul 2022 09:17:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 09/10] md: only delete entries from all_mddevs when the
 disk is freed
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-10-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> This ensures device names don't get prematurely reused.  Instead add a
> deleted flag to skip already deleted devices in mddev_get and other
> places that only want to see live mddevs.
> 
> Reported-by; Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 56 +++++++++++++++++++++++++++++++++----------------
>   drivers/md/md.h |  1 +
>   2 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 805f2b4ed9c0d..08cf21ad4c2d7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -625,6 +625,10 @@ EXPORT_SYMBOL(md_flush_request);
>   
>   static inline struct mddev *mddev_get(struct mddev *mddev)
>   {
> +	lockdep_assert_held(&all_mddevs_lock);
> +
> +	if (mddev->deleted)
> +		return NULL;
>   	atomic_inc(&mddev->active);
>   	return mddev;
>   }

Why can't we use 'atomic_inc_unless_zero' here and do away with the 
additional 'deleted' flag?

> @@ -639,7 +643,7 @@ static void mddev_put(struct mddev *mddev)
>   	    mddev->ctime == 0 && !mddev->hold_active) {
>   		/* Array is not configured at all, and not held active,
>   		 * so destroy it */
> -		list_del_init(&mddev->all_mddevs);
> +		mddev->deleted = true;
>   
>   		/*
>   		 * Call queue_work inside the spinlock so that
> @@ -719,8 +723,8 @@ static struct mddev *mddev_find(dev_t unit)
>   
>   	spin_lock(&all_mddevs_lock);
>   	mddev = mddev_find_locked(unit);
> -	if (mddev)
> -		mddev_get(mddev);
> +	if (mddev && !mddev_get(mddev))
> +		mddev = NULL;
>   	spin_unlock(&all_mddevs_lock);
>   
>   	return mddev;
> @@ -3338,6 +3342,8 @@ static bool md_rdev_overlaps(struct md_rdev *rdev)
>   
>   	spin_lock(&all_mddevs_lock);
>   	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> +		if (mddev->deleted)
> +			continue;

Any particular reason why you can't use the 'mddev_get()' / 
'mddev_put()' sequence here?
After all, I don't think that 'mddev' should vanish while being in this 
loop, no?

>   		rdev_for_each(rdev2, mddev) {
>   			if (rdev != rdev2 && rdev->bdev == rdev2->bdev &&
>   			    md_rdevs_overlap(rdev, rdev2)) {
> @@ -5525,11 +5531,10 @@ md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
>   	if (!entry->show)
>   		return -EIO;
>   	spin_lock(&all_mddevs_lock);
> -	if (list_empty(&mddev->all_mddevs)) {
> +	if (!mddev_get(mddev)) { >   		spin_unlock(&all_mddevs_lock);
>   		return -EBUSY;
>   	}
> -	mddev_get(mddev);
>   	spin_unlock(&all_mddevs_lock);
>   
>   	rv = entry->show(mddev, page);
> @@ -5550,11 +5555,10 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EACCES;
>   	spin_lock(&all_mddevs_lock);
> -	if (list_empty(&mddev->all_mddevs)) {
> +	if (!mddev_get(mddev)) {
>   		spin_unlock(&all_mddevs_lock);
>   		return -EBUSY;
>   	}
> -	mddev_get(mddev);
>   	spin_unlock(&all_mddevs_lock);
>   	rv = entry->store(mddev, page, length);
>   	mddev_put(mddev);
> @@ -7851,7 +7855,7 @@ static void md_free_disk(struct gendisk *disk)
>   	bioset_exit(&mddev->bio_set);
>   	bioset_exit(&mddev->sync_set);
>   
> -	kfree(mddev);
> +	mddev_free(mddev);
>   }
>   
>   const struct block_device_operations md_fops =
> @@ -8173,6 +8177,8 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
>   		if (!l--) {
>   			mddev = list_entry(tmp, struct mddev, all_mddevs);
>   			mddev_get(mddev);
> +			if (!mddev_get(mddev))
> +				continue;
>   			spin_unlock(&all_mddevs_lock);
>   			return mddev;
>   		}
> @@ -8186,25 +8192,35 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>   {
>   	struct list_head *tmp;
>   	struct mddev *next_mddev, *mddev = v;
> +	struct mddev *to_put = NULL;
>   
>   	++*pos;
>   	if (v == (void*)2)
>   		return NULL;
>   
>   	spin_lock(&all_mddevs_lock);
> -	if (v == (void*)1)
> +	if (v == (void*)1) {
>   		tmp = all_mddevs.next;
> -	else
> +	} else {
> +		to_put = mddev;
>   		tmp = mddev->all_mddevs.next;
> -	if (tmp != &all_mddevs)
> -		next_mddev = mddev_get(list_entry(tmp,struct mddev,all_mddevs));
> -	else {
> -		next_mddev = (void*)2;
> -		*pos = 0x10000;
>   	}
> +
> +	for (;;) {
> +		if (tmp == &all_mddevs) {
> +			next_mddev = (void*)2;
> +			*pos = 0x10000;
> +			break;
> +		}
> +		next_mddev = list_entry(tmp, struct mddev, all_mddevs);
> +		if (mddev_get(next_mddev))
> +			break;
> +		mddev = next_mddev;
> +		tmp = mddev->all_mddevs.next;
> +	};
>   	spin_unlock(&all_mddevs_lock);
>   
> -	if (v != (void*)1)
> +	if (to_put)
>   		mddev_put(mddev);
>   	return next_mddev;
>   
> @@ -8768,6 +8784,8 @@ void md_do_sync(struct md_thread *thread)
>   			goto skip;
>   		spin_lock(&all_mddevs_lock);
>   		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
> +			if (mddev2->deleted)
> +				continue;
>   			if (mddev2 == mddev)
>   				continue;
>   			if (!mddev->parallel_resync
> @@ -9570,7 +9588,8 @@ static int md_notify_reboot(struct notifier_block *this,
>   
>   	spin_lock(&all_mddevs_lock);
>   	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
> -		mddev_get(mddev);
> +		if (!mddev_get(mddev))
> +			continue;
>   		spin_unlock(&all_mddevs_lock);
>   		if (mddev_trylock(mddev)) {
>   			if (mddev->pers)
> @@ -9925,7 +9944,8 @@ static __exit void md_exit(void)
>   
>   	spin_lock(&all_mddevs_lock);
>   	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
> -		mddev_get(mddev);
> +		if (!mddev_get(mddev))
> +			continue;
>   		spin_unlock(&all_mddevs_lock);
>   		export_array(mddev);
>   		mddev->ctime = 0;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1a85dbe78a71c..bc870e1f1e8c2 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -503,6 +503,7 @@ struct mddev {
>   
>   	atomic_t			max_corr_read_errors; /* max read retries */
>   	struct list_head		all_mddevs;
> +	bool				deleted;
>   
>   	const struct attribute_group	*to_remove;
>   

Cheers,

Hannes
