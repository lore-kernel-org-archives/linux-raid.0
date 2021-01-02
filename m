Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAB4C433DB
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 22:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA04320798
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 22:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbhABWN1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:13:27 -0500
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:51744 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbhABWN1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Jan 2021 17:13:27 -0500
Received: from [212.54.42.135] (helo=smtp11.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kvp8f-0008Vo-9I; Sat, 02 Jan 2021 23:12:45 +0100
Received: from 94-214-94-139.cable.dynamic.v4.ziggo.nl ([94.214.94.139] helo=imail.office.romunt.nl)
        by smtp11.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kvp8f-0001zo-4L; Sat, 02 Jan 2021 23:12:45 +0100
Received: from [192.168.30.63] (arya.office.romunt.nl [192.168.30.63])
        by imail.office.romunt.nl (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 102MCeAd018237;
        Sat, 2 Jan 2021 23:12:41 +0100
Subject: Re: naming system of raid devices
To:     c.buhtz@posteo.jp, linux-raid@vger.kernel.org
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
 <5d53fe14-3e61-d3bf-d467-9227c93b11a2@turmel.org>
 <4D7R0G5b5cz9rxP@submission02.posteo.de>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <9a684c9f-6883-db59-b8fa-0a8b461bd827@grumpydevil.homelinux.org>
Date:   Sat, 2 Jan 2021 23:12:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <4D7R0G5b5cz9rxP@submission02.posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Virus-Scanned: clamav-milter 0.102.3 at hermes
X-Virus-Status: Clean
X-SourceIP: 94.214.94.139
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.4 cv=Gq78Rm5C c=1 sm=1 tr=0 ts=5ff0efdd a=MLz4jdL9LhxtSH7CRyKX8g==:17 a=IkcTkHD0fZMA:10 a=EmqxpYm9HcoA:10 a=RPUKk7Z6AAAA:8 a=f4o0ZnlcV5qeIW4TryIA:9 a=QEXdDO2ut3YA:10 a=ns9jL1NFIDDRZyFTcKrG:22
X-Ziggo-Spam-Status: No
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02-01-2021 16:39, c.buhtz@posteo.jp wrote:
> Thanks to you and all other answers. It helped me a lot to understand
> the backgrounds.
>
> On 2021-01-01 14:09 Phil Turmel <philip@turmel.org> wrote:
>> I recommend creating an mdadm.conf file containing ARRAY entries for
>> your desired setup.  Trim those lines to only have the desired name
>> and UUID.
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
>
> So information's in mdadm.conf would be redundant. And especially for
> a non-routine home-admin like me each conf-file I modify keep the
> possibility of misstakes/missconfigurations and more problems. Keeping
> it as simple as possible is very important for my environment.

Nope, it is not redundant. It tells the init system that your UUID is on 
a raid device, which means it has to wait for the raid devices to be 
online. Without mdadm.conf it cannot know this.
