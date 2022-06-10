Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BA6C43334
	for <linux-raid@archiver.kernel.org>; Fri, 10 Jun 2022 15:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiFJP1w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Jun 2022 11:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiFJP1s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Jun 2022 11:27:48 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922B71CB
        for <linux-raid@vger.kernel.org>; Fri, 10 Jun 2022 08:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=QRlq01VtLXAiJW/7xk1dgzDErhc+pM0ErSk3ouiNZIM=; b=p4DWV3vtxreO6aFsh8EHvVF12h
        LY0N3JHLBDyRqhiY5+fuYXK0D3mn2fscBHa6/YYjfHahHKyz40HeiS/0zsRbvlBxcfG4EZoNLuYpk
        8dGLgqTjgricXYM2Xwqye9PaEWhnRUAFuwkNIKTFwSkPpMdTmyNjZSEpiJQRpQHxyWmmPbNnheZWU
        9CJ16RHdf0Ll873oiBHujAlMMXAWJpn4RJnN5RAUnPTbtRxz7S0CGHvlozKtVwgszviHPpk8UHP8f
        UF9f84w90c0CDXRvkWgbPbpTyjUhbZDjCGMhoq5IN6KGqd+8GBbnk0tedl/+FerU9tLDgesinRnww
        Lij05SaA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nzgY4-003sOb-2r; Fri, 10 Jun 2022 09:27:44 -0600
Message-ID: <421ac1f7-87fa-6550-7b3e-8d3109b3a946@deltatee.com>
Date:   Fri, 10 Jun 2022 09:27:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-CA
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220609211130.5108-1-logang@deltatee.com>
 <fdcc3343-9aca-b8df-8960-0ea8ba8f13b0@molgen.mpg.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <fdcc3343-9aca-b8df-8960-0ea8ba8f13b0@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: pmenzel@molgen.mpg.de, linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v1 00/14] Bug fixes and testing improvments
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-06-10 04:14, Paul Menzel wrote:
> Dear Logan,
> 
> 
> Am 09.06.22 um 23:11 schrieb Logan Gunthorpe:
> 
> […]
> 
>> There are still a number of broken tests which need more work, and there
>> may be other issues on other people's systems (kernel configurations,
>> etc) but that will have to be left to other developers.
> 
> Thank you for all your work. Can you list the broken tests, you
> encountered, in the cover letter?

For full details of broken tests (after this series) see patch 14.

Here they are again:

01r5integ.broken
01raid6integ.broken
04r5swap.broken
07autoassemble.broken
07autodetect.broken
07changelevelintr.broken
07changelevels.broken
07reshape5intr.broken
07revert-grow.broken
07revert-shrink.broken
07testreshape5.broken
09imsm-assemble.broken
09imsm-create-fail-rebuild.broken
09imsm-overlap.broken
10ddf-assemble-missing.broken
10ddf-fail-create-race.broken
10ddf-fail-two-spares.broken
10ddf-incremental-wrong-order.broken
14imsm-r1_2d-grow-r1_3d.broken
14imsm-r1_2d-takeover-r0_2d.broken
18imsm-r10_4d-takeover-r0_2d.broken
18imsm-r1_2d-takeover-r0_1d.broken
19raid6auto-repair.broken
19raid6repair.broken

I don't have a comprehensive list of tests that were fixed by this
series (or my kernel series) as some of the fixes fixed multiple tests
that I didn't keep track of.

Logan
