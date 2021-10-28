Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881D3C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 17:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A7F60C40
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 17:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJ1R1a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Oct 2021 13:27:30 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:42108 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhJ1R1a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Oct 2021 13:27:30 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2021 13:27:29 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 19SHH7IL011026
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 28 Oct 2021 18:17:07 +0100
From:   Nix <nix@esperi.org.uk>
To:     Wol <antlists@youngman.org.uk>
Cc:     John Atkins <John@aawcs.co.uk>,
        Roger Heflin <rogerheflin@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Missing Superblocks
References: <de712291-fa08-b35a-f8fb-6d18b573f3f4@aawcs.co.uk>
        <a5f362c3-122e-d0ac-1234-d4852e43adfa@aawcs.co.uk>
        <CAAMCDee8fEHGMg7NBNzMq7+kbFHo-4DM0D2T=rNezpPZgKabeg@mail.gmail.com>
        <9d80e924-ae3e-4a04-1d17-65bfc949e276@aawcs.co.uk>
        <880c0b3a-a3b8-d8fa-4ea4-bd0a801938d3@youngman.org.uk>
Emacs:  indefensible, reprehensible, and fully extensible.
Date:   Thu, 28 Oct 2021 18:17:07 +0100
In-Reply-To: <880c0b3a-a3b8-d8fa-4ea4-bd0a801938d3@youngman.org.uk> (Wol's
        message of "Wed, 27 Oct 2021 17:33:24 +0100")
Message-ID: <87h7d1qdbg.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=4 Fuz1=4 Fuz2=4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27 Oct 2021, Wol uttered the following:

> On 26/10/2021 10:45, John Atkins wrote:
>> Thanks for the suggestions.
>> No partition ever on these disks.
>
> BAD IDEA ... it *should* be okay, but there are too many rogue programs/utilities out there that think stomping all over a 
> partition-free disk is acceptable behaviour ...

There are even some BIOSes (or, rather, UEFI firmwares) that think this
is just fine. Without notice, of course, and often when you do nothing
more than reboot.

> It's bad enough when a GPT or MBR gets trashed, which sadly is not unusual in your scenario, but without partitions you're inviting 
> disaster... :-(

Quite. I moved away from raw disk usage long ago: the cost/benefit
tradeoff is just not worth it.

-- 
NULL && (void)
