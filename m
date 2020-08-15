Return-Path: <SRS0=Kmql=BZ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8759FC433DF
	for <linux-raid@archiver.kernel.org>; Sat, 15 Aug 2020 21:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E9423B24
	for <linux-raid@archiver.kernel.org>; Sat, 15 Aug 2020 21:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgHOVnp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 15 Aug 2020 17:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgHOVno (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 15 Aug 2020 17:43:44 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD2AC03D1C5
        for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2020 14:43:44 -0700 (PDT)
Received: from 108-243-25-188.lightspeed.tukrga.sbcglobal.net ([108.243.25.188] helo=[192.168.20.239])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1k73xk-00036q-6r; Sat, 15 Aug 2020 21:43:40 +0000
Subject: Re: Confusing output of --examine-badblocks1 message
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
References: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net>
 <2053545579.22464117.1597329096623.JavaMail.zimbra@karlsbakk.net>
 <303847410.22535373.1597344622629.JavaMail.zimbra@karlsbakk.net>
 <573421659.22903312.1597428439621.JavaMail.zimbra@karlsbakk.net>
 <de6e9dd1-7447-54ab-1818-ceabf422c8a0@turmel.org>
 <1188544829.565.1597512803014.JavaMail.zimbra@karlsbakk.net>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <044f2487-6489-4d5a-c391-8977c02185a0@turmel.org>
Date:   Sat, 15 Aug 2020 17:43:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1188544829.565.1597512803014.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/15/20 1:33 PM, Roy Sigurd Karlsbakk wrote:
>> In my not-so-humble opinion, the bug is the existence of the BadBlocks
>> feature.  Once a badblock is recorded for a sector, redundancy is
>> permanently lost at that location.  There is no tool to undo this.
>>
>> I strongly recommend that you remove badblock logs on all arrays before
>> the "feature" screws you.
> 
> I think it has screwed me a bit already, but then, I didn't check until recently. I didn't even know about this "feature". But doesn't help much when those "badblocks" are recorded already. What would be the official way to remove them apart from rebuild the whole array?

That's the biggest problem.  There is no way to remove sectors from the 
badblocks log.  At least, I've not seen one.  Official or otherwise.

What I don't understand is how this feature ended up in mdadm without 
any way to reverse the addition of entries, particularly since *you 
silently lose redundancy*.

> A friend of mine wrote a thing in python to remove the badblocks list from an offline array. I haven't dared to test it on a live system, but apparently it worked on his (5 drives in RAID-5 IIRC with three of them showing a list identical of badblocks). You can find the code here https://git.thehawken.org/hawken/md-badblocktool.git

This would be the first. /:

> Vennlig hilsen
> 
> roy


Phil
