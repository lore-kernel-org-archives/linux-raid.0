Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BCCC28CF5
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 12:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiAZMM5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 07:12:57 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:32827 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233952AbiAZMM4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 Jan 2022 07:12:56 -0500
Received: from [192.168.0.2] (ip5f5aecd1.dynamic.kabel-deutschland.de [95.90.236.209])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D6B2F61EA191D;
        Wed, 26 Jan 2022 13:12:55 +0100 (CET)
Message-ID: <e2e25fc9-ff40-9183-6ca7-fab4708fa1d0@molgen.mpg.de>
Date:   Wed, 26 Jan 2022 13:12:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/3] lib/raid6/test/Makefile: Use `$(pound)` instead of
 `\#` for Make 4.3
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Matt Brown <matthew.brown.dev@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
 <0214ae2639174812948a631ac4e142c8@AcuMS.aculab.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <0214ae2639174812948a631ac4e142c8@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear David,


Am 26.01.22 um 13:06 schrieb David Laight:
> From: Paul Menzel
>> Sent: 26 January 2022 11:42
> ..
>> +pound := \#
> 
> Please use 'hash' not 'pound'.
> Only american greengrocers use that horrid name.
> 
> A 'pound' is '£'.

Sure, I can change that, if you send a patch cleaning this up for the 
other files already using that in the tree? ;-) Or can it be different 
all over the Linux code base?


Kind regards,

Paul


PS:

> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

If you care, the standard signature delimiter is `-- ` [1].


[1]: https://en.wikipedia.org/wiki/Signature_block#Standard_delimiter
