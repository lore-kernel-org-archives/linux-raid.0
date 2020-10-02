Return-Path: <SRS0=y/j/=DJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B963C4363D
	for <linux-raid@archiver.kernel.org>; Fri,  2 Oct 2020 11:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E60206DC
	for <linux-raid@archiver.kernel.org>; Fri,  2 Oct 2020 11:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgJBLZD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Oct 2020 07:25:03 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:53694 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgJBLZD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Oct 2020 07:25:03 -0400
X-Greylist: delayed 1942 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2020 07:25:02 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 092AqbTn028016;
        Fri, 2 Oct 2020 11:52:37 +0100
From:   Nix <nix@esperi.org.uk>
To:     David Madore <david+ml@madore.org>
Cc:     antlists <antlists@youngman.org.uk>,
        Linux RAID mailing-list <linux-raid@vger.kernel.org>
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even start)
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
        <5F740390.7050005@youngman.org.uk>
        <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
        <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
        <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
        <5F74D684.8020005@youngman.org.uk>
        <20200930194510.vki7zixjca6sxvin@achernar.gro-tsen.net>
        <bfe9949c-1b46-baa3-1a89-0d994175dc95@youngman.org.uk>
        <20200930222637.mmlphc4patipalng@achernar.gro-tsen.net>
Emacs:  anything free is worth what you paid for it.
Date:   Fri, 02 Oct 2020 11:52:37 +0100
In-Reply-To: <20200930222637.mmlphc4patipalng@achernar.gro-tsen.net> (David
        Madore's message of "Thu, 1 Oct 2020 00:26:37 +0200")
Message-ID: <871righpca.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=3 Fuz1=3 Fuz2=3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30 Sep 2020, David Madore verbalised:

> On Wed, Sep 30, 2020 at 09:16:10PM +0100, antlists wrote:
>> The problem is that if you use mdadm 3.4 with kernel 4.9.237, the 237 means
>> that your kernel has been heavily updated and is far too new. But if you use
>> mdadm 4.1 with kernel 4.9.237, the 4.9 means that the kernel is basically a
>> very old one - too old for mdadm 4.1
>
> But the point of the longterm kernel lines like 4.9.237 is to keep
> strict compatibility with the original branch point (that's the point
> of a "stable" line) and perform only bugfixes, isn't it?  Do you mean

Yes... but the older a kernel release is, the less testing it gets for
edge cases, and reshaping is an edge case that doesn't happen very
often. I'm not terribly surprised that nobody turns out to have been
testing it in this kernel line and that it's rusted as a consqueence.

(Reshaping in conjunction with systemd is probably even rarer, because
reshaping tends to happen when you run out of disk space and need more,
or when disks age out and need replacement, which means it happens on
fairly old, stable machines -- and probably, even now, most such old
machines aren't running systemd and aren't exercising the buggy code
triggered by that systemd unit file.)

> to say that there is NO stable kernel line with full mdadm support?

The question isn't "full support", the question is "what gets a lot of
testing"? Recent, supported stable kernels get a lot of testing, so they
are likely to have exercised relatively obscure paths like this one.
