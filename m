Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95890C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 31 Dec 2021 08:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhLaI6A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 31 Dec 2021 03:58:00 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:42739 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229862AbhLaI57 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 31 Dec 2021 03:57:59 -0500
Received: from [192.168.0.3] (ip5f5aea97.dynamic.kabel-deutschland.de [95.90.234.151])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id B8EE061EA1922;
        Fri, 31 Dec 2021 09:57:58 +0100 (CET)
Message-ID: <2f8b76e0-a784-af2b-1411-8f7ad5fb874f@molgen.mpg.de>
Date:   Fri, 31 Dec 2021 09:57:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] Use strict priority ranking for pq gen() benchmarking
Content-Language: en-US
To:     =?UTF-8?Q?Dirk_M=c3=bcller?= <dmueller@suse.de>
Cc:     linux-raid@vger.kernel.org
References: <20211229223600.29346-1-dmueller@suse.de>
 <0c95af18-2924-573c-9473-6645f8fc93bd@molgen.mpg.de>
 <5d98e14e6fbc4de157e16ca401d1a562@suse.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <5d98e14e6fbc4de157e16ca401d1a562@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Dear Dirk,


Thank you for the detailed reply.


Am 31.12.21 um 09:52 schrieb Dirk Müller:
> Am 2021-12-30 14:46, schrieb Paul Menzel:

>> Can the AVX2 wins over AVX512 be explained, or does it point to
>> some implementation problem?
> 
> I've not yet analyzed this deep enough to have a defendable
> explanation ready, sorry. My patch is not changing the situation in
> regards to AVX512 vs AVX2 (both are ranked equal, same like before). 
> The only change I do is that SSE2 is ranked lower than AVX2, so cpu 
> generations that have AVX2 will stop benchmarking at AVX2 rather than
> also including SSE2 benchmark runs.
> 
> The current benchmark routine is likely too naive when you look at
> the last 20+ years of cpu design improvements (prefetching,
> Out-of-Order Execution, Turbo modes, Energy-Cores, AVX512 licensing
> turbo and many other aspects). This is not in my current focus, my
> current focus is on lowering the tax of the benchmark.

Thank you. Sorry for hijacking this thread with the question.

>> By the way, Borislav did not give much credit to the benchmarks 
>> results [1].
> 
> I have seen that as well, there are two remarks on this (both not 
> invalidating what Borislav wrote):
> 
> * the comment was about xor(), this patch is about gen()
> * the benchmark logic does a relative ranking of approaches, so the 
> absolute number fluctuation doesn't matter if they still rank the same.

Indeed.

>>> By giving AVXx variants higher priority over SSE, we can generally
>>> skip 3 benchmarks which speeds this up by 33% - 50%, depending on
>>> whether AVX512 is available.
>> Please give concrete timing numbers for one system you tested this on.
> 
> I have given an explanation of how this patch affects number of 
> benchmarks that are run. how long they take depends on other factors. 
> this is the list of benchmarks configured (lib/raid6/algos.c the 
> raid6_algos6[] array):
> 
> 
>    #if defined(__x86_64__) && !defined(__arch_um__)
>    #ifdef CONFIG_AS_AVX512
>            &raid6_avx512x4,
>            &raid6_avx512x2,
>            &raid6_avx512x1,
>    #endif
>            &raid6_avx2x4,
>            &raid6_avx2x2,
>            &raid6_avx2x1,
>            &raid6_sse2x4,
>            &raid6_sse2x2,
>            &raid6_sse2x1,
>    #endif
> 
> without this patch, all 9 are executed. with this patch, the last 3 
> (sse2x*) are skipped, leading to a 3 out of 6 or 3 out of 9 (depending 
> on whether or not AVX512 is enabled) improvement, or 33%-50% as written 
> above.
> 
> I'm open to any suggestion of a wording change that makes this clearer.

As in the other patch, having an additional statement like below, would 
help me.

With a 250HZ kernel, on Intel Xeon(?) … according to `initcall_debug` 
the former load time is X ms, and now only Y ms.


Kind regards,

Paul
