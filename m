Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1413C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 14:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B823F60F94
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 14:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbhG3OUe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Jul 2021 10:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239362AbhG3OUA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Jul 2021 10:20:00 -0400
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159CBC0613D3
        for <linux-raid@vger.kernel.org>; Fri, 30 Jul 2021 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=73USCSMOp7RUdmHWvWhFehraXwP/PtjrrV0cNYwnCBA=; b=UYRD4q+6ydXjMoMg/v+Samd5ec
        boQ1ZTJ9sxlJJ1Wa8Q3t0rX4eOXE9UD0uAbNqjwOoggnPuuqCnJl0AikNO/qD9CC4vs4DqOMenni4
        rWpI0+QhRI0U+00iAyu5YdRlYAL1dV7gavupbtJQDljJSRe0GqQ3isIKfry91ZUgB4lv42diptTI5
        m7aaHkGh2uC7fXq6Gg2edVrOL1YdrFYIwaWJ7kRyOwkes3P5nBuCPZMwCABj4R2t0h/0e/POXC4St
        OFf449HqPBDzfI7klgwXZw9SU1Z5rPIPRY0bIg8KPbb2JxaAuAiGu2cTsrlys95X3wuLETv6wPlFA
        hwQO+hkQ==;
Received: from b2b-5-147-245-69.unitymedia.biz ([5.147.245.69] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1m9TMF-0052rv-Pc   id 1m9TMF-0052rv-Pcby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Fri, 30 Jul 2021 14:19:27 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1m9SOK-004Hzz-Ea
        for <linux-raid@vger.kernel.org>; Fri, 30 Jul 2021 15:17:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24835.64492.166839.611174@cyme.ty.sabi.co.uk>
Date:   Fri, 30 Jul 2021 15:17:32 +0200
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS - AMD ROME what am I missing?????
In-Reply-To: <CD53203D-6A23-40F8-9FD4-A60019F67B37@gmail.com>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
        <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
        <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
        <21187A73-4000-4017-B016-15C03D19B799@madmonks.org>
        <5EAED86C53DED2479E3E145969315A23858415CB@UMECHPA7B.easf.csd.disa.mil>
        <EF5FF3B7-927D-44E5-89CE-CEB86BB225FF@madmonks.org>
        <CD53203D-6A23-40F8-9FD4-A60019F67B37@gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>> On Fri, 30 Jul 2021 16:45:32 +0800, Miao Wang
>>> <shankerwangmiao@gmail.com> said:

> [...] was also stuck in a similar problem and finally gave
> up. Since it is very difficult to find such environment with
> so many fast nvme drives, I wonder if you have any interest in
> ZFS. [...]

Or Btrfs or the new 'bachefs' which is OK for simple
configurations (RAID10-like).

But part of the issue here with MD RAID is that it is in theory
mostly a translation layer like 'loop', but also sort of like a
virtual block device too, and weird things happen as IO requests
get reshape and requeued.

My impression that I mentioned in a previous message is that
probably the critical detail is:


>> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
>> nvme0n1       1317510.00    0.00 5270044.00      0.00     0.00     0.00   0.00   0.00    0.31    0.00 411.95     4.00     0.00   0.00 100.40
>> [...]
>> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
>> nvme0n1       114589.00    0.00 458356.00      0.00     0.00     0.00   0.00   0.00    0.29    0.00  33.54     4.00     0.00   0.01 100.00

> The obvious difference is the factor of 10 in "aqu-sz" and that
> correspond to the factor of 10 in "r/s" and "rkB/s".

That may happen because the test is run directly on the 'md[01]'
block device, which can do odd things. Counterintutively much
bigger 'aqu-sz' and thus much better speed could be achieved by
doing the test using a suitable filesystem on top of the 'md[01]'
device.

With ZFS there is a good chance that since striping is integrated
within ZFS that could happen too, especially on highly parallel
workloads.

There is however a huge warning: the test is run on IOPS with
4KiB blocks, and ZFS in COW mode does not work well with that
(especially for writes, but also for reads, if compression and
checksumming are enabled, for RAIDz) so I think that it should be
run with COW disabled, or perhaps on a 'zvol'.
