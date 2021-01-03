Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AAEC433E0
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 19:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F240D207C9
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 19:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbhACTle (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jan 2021 14:41:34 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:54582 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbhACTle (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 3 Jan 2021 14:41:34 -0500
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2021 14:41:33 EST
Received: from host86-158-105-41.range86-158.btcentralplus.com ([86.158.105.41] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <anthony@youngman.org.uk>)
        id 1kw8u4-0001FJ-8i; Sun, 03 Jan 2021 19:19:01 +0000
Subject: Re: naming system of raid devices
To:     Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, c.buhtz@posteo.jp,
        linux-raid@vger.kernel.org
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
 <5d53fe14-3e61-d3bf-d467-9227c93b11a2@turmel.org>
 <4D7R0G5b5cz9rxP@submission02.posteo.de>
 <9a684c9f-6883-db59-b8fa-0a8b461bd827@grumpydevil.homelinux.org>
From:   Anthony Youngman <anthony@youngman.org.uk>
Message-ID: <f8f20ead-200d-d00b-fc87-7d5db48f3984@youngman.org.uk>
Date:   Sun, 3 Jan 2021 19:19:02 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9a684c9f-6883-db59-b8fa-0a8b461bd827@grumpydevil.homelinux.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/01/2021 22:12, Rudy Zijlstra wrote:
>> I do not see the advantage of creating mdadm.conf.
>> Via fstab I mount the devices by their UUID.
>> And all other information's mdadm needs to use the RAID is stored in the
>> superblock.
>>
>> So information's in mdadm.conf would be redundant. And especially for
>> a non-routine home-admin like me each conf-file I modify keep the
>> possibility of misstakes/missconfigurations and more problems. Keeping
>> it as simple as possible is very important for my environment.
> 
> Nope, it is not redundant. It tells the init system that your UUID is on 
> a raid device, which means it has to wait for the raid devices to be 
> online. Without mdadm.conf it cannot know this.

So it just waits until that UUID appears ...

Dunno whether my system is configured with UUID or device name, but root 
is on an array, and there's no mdadm.conf. Works fine ...

That's why the suggestion is "use eg /dev/md/root".

I'm with the OP. You don't need an mdadm.conf, so don't bother with it.

Cheers,
Wol
