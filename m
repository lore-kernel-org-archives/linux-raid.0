Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAC7C43334
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 06:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiGYG0y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 02:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGYG0x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 02:26:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5173E0B5
        for <linux-raid@vger.kernel.org>; Sun, 24 Jul 2022 23:26:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5F3FA34CA8;
        Mon, 25 Jul 2022 06:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658730411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sj0oReBev90CH1Kj1tZuRtrC+4X5Bf2xmDZ9jTb6RaU=;
        b=uV1oPmYE5OG9hBi9OXdeIYxaITOF+XhoO+3NeT2GvNUMr3wBADi+RDBLwM7KGcAHIWGw6p
        KywBMlFFjOyBDIyQG/kGekzoH1WHTbcUNAPPgaETnFTSATbqcQxDPGeiEUgjJlhoYXfdCL
        lgXts5Ie8BWEg7vnUq6RWxc7MBksOuU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658730411;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sj0oReBev90CH1Kj1tZuRtrC+4X5Bf2xmDZ9jTb6RaU=;
        b=vAu4S09ebzEwElTm5uI+Vf/tV11YBminFhXZGSdWMstxm3CUSgsbmGalv/Cz+AnqVLE13I
        CHzKwXUywWxjBGAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38FA013AD7;
        Mon, 25 Jul 2022 06:26:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IbNUDKs33mJePQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 25 Jul 2022 06:26:51 +0000
Message-ID: <d184e059-829e-4737-cb8e-6f8db984c6d7@suse.de>
Date:   Mon, 25 Jul 2022 08:26:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] md: open code md_probe in autorun_devices
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
References: <20220723062429.2210193-1-hch@lst.de>
 <20220723062429.2210193-2-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220723062429.2210193-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/23/22 08:24, Christoph Hellwig wrote:
> autorun_devices should not be limited to the controls for the legacy
> probe on open, so just call md_alloc directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2b2267be5c329..5671160ad3982 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6500,7 +6500,7 @@ static void autorun_devices(int part)
>   			break;
>   		}
>   
> -		md_probe(dev);
> +		md_alloc(dev, NULL);
>   		mddev = mddev_find(dev);
>   		if (!mddev)
>   			break;
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
