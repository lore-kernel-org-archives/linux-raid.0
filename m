Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D31AC4727C
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 20:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4247D2074B
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 20:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgI3UQP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 16:16:15 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:14572 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729504AbgI3UQP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Sep 2020 16:16:15 -0400
Received: from host86-157-96-171.range86-157.btcentralplus.com ([86.157.96.171] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kNiWI-0006j5-FQ; Wed, 30 Sep 2020 21:16:11 +0100
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
To:     David Madore <david+ml@madore.org>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
 <5F740390.7050005@youngman.org.uk>
 <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
 <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
 <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
 <5F74D684.8020005@youngman.org.uk>
 <20200930194510.vki7zixjca6sxvin@achernar.gro-tsen.net>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <bfe9949c-1b46-baa3-1a89-0d994175dc95@youngman.org.uk>
Date:   Wed, 30 Sep 2020 21:16:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930194510.vki7zixjca6sxvin@achernar.gro-tsen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/09/2020 20:45, David Madore wrote:
> On Wed, Sep 30, 2020 at 08:03:32PM +0100, Wols Lists wrote:
>> On 30/09/20 19:58, David Madore wrote:
>>> mdadm - v4.1 - 2018-10-01
>>>
>>> - which I think is roughly contemporaneous to the kernel version I'm
>>> using.  But the problem still persists (with the exact same symptoms
>>> and details).
>>
>> Except that mdadm is NOT the problem. The problem is that the kernel and
>> mdadm are not matched date-wise, and because the kernel is a
>> franken-kernel you need to use a different kernel.
> 
> I don't understand what you mean by "matched date-wise".  The kernel
> I'm using is a longterm support branch (4.9) which was frozen at the
> same approximate date as the mdadm I just installed.  And it was also
> the same longterm support branch that was used in the Debian oldstable
> (9 aka stretch).  Do you mean that there is no mdadm version which is
> compatible with the 4.9 kernels?  How often does the mdadm-kernel
> interface break compatibility?

The problem is that if you use mdadm 3.4 with kernel 4.9.237, the 237 
means that your kernel has been heavily updated and is far too new. But 
if you use mdadm 4.1 with kernel 4.9.237, the 4.9 means that the kernel 
is basically a very old one - too old for mdadm 4.1

As I said, the problem is the kernel - it is, at heart, an ancient 
kernel. And it hasn't been regression tested for raid reshapes. And what 
the problem is, we don't know exactly, nor do we particularly care, 
sorry. So long as your data isn't lost, the response here is pretty much 
the same as elsewhere, unfortunately - "run an up-to-date system".
> 
>> Use a rescue disk!!! That way, you get a kernel and an mdadm that are
>> the same approximate date. As it stands, your frankenkernel is too new
>> for mdadm 3.4, but too ancient for a modern kernel.
> 
> Using a rescue disk would mean taking the system down for longer than
> I can afford (I can afford to have this particular partition down for
> a long time, but not the whole system...  which unfortunately resides
> on the same disks).  So I'd like to keep this as a very last resort,
> or at least, not consider it until I've fully understood what's going
> on.  (It's especially problematic that I have absolutely no idea of
> the speed at which I can expect the reshape to take place, compared to
> an ordinary resync.  If you could give me a ballpark figure, it would
> help me decide.  My disks resync at ~120MB/sec, and the RAID array I
> wish to reshape is ~900GB in per partition, so it takes a few hours to
> do an "ordinary" resync: I assume a reshape will take much longer, but
> how much longer are we talking?)

What do you mean by a resync? Do you mean replacing a drive? Because I 
can't speak for certain, but I wouldn't expect a reshape to take much 
longer.

If you don't want to take the system down to use a rescue disk, I don't 
really know what to suggest. You could revert your kernel back to a 
4.9.x where x is a single digit, and it would probably work. Or you 
could install a modern 5.9 or similar kernel, but that might well break 
a load of other stuff. Or just upgrade to a new Debian/Ubuntu ... any of 
them *should* work, but the only options we'd recommend would be to 
upgrade your distro, or use a rescue disk. Sorry.

Cheers,
Wol
