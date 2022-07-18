Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CC1C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiGRGzS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiGRGzP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:55:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035DC15FED;
        Sun, 17 Jul 2022 23:55:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E42F920B8F;
        Mon, 18 Jul 2022 06:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658127310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEAKP7CHmD8oD6U8D4KqcRFrBs/dsOInWcncJJtoVpg=;
        b=CGOWeOtCBmoXUR1Kjolc2qQaeQ62r0jkIhSkkmE1c5P/+tIswWygHAE1NhVdvrgIMIhI0I
        PV8AYNxLOpBm0XjXZIsQvWpD2nUEDwkgoEI1iukgCAu9i6YWmaFyYXgJ6SwP9wFHfHQ4YB
        q1DykzAP4Rbm/0IkBA+EcJE7AVsU8u4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658127310;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEAKP7CHmD8oD6U8D4KqcRFrBs/dsOInWcncJJtoVpg=;
        b=JZolp5+YkqlQ8nv/tPcO7KihHf8lcw6dVF0YNHqxjxjh0cvmNClyw+7Rv4AEK0oneoPBQN
        rI/+2T5n5po0BfBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B62ED13754;
        Mon, 18 Jul 2022 06:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id j/+rK84D1WJnZAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 06:55:10 +0000
Message-ID: <4dd9ad02-f79c-7b09-38ee-6eae8cfe2b5b@suse.de>
Date:   Mon, 18 Jul 2022 08:55:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 01/10] md: fix mddev->kobj lifetime
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-2-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> Once a kobject is initialized, the containing object should not be
> directly freed.  So delay initialization until it is added.  Also
> remove the kobject_del call as the last put will remove the kobject as
> well.  The explicitly delete isn't needed here, and dropping it will
> simplify further fixes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b64de313838f2..a49ddc9454ff6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -678,7 +678,6 @@ static void md_safemode_timeout(struct timer_list *t);
>   
>   void mddev_init(struct mddev *mddev)
>   {
> -	kobject_init(&mddev->kobj, &md_ktype);
>   	mutex_init(&mddev->open_mutex);
>   	mutex_init(&mddev->reconfig_mutex);
>   	mutex_init(&mddev->bitmap_info.mutex);
> @@ -5617,7 +5616,6 @@ static void mddev_delayed_delete(struct work_struct *ws)
>   {
>   	struct mddev *mddev = container_of(ws, struct mddev, del_work);
>   
> -	kobject_del(&mddev->kobj);
>   	kobject_put(&mddev->kobj);
>   }
>   
> @@ -5719,6 +5717,7 @@ int md_alloc(dev_t dev, char *name)
>   	if (error)
>   		goto out_cleanup_disk;
>   
> +	kobject_init(&mddev->kobj, &md_ktype);
>   	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
>   	if (error)
>   		goto out_del_gendisk;
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
