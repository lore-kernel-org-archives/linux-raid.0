Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA2DC433DB
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 02:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDC964DCC
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 02:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhA1CUG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jan 2021 21:20:06 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:33400 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhA1CUE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Jan 2021 21:20:04 -0500
Received: from host86-162-184-82.range86-162.btcentralplus.com ([86.162.184.82] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1l4vfA-000BLZ-5I; Thu, 28 Jan 2021 00:59:56 +0000
Subject: Re: "attempt to access beyond end of device" when reshaping raid10
 from near=2 to offset=2
To:     Daniel Gnoutcheff <gnoutchd@softwarefreedom.org>,
        linux-raid@vger.kernel.org
References: <09505ed1-ad29-28f1-627e-8a6a0b8df3a4@softwarefreedom.org>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <bfbf7ae7-b443-4559-38ba-d7b9710792ba@youngman.org.uk>
Date:   Thu, 28 Jan 2021 00:59:56 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <09505ed1-ad29-28f1-627e-8a6a0b8df3a4@softwarefreedom.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/01/2021 22:15, Daniel Gnoutcheff wrote:
> Greets,
> 
> Whilst experimenting with array reshaping, I've found that if I create a 
> near=2 raid10 like so:

I seem to remember this coming up very recently. And I also seem to 
remember them coming up with fixes but I'm not sure if it's solved.

So if you search the archive you should find a recent thread and an 
update should fix it properly soon.

Oh - and as for Stretch, old mdadm and Ubuntu are known to be, shall we 
say, problematic when you reshape an array, so please try not to ... :-)

Cheers,
Wol
