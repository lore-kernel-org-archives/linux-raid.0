Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526CBC433DB
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 15:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A0520782
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 15:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbhABPkl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Jan 2021 10:40:41 -0500
Received: from mout01.posteo.de ([185.67.36.65]:43910 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbhABPkk (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 2 Jan 2021 10:40:40 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 31824160061
        for <linux-raid@vger.kernel.org>; Sat,  2 Jan 2021 16:39:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.jp; s=2017;
        t=1609601983; bh=TwHOX83NBRjdr0/4DWs0xJ9y4gWb9ESN9LdJHahWB/o=;
        h=Date:From:To:Subject:From;
        b=qJ9/jqb6dTWedqrBJY2ko+kZQwZAOoyGNuYZkCeVk05jBfh/zmQi0XMkljzIbVy8Z
         EiSRv4r+mTBbSCLv5V3250k9C8x3aWEhgg6eOGL1ViLS7MVAIRaOOIfOklgNrw+38v
         m0gylxl9ppR1hgWFYRU59LVIfrSksOi69HB6lElKpyJRkOiZRp0XKbZ6LtKjV3AHlw
         nCpsET3WfOS1x2TdrTHvj7lGUtlOkD/9lP9Xlh2qkFNsTsdaHZiM0YhWJaiFyjuH+c
         bpCf/nAkSGuBzeQVvHi6lrovUJCMr7a93okfVbDPWM9byZsMmRep4sX/TY3e8kHiqE
         ydDFab6z+4CNw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4D7R0G3yf4z9rxM
        for <linux-raid@vger.kernel.org>; Sat,  2 Jan 2021 16:39:42 +0100 (CET)
Date:   Sat, 2 Jan 2021 16:39:38 +0100
From:   <c.buhtz@posteo.jp>
To:     linux-raid@vger.kernel.org
Subject: Re: naming system of raid devices
In-Reply-To: <5d53fe14-3e61-d3bf-d467-9227c93b11a2@turmel.org>
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
        <5d53fe14-3e61-d3bf-d467-9227c93b11a2@turmel.org>
Followup-To: linux-raid@vger.kernel.org
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <4D7R0G5b5cz9rxP@submission02.posteo.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks to you and all other answers. It helped me a lot to understand
the backgrounds.

On 2021-01-01 14:09 Phil Turmel <philip@turmel.org> wrote:
> I recommend creating an mdadm.conf file containing ARRAY entries for 
> your desired setup.  Trim those lines to only have the desired name
> and UUID.

Maybe I should open a new thread for that topic?
Please correct me, because I am not an usual admin nor an mdadm expert.

I do not want to convince you with the following! I just want to bring
up my point of view and my opinion to make it possible for you experts
to "correct" me. ;)

I do not see the advantage of creating mdadm.conf.
Via fstab I mount the devices by their UUID.
And all other information's mdadm needs to use the RAID is stored in the
superblock.

So information's in mdadm.conf would be redundant. And especially for
a non-routine home-admin like me each conf-file I modify keep the
possibility of misstakes/missconfigurations and more problems. Keeping
it as simple as possible is very important for my environment.

> Once you are sure it works, I also recommend adding AUTO=-all to 
> mdadm.conf, so any extra arrays you might plug in temporarily won't 
> auto-assemble if still plugged in during boot.

I do not understand this. What does "auto-assemble" means? You mean if
I plug in a SDD/HDD with a mdadm-created superblock?
