Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9DCC4332F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 14:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKYOXk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Nov 2022 09:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiKYOXk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Nov 2022 09:23:40 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A264286D9
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 06:23:38 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oyZc9-0001b4-3E;
        Fri, 25 Nov 2022 14:23:37 +0000
Message-ID: <008f8ea9-5c01-dc69-8d35-787b8a286378@youngman.org.uk>
Date:   Fri, 25 Nov 2022 14:23:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: about linear and about RAID10 (was "Re: how do i fix these RAID5
 arrays?")
Content-Language: en-GB
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20221125133050.GH19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 25/11/2022 13:30, David T-G wrote:
> % Either version (10, or 1+0), gives you get the speed of striping, and the
> % safety of a mirror. 10, however, can use an odd number of disks, and disks
> % of random sizes.
> 
> That's still magic to me 😄  Mirroring (but not doubling up the
> redundancy) on an odd number of disks?!?

Disk:     a   b   c

Stripe:   1   1   2
           2   3   3
           4   4   5
           5   6   6

and so on.

I was trying to work out how I'd smear them a lot more randomly, but it 
was a nightmare. Iirc, no matter how many drives you have, (for two 
copies) it seems that drive a is only mirrored to drives b and c, for 
any value of a. So if you lose drive a, and then either b or c, you are 
guaranteed to lose half a drive of contents.

It also means that replacing a failed drive will hammer just two drives 
to replace it and not touch the others. I wanted to try and spread stuff 
far more evenly so it read from all the other drives, not just two. 
Okay, it increases the risk that you will lose *some* data to a double 
failure, but reduces the *amount* of data at risk (and also reduces the 
risk of a double failure!). Because if the first failure *provokes* the 
second, data loss is pretty much guaranteed.

Cheers,
Wol
