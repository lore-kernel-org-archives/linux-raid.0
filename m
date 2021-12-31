Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8192FC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 31 Dec 2021 08:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhLaIwz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 31 Dec 2021 03:52:55 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49602 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhLaIwy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 31 Dec 2021 03:52:54 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B0CA8210E0;
        Fri, 31 Dec 2021 08:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640940773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0jIpkFx9+ZCJMyylmHY4PBPHM1h5ol6xNB6hApTklA=;
        b=K3yDJmOynTcJiVVp5KwncmDVGG4qnweFG8Zn1JHbvOmBOAry9DNtaKu8POMwi62au1XevH
        Hry6xT1clDeQW+7gXT88x9vp8poYekgV7KyvhdsdDsFqC0pgxG4P9xP6g+sUP2R39WaVv7
        Wg8viuOaGCm+g5JyfyfI6tMhDMC4eVk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640940773;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0jIpkFx9+ZCJMyylmHY4PBPHM1h5ol6xNB6hApTklA=;
        b=4g6je6U0z9kjQ6eP3sVAkdu9ZVJepEaJ91LuvYD3UdFZyp8LFUhTRNtOAhkEvQDwudKlfo
        Y7e6Qc5lpI4u1LCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A1D5013C2F;
        Fri, 31 Dec 2021 08:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 29jTJuXEzmH7fgAAMHmgww
        (envelope-from <dmueller@suse.de>); Fri, 31 Dec 2021 08:52:53 +0000
MIME-Version: 1.0
Date:   Fri, 31 Dec 2021 09:52:53 +0100
From:   =?UTF-8?Q?Dirk_M=C3=BCller?= <dmueller@suse.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] Use strict priority ranking for pq gen() benchmarking
In-Reply-To: <0c95af18-2924-573c-9473-6645f8fc93bd@molgen.mpg.de>
References: <20211229223600.29346-1-dmueller@suse.de>
 <0c95af18-2924-573c-9473-6645f8fc93bd@molgen.mpg.de>
User-Agent: Roundcube Webmail
Message-ID: <5d98e14e6fbc4de157e16ca401d1a562@suse.de>
X-Sender: dmueller@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am 2021-12-30 14:46, schrieb Paul Menzel:

Hi Paul,

> Can the AVX2 wins over AVX512 be explained, or does it point to some
> implementation problem?

I've not yet analyzed this deep enough to have a defendable explanation 
ready, sorry. My patch is
not changing the situation in regards to AVX512 vs AVX2 (both are ranked 
equal, same like before).
The only change I do is that SSE2 is ranked lower than AVX2, so cpu 
generations that have AVX2 will
stop benchmarking at AVX2 rather than also including SSE2 benchmark 
runs.

The current benchmark routine is likely too naive when you look at the 
last 20+ years of
cpu design improvements (prefetching, Out-of-Order Execution, Turbo 
modes, Energy-Cores,
AVX512 licensing turbo and many other aspects). This is not in my 
current focus, my current
focus is on lowering the tax of the benchmark.

> By the way, Borislav did not give much credit to the benchmarks results 
> [1].

I have seen that as well, there are two remarks on this (both not 
invalidating what Borislav wrote):

* the comment was about xor(), this patch is about gen()
* the benchmark logic does a relative ranking of approaches, so the 
absolute number fluctuation doesn't matter if they still rank the same.

>> By giving AVXx variants higher priority over SSE, we can generally
>> skip 3 benchmarks which speeds this up by 33% - 50%, depending on
>> whether AVX512 is available.
> Please give concrete timing numbers for one system you tested this on.

I have given an explanation of how this patch affects number of 
benchmarks that are run. how long they take depends on other factors. 
this is the list of benchmarks configured (lib/raid6/algos.c the 
raid6_algos6[] array):


   #if defined(__x86_64__) && !defined(__arch_um__)
   #ifdef CONFIG_AS_AVX512
           &raid6_avx512x4,
           &raid6_avx512x2,
           &raid6_avx512x1,
   #endif
           &raid6_avx2x4,
           &raid6_avx2x2,
           &raid6_avx2x1,
           &raid6_sse2x4,
           &raid6_sse2x2,
           &raid6_sse2x1,
   #endif

without this patch, all 9 are executed. with this patch, the last 3 
(sse2x*) are skipped, leading to a 3 out of 6 or 3 out of 9 (depending 
on whether or not AVX512 is enabled) improvement, or 33%-50% as written 
above.

I'm open to any sugggestion of a wording change that makes this clearer.


Thanks,
Dirk
