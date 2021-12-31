Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEF8C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 31 Dec 2021 08:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhLaIxY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 31 Dec 2021 03:53:24 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50693 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229862AbhLaIxX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 31 Dec 2021 03:53:23 -0500
Received: from [192.168.0.3] (ip5f5aea97.dynamic.kabel-deutschland.de [95.90.234.151])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2AB6961EA1922;
        Fri, 31 Dec 2021 09:53:22 +0100 (CET)
Message-ID: <894a0b65-03ab-1bff-bc9f-cfb48e171678@molgen.mpg.de>
Date:   Fri, 31 Dec 2021 09:53:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] Skip benchmarking of non-best xor_syndrome functions
Content-Language: en-US
To:     =?UTF-8?Q?Dirk_M=c3=bcller?= <dmueller@suse.de>
Cc:     linux-raid@vger.kernel.org
References: <20211229223407.11647-1-dmueller@suse.de>
 <71f0f9ea-1431-a10c-084b-a956a5b9de2f@molgen.mpg.de>
 <4b0faf644530d0f7317bfeb88884f114@suse.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <4b0faf644530d0f7317bfeb88884f114@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Dirk,


Thank you for your reply.


Am 31.12.21 um 09:35 schrieb Dirk Müller:
> Am 2021-12-30 12:33, schrieb Paul 

[…]

>> The new message below is logged?
>>
>>     raid6: skipped pq benchmark and selected …
> 
> its the same message like before, just worded slightly differently. I 
> can undo the wording change if requested.

No, it can stay. I always like to have these things mentioned in the 
commit message though.

[…]


Kind regards,

Paul
