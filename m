Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D9DC433ED
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 10:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A17D61154
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 10:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245265AbhDFK61 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:58:27 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:58755 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245259AbhDFK60 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 6 Apr 2021 06:58:26 -0400
Received: from [141.14.14.84] (v084.vpnx.molgen.mpg.de [141.14.14.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 13CFF206473CA;
        Tue,  6 Apr 2021 12:58:16 +0200 (CEST)
Subject: =?UTF-8?B?UmU6IFtyZWdyZXNzaW9uIDUuNC45NyDihpIgNS4xMC4yNF06IHJhaWQ2?=
 =?UTF-8?Q?_avx2x4_speed_drops_from_18429_MB/s_to_6155_MB/s?=
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, it+linux-x86@molgen.mpg.de,
        =?UTF-8?Q?Krzysztof_Ol=c4=99dzki?= <ole@ans.pl>,
        Andy Lutomirski <luto@kernel.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>
References: <6a1b0110-07f1-8c2e-fc7f-379758dbd8ca@molgen.mpg.de>
 <20210402140554.GG28499@zn.tnic>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <05dbb237-1d23-df32-e4ed-6bc7b47f42dc@molgen.mpg.de>
Date:   Tue, 6 Apr 2021 12:58:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210402140554.GG28499@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Borislav,


Am 02.04.21 um 16:05 schrieb Borislav Petkov:
> On Fri, Apr 02, 2021 at 10:33:51AM +0200, Paul Menzel wrote:

>> On an two socket AMD EPYC 7601, we noticed a decrease in raid6 avx2x4 speed
>> shown at the beginning of the boot.
>>
>>                         5.4.95        5.10.24
>> ----------------------------------------------
>> raid6: avx2x4 gen()   18429 MB/s     6155 MB/s
>> raid6: avx2x4 xor()    6644 MB/s     4274 MB/s
>> raid6: avx2x2 gen()   17894 MB/s    18744 MB/s
>> raid6: avx2x2 xor()   11642 MB/s    11950 MB/s
>> raid6: avx2x1 gen()   13992 MB/s    17112 MB/s
>> raid6: avx2x1 xor()   10855 MB/s    11143 MB/s
> 
> Looks like those two might help:
> 
> 49200d17d27d x86/fpu/64: Don't FNINIT in kernel_fpu_begin()
> e45122893a98 x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state

I booted Linux 5.12-rc6, containing these commits, on a Dell OptiPlex 
5055 with AMD Ryzen 5 PRO 1500 Quad-Core Processor, and the regression 
is still present for `avx2x4 xor()`:

                         5.4.95       5.10.24
----------------------------------------------
raid6: avx2x4 gen()    23964 MB/s   24540 MB/s 

raid6: avx2x4 xor()    13101 MB/s    8354 MB/s
raid6: avx2x2 gen()    22746 MB/s   26972 MB/s
raid6: avx2x2 xor()    14917 MB/s   16463 MB/s
raid6: avx2x1 gen()    17519 MB/s   24394 MB/s
raid6: avx2x1 xor()    14091 MB/s   15330 MB/s
raid6: sse2x4 gen()    16867 MB/s   16136 MB/s
raid6: sse2x4 xor()     9667 MB/s    8176 MB/s
raid6: sse2x2 gen()    14996 MB/s   18234 MB/s
raid6: sse2x2 xor()    10765 MB/s   10455 MB/s
raid6: sse2x1 gen()     7667 MB/s   13769 MB/s
raid6: sse2x1 xor()     7818 MB/s    7741 MB/s

What system are you using, and what results do you get with 5.4 and 
5.12-rc6?


Kind regards,

Paul
