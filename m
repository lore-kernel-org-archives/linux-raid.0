Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68C0C47088
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 20:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiLCUHy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 15:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLCUHx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 15:07:53 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84BC1128
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 12:07:50 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1p1Ync-000BRt-Fl
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 20:07:49 +0000
Message-ID: <38fdcd1b-2122-1f06-8dfe-5b2f8ffa8670@youngman.org.uk>
Date:   Sat, 3 Dec 2022 20:07:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: batches and serial numbers (was "Re: md vs LVM and VMs and ...")
Content-Language: en-GB
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo> <20221128142422.GM19721@jpo>
 <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
 <20221203054130.GP19721@jpo>
 <1e419d58-46d8-affa-36dc-ef8c14760305@youngman.org.uk>
 <20221203180425.GU19721@jpo>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20221203180425.GU19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/12/2022 18:04, David T-G wrote:
> % It's why my raid is composed of a Seagate Barracuda 3TB (slap wrist, don't
> % use Barracudas!), 2 x 4TB Seagate Ironwolves, and 1 Toshiba 8TB N300.
> 
> These are Tosh X300s, FWIW.  Like 'em so far!

OUCH !!!

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

Do the X300s have ERC, and what's the timeout? Barracudas are nice 
drives, I like 'em, but they're not good in raid. And the BarraCudas 
even less so! I've got a nasty feeling your X300s are the same!

I said it's easy to get slices kicked out due to misconfiguration - 
that's exactly what happens with Barracudas, and I suspect your X300s 
suffer the exact same problem ...

Read up, and come back if you've got any problems. The fix is that 
script, but it means if anything goes wrong you're going to be cursing 
"that damn slow computer".

Cheers,
Wol
