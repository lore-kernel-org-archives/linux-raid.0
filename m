Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AD4C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 21:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD5261A09
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 21:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238191AbhCXVMH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Mar 2021 17:12:07 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:12027 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhCXVLj (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Mar 2021 17:11:39 -0400
Received: from host86-155-154-65.range86-155.btcentralplus.com ([86.155.154.65] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lPAmv-000CPy-4q
        for linux-raid@vger.kernel.org; Wed, 24 Mar 2021 21:11:37 +0000
Subject: Re: MDRaid Rollback
To:     linux-raid@vger.kernel.org
References: <CA+OzjxLW2Vw-ecs7jNELecpYxoBbK767pXEV8rFVaQp_HXfjOg@mail.gmail.com>
 <20210324144407.GL3712@bitfolk.com>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <605BB43C.5020201@youngman.org.uk>
Date:   Wed, 24 Mar 2021 21:50:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20210324144407.GL3712@bitfolk.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/03/21 14:44, Andy Smith wrote:
> But, this being a RAID-1 you have at least two devices so wouldn't
> it be safer to:
> 
> - Fail out one device
> - Zero that device
> - Create new filesystem on the removed device
> - Copy data onto it from the still-running array that is currently
>   degraded
> - Use new filesystem for whatever you wanted

Better yet just get another drive and copy it across. You can always do
a "dd if=/dev/md0 of=/dev/sdc1" or whatever is appropriate. (And before
anyone asks, I'm planning to copy a filesystem that way, because it's
chokker with hard links. I *really* don't want to cp the contents ...)

BUT. If you really do want to break the mirror (as I might, just to see
what happens :-), then your best bet is to add a third disk, let it
sync, then fail it off and play with that disk.

As the others said, if you have a 0.9 or 1.0 superblock, your filesystem
starts in the same place as your partition, so if you delete the
superblock the partition becomes non-raid. But if your superblock is 1.1
or 1.2, then that won't work.

Cheers,
Wol
