Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB90C63777
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 20:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4333A2073C
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 20:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgK3UwU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:52:20 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:42646 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgK3UwU (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 15:52:20 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kjq94-0002Qx-7y; Mon, 30 Nov 2020 20:51:38 +0000
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
To:     David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
Date:   Mon, 30 Nov 2020 20:51:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130200503.GV1415@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/11/2020 20:05, David T-G wrote:
> You don't see any "filesystem" or, more correctly, partition in your
> 
>    fdisk -l
> 
> output because you have apparently created your filesystem on the entire
> device (hey, I didn't know one could do that!). 

That, actually, is the norm. It is NOT normal to partition a raid array.

It's also not usual (which the OP has done) to create a raid array on 
top of raw devices rather than partitions - although this is down to the 
fact that various *other* utilities seem to assume that an unpartitioned 
device is free space that can be trampled on. Every now and then people 
seem to lose their arrays because an MBR or GPT has mysteriously 
appeared on the disk.

> That conclusion is
> supported by your mount point (/dev/md127 rather than /dev/md127p1 or
> similar) and your fstab entry (same).
> 
> So the display isn't interesting, although the logic behind that approach
> certainly is to me.

Your approach seems to be at odds with *normal* practice, although there 
is nothing wrong with it. At the end of the day, as far as linux is 
concerned, one block device is much the same as any other.

Cheers,
Wol
