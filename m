Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EB0C2B9F8
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 17:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F27D611C2
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 17:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhEYRvS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 13:51:18 -0400
Received: from mail.thelounge.net ([91.118.73.15]:55475 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhEYRvS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 13:51:18 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4FqM6L25dKzXN3;
        Tue, 25 May 2021 19:49:46 +0200 (CEST)
Subject: Re: Spurious bad blocks on RAID-5
To:     antlists <antlists@youngman.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-raid@vger.kernel.org
References: <254383d7670ce90f3230fb1b16276dd0c56672e4.camel@infradead.org>
 <03a8ce28-3699-6dd9-b3ad-baf1e6dd8668@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <bb85ee01-f93e-8184-973d-1c46d56016fa@thelounge.net>
Date:   Tue, 25 May 2021 19:49:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <03a8ce28-3699-6dd9-b3ad-baf1e6dd8668@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 25.05.21 um 18:49 schrieb antlists:
> On 25/05/2021 01:41, David Woodhouse wrote:
>> I see no actual I/O errors on the underlying drives, and S.M.A.R.T
>> reports them healthy. Yet MD thinks I have bad blocks on three of them
>> at exactly the same location:
>>
>> Bad-blocks list is empty in /dev/sda3
>> Bad-blocks list is empty in /dev/sdb3
>> Bad-blocks on /dev/sdc3:
>>           13086517288 for 32 sectors
>> Bad-blocks on /dev/sdd3:
>>           13086517288 for 32 sectors
>> Bad-blocks on /dev/sde3:
>>           13086517288 for 32 sectors
>>
>> That seems very unlikely to me. FWIW those ranges are readable on the
>> underlying disks, and contain all zeroes.
>>
>> Is the best option still to reassemble the array with
>> '--update=force-no-bbl'? Will that*clear*  the BBL so that I can
>> subsequently assemble it with '--update=bbl' without losing those
>> sectors again?
> 
> A lot of people swear AT md badblocks. If you assemble with force 
> no-bbl, the recommendation will be to NOT re-enable it.
> 
> Personally, I'd recommend using dm-integrity rather than badblocks, but 
> that (a) chews up some disk space, and (b) is not very well tested with 
> mdraid at the moment.
> 
> For example, md-raid should NEVER have any permanent bad blocks, because 
> it's a logical layer, and the physical layer will fix it behind raid's 
> back. But raid seems to accumulate and never clear bad-blocks ...

and why is that crap implemented in a way that replace a disk with bad 
blocks don't reset the bad blocks for the given device?

that's pervert
