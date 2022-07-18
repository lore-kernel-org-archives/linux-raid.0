Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3385C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 07:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiGRHFc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 03:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiGRHFa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 03:05:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F01175BA;
        Mon, 18 Jul 2022 00:05:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3C082372D6;
        Mon, 18 Jul 2022 07:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658127925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtYcwVpQIAaFq8idio3Wd2WbAr/wWfbDEtFwt/c/L6g=;
        b=f7ax/mEGKR3lM6LKVydRdXyD5Z/IbEzJ/wWgM5NX85ua69u4ISJhjjRTJL8/KazEBo6L9X
        9Axws3BxKhsgk6cltoq95bn3lOeoy25m2LnPo/jcfxDB6QD25pi5QZg707N6hxKzE4zLmS
        +mQZkcXD3V5b0KHZAViRqxq3mnqQyCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658127925;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtYcwVpQIAaFq8idio3Wd2WbAr/wWfbDEtFwt/c/L6g=;
        b=B1PX0kpV9Fr3+DU+6J6WGueTD9sGTSoTQowXrkq7osVG/hW3HNwkiBF96zN/+o22u8d1mD
        +btukApacNa4teCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1035213754;
        Mon, 18 Jul 2022 07:05:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fOv/AjUG1WKvaAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 07:05:25 +0000
Message-ID: <77cfe0c0-63a1-4e1c-9d3f-c15f73c9a506@suse.de>
Date:   Mon, 18 Jul 2022 09:05:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 07/10] md: stop using for_each_mddev in md_notify_reboot
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-8-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> Just do a simple list_for_each_entry_safe on all_mddevs, and only grab a
> reference when we drop the lock.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 687f320c7ec4a..44e4071b43148 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9587,11 +9587,13 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>   static int md_notify_reboot(struct notifier_block *this,
>   			    unsigned long code, void *x)
>   {
> -	struct list_head *tmp;
> -	struct mddev *mddev;
> +	struct mddev *mddev, *n;
>   	int need_delay = 0;
>   
> -	for_each_mddev(mddev, tmp) {
> +	spin_lock(&all_mddevs_lock);
> +	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
> +		mddev_get(mddev);
> +		spin_unlock(&all_mddevs_lock);
>   		if (mddev_trylock(mddev)) {
>   			if (mddev->pers)
>   				__md_stop_writes(mddev);
> @@ -9600,7 +9602,11 @@ static int md_notify_reboot(struct notifier_block *this,
>   			mddev_unlock(mddev);
>   		}
>   		need_delay = 1;
> +		mddev_put(mddev);
> +		spin_lock(&all_mddevs_lock);
>   	}
> +	spin_unlock(&all_mddevs_lock);
> +
>   	/*
>   	 * certain more exotic SCSI devices are known to be
>   	 * volatile wrt too early system reboots. While the

I wish 'mddev_get()' could fail if 'mddev->active' is zero when we call 
it ... but maybe for another time.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

