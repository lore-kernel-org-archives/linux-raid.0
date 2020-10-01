Return-Path: <SRS0=h+Ja=DI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34478C4727C
	for <linux-raid@archiver.kernel.org>; Thu,  1 Oct 2020 14:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB55220872
	for <linux-raid@archiver.kernel.org>; Thu,  1 Oct 2020 14:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgJAOKY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Oct 2020 10:10:24 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:65206 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732020AbgJAOKY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 1 Oct 2020 10:10:24 -0400
Received: from host86-157-96-171.range86-157.btcentralplus.com ([86.157.96.171] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kNzHp-0008WQ-CK; Thu, 01 Oct 2020 15:10:22 +0100
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
To:     David Madore <david+ml@madore.org>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
 <5F740390.7050005@youngman.org.uk>
 <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
 <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
 <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
 <5F74D684.8020005@youngman.org.uk>
 <20200930194510.vki7zixjca6sxvin@achernar.gro-tsen.net>
 <bfe9949c-1b46-baa3-1a89-0d994175dc95@youngman.org.uk>
 <20200930222637.mmlphc4patipalng@achernar.gro-tsen.net>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <5F75E34D.7030207@youngman.org.uk>
Date:   Thu, 1 Oct 2020 15:10:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20200930222637.mmlphc4patipalng@achernar.gro-tsen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/09/20 23:26, David Madore wrote:
> On Wed, Sep 30, 2020 at 09:16:10PM +0100, antlists wrote:
>> The problem is that if you use mdadm 3.4 with kernel 4.9.237, the 237 means
>> that your kernel has been heavily updated and is far too new. But if you use
>> mdadm 4.1 with kernel 4.9.237, the 4.9 means that the kernel is basically a
>> very old one - too old for mdadm 4.1
> 
> But the point of the longterm kernel lines like 4.9.237 is to keep
> strict compatibility with the original branch point (that's the point
> of a "stable" line) and perform only bugfixes, isn't it?  Do you mean
> to say that there is NO stable kernel line with full mdadm support?
> Or just the ones provided by distributions?  (But don't distributions
> like Debian do exactly the same thing as GKH and others with these
> longterm lines?  I.e., fix bugs while keeping strict compatibility.
> If there are no longterm stable kernels with full RAID support, I find
> this rather worrying.)

Depends what you mean by full RAID support. Any kernel (within limits)
should work with any raid. We've found, by experience, that trying to
upgrade a raid can have problems ... :-)
> 
> But in my specific case, the issue didn't come from a mdadm/kernel
> mismatch after all: I performed further investigation after I wrote my
> previous message, and my problem did indeed come from the
> /lib/systemd/system/mdadm-grow-continue@.service which, as far as I
> can tell, is broken insofar as --backup-file=... goes (the option is
> needed for --continue to work and it isn't passed).  Furthermore, this
> file appears to be distributed by mdadm itself (it's not
> Debian-specific), and the systemd service is called by mdadm (from
> continue_via_systemd() in Grow.c).

Except is this the problem? If the reshape fails to start, I don't quite
see how the restart service-file can be to blame?
> 
> So it seems to me that RAID reshaping with backup files is currently
> broken on all systems which use systemd.  But then I'm confused as to
> why this didn't get more attention.  Anyway, if you have any
> suggestion as to where I should bugreport this, it's the least I can
> do.

It works fine with a "latest and greatest" kernel and mdadm ... that
said, we know that there's been a fair bit of general house-keeping and
tidying up going on.
> 
> In my particular setup, after giving this more thought, I thought the
> wisest thing would be to get tons of external storage, copy everything
> away, recreate a fresh RAID6 array, and copy everything back into it.

Well, I'm thinking of getting a huge shingled disk for backups :-) but
if that's worked for you, great.
> 
> Whatever the case, thanks for your help.
> 
And thank you for documenting what's going wrong. I doubt much work will
go in to fixing it for Debian 9, but if it really is a problem and rears
its head again, at least we'll have more info to start digging. I'll
make a note of this ...

But this is exactly the problem with the concept of LTS. Yes I
understand why people want LTS, but if the kernel accumulates bug-fixes
and patches it will get out of sync with user-space. And yes, the
intention is to minimise this as much as possible, but mdadm 3.4 is a
lot older (and known to be buggy) compared to your updated kernel, but
your updated the kernel is still anchored firmly in the past relative to
mdadm 4.1. LTS is a work-around to cope with the fact that time flows ...

Oh - and as for backup files - newer arrays by default don't need or use
them. So that again could be part of the problem ...

Cheers,
Wol

