Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823A4C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 06:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 683166103A
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 06:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbhHRGfN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Aug 2021 02:35:13 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34165 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238168AbhHRGfN (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 18 Aug 2021 02:35:13 -0400
Received: from [192.168.0.3] (ip5f5aeb62.dynamic.kabel-deutschland.de [95.90.235.98])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 496E961E5FE33;
        Wed, 18 Aug 2021 08:34:37 +0200 (CEST)
Subject: Re: [PATCH] Fix potential overlap dest buffer
To:     Nigel Croxon <ncroxon@redhat.com>
References: <20210817131448.2496995-1-ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <6ffc271e-c24e-aaf7-7392-0041f26e4bf2@molgen.mpg.de>
Date:   Wed, 18 Aug 2021 08:34:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210817131448.2496995-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Nigel,


Am 17.08.21 um 15:14 schrieb Nigel Croxon:
> To meet requirements of Common Criteria certification vulnerablility

vulnerability

> assessment.

That’s only part of a sentence? Is that supposed to be read as a 
continuation of the commit message summary: … to meet requirements …?

> Static code analysis has been run and found the following
> error.  Overlapping_buffer: The source buffer potentially overlaps

It’d be great, if you denoted, which tool was run. Maybe even add a 
Found-by tag.

> with the destination buffer, which results in undefined
> behavior for "memcpy".
> 
> The change is to use memmove instead of memcpy.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   sha1.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sha1.c b/sha1.c
> index 11be7045..89b32f46 100644
> --- a/sha1.c
> +++ b/sha1.c
> @@ -258,7 +258,7 @@ sha1_process_bytes (const void *buffer, size_t len, struct sha1_ctx *ctx)
>   	{
>   	  sha1_process_block (ctx->buffer, 64, ctx);
>   	  left_over -= 64;
> -	  memcpy (ctx->buffer, &ctx->buffer[16], left_over);
> +	  memmove (ctx->buffer, &ctx->buffer[16], left_over);
>   	}
>         ctx->buflen = left_over;
>       }

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
