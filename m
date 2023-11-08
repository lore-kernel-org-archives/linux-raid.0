Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7C0C4167D
	for <linux-raid@archiver.kernel.org>; Wed,  8 Nov 2023 16:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjKHQvC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Nov 2023 11:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjKHQvB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Nov 2023 11:51:01 -0500
Received: from SMTP.sabi.co.uk (SMTP.sabi.co.UK [185.17.255.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAB11FEF
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 08:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=root.for.sabi.co.uk; s=dkim-00; h=From:Subject:To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:Date:Message-ID;
        bh=lcYdcl8zrrQmr+sHTM5yskX8C+o10+LmVw50WqkNr8A=; b=Dli+LTbZe0qHrwgFpbwfxZqCqb
        Qa3VOEguTHJgJu2T9aJKiRTGgvWC6HqHuGttN1E/zdi8QcMj+kCP7I4Ky1lBxSNIuFFlEl/XCu3vj
        6fP7+83D+KLntZh5XiwbfpDqHbd4gj7TLZS+RCOcdESeMqsyIGpSWuISVwRCADC6/m6Kfxui8nUVd
        UxP5nW/lZkLMZYkKjyVOWpuN64Rdue/0aAzvcwNlSH+0vQrQwDIa1qoFGUeTEUAnJv9+4a7J6BOYo
        cI9eMMemRPv6mYyETW568V+0t3O0PlIvk71ckQFawtrceUClcvvcVC3RcwbtZJLZ9zPtmbVJGJXRW
        qg1CW/0Q==;
Received: from [87.254.0.135] (helo=petal.ty.sabi.co.uk)
        by SMTP.sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
        id 1r0llY-007TBf-FTby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Wed, 08 Nov 2023 16:50:56 +0000
Received: from localhost ([127.0.0.1] helo=petal.ty.sabi.co.uk)
        by petal.ty.sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
        id 1r0llT-000gtR-Gp
        for <linux-raid@vger.kernel.org>; Wed, 08 Nov 2023 16:50:51 +0000
Message-ID: <25931.48235.341560.25122@petal.ty.sabi.co.uk>
Date:   Wed, 8 Nov 2023 16:50:51 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: extremely slow writes to degraded array
In-Reply-To: <2d44a37a-ca08-4d74-ab7e-16f51a0004c4@eyal.emu.id.au>
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
        <25930.43201.247015.388374@petal.ty.sabi.co.uk>
        <3a6d41e6-7e49-4d6d-acb4-f10b05b02ee5@eyal.emu.id.au>
        <2d44a37a-ca08-4d74-ab7e-16f51a0004c4@eyal.emu.id.au>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> The same issue is still there. Short of a kernel bug, maybe
> some md settings are less than optimal.

There is no MD RAID setting to increase the IOPS-per-TB of the
storage system or to make the free list of the filesystem on top
of it less fragmented.

> I see some postings saying dirty limit should actually be lowered?

That is generally a good idea, it does not necessarily help with
the two optimizations mentioned above.
https://www.sabi.co.uk/blog/14-two.html?141010#141010

>> While the fs is at about 83% full (10TB free out of 60TB) I
>> had the array almost 100% full in the past (it was then a
>> 20TB array) and did not notice such a drastic slowdown.

The high CPU time depends on how fragmented the filesystem free
list has become over time. Bringing its usage to 100% and then
deleting a lot of files (probably many small ones) had some long
term effects on the files allocated in the newly freed areas.

>> [...] %util is not that bad, though the array is
>> significantly higher than the members, and there is still
>> much reading while writing. [...]

A minor optimization here is having a wide parity stripe to
which read-modify-write then has to happen, which optimizes
storage wait times even more for any IO smaller than the stripe.
https://www.sabi.co.uk/blog/12-thr.html?120414#120414
https://www.sabi.co.uk/blog/12-two.html?120218#120218
