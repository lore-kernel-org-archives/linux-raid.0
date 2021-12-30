Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B8CC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 30 Dec 2021 13:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbhL3NqQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Dec 2021 08:46:16 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34883 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239587AbhL3NqQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 30 Dec 2021 08:46:16 -0500
Received: from [192.168.0.3] (ip5f5aeaad.dynamic.kabel-deutschland.de [95.90.234.173])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3B58961E6478B;
        Thu, 30 Dec 2021 14:46:14 +0100 (CET)
Message-ID: <0c95af18-2924-573c-9473-6645f8fc93bd@molgen.mpg.de>
Date:   Thu, 30 Dec 2021 14:46:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] Use strict priority ranking for pq gen() benchmarking
Content-Language: en-US
To:     =?UTF-8?Q?Dirk_M=c3=bcller?= <dmueller@suse.de>
References: <20211229223600.29346-1-dmueller@suse.de>
Cc:     linux-raid@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211229223600.29346-1-dmueller@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Dirk,


Am 29.12.21 um 23:36 schrieb Dirk Müller:
> On x86_64, currently 3 variants of AVX512, 3 variants of AVX2
> and 3 variants of SSE2 are benchmarked on initialization, taking
> between 144-153 jiffies. Over a hardware pool of various generations
> of intel cpus I could not find a single case where SSE2 won over
> AVX2 or AVX512. There are cases where AVX2 wins over AVX512.

Can the AVX2 wins over AVX512 be explained, or does it point to some 
implementation problem? By the way, Borislav did not give much credit to 
the benchmarks results [1].

> By giving AVXx variants higher priority over SSE, we can generally
> skip 3 benchmarks which speeds this up by 33% - 50%, depending on
> whether AVX512 is available.

Please give concrete timing numbers for one system you tested this on.

> Signed-off-by: Dirk Müller <dmueller@suse.de>
> ---
>   include/linux/raid/pq.h | 2 +-
>   lib/raid6/algos.c       | 2 +-
>   lib/raid6/avx2.c        | 6 +++---
>   lib/raid6/avx512.c      | 6 +++---
>   4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 154e954b711d..d6e5a1feb947 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -81,7 +81,7 @@ struct raid6_calls {
>   	void (*xor_syndrome)(int, int, int, size_t, void **);
>   	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
>   	const char *name;	/* Name of this routine set */
> -	int prefer;		/* Has special performance attribute */
> +	int priority;		/* Relative priority ranking if non-zero */
>   };
>   
>   /* Selected algorithm */
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 889033b7fc0d..d1e8ff837a32 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -151,7 +151,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
>   	const struct raid6_calls *best;
>   
>   	for (bestgenperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
> -		if (!best || (*algo)->prefer >= best->prefer) {
> +		if (!best || (*algo)->priority >= best->priority) {
>   			if ((*algo)->valid && !(*algo)->valid())
>   				continue;
>   
> diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
> index f299476e1d76..31be496b8c81 100644
> --- a/lib/raid6/avx2.c
> +++ b/lib/raid6/avx2.c
> @@ -132,7 +132,7 @@ const struct raid6_calls raid6_avx2x1 = {
>   	raid6_avx21_xor_syndrome,
>   	raid6_have_avx2,
>   	"avx2x1",
> -	1			/* Has cache hints */
> +	.priority = 2
>   };
>   
>   /*
> @@ -262,7 +262,7 @@ const struct raid6_calls raid6_avx2x2 = {
>   	raid6_avx22_xor_syndrome,
>   	raid6_have_avx2,
>   	"avx2x2",
> -	1			/* Has cache hints */
> +	.priority = 2
>   };
>   
>   #ifdef CONFIG_X86_64
> @@ -465,6 +465,6 @@ const struct raid6_calls raid6_avx2x4 = {
>   	raid6_avx24_xor_syndrome,
>   	raid6_have_avx2,
>   	"avx2x4",
> -	1			/* Has cache hints */
> +	.priority = 2
>   };
>   #endif
> diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
> index bb684d144ee2..63ae197c3294 100644
> --- a/lib/raid6/avx512.c
> +++ b/lib/raid6/avx512.c
> @@ -162,7 +162,7 @@ const struct raid6_calls raid6_avx512x1 = {
>   	raid6_avx5121_xor_syndrome,
>   	raid6_have_avx512,
>   	"avx512x1",
> -	1                       /* Has cache hints */
> +	.priority = 2
>   };
>   
>   /*
> @@ -319,7 +319,7 @@ const struct raid6_calls raid6_avx512x2 = {
>   	raid6_avx5122_xor_syndrome,
>   	raid6_have_avx512,
>   	"avx512x2",
> -	1                       /* Has cache hints */
> +	.priority = 2
>   };
>   
>   #ifdef CONFIG_X86_64
> @@ -557,7 +557,7 @@ const struct raid6_calls raid6_avx512x4 = {
>   	raid6_avx5124_xor_syndrome,
>   	raid6_have_avx512,
>   	"avx512x4",
> -	1                       /* Has cache hints */
> +	.priority = 2
>   };
>   #endif
>   

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul


[1]: https://lore.kernel.org/all/20210406124126.GM17806@zn.tnic/
