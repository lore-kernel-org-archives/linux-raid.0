Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFE7C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 07:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiGRHDn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 03:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiGRHDn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 03:03:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D62167FE;
        Mon, 18 Jul 2022 00:03:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5FC8220BA6;
        Mon, 18 Jul 2022 07:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658127820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucn7PLgyVVW2xjdaqkCupWNgj3kZZaaPKquQx4z0aaA=;
        b=BCU4l78pxaIrR4bpGiZNcA8P8vJQzINUw6Y40YUwtzkTLCJhvwTE42vBAo7sryF+JEca2M
        eVeRD2dH8QPSA+Hwqmxcp4HgXQZiuiuNOc97h4aKfZV38WVh63odkeV2o+1Z4Tuo6OjfS9
        8/AA48qIAm19BRAfupD0/apvK/k6zzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658127820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucn7PLgyVVW2xjdaqkCupWNgj3kZZaaPKquQx4z0aaA=;
        b=gU22g/5IXteQGQ3BEfvrPdStEFz0MXbXhf3JihczUpBogv+tBpHulpYiOSwVF76cyxn9ft
        UzGibzXE6BT4MeBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4281D13754;
        Mon, 18 Jul 2022 07:03:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1JiMD8wF1WLcZwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 07:03:40 +0000
Message-ID: <5acec8a3-1708-1eea-6850-11bec45bd95e@suse.de>
Date:   Mon, 18 Jul 2022 09:03:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 06/10] md: stop using for_each_mddev in md_do_sync
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-7-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> Just do a plain list_for_each that only grabs a mddev reference in
> the case where the thread sleeps and restarts the list iteration.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


