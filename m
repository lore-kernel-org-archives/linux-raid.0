Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C69C41620
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF4E60233
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbhCCX75 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Mar 2021 18:59:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:32948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379675AbhCCIVA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 3 Mar 2021 03:21:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2075AAD57;
        Wed,  3 Mar 2021 08:20:18 +0000 (UTC)
Subject: Re: [RFC PATCH v1 1/6] badblocks: add more helper structure and
 routines in badblocks.h
To:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        axboe@kernel.dk, dan.j.williams@intel.com,
        vishal.l.verma@intel.com, neilb@suse.de
Cc:     antlists@youngman.org.uk, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
References: <20210302040252.103720-1-colyli@suse.de>
 <20210302040252.103720-2-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <96a899a9-151e-ff8c-c61c-900df1122357@suse.de>
Date:   Wed, 3 Mar 2021 09:20:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210302040252.103720-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/2/21 5:02 AM, Coly Li wrote:
> This patch adds the following helper structure and routines into
> badblocks.h,
> - struct bad_context
>   This structure is used in improved badblocks code for bad table
>   iteration.
> - BB_END()
>   The macro to culculate end LBA of a bad range record from bad
>   table.
> - badblocks_full() and badblocks_empty()
>   The inline routines to check whether bad table is full or empty.
> - set_changed() and clear_changed()
>   The inline routines to set and clear 'changed' tag from struct
>   badblocks.
> 
> These new helper structure and routines can help to make the code more
> clear, they will be used in the improved badblocks code in following
> patches.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  include/linux/badblocks.h | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 2426276b9bd3..166161842d1f 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -15,6 +15,7 @@
>  #define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
>  #define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
>  #define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
> +#define BB_END(x)	(BB_OFFSET(x) + BB_LEN(x))
>  #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
>  
>  /* Bad block numbers are stored sorted in a single page.
> @@ -41,6 +42,14 @@ struct badblocks {
>  	sector_t size;		/* in sectors */
>  };
>  
> +struct bad_context {
> +	sector_t	start;
> +	sector_t	len;
> +	int		ack;
> +	sector_t	orig_start;
> +	sector_t	orig_len;
> +};
> +
Maybe rename it to 'badblocks_context'.
It's not the context which is bad ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
