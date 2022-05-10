Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1E5C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 12:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbiEJMjh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 08:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241804AbiEJMj0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 08:39:26 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9392A9CE7
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 05:35:27 -0700 (PDT)
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2CFA161E6478B;
        Tue, 10 May 2022 14:35:26 +0200 (CEST)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <fdabab9e-e0ce-330d-b4db-0a11fde82615@molgen.mpg.de>
 <e50fa5ee-156a-aa22-fc49-390cefa3875f@linux.dev>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <675626ff-f18b-78ab-f5a0-2ee44ab0d399@molgen.mpg.de>
Date:   Tue, 10 May 2022 14:35:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e50fa5ee-156a-aa22-fc49-390cefa3875f@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/10/22 2:09 PM, Guoqing Jiang wrote:
> 
> 
> On 5/10/22 8:01 PM, Donald Buczek wrote:
>>
>>> I guess v2 is the best at the moment. I pushed a slightly modified v2 to
>>> md-next.
>>
>> I think, this can be used to get a double-free from md_unregister_thread.
>>
>> Please review
>>
>> https://lore.kernel.org/linux-raid/8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de/
> 
> That is supposed to be addressed by the second one, pls consider it too.

Right, but this has not been pulled into md-next. I just wanted to note, that the current state of md-next has this problem.

If the other patch is taken, too, and works as intended, that would be solved.

> [PATCH 2/2] md: protect md_unregister_thread from reentrancy

Looks good to me.

Best

   Donald

> 
> Thanks,
> Guoqing


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
