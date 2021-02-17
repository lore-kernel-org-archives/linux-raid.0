Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54EEC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 20:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84C4E64D5D
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 20:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhBQUvU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:51:20 -0500
Received: from SMTP.sabi.co.UK ([72.249.182.114]:40518 "EHLO sabi.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhBQUvU (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Feb 2021 15:51:20 -0500
Received: from b2b-5-147-245-68.unitymedia.biz ([5.147.245.68] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.2:RSA_AES_256_CBC_SHA1:256)(Exim 4.82 id 1lCTmR-0006ob-5v        id 1lCTmR-0006ob-5vby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 20:50:39 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1lCTmK-006hoc-55
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 21:50:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24621.33174.413582.234150@cyme.ty.sabi.co.uk>
Date:   Wed, 17 Feb 2021 21:50:30 +0100
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: use ssd as write-journal or lvm-cache?
In-Reply-To: <CAC6SzH+ai5jD8ZQi2f-vTYjBGWDshXJVVm+xM9KZ3OCjk5Sz4g@mail.gmail.com>
References: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
        <24620.56829.93946.65275@cyme.ty.sabi.co.uk>
        <CAC6SzH+ai5jD8ZQi2f-vTYjBGWDshXJVVm+xM9KZ3OCjk5Sz4g@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I thought journal write-back mode should use large ssd
> space,like bcache which will prevent random write at all cost.

The write journal is supposed to buffer a few stripes to avoid
the write hole. Consider the case of a 2-drive write journal
arrangement: you would be effectively adding a RAID1 component
to your RAID5 set for recently updated data. Then why use RAID5?
Also consider the size of journals for filesystem types that
have it: typically it is 32MiB-128MiB.

> but reading the document again, it said "The flush conditions
> could be free in-kernel memory cache space is low".

That's another issue with the Linux default for the buffer
system, it usually buffers too much if there is no 'sync'.

> since the memory won't be too large compare to normal ssd
> disk,

I am not sure I understand why that is relevant, what happens
there depends on 'sync' behaviour and the filesystem and buffer
cache flushing interval if any.

> maybe a small optane ssd is best for mdadm write-journal.

The reasoning before this I don't quite understand, but Optane
is a very good choice for a persistent write buffer, as it is
not volatile and has much faster and smaller writes than flash
chips.
