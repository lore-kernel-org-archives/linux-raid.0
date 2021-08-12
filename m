Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F96C43214
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 08:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D59C6103A
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 08:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhHLIjV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:39:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56244 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbhHLIjE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Aug 2021 04:39:04 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B7B4D1FF27;
        Thu, 12 Aug 2021 08:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628757518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPpCgZsZujeHpFjKQKbfSj++xp0YtZ9ihzOrHo+mO84=;
        b=lqWyC3V0Viit0MCDa2F8x2Cxg+52gkzX0IMmmSaJv9pa1zQRH8Z/Ku01caEw6EVmBIQ3WQ
        /s8sjdv8HKDjG9kHai/YaHffgeIEfd0GE6C4bnNyrJIt/IB0W8SCbkEYEbIibdvOCs3M2y
        lerpWfd1yQI8dsFoo3/ZnlO7BF7Qa+o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628757518;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPpCgZsZujeHpFjKQKbfSj++xp0YtZ9ihzOrHo+mO84=;
        b=9OyYFVp2+osa2ADsUh0iYui0qaiJ2PaF4wA0XkeewrHVcbpFSivlwIpLbFY1jppDHeuWED
        yV+2yqgKkGJxe8BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6B17213C3B;
        Thu, 12 Aug 2021 08:38:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TyTYDQzeFGHMLgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 12 Aug 2021 08:38:36 +0000
Subject: Re: [PATCH 7/8] bcache: move the del_gendisk call out of
 bcache_device_free
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
References: <20210809064028.1198327-1-hch@lst.de>
 <20210809064028.1198327-8-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <7ec809f8-c3d0-c3ad-8b2f-4b8d34b688ab@suse.de>
Date:   Thu, 12 Aug 2021 16:38:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809064028.1198327-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/9/21 2:40 PM, Christoph Hellwig wrote:
> Let the callers call del_gendisk so that we can check if add_disk
> has been called properly for the cached device case instead of relying
> on the block layer internal GENHD_FL_UP flag.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It looks good to me.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index d0f08e946453..f2874c77ff79 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -885,11 +885,6 @@ static void bcache_device_free(struct bcache_device *d)
>  		bcache_device_detach(d);
>  
>  	if (disk) {
> -		bool disk_added = (disk->flags & GENHD_FL_UP) != 0;
> -
> -		if (disk_added)
> -			del_gendisk(disk);
> -
>  		blk_cleanup_disk(disk);
>  		ida_simple_remove(&bcache_device_idx,
>  				  first_minor_to_idx(disk->first_minor));
> @@ -1371,8 +1366,10 @@ static void cached_dev_free(struct closure *cl)
>  
>  	mutex_lock(&bch_register_lock);
>  
> -	if (atomic_read(&dc->running))
> +	if (atomic_read(&dc->running)) {
>  		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
> +		del_gendisk(dc->disk.disk);
> +	}
>  	bcache_device_free(&dc->disk);
>  	list_del(&dc->list);
>  
> @@ -1518,6 +1515,7 @@ static void flash_dev_free(struct closure *cl)
>  	mutex_lock(&bch_register_lock);
>  	atomic_long_sub(bcache_dev_sectors_dirty(d),
>  			&d->c->flash_dev_dirty_sectors);
> +	del_gendisk(d->disk);
>  	bcache_device_free(d);
>  	mutex_unlock(&bch_register_lock);
>  	kobject_put(&d->kobj);

