Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259BAC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 22 May 2022 13:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbiEVNbM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 May 2022 09:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbiEVNbL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 May 2022 09:31:11 -0400
Received: from mail-out-auth1.hosts.co.uk (mail-out-auth1.hosts.co.uk [195.7.255.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D4363FE
        for <linux-raid@vger.kernel.org>; Sun, 22 May 2022 06:31:06 -0700 (PDT)
Received: from host86-156-102-78.range86-156.btcentralplus.com ([86.156.102.78] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nslfk-0003Q3-6h;
        Sun, 22 May 2022 14:31:04 +0100
Message-ID: <1c65063e-f9e3-444e-649a-5fa6d1606ae6@youngman.org.uk>
Date:   Sun, 22 May 2022 14:31:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Failed adadm RAID array after aborted Grown operation
Content-Language: en-GB
To:     Bob Brand <brand@wmawater.com.au>,
        Reindl Harald <h.reindl@thelounge.net>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au>
 <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk>
 <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au>
 <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk>
 <00d101d86329$a2a57130$e7f05390$@wmawater.com.au>
 <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au>
 <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au>
 <00eb01d86339$18cc0860$4a641920$@wmawater.com.au>
 <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk>
 <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com>
 <04ed01d86c5c$2f632f50$8e298df0$@wmawater.com.au>
 <06995c9b-2dc5-3c0b-9ba1-59be171a7de8@thelounge.net>
 <054401d86d92$3c59cac0$b50d6040$@wmawater.com.au>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <054401d86d92$3c59cac0$b50d6040$@wmawater.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22/05/2022 05:13, Bob Brand wrote:
> Unfortunately, restore from back up isn't an option - after all to where do
> you back up 200TB of data? This storage was originally set up with the
> understanding that it wasn't backed up and so no valuable data was supposed
> to have been stored on it. Unfortunately, people being what they are,
> valuable data has been stored there and I'm the mug now trying to get it
> back - it's a system that I've inherited.
> 
> So, any help or constructive advice would be appreciated.

Unfortunately, about the only constructive advice I can give you is 
"live and learn". I made a similar massive cock-up at the start of my 
career, and I've always been excessively cautious about disks and data 
ever since.

What your employer needs to take away from this - and no disrespect to 
yourself - is that if they run a system that was probably supported for 
about five years, then has been running on duck tape and baling wire for 
a further ten years, DON'T give it to someone with pretty much NO 
sysadmin or computer ops experience to carry out a potentially 
disastrous operation like messing about with a raid array!

This is NOT a simple setup, and it seems clear to me that you have 
little familiarity with the basic concepts. Unfortunately, your employer 
was playing Russian Roulette, and the gun went off.

On a *personal* level, and especially if your employer wants you to 
continue looking after their systems, they need to give you an (old?) 
box with a bunch of disk drives. Go back to the raid website and look at 
the article about building a new system. Take that system they've given 
you, and use that article as a guide to build it from scratch. It's 
actually about the computer being used right now to type this message.

I use(d) gentoo as my distro. It's a great distro, but for a newbie I 
think it takes "throw them in at the deep end" to extremes. Go find 
Slackware and start with that. It's not a "hold their hands and do 
everything for them" distro, but nor is it a "here's the instructions, 
if they don't work for you then you're on your own" distro. Once you've 
got to grips with Slack, have a go at gentoo. And once you've managed to 
get gentoo working, you should have a pretty decent grasp of what's 
going "under the bonnet". CentOS/RedHat/SLES should be a breeze after that.

Cheers,
Wol
