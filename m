Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065B2C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 14:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346978AbiC3Okz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 10:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347029AbiC3Okw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 10:40:52 -0400
Received: from titan.nuclearwinter.com (titan.nuclearwinter.com [IPv6:2603:c020:4000:e500::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE35577A
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 07:39:03 -0700 (PDT)
Received: from [10.0.0.102] (unknown [10.0.0.102])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by titan.nuclearwinter.com (Postfix) with ESMTPSA id B0AF3B8A1F;
        Wed, 30 Mar 2022 10:39:02 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com B0AF3B8A1F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1648651142;
        bh=85E54NCn/vEIjrVZRcmiETHnUzr1fFC8qOa0OsY6DdI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cnWypoTcwYbur9osIyP1Cy57BL8FnWYpE9mh40/txGRLZKsh60LAUKUqXUsrlBMIO
         nK9Fesh7y2RhHfo5pgY/OatFsPHx7kFUTsFaKczdguwWc1XVhprCMPbpn1RS+oFn7Z
         f5Dgr7RgZZOVF8xGXtBX8SRA3yp20PJuT65u9Rpc=
Message-ID: <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com>
Date:   Wed, 30 Mar 2022 10:39:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
In-Reply-To: <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thank you for investigating and resolving this issue. Your effort is 
very much appreciated.

I am interested in when this patch will end up in a release. Is it going 
to make it into a 5.17.x release or will it not come until 5.18?

--Larkin

On 3/11/2022 11:59 AM, Song Liu wrote:
> Hi Jens,
>
> On Fri, Mar 11, 2022 at 6:16 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 3/10/22 5:07 PM, Jens Axboe wrote:
>>> In any case, just doing larger reads would likely help quite a bit, but
>>> would still be nice to get to the bottom of why we're not seeing the
>>> level of merging we expect.
>> Song, can you try this one? It'll do the dispatch in a somewhat saner
>> fashion, bundling identical queues. And we'll keep iterating the plug
>> list for a merge if we have multiple disks, until we've seen a queue
>> match and checked.
> This one works great! We are seeing 99% read request merge and
> 500kB+ average read size. The original patch in this thread only got
> 88% and 34kB for these two metrics.
>
> Thanks,
> Song
>
> [...]

