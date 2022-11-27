Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37F5C4321E
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 09:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiK0Jdi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 04:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiK0Jdi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 04:33:38 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF94CF40
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 01:33:35 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ozE2X-0003BP-5y;
        Sun, 27 Nov 2022 09:33:34 +0000
Message-ID: <4c002286-7113-6531-a361-6696df4c912b@youngman.org.uk>
Date:   Sun, 27 Nov 2022 09:33:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
To:     John Stoffel <john@stoffel.org>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <25474.28874.952381.412636@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 26/11/2022 20:02, John Stoffel wrote:
>> Parity raid is still borken...

> So why the hell are you recommending it?
> 
I did say "so long as you don't do anything exotic". Raids 0 and 1 are 
apparently pretty rock solid, so long as you've actually GOT raid 1, see 
my comment about that!

The snapshot issue is supposedly fixed, but that's part of the disk full 
issue. I agree - it's crazy you can't drop a snapshot to recover disk 
space if the disk fills up - hell that should have been one of the FIRST 
things to be made rock solid, not one of the last!

But I do get the impression that btrfs is finally, provided you avoid 
all the EXPERIMENTAL (which is most of them :-) features is a decent 
file system.

Unfortunately, it seems to be typical in the linux world, you have a 
feature which is broken (alsa, ext4, sysVinit, zfs licence etc), and 
when somebody tries to design and write a decent replacement, the 
distros push it out into the "stable distro" world before it's ready. 
And so decent systems get a bad rep while in beta (or even alpha) 
through no fault of the person/team writing them. Mind you, most of 
btrfs is still alpha :-)

And no. The only place I use it is where it's the SUSE default. Not even 
there, maybe, I think it uses it for /home and I share that between 
distros ...

Cheers,
Wol
