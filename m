Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2223C64E7B
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF00321527
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbgK1VuQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:16 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:28275 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732385AbgK1SHo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 28 Nov 2020 13:07:44 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kj4KC-0002UW-FB
        for linux-raid@vger.kernel.org; Sat, 28 Nov 2020 17:47:56 +0000
Subject: Re: Assemble RAID on new machine but with missing devices
To:     linux-raid@vger.kernel.org
References: <4CjVhl4nSbz6tm9@submission01.posteo.de>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <b5d9ee39-3be6-381b-78ac-93b500255945@youngman.org.uk>
Date:   Sat, 28 Nov 2020 17:47:58 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <4CjVhl4nSbz6tm9@submission01.posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/11/2020 23:10, c.buhtz@posteo.jp wrote:
> Hello,
> 
> I red some stuff about assembling mode for mdadm. But two points are
> unclear for me.
> 
> 1. Missing devices
> I have two HDDs in a RAID1 - only data, no OS, on them. I want to
> physical remove one HDD and plug it into a new server machine. Then I
> want to bring the RAID1 online again on the new machine but with one
> existing and one missing drive.
> Background: When finished I will plug in a new fresh HDD as the second
> one to the new server.

It's fairly certain that the array will - initially - refuse to run. 
That's a safety feature - if an array is damaged while shut down, it 
won't come back without intervention.

Put the single disk in your new system. As I say, it's unlikely it'll 
start straight away. "cat /proc/mdstat" and if the array is there in a 
failed state, stop it. Then you can re-assemble it and it should come up 
degraded. All you have to do after that is replace the non-existent 
drive with your new replacement, and you'll have a functioning array.
> 
> 2. mdadm.conf
> On the web I read sometimes about modifying mdadm.conf on the new
> machine. But I do not understand why. If so. Why and what do I have to
> modify in the mdadm.conf?
> 
If you've even got one ...

I don't know the history of it, but the early arrays did not have 
superblocks, so mdadm.conf - an ACCURATE - mdadm.conf was essential. Now 
they've got superblocks, it's optional and - to the best of my knowledge 
- none of my systems have mdadm.conf's.

Do you have a superblock? Preferably v1 (1.0, 1.1 or 1.2). If you do, 
don't worry about it, it's old advice, and while it's good to have an 
up-to-date mdadm.conf to tell *you* what's what, the system doesn't need it.

Cheers,
Wol
