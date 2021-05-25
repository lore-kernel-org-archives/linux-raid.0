Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F96AC2B9F8
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 16:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0526140F
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 16:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhEYQuh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 12:50:37 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:41222 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhEYQug (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 25 May 2021 12:50:36 -0400
Received: from host86-157-72-169.range86-157.btcentralplus.com ([86.157.72.169] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1llaEq-0008Iq-8w; Tue, 25 May 2021 17:49:04 +0100
Subject: Re: Spurious bad blocks on RAID-5
To:     David Woodhouse <dwmw2@infradead.org>, linux-raid@vger.kernel.org
References: <254383d7670ce90f3230fb1b16276dd0c56672e4.camel@infradead.org>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <03a8ce28-3699-6dd9-b3ad-baf1e6dd8668@youngman.org.uk>
Date:   Tue, 25 May 2021 17:49:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <254383d7670ce90f3230fb1b16276dd0c56672e4.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 25/05/2021 01:41, David Woodhouse wrote:
> I see no actual I/O errors on the underlying drives, and S.M.A.R.T
> reports them healthy. Yet MD thinks I have bad blocks on three of them
> at exactly the same location:
> 
> Bad-blocks list is empty in /dev/sda3
> Bad-blocks list is empty in /dev/sdb3
> Bad-blocks on /dev/sdc3:
>           13086517288 for 32 sectors
> Bad-blocks on /dev/sdd3:
>           13086517288 for 32 sectors
> Bad-blocks on /dev/sde3:
>           13086517288 for 32 sectors
> 
> That seems very unlikely to me. FWIW those ranges are readable on the
> underlying disks, and contain all zeroes.
> 
> Is the best option still to reassemble the array with
> '--update=force-no-bbl'? Will that*clear*  the BBL so that I can
> subsequently assemble it with '--update=bbl' without losing those
> sectors again?

A lot of people swear AT md badblocks. If you assemble with force 
no-bbl, the recommendation will be to NOT re-enable it.

Personally, I'd recommend using dm-integrity rather than badblocks, but 
that (a) chews up some disk space, and (b) is not very well tested with 
mdraid at the moment.

For example, md-raid should NEVER have any permanent bad blocks, because 
it's a logical layer, and the physical layer will fix it behind raid's 
back. But raid seems to accumulate and never clear bad-blocks ...

Cheers,
Wol
