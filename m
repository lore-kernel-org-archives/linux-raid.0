Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36F8C433DB
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 21:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 650F82076D
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 21:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbhABVpt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Jan 2021 16:45:49 -0500
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:47916 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbhABVpt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Jan 2021 16:45:49 -0500
Received: from [212.54.42.136] (helo=smtp12.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kvoht-0004yL-7T; Sat, 02 Jan 2021 22:45:05 +0100
Received: from 94-214-94-139.cable.dynamic.v4.ziggo.nl ([94.214.94.139] helo=imail.office.romunt.nl)
        by smtp12.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kvohs-0007eP-Rh; Sat, 02 Jan 2021 22:45:04 +0100
Received: from [192.168.30.63] (arya.office.romunt.nl [192.168.30.63])
        by imail.office.romunt.nl (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 102Lj0Ho018049;
        Sat, 2 Jan 2021 22:45:01 +0100
Subject: Re: naming system of raid devices
To:     Wols Lists <antlists@youngman.org.uk>, c.buhtz@posteo.jp,
        linux-raid@vger.kernel.org
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
 <5d53fe14-3e61-d3bf-d467-9227c93b11a2@turmel.org>
 <4D7R0G5b5cz9rxP@submission02.posteo.de> <5FF0B8F9.3090501@youngman.org.uk>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <5fa87ae8-957b-7112-f2d3-d450e1f6bdb9@grumpydevil.homelinux.org>
Date:   Sat, 2 Jan 2021 22:44:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <5FF0B8F9.3090501@youngman.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Virus-Scanned: clamav-milter 0.102.3 at hermes
X-Virus-Status: Clean
X-SourceIP: 94.214.94.139
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.4 cv=PISxRdmC c=1 sm=1 tr=0 ts=5ff0e960 a=MLz4jdL9LhxtSH7CRyKX8g==:17 a=N659UExz7-8A:10 a=EmqxpYm9HcoA:10 a=tXFoFzo5SyDQM-CVkQ0A:9 a=pILNOxqGKmIA:10
X-Ziggo-Spam-Status: No
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02-01-2021 19:18, Wols Lists wrote:
> On 02/01/21 15:39, c.buhtz@posteo.jp wrote:
>>
>> I do not see the advantage of creating mdadm.conf.
>> Via fstab I mount the devices by their UUID.
>> And all other information's mdadm needs to use the RAID is stored in the
>> superblock.
> As the guy who looks after the wiki, none of my systems (to my best
> knowledge) have or have had an mdadm.conf. There's supposed to be a way
> to create it automagically from the current running config, but I've
> never managed to get to grips with it ...
It's easy and in the man page. Several options actually. I typically use:
mdadm --examine --scan > <output file>
I than check the outputfile, if i agree add it to the distro mdadm.conf 
and re-generate the initrd/initramfs or however the distro calls it.

As i often have my boot disk on an array, i want predictability... thus 
i use mdadm.conf in the initrd.

Without mdadm.conf there is no predictability, as order of disk 
detection can, and sometimes indeed does, change.
>> So information's in mdadm.conf would be redundant. And especially for
>> a non-routine home-admin like me each conf-file I modify keep the
>> possibility of misstakes/missconfigurations and more problems. Keeping
>> it as simple as possible is very important for my environment.
mdadm.conf is your friend :)
>>
>>> Once you are sure it works, I also recommend adding AUTO=-all to
>>> mdadm.conf, so any extra arrays you might plug in temporarily won't
>>> auto-assemble if still plugged in during boot.
This is the start of a philosophical discussion. In other words, 
different minds have different preferences.
>> I do not understand this. What does "auto-assemble" means? You mean if
>> I plug in a SDD/HDD with a mdadm-created superblock?
>>
> It's what happens when a system boots - as each drive is recognised,
> it's added to an array until the array has enough drives to function. In
> other words, rather than doing an mdadm assemble command with all the
> drives, it's doing an assemble with just one drive at a time saying "add
> to the relevant array".
>
> If you've disabled auto-assemble, presumably you do need mdadm.conf to
> tell mdadm what to assemble, which presumably also means you can't have
> root on a raid because boot needs the array to find mdadm.conf in order
> to start the array ... Don't quote me on that ...
nope. The suggestion here is to define the raids you need in mdadm.conf, 
and then disable auto-creation to prevent surprises from temporarily 
connected disks.

Cheers

Rudy

