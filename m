Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08554C6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 22:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCSWwF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 18:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCSWwD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 18:52:03 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF661CBCD
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 15:51:52 -0700 (PDT)
Received: from host81-156-202-200.range81-156.btcentralplus.com ([81.156.202.200] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pe1sS-00008G-FW;
        Sun, 19 Mar 2023 22:51:49 +0000
Message-ID: <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
Date:   Sun, 19 Mar 2023 22:51:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-GB
To:     Ram Ramesh <rramesh2400@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19/03/2023 18:58, Ram Ramesh wrote:
> Hi,
> 
>    My primary DVR is old and I need to move it to more recent hardware. 
> I have two md raids (a raid1 and another raid6) called /dev/md0 and 
> /dev/md1. I plan to have root on the new machine on raid1 and thus I 
> like to rename my /dev/md0 to /dev/md1 in the old machine before I move 
> it to the new machine. After that I want to move the disks in the most 
> recommended way to minimize the chance of loss.

Do you have an mdadm.conf, or do the arrays auto-assemble without one?
> 
>    Since the data is large and usually contains recordings and videos 
> that have backup on Hulu/Ultraviolet, I worry less about backup. Still 
> it will be big task to repopulate all my data from the source and 
> therefore prefer not to do stupid things and loose the data.
> 
>   Online search showed me a way to rename using just mdadm.conf and that 
> did not work at all. In fact it messed up my raid6 that I had a panic 
> for a short time. Luckily, I got everything back working normally. So, I 
> am not sure which one of the online instructions to follow to rename my 
> /dev/md0 to /dev/md1 before the move. So, I thought best to ask here.

Your raid shouldn't be named md0 (md1) at all. By default they now count 
down from md127 (I think ...)

If you're going to give it a name, give it a name like "root", or 
"data", or "home". But I've found that very tricky post-facto - it's 
best done when the array is first created.
> 
>    Also, once I renamed /dev/md0 to /dev/md1, I want to move all 6 disks 
> in raid6 to the new machine. What is the correct procedure so that after 
> the movement, I will be able to reboot both the old machine without 
> raid6 (ie /dev/md1)and the new machine with the moved disks as /dev/md1? 
> Ideally, I like to teach my old machine to forget /dev/md1 that I want 
> to move and not touch the disks. If I do not do that, I am afraid my 
> reboot (of the old machine) will get stuck at some point trying to look 
> for the missing disks/md. All online tutorial talks about how to 
> assemble on new machine. Does not talk about gracefully removing an md 
> from an old machine. I want to know if there is any trick to this other 
> than shutting down and pulling all disks and rebooting.
> 
>    Old host runs debian bullseye (linux 5.19, mdadm v4.1) and new will 
> run debian testing/bookworm (linux 6.1,  mdadm v4.2).  Let me know if 
> you need anymore information.

Old host, new host ...

Sounds to me like the best way to move the raid would simply be to 
transfer the disks across. The new system should just recognise the 
array. If it doesn't you can just put the disks back in the old system.

What I would NOT do is put the old disks in the new system and then 
build it. Make sure the new system is up and running before you move the 
disks across. (There have been reports of 
installers/updates/stuff-like-that not recognising raids and trashing them.)
> 
> Thanks and Regards
> Ramesh
> 
https://raid.wiki.kernel.org/index.php/Linux_Raid

Dunno where you looked on-line, but this is the best place. Any 
improvements you think of, let me know.

Cheers,
Wol
