Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821B0C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 17 Jan 2022 21:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243301AbiAQVkJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Jan 2022 16:40:09 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:25991 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230312AbiAQVkJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 Jan 2022 16:40:09 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1n9ZjT-000CG1-3y;
        Mon, 17 Jan 2022 21:40:07 +0000
Message-ID: <210ecc45-fcc9-4e54-9c27-b5bb2d44c445@youngman.org.uk>
Date:   Mon, 17 Jan 2022 21:40:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: raid6: badblocks-related bio panics
Content-Language: en-GB
To:     Joe Rayhawk <jrayhawk@fairlystable.org>, linux-raid@vger.kernel.org
References: <164244747275.86917.2623783912687807916@richardiv.omgwallhack.org>
From:   Wol <antlists@youngman.org.uk>
Cc:     NeilBrown <neilb@suse.com>
In-Reply-To: <164244747275.86917.2623783912687807916@richardiv.omgwallhack.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/01/2022 19:24, Joe Rayhawk wrote:
> I don't understand how badblocks got into this inconsistent state or how
> to uncorruptedly get it out of this state without copying the entire
> array; if anyone has pointers, I would be glad to hear them.

How it got into this state is probably easy. Various people on the list 
say "don't use badblocks !!!" - it's a mess. The easy way to fix that is 
simply to assemble the array with --force-no-badblocks or whatever.

The concern with that is if the problem is actually nothing to do with 
badblocks itself, and everything to do with what's underneath them. So 
don't be too hasty.

I'll leave it to the experts to dig into your problem in more detail.

Cheers,
Wol
