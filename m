Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99912C4332F
	for <linux-raid@archiver.kernel.org>; Sun,  4 Dec 2022 13:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiLDNyR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 4 Dec 2022 08:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiLDNyQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 4 Dec 2022 08:54:16 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDBC13F1D
        for <linux-raid@vger.kernel.org>; Sun,  4 Dec 2022 05:54:13 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1p1pRb-0001pf-ES
        for linux-raid@vger.kernel.org;
        Sun, 04 Dec 2022 13:54:11 +0000
Message-ID: <86410eab-5a5a-8f9b-7b67-c9ecd10ae128@youngman.org.uk>
Date:   Sun, 4 Dec 2022 13:54:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: batches and serial numbers
Content-Language: en-GB
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo> <20221128142422.GM19721@jpo>
 <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
 <20221203054130.GP19721@jpo>
 <1e419d58-46d8-affa-36dc-ef8c14760305@youngman.org.uk>
 <20221203180425.GU19721@jpo>
 <38fdcd1b-2122-1f06-8dfe-5b2f8ffa8670@youngman.org.uk>
 <20221204024711.GE19721@jpo>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20221204024711.GE19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 04/12/2022 02:47, David T-G wrote:
> % like 'em, but they're not good in raid. And the BarraCudas even less so!
> % I've got a nasty feeling your X300s are the same!
> 
> They have been good to me so far.  I was originally going to get N300s,
> but I couldn't at the time, and the X300s read as the same for everything
> I could find.  Does your N300 have ERC with a short timeout enabled by
> default?

Well, Phil Turmell (one of the best recovery guys here) has N300s as his 
"go to" drives. I trust his judgement :-)

When I did my search on X300s, they come over as being "fast 
high-performance desktop drives". And manufacturers have pretty much 
deleted ERC from desktop drives!

Given that these are CMR, though, I guess Toshiba thought "high 
performance, we need ERC to prevent disk hangs".

Whereas Barracudas were good desktop workhorse drives, and the 
BarraCudas are aimed at the same market. The BarraCudas are SMR, and 
presumably come with a big enough cache to guarantee decent desktop 
performance, but they aren't aimed at the performance market.

Good to know the X300s aren't going to drop people in it ...

Cheers,
Wol
