Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81915C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 07:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A0460F48
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 07:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhI0HZo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbhI0HZl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Sep 2021 03:25:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EFFC061570;
        Mon, 27 Sep 2021 00:24:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so3131140pjb.1;
        Mon, 27 Sep 2021 00:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zRcqo9ZRM0x4X1qC1VhpLMYfBLcHfFC5rDADl7ze48U=;
        b=bOT9MpcfrFqg+qIyclqxXB8nUB7bsphZ1S/xpNatC4515Qo0sU2pi7x/EqYfPeIecW
         mlWgsxwLB5US417ZTRVOTKD08cp+ghdFf4H9oqoHaxWhlzirb3f2FWOuxybhJkvZ/+ja
         qKOa4lVx0cxzVRr3tICl9/dqMwoYYiDuILPunoXKMJ988zvC3pkXz84SY02xR91xqMeK
         Mhp2uzUyyW2uZ/0Nc8HRp7/1fexH3wr5WeeDqSNePU1G8UM800sMYpIUEBhhJ1q8EClr
         3QGi9A8k5/PF2XUlSqn4bI8rhW3d22Oma7WyaTjuyEkKGu9oyDLD/vKogouMl84vHBQO
         3QhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zRcqo9ZRM0x4X1qC1VhpLMYfBLcHfFC5rDADl7ze48U=;
        b=y8epyuEL5Y8AOU5pIp9WgsX+eXP1mdh8zJLJTIEloq39mccmRvGTTWapYCHIiYp1AA
         LRQT92TDn33PygoHn4j9o91DM8QnfwdMHjRdVjU92Sd+VELa6UWIXyWnh97K2BK2jz5f
         QqZB3eIokKMpHNe2tZOOHCLMPYt9qlcL4cah9YiNbkRrOFqfrwoLQvNaKI8aq3vDgQYn
         jAgjx1QsLB3fv94n8kUBCm0j/LTRTJZfWnqpbik84OfyNwEKpUO4+hietG9TuWdJbyDn
         o/qOW3fBhY1CjXULJnozwsOCHw5M4RlTfQnJxNg7GuQI1MJRJkrREddEQYYy/YFkEHBR
         R77Q==
X-Gm-Message-State: AOAM5320wmw7B5Xz3wm4EwfjucL2GuQ0baVKIdRIYSEN0kV45v4u/SKI
        PAr0yzTmJu7IN+WLlDKeIzpsbmD50AzSjQ==
X-Google-Smtp-Source: ABdhPJyM/wgKmx+FlPefYMinMxbqa/qTjV2GwDFj7rJrusdlBfsgZsLqa6sHI/ycfYifxKX04bR5Fg==
X-Received: by 2002:a17:90a:bc8d:: with SMTP id x13mr18015275pjr.9.1632727442789;
        Mon, 27 Sep 2021 00:24:02 -0700 (PDT)
Received: from [10.239.207.187] ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id q16sm14532927pfh.16.2021.09.27.00.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 00:24:02 -0700 (PDT)
Message-ID: <e0fc4902-e8db-b507-651b-d930a74702ef@gmail.com>
Date:   Mon, 27 Sep 2021 15:23:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 1/6] badblocks: add more helper structure and routines
 in badblocks.h
Content-Language: en-US
To:     Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev
Cc:     antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
        Vishal L Verma <vishal.l.verma@intel.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <20210913163643.10233-2-colyli@suse.de>
From:   Geliang Tang <geliangtang@gmail.com>
In-Reply-To: <20210913163643.10233-2-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly,

On 9/14/21 00:36, Coly Li wrote:
> This patch adds the following helper structure and routines into
> badblocks.h,
> - struct badblocks_context
>    This structure is used in improved badblocks code for bad table
>    iteration.
> - BB_END()
>    The macro to culculate end LBA of a bad range record from bad
>    table.
> - badblocks_full() and badblocks_empty()
>    The inline routines to check whether bad table is full or empty.
> - set_changed() and clear_changed()
>    The inline routines to set and clear 'changed' tag from struct
>    badblocks.
> 
> These new helper structure and routines can help to make the code more
> clear, they will be used in the improved badblocks code in following
> patches.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Richard Fan <richard.fan@suse.com>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> ---
>   include/linux/badblocks.h | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
> index 2426276b9bd3..166161842d1f 100644
> --- a/include/linux/badblocks.h
> +++ b/include/linux/badblocks.h
> @@ -15,6 +15,7 @@
>   #define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
>   #define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
>   #define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
> +#define BB_END(x)	(BB_OFFSET(x) + BB_LEN(x))
>   #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
>   
>   /* Bad block numbers are stored sorted in a single page.
> @@ -41,6 +42,14 @@ struct badblocks {
>   	sector_t size;		/* in sectors */
>   };
>   
> +struct badblocks_context {
> +	sector_t	start;
> +	sector_t	len;

I think the type of 'len' should be 'int' instead of 'sector_t', since 
we used 'int sectors' as one of the arguments of _badblocks_set().

> +	int		ack;
> +	sector_t	orig_start;
> +	sector_t	orig_len;

I think 'orig_start' and 'orig_len' can be dropped, see comments in patch 3.

> +};
> +
>   int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>   		   sector_t *first_bad, int *bad_sectors);
>   int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> @@ -63,4 +72,27 @@ static inline void devm_exit_badblocks(struct device *dev, struct badblocks *bb)
>   	}
>   	badblocks_exit(bb);
>   }
> +
> +static inline int badblocks_full(struct badblocks *bb)
> +{
> +	return (bb->count >= MAX_BADBLOCKS);
> +}
> +
> +static inline int badblocks_empty(struct badblocks *bb)
> +{
> +	return (bb->count == 0);
> +}
> +
> +static inline void set_changed(struct badblocks *bb)
> +{
> +	if (bb->changed != 1)
> +		bb->changed = 1;
> +}
> +
> +static inline void clear_changed(struct badblocks *bb)
> +{
> +	if (bb->changed != 0)
> +		bb->changed = 0;
> +}
> +
>   #endif
> 

