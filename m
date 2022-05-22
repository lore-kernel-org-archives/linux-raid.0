Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF88C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 22 May 2022 22:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiEVWy2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 May 2022 18:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiEVWy0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 May 2022 18:54:26 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 183DD37ABC
        for <linux-raid@vger.kernel.org>; Sun, 22 May 2022 15:54:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 4A36819F373;
        Mon, 23 May 2022 08:54:23 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id zwgreKbiTEZ3; Mon, 23 May 2022 08:54:23 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 17C7419F375;
        Mon, 23 May 2022 08:54:23 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au 17C7419F375
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1653260063;
        bh=jLQtwE77z05ux+N8knkVuJeBlUf/qfGnwLBBX5xheXs=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=PFDZArssk7aqShCedFAa5RiibCxBCOQRmD/VHuI/R9lmHuCa5H3B+cq8tCFwJ9GfJ
         BWtOz7wqdJSzFT3LFHUCb6akQmA2bBQbrHU14f/vNoW+XeYpTesfbXaHccQtXcLbRF
         0yK3zvVOT9HyAZwZrEhIKhDotaqwdlAZkSGVKmHc=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id plPMiDqv2STq; Mon, 23 May 2022 08:54:22 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id D6AB619F373;
        Mon, 23 May 2022 08:54:22 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Wols Lists" <antlists@youngman.org.uk>,
        "Reindl Harald" <h.reindl@thelounge.net>,
        "Roger Heflin" <rogerheflin@gmail.com>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Phil Turmel" <philip@turmel.org>, "NeilBrown" <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk> <00d101d86329$a2a57130$e7f05390$@wmawater.com.au> <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au> <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au> <00eb01d86339$18cc0860$4a641920$@wmawater.com.au> <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk> <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com> <04ed01d86c5c$2f632f50$8e298df0$@wmawater.com.au> <06995c9b-2dc5-3c0b-9ba1-59be171a7de8@thelounge.net> <054401d86d92$3c59cac0$b50d6040$@wmawater.com.au> <1c65063e-f9e3-444e-649a-5fa6d1606ae6@youngman.org.uk>
In-Reply-To: <1c65063e-f9e3-444e-649a-5fa6d1606ae6@youngman.org.uk>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Mon, 23 May 2022 08:54:22 +1000 (AEST)
Message-ID: <057301d86e2e$e0bb1e60$a2315b20$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P1de8 T376c R35192)
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dAGZ0oLFAdWidsoCQWnqlQI7z0N+AMQVcYoBrcfnAQHzgz42AmhhXhgCKCXVgAHcFtH1qr8LCvA=
Content-Language: en-au
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks Wol.

I can't really disagree with anything you've said except to mention that I 
do have a fair bit of experience (20+ years) but it's all been pretty much 
Microsoft/Windows and hardware RAID.

Like I said this device was never meant to be used for critical data - if 
nothing else this has been something of a wake-up call for us.



-----Original Message-----
From: Wols Lists <antlists@youngman.org.uk>
Sent: Sunday, 22 May 2022 11:31 PM
To: Bob Brand <brand@wmawater.com.au>; Reindl Harald 
<h.reindl@thelounge.net>; Roger Heflin <rogerheflin@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>; Phil Turmel 
<philip@turmel.org>; NeilBrown <neilb@suse.com>
Subject: Re: Failed adadm RAID array after aborted Grown operation

On 22/05/2022 05:13, Bob Brand wrote:
> Unfortunately, restore from back up isn't an option - after all to
> where do you back up 200TB of data? This storage was originally set up
> with the understanding that it wasn't backed up and so no valuable
> data was supposed to have been stored on it. Unfortunately, people
> being what they are, valuable data has been stored there and I'm the
> mug now trying to get it back - it's a system that I've inherited.
>
> So, any help or constructive advice would be appreciated.

Unfortunately, about the only constructive advice I can give you is "live 
and learn". I made a similar massive cock-up at the start of my career, and 
I've always been excessively cautious about disks and data ever since.

What your employer needs to take away from this - and no disrespect to 
yourself - is that if they run a system that was probably supported for 
about five years, then has been running on duck tape and baling wire for a 
further ten years, DON'T give it to someone with pretty much NO sysadmin or 
computer ops experience to carry out a potentially disastrous operation like 
messing about with a raid array!

This is NOT a simple setup, and it seems clear to me that you have little 
familiarity with the basic concepts. Unfortunately, your employer was 
playing Russian Roulette, and the gun went off.

On a *personal* level, and especially if your employer wants you to continue 
looking after their systems, they need to give you an (old?) box with a 
bunch of disk drives. Go back to the raid website and look at the article 
about building a new system. Take that system they've given you, and use 
that article as a guide to build it from scratch. It's actually about the 
computer being used right now to type this message.

I use(d) gentoo as my distro. It's a great distro, but for a newbie I think 
it takes "throw them in at the deep end" to extremes. Go find Slackware and 
start with that. It's not a "hold their hands and do everything for them" 
distro, but nor is it a "here's the instructions, if they don't work for you 
then you're on your own" distro. Once you've got to grips with Slack, have a 
go at gentoo. And once you've managed to get gentoo working, you should have 
a pretty decent grasp of what's going "under the bonnet". CentOS/RedHat/SLES 
should be a breeze after that.

Cheers,
Wol



CAUTION!!! This E-mail originated from outside of WMA Water. Do not click 
links or open attachments unless you recognize the sender and know the 
content is safe.


