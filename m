Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EA3C43334
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 06:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGYG1V (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 02:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGYG1U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 02:27:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090EFE0B5
        for <linux-raid@vger.kernel.org>; Sun, 24 Jul 2022 23:27:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B913B34CA8;
        Mon, 25 Jul 2022 06:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658730437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B82GvKdPbM4LRuqBHL3i7PN72shO5htjUQanQ4TNxWE=;
        b=tfHllwL+6pyBHQdYvX+eJlciqgA1wZ1aRBAXhf1Vz3B659kuRVjfPBo1jLP6Yf7fO2nF7X
        n9eZUxnv4fMYvDv/2d5vhVCaOQ2PbpCedHoJ2gbtrIcnIiIR2Pv27mXAyxWf8nVtTfn/mF
        Dw3l/dHULfc3+zQRMXLnJEF2JWUwSAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658730437;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B82GvKdPbM4LRuqBHL3i7PN72shO5htjUQanQ4TNxWE=;
        b=EojlXaHuqyakHp17Y00FcUGLf96lGkBCEhkNeWVVxILpwfl12A63j50qBM8jEVdbvuohS5
        pLxsMcnKE4TEZ7Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85DCC13AD7;
        Mon, 25 Jul 2022 06:27:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Oh3NHMU33mKqPQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 25 Jul 2022 06:27:17 +0000
Message-ID: <ed9206fa-c047-77bc-918f-ed61fc88631e@suse.de>
Date:   Mon, 25 Jul 2022 08:27:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] md: return the allocated devices from md_alloc
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
References: <20220723062429.2210193-1-hch@lst.de>
 <20220723062429.2210193-3-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220723062429.2210193-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/23/22 08:24, Christoph Hellwig wrote:
> Two callers of md_alloc want to use the newly allocated devices, so
> return it instead of letting them find it cumbersomely after the
> allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md-autodetect.c | 22 +++++-----------
>   drivers/md/md.c            | 54 ++++++++++++++++----------------------
>   drivers/md/md.h            |  3 ++-
>   3 files changed, 30 insertions(+), 49 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
