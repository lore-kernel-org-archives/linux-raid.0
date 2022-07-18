Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE697C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 07:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiGRHBj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 03:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiGRHBh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 03:01:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5C8167F1;
        Mon, 18 Jul 2022 00:01:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C48FF372D0;
        Mon, 18 Jul 2022 07:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658127694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R7vLO4D2H6z51xnNNEkgJEXozWFWD25ba8n/l5gSEPU=;
        b=jOtWKDHbCLo4AH8itD0t7HdJ5nSSsZSsPu0n9jjqUt0V95zhPZ60FZSqMlsw+Mh69aAMzR
        J1ajTmVCWeGpprQoc6bpefgKRH3Hv1fcGqSkdSP6GMaYgyG7bB8LL5m8KEzPyOEkhMflkq
        nlH6TkNMv+kEQ269a8kPrwrMuJctsBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658127694;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R7vLO4D2H6z51xnNNEkgJEXozWFWD25ba8n/l5gSEPU=;
        b=pa72XpxWqq/GAmBqPBPOgql9BJ/etnGO/9zgzD5EJ0+5URJaR07pTc8ISNRsWAVaucZO3x
        DBrZtteoCL/qh/Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AF3C013754;
        Mon, 18 Jul 2022 07:01:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id S9NWKk4F1WIpZwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 07:01:34 +0000
Message-ID: <6a0d6dec-a1b8-f211-2432-dd08f8b454d9@suse.de>
Date:   Mon, 18 Jul 2022 09:01:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 04/10] md: rename md_free to md_kobj_release
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-5-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> The md_free name is rather misleading, so pick a better one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1e658d5060842..96b4e901ff6b5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5589,7 +5589,7 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
>   	return rv;
>   }
>   
> -static void md_free(struct kobject *ko)
> +static void md_kobj_release(struct kobject *ko)
>   {
>   	struct mddev *mddev = container_of(ko, struct mddev, kobj);
>   
> @@ -5609,7 +5609,7 @@ static const struct sysfs_ops md_sysfs_ops = {
>   	.store	= md_attr_store,
>   };
>   static struct kobj_type md_ktype = {
> -	.release	= md_free,
> +	.release	= md_kobj_release,
>   	.sysfs_ops	= &md_sysfs_ops,
>   	.default_groups	= md_attr_groups,
>   };
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

