Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50CBC28D13
	for <linux-raid@archiver.kernel.org>; Fri, 19 Aug 2022 22:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243168AbiHSWwZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 Aug 2022 18:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243127AbiHSWwY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 19 Aug 2022 18:52:24 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D950A10B51F
        for <linux-raid@vger.kernel.org>; Fri, 19 Aug 2022 15:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:From:To:MIME-Version:Date:Message-ID:cc
        :references:content-disposition:in-reply-to;
        bh=0CL1/PS7kYJ8voaCxBV5rWmIhHn5w+1Q84bRxOLEXr4=; b=mNkPUjSzSrln1Nu+e3xaiQYbbY
        9TbXnNdo91JfHWiafiNYzPkMh2kxNx5aUBbTfzSzvTp4UprefwJc+hVcTbBEptQKWG3tiB3K3M2Y0
        TT+QDzYchYX3Gv6d00QaWrsOiADx0Ib8p1aufsC4XWGE1fHrhTZWZMXK6HK57enN9YK8UpWZVVb1Q
        FMqbMu7/BAMsN0Eo+IsBvk75SDcD6kLx0PI9MD9w0Ev0pC7Wko1SV5H4hX/DR16bcoeKBP3g0q7jd
        rDofeOoAHBdgTAVMFy0/wdOqRKKOvjz+wGN9xpnjpfeH7v/OPbSxb21ErAiAfp+/yhUDoegFvOe9r
        6UE/V4Kw==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oPAqh-003J1Z-9g; Fri, 19 Aug 2022 16:52:20 -0600
Message-ID: <e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com>
Date:   Fri, 19 Aug 2022 16:52:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
From:   Logan Gunthorpe <logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: song@kernel.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: raid5 Journal Recovery Bug
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

I'm wondering if you can help shed some light on a bug I'm trying to
track down.

We're hitting the BUG_ON in handle_parity_checks5() that tests to ensure
R5_UPTODATE is set for a failed disk in a stripe[1].

We hit this in our test suite somewhat rarely when the journal is
enabled doing device removal and recovery tests. We've concocted a test
that can hit it in under ten minutes.

After some debugging I've found that the stripe that hits the BUG_ON is
hitting a conditional in handle_stripe_fill() for stripes that are in
the journal with a failed disk[2]. This check was added in 2017 by your
patch:

   07e83364845e ("md/r5cache: shift complex rmw from read path to write
path")

A stripe that hits the bug has one injournal dev, and one failed dev and
does not have STRIPE_R5C_CACHING set and therefore hits the conditional
and returns from handle_stripe_fill() without calling fetch_block() or
doing anything else to change the flow of execution. Normally,
fetch_block() would set STRIPE_COMPUTE_RUN to recompute the missing
disk, however that gets skipped for this case. After returning from
handle_stripe_fill(), handle_stripe() will then call
handle_parity_checks5() because STRIPE_COMPUTE_RUN was not set and this
will immediately hit the BUG_ON, because nothing has computed the disk
and set it UPTODATE yet.

I can't say I fully understand the patch that added this, so I don't
really understand why that conditional is there or what it's trying to
accomplish and thus I don't know what the correct solution might be.

Any thoughts?

Thanks,

Logan


[1]
https://elixir.bootlin.com/linux/v6.0-rc1/source/drivers/md/raid5.c#L4381
[2]
https://elixir.bootlin.com/linux/v6.0-rc1/source/drivers/md/raid5.c#L4050

