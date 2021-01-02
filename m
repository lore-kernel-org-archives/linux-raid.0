Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B16C433E0
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 17:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E000207A1
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 17:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbhABRjn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Jan 2021 12:39:43 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:11316 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbhABRjn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 2 Jan 2021 12:39:43 -0500
Received: from host86-158-105-41.range86-158.btcentralplus.com ([86.158.105.41] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kvkrl-0005TV-3g; Sat, 02 Jan 2021 17:39:01 +0000
Subject: Re: naming system of raid devices
To:     c.buhtz@posteo.jp, linux-raid@vger.kernel.org
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
 <5d53fe14-3e61-d3bf-d467-9227c93b11a2@turmel.org>
 <4D7R0G5b5cz9rxP@submission02.posteo.de>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <5FF0B8F9.3090501@youngman.org.uk>
Date:   Sat, 2 Jan 2021 18:18:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <4D7R0G5b5cz9rxP@submission02.posteo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/01/21 15:39, c.buhtz@posteo.jp wrote:
> Thanks to you and all other answers. It helped me a lot to understand
> the backgrounds.
> 
> On 2021-01-01 14:09 Phil Turmel <philip@turmel.org> wrote:
>> I recommend creating an mdadm.conf file containing ARRAY entries for 
>> your desired setup.  Trim those lines to only have the desired name
>> and UUID.
> 
> Maybe I should open a new thread for that topic?
> Please correct me, because I am not an usual admin nor an mdadm expert.
> 
> I do not want to convince you with the following! I just want to bring
> up my point of view and my opinion to make it possible for you experts
> to "correct" me. ;)
> 
> I do not see the advantage of creating mdadm.conf.
> Via fstab I mount the devices by their UUID.
> And all other information's mdadm needs to use the RAID is stored in the
> superblock.

As the guy who looks after the wiki, none of my systems (to my best
knowledge) have or have had an mdadm.conf. There's supposed to be a way
to create it automagically from the current running config, but I've
never managed to get to grips with it ...
> 
> So information's in mdadm.conf would be redundant. And especially for
> a non-routine home-admin like me each conf-file I modify keep the
> possibility of misstakes/missconfigurations and more problems. Keeping
> it as simple as possible is very important for my environment.
> 
>> Once you are sure it works, I also recommend adding AUTO=-all to 
>> mdadm.conf, so any extra arrays you might plug in temporarily won't 
>> auto-assemble if still plugged in during boot.
> 
> I do not understand this. What does "auto-assemble" means? You mean if
> I plug in a SDD/HDD with a mdadm-created superblock?
> 
It's what happens when a system boots - as each drive is recognised,
it's added to an array until the array has enough drives to function. In
other words, rather than doing an mdadm assemble command with all the
drives, it's doing an assemble with just one drive at a time saying "add
to the relevant array".

If you've disabled auto-assemble, presumably you do need mdadm.conf to
tell mdadm what to assemble, which presumably also means you can't have
root on a raid because boot needs the array to find mdadm.conf in order
to start the array ... Don't quote me on that ...

Cheers,
Wol
