Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF4FC678D5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Mar 2023 08:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCHIOp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Mar 2023 03:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCHIOp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Mar 2023 03:14:45 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96B427D6E
        for <linux-raid@vger.kernel.org>; Wed,  8 Mar 2023 00:14:38 -0800 (PST)
Received: from host86-157-72-214.range86-157.btcentralplus.com ([86.157.72.214] helo=[192.168.1.99])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pZowW-0003hF-G4;
        Wed, 08 Mar 2023 08:14:37 +0000
Message-ID: <5d1fb871-80b7-a82a-25b5-14b156eec802@youngman.org.uk>
Date:   Wed, 8 Mar 2023 08:14:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: What's the usage of md-autodetect.c
Content-Language: en-GB
To:     Xiao Ni <xni@redhat.com>, Geoff Back <geoff@demonlair.co.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>
References: <CALTww2-1B08z+BgPKqoBMnGQ-PhB9Yr=bA7YR7HyzGX0K127MQ@mail.gmail.com>
 <2b52d846-054b-6265-21dc-b091b39b0ee9@demonlair.co.uk>
 <CALTww2-7O2Fj3E8gmLDb_XPb0NGARqvHXp3oJaDMeWFue_=yGQ@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CALTww2-7O2Fj3E8gmLDb_XPb0NGARqvHXp3oJaDMeWFue_=yGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 08/03/2023 02:40, Xiao Ni wrote:
>> (IIRC) get built if CONFIG_MD is set to M.  Changing the default for
>> CONFIG_MD should not have any impact on this so long as the ability to
>> set CONFIG_MD=y does not get disabled (which would also be a regression).
> I'm a little confused here. If I understand right, for the os that

> doesn't use initrd
> and we still have the ability to set CONFIG_MD=y, so we can set it to
> y and rebuild
> the kernel. So the raid1 can be assembled by md auto-detect, right?
> 
Bear in mind that - iirc - in order for the kernel to auto-assemble a raid-1

(a) it has to be superblock 0.9
(b) superblock 0.9 is deprecated

So the functionality is still used, still "supported", but we make no 
promises ...

If it breaks, I'm sure people will scream and fix it, but from our point 
of view it's "if it ain't broke don't touch it".

Cheers,
Wol
