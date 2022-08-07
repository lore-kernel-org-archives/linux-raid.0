Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1622AC19F2A
	for <linux-raid@archiver.kernel.org>; Sun,  7 Aug 2022 20:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiHGUge (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 Aug 2022 16:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHGUgd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 7 Aug 2022 16:36:33 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FCE62FC
        for <linux-raid@vger.kernel.org>; Sun,  7 Aug 2022 13:36:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659904536; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=hv5A7ZXJtalcNLIMVumJ1QxY083GzZMnSqy0489ZdFLCsoHUbyPpp0t7yHosCvHkiBiSQ6qz5mxZ08ylko/FL4Ub8n/bncNn3eM/POYZLMHZZbAO/CnxvM/jLNWT0Dd0SFMs6cojjeSg4TLQb0P+VQ3O6OBWObJUSQWNTo4Kvjo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1659904536; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=u3X73oLgU0XzNH6P3bFB60Z8rpSwnlc5unmxcRZ2SGU=; 
        b=eZUk9O376AbewqUTgdvjIWWajkH/yZC7jOdIVZLz7q2RQok62Iwi66D++dnRl4eozVTTzt7dh2SDj6m2E6poyZxMAqG8nHAG19slRbqofvsSF+L1wOIsF5xvkfNhy/EYswNlxBBZdaYZZww0eOOQLvqky8j8G53em/aD5Y1FJlU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.20.4.58] (207.253.54.47 [207.253.54.47]) by mx.zoho.eu
        with SMTPS id 1659904532366612.9263557146029; Sun, 7 Aug 2022 22:35:32 +0200 (CEST)
Message-ID: <1dcd5807-b7ab-f405-2209-d3d5d1220e4a@trained-monkey.org>
Date:   Sun, 7 Aug 2022 16:35:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220622202519.35905-1-logang@deltatee.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/22/22 16:25, Logan Gunthorpe wrote:
> Hi,
> 
> This series tries to clean up the testing infrastructure to be a bit
> more reliable. It doesn't fix all the broken tests but annotates those
> that I see as broken so testing can continue. V2 includes changes
> requested in the feedback so far.
> 
> As such, I've fixed all the kernel panics (in md-next now) and segfaults
> that caused testing to halt regardless of whether --keep-going was
> passed. I've also included some patches posted to the list from Sudhakar
> and Himanshu which fix some more broken tests.
> 
> I've also included a patch which adds the --loop option to ./test which
> runs tests for a specified number of iterations (or indefinitely if zero
> is specified). This was very useful for ferreting out tests that failed
> randomly.
> 
> The last two patches adds some infrastructure and annotation for known
> broken tests so that they don't stop the processing (even if
> --keep-going is not passed). Tests that are known to be broken  can
> optionally be skipped with the --skip-broken or --skip-always-broken
> flags.
> 
> With these changes it's possible to run './test --loop=0' for several
> days without stopping.
> 
> There are still a number of broken tests which need more work, and there
> may be other issues on other people's systems (kernel configurations,
> etc) but that will have to be left to other developers.
> 
> The tests that are still broken for me in one way or another are:
>    01r5integ, 01raid6integ, 04r5swap.broken, 04update-metadata,
>    07autoassemble, 07autodetect, 07changelevelintr, 07changelevels,
>    07reshape5intr, 07revert-grow, 07revert-shrink, 07testreshape5,
>    09imsm-assemble, 09imsm-create-fail-rebuild, 09imsm-overlap,
>    10ddf-assemble-missing, 10ddf-fail-create-race,
>    10ddf-fail-two-spares, 10ddf-incremental-wrong-order,
>    14imsm-r1_2d-grow-r1_3d, 14imsm-r1_2d-takeover-r0_2d,
>    18imsm-r10_4d-takeover-r0_2d, 18imsm-r1_2d-takeover-r0_1d,
>    19raid6auto-repair, 19raid6repair.broken
> 
> Details on how they are broken can be found in the last patch.
> 
> This series is based on the current kernel.org master (190dc029) and
> a git repo can be found here:
> 
>    https://github.com/lsgunth/mdadm bugfixes_v2

Applied,

I am traveling and brought a new laptop, without the SSH key I need to 
push, so I'll push things next week when I get home.

Thanks,
Jes

