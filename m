Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B89C7618A
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 19:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCST36 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 15:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCST35 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 15:29:57 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E487EFF0F
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 12:29:54 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Pfnxm5YJlzXLN;
        Sun, 19 Mar 2023 20:29:43 +0100 (CET)
Message-ID: <07163ff3-9e2b-72be-8de2-e4d5e9127e36@thelounge.net>
Date:   Sun, 19 Mar 2023 20:29:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
To:     Ram Ramesh <rramesh2400@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 19.03.23 um 19:58 schrieb Ram Ramesh:
>    My primary DVR is old and I need to move it to more recent hardware. 
> I have two md raids (a raid1 and another raid6) called /dev/md0 and 
> /dev/md1. I plan to have root on the new machine on raid1 and thus I 
> like to rename my /dev/md0 to /dev/md1 in the old machine before I move 
> it to the new machine. After that I want to move the disks in the most 
> recommended way to minimize the chance of loss.
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

* create new arrays
* mount both on the new machine (1 disk is enough for RAID1)
* use dd

