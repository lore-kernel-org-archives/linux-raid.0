Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9326EC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72AEA63227
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 09:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhKPJzW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 04:55:22 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:45421 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233669AbhKPJzN (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Nov 2021 04:55:13 -0500
Received: from [192.168.0.2] (ip5f5aecf5.dynamic.kabel-deutschland.de [95.90.236.245])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id F255361EA191E;
        Tue, 16 Nov 2021 10:52:15 +0100 (CET)
Message-ID: <f08f5e72-dcf4-7f89-21eb-e293b3db0dbf@molgen.mpg.de>
Date:   Tue, 16 Nov 2021 10:52:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
Content-Language: en-US
To:     Markus Hochholdinger <Markus@hochholdinger.net>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, xni@redhat.com
References: <20211112142822.813606-1-markus@hochholdinger.net>
 <91d75292-401f-3788-63aa-f3c9aca8841c@molgen.mpg.de>
 <2299535.YZZJjEnbGj@enterprise>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <2299535.YZZJjEnbGj@enterprise>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Markus,


Am 16.11.21 um 10:44 schrieb Markus Hochholdinger:

> Am Dienstag, 16. November 2021, 10:24:17 CET schrieb Paul Menzel:

[…]

>> Am 12.11.21 um 15:28 schrieb markus@hochholdinger.net:
>>> From: Markus Hochholdinger <markus@hochholdinger.net>
>>> The superblock of version 1.0 doesn't get moved to the new position on a
>>> device size change. This leads to a rdev without a superblock on a known
>>> position, the raid can't be re-assembled.
>>> Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super
>>> 1.0")
>> I think it’s common to not write *commit* in there, but just the short
>> hash. `scripts/checkpatch.pl` does not mention that, but it mentions:
>>       ERROR: Missing Signed-off-by: line(s)
>>       total: 1 errors, 0 warnings, 7 lines checked
> 
> I'm sorry, this was my first patch request against the linux kernel.

Awesome. We all started with that.

> Within https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> tree/Documentation/process/submitting-patches.rst I read to sign off a patch if
> it is from me, but the line was there before. So I thought I don't have to
> sign it.

No, even reverts have to be signed off.

> Should I do the patch request again with Signed-off information?

Yes, please do, and maybe amend the commit message, to mention, that the 
line was removed by mistake, and is added back.

You can create a v2 easily with the `git send-email` switch below:

     -v <n>, --reroll-count=<n>

You can also add the Reviewed-by lines you already got.

[…]


Kind regards,

Paul
