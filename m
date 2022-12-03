Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFC7C4332F
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 12:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiLCMGg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 07:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLCMGf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 07:06:35 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E008ACC8
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 04:06:33 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1p1RHr-0009pp-By
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 12:06:31 +0000
Message-ID: <1e419d58-46d8-affa-36dc-ef8c14760305@youngman.org.uk>
Date:   Sat, 3 Dec 2022 12:06:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: md vs LVM and VMs and ... (was "Re: md RAID0 can be grown (was
 ...")
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo> <20221128142422.GM19721@jpo>
 <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
 <20221203054130.GP19721@jpo>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20221203054130.GP19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/12/2022 05:41, David T-G wrote:
> % I had different side disks, so I made raid5 so that I first joined example
> % 1TB and 2TB together with md linear so I could add that as member to other
> % 3TB raid5 pool.
> 
> The good news here is that I don't mix disk sizes; all of these are not
> only the same size but, for the foreseeable future, the exact same model.

 From the exact same batch? That's BAD news actually.

Now that disk sizes have been standardised (and the number of actual 
factories/manufacturers seriously reduced), it should be that a 1TB 
drive is a 1TB drive is a 1TB drive. Decimal, that is, not binary. So 
there *shouldn't* be any problems swapping one random drive out for another.

But if all your drives are the same make, model(, and batch), there is a 
not insignificant risk they will all share the same defects, and fail at 
the same time. It's accepted the risk is small, but it's there.

It's why my raid is composed of a Seagate Barracuda 3TB (slap wrist, 
don't use Barracudas!), 2 x 4TB Seagate Ironwolves, and 1 Toshiba 8TB N300.

Cheers,
Wol
