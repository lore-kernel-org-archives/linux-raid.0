Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872EAC433ED
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 12:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50EDF61380
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 12:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344151AbhDFMlq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344145AbhDFMlm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Apr 2021 08:41:42 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47FDC06174A;
        Tue,  6 Apr 2021 05:41:29 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a0d0028dd5ac2a57e9950.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:d00:28dd:5ac2:a57e:9950])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37BAD1EC01DF;
        Tue,  6 Apr 2021 14:41:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617712888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Pv17T3ai77Xev+NWaPOI51QWhDN6big+Jsrye4oweIQ=;
        b=k2bkf31eTt3jtPXlgdbxv3YCgoXgfzdfwRRM8SnWSGM0m1BljQuJGuLBXXuYdzOursyS5j
        WsrKAk6zUzRIwIPlYuSVd7W33rV0UZ0dGyj8tdbtoq85qytMpJlssEOgKnqpBTgLjuBRFa
        y4Us3NKkGkOTYAW0B5xOWnzESzcreYQ=
Date:   Tue, 6 Apr 2021 14:41:26 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, it+linux-x86@molgen.mpg.de,
        Krzysztof =?utf-8?Q?Ol=C4=99dzki?= <ole@ans.pl>,
        Andy Lutomirski <luto@kernel.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: Re: [regression 5.4.97 =?utf-8?B?4oaSIDUu?= =?utf-8?B?MTAuMjRd?=
 =?utf-8?Q?=3A?= raid6 avx2x4 speed drops from 18429 MB/s to 6155 MB/s
Message-ID: <20210406124126.GM17806@zn.tnic>
References: <6a1b0110-07f1-8c2e-fc7f-379758dbd8ca@molgen.mpg.de>
 <20210402140554.GG28499@zn.tnic>
 <05dbb237-1d23-df32-e4ed-6bc7b47f42dc@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05dbb237-1d23-df32-e4ed-6bc7b47f42dc@molgen.mpg.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Apr 06, 2021 at 12:58:15PM +0200, Paul Menzel wrote:
> I booted Linux 5.12-rc6, containing these commits, on a Dell OptiPlex 5055
> with AMD Ryzen 5 PRO 1500 Quad-Core Processor, and the regression is still
> present for `avx2x4 xor()`:

So I don't think that's a regression - this looks more like "you should
not look at those numbers and compare them". Below are some results from
boot logs on one of my test boxes, first column is the kernel version.

IOW, you can use those numbers as a random number generator.

Now, I'm not saying that there isn't anything happening after
5.4-5.6-ish timeframe but this needs to be checked with a proper
benchmark and then look at what could be causing this. It could be the
MXCSR clearing but it's not like we don't need that so there won't be a
whole lot we can do.

But someone would have to sit down and do proper measurements first. And
bisect. Then we'll see...

HTH.

01-0+   :raid6: avx2x4   xor() 10311 MB/s
01-rc3+ :raid6: avx2x4   xor()  5497 MB/s
01-rc6+ :raid6: avx2x4   xor()  5369 MB/s
02-rc3+ :raid6: avx2x4   xor()  9812 MB/s
02-rc5+ :raid6: avx2x4   xor() 11479 MB/s
03-rc1+ :raid6: avx2x4   xor()  6434 MB/s
03-rc2+ :raid6: avx2x4   xor()  5487 MB/s
03-rc3+ :raid6: avx2x4   xor()  4840 MB/s
03-rc5+ :raid6: avx2x4   xor() 11104 MB/s
04-rc1+ :raid6: avx2x4   xor()  6443 MB/s
04-rc2+ :raid6: avx2x4   xor()  4959 MB/s
04-rc3+ :raid6: avx2x4   xor()  4918 MB/s
04-rc7+ :raid6: avx2x4   xor()  5219 MB/s
05-rc1+ :raid6: avx2x4   xor()  5362 MB/s
05-rc2+ :raid6: avx2x4   xor()  5356 MB/s
05-rc7+ :raid6: avx2x4   xor()  5821 MB/s
06-rc1+ :raid6: avx2x4   xor()  3358 MB/s
06-rc2+ :raid6: avx2x4   xor()  3591 MB/s
06-rc4+ :raid6: avx2x4   xor()  3947 MB/s
06-rc6+ :raid6: avx2x4   xor()  4100 MB/s
06-rc7+ :raid6: avx2x4   xor()  4038 MB/s
07-0+   :raid6: avx2x4   xor()  3410 MB/s
07-rc1+ :raid6: avx2x4   xor()  4836 MB/s
07-rc2+ :raid6: avx2x4   xor()  3194 MB/s
07-rc5  :raid6: avx2x4   xor()  4220 MB/s
07-rc6+ :raid6: avx2x4   xor()  3949 MB/s
07-rc7+ :raid6: avx2x4   xor()  3238 MB/s
09-0+   :raid6: avx2x4   xor()  3259 MB/s
09-rc1+ :raid6: avx2x4   xor()  2963 MB/s
09-rc4+ :raid6: avx2x4   xor()  2593 MB/s
09-rc5+ :raid6: avx2x4   xor()  2555 MB/s
09-rc7+ :raid6: avx2x4   xor()  3333 MB/s
09-rc8+ :raid6: avx2x4   xor()  2979 MB/s
10-rc4+ :raid6: avx2x4   xor()  4482 MB/s
10-rc5+ :raid6: avx2x4   xor()  6170 MB/s
10-rc7+ :raid6: avx2x4   xor()  3557 MB/s
11-rc1+ :raid6: avx2x4   xor()  1461 MB/s
11-rc2+ :raid6: avx2x4   xor()  4095 MB/s
11-rc7+ :raid6: avx2x4   xor()  6088 MB/s
12-rc1+ :raid6: avx2x4   xor()  4147 MB/s
12-rc2+ :raid6: avx2x4   xor()  4361 MB/s
12-rc3+ :raid6: avx2x4   xor()  4070 MB/s
12-rc4+ :raid6: avx2x4   xor()  6078 MB/s

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
