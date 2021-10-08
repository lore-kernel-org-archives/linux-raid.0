Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2A2C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 15:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F5060FD7
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 15:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243184AbhJHPwN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 11:52:13 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17218 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243205AbhJHPwM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 11:52:12 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633708206; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=FHYIWtIpfR+8bHvIrp5WnQ/1Fb1wTx06Tv034gwL70AHxnhnoDFlJq/RLmdW4xDmZRHMV/51ScrE1nNkQJM3ub/c6+UFArQYYbImYAOBvwwxTIt6duKhZz0MoKeJxeGqMkQeMIwrx7JOVopo6KdxTc9vhgi/P2UlMjmPJoqXFfA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633708206; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qWhIowDKD34pqGQduo1J/3C/Thv1L2hkUtkdN8zb1GM=; 
        b=EAa+vmlg1TcmFkAQbX1/Qzzb+ju30I03mV/U/LytH/HqCT2P7U8QTpgDUaZaTMijz3NkFleJWVGkp6Okc5WjjHGusBFAkCeH3r79KblBf70cqGYmYHbPrYbZ+ONYWXIGKpqUVcTWJJ7d6mXcbEbHHU5+KT5WRLvWeU/oGwwcJbs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633708205621982.957443479342; Fri, 8 Oct 2021 17:50:05 +0200 (CEST)
Subject: Re: [PATCH] Fix potential overlap dest buffer
To:     Nigel Croxon <ncroxon@redhat.com>, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org
References: <20210817131448.2496995-1-ncroxon@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6e2f75ae-988e-3e00-6455-cbf9adb75aa7@trained-monkey.org>
Date:   Fri, 8 Oct 2021 11:50:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210817131448.2496995-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/17/21 9:14 AM, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerablility
> assessment. Static code analysis has been run and found the following
> error.  Overlapping_buffer: The source buffer potentially overlaps
> with the destination buffer, which results in undefined
> behavior for "memcpy".
> 
> The change is to use memmove instead of memcpy.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  sha1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sha1.c b/sha1.c
> index 11be7045..89b32f46 100644
> --- a/sha1.c
> +++ b/sha1.c
> @@ -258,7 +258,7 @@ sha1_process_bytes (const void *buffer, size_t len, struct sha1_ctx *ctx)
>  	{
>  	  sha1_process_block (ctx->buffer, 64, ctx);
>  	  left_over -= 64;
> -	  memcpy (ctx->buffer, &ctx->buffer[16], left_over);
> +	  memmove (ctx->buffer, &ctx->buffer[16], left_over);
>  	}
>        ctx->buflen = left_over;
>      }
> 

Applied!

Thanks,
Jes

