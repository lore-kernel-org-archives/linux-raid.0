Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9320BC433B4
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 14:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75BB961056
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 14:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhDBOF5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:05:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39516 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235675AbhDBOF4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 2 Apr 2021 10:05:56 -0400
Received: from zn.tnic (p200300ec2f0a200019ff857a83051552.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2000:19ff:857a:8305:1552])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 935A91EC0301;
        Fri,  2 Apr 2021 16:05:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617372354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fawn1BZhXE7Mko9X0iWw+cF95ko4CyRJ+vlQBlaxIJw=;
        b=BSEVff7uMXQkjtvCXSTN2lYFMSss+DdQpwycZJVLXucbyut+i73u/Iz6fnPFpjjI9S+cdR
        g0J/dIxvOBJNnYJD1C4uBU7xXbR1+4qVhgtobBvEm8bhoKKdcTpqxrGer5t0VYkBmsACZe
        vRUV/K5kURJWXfPSyzPU8fl2aMMwBlk=
Date:   Fri, 2 Apr 2021 16:05:54 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, it+linux-x86@molgen.mpg.de
Subject: Re: [regression 5.4.97 =?utf-8?B?4oaSIDUu?= =?utf-8?B?MTAuMjRd?=
 =?utf-8?Q?=3A?= raid6 avx2x4 speed drops from 18429 MB/s to 6155 MB/s
Message-ID: <20210402140554.GG28499@zn.tnic>
References: <6a1b0110-07f1-8c2e-fc7f-379758dbd8ca@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6a1b0110-07f1-8c2e-fc7f-379758dbd8ca@molgen.mpg.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Apr 02, 2021 at 10:33:51AM +0200, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> On an two socket AMD EPYC 7601, we noticed a decrease in raid6 avx2x4 speed
> shown at the beginning of the boot.
> 
>                        5.4.95        5.10.24
> ----------------------------------------------
> raid6: avx2x4 gen()   18429 MB/s     6155 MB/s
> raid6: avx2x4 xor()    6644 MB/s     4274 MB/s
> raid6: avx2x2 gen()   17894 MB/s    18744 MB/s
> raid6: avx2x2 xor()   11642 MB/s    11950 MB/s
> raid6: avx2x1 gen()   13992 MB/s    17112 MB/s
> raid6: avx2x1 xor()   10855 MB/s    11143 MB/s

Looks like those two might help:

49200d17d27d x86/fpu/64: Don't FNINIT in kernel_fpu_begin()
e45122893a98 x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
