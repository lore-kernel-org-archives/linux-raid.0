Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64510C2D0E4
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 21:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C768B206E5
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 21:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387653AbgKXVvQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 16:51:16 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:45315 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731557AbgKXVvQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Nov 2020 16:51:16 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1khftn-0002yE-5t; Tue, 24 Nov 2020 21:30:56 +0000
Subject: Re: RAID-6 and write hole with write-intent bitmap
To:     Mukund Sivaraman <muks@mukund.org>
Cc:     linux-raid@vger.kernel.org
References: <20201124072039.GA381531@jurassic.vpn.mukund.org>
 <5FBCDC18.9050809@youngman.org.uk>
 <20201124185004.GA27132@jurassic.vpn.mukund.org>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <ae4c0922-eb63-6f1b-3542-503c369a6110@youngman.org.uk>
Date:   Tue, 24 Nov 2020 21:30:54 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124185004.GA27132@jurassic.vpn.mukund.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 24/11/2020 18:50, Mukund Sivaraman wrote:
> (a) With RAID-5, assuming there are 4 member disks A, B, C, D, a write
> operation with its data on disk A and stripe's parity on disk B may
> involve:

Close
> 
> 1. a read of the stripe
> 2. update of data in the stripe
2.5 write A^C^D
> 3. computation and update of parity A^C^D on B
> 
> These are not atomic updates. If power is lost between steps 2 and 3,
> upon recovery the mismatch between data and parity for the stripe would
> be found and the parity can be updated on B. The data chunk written to A
> may be incomplete if power is lost during step 2, but the ext4's journal
> would return the FS to a consistent state. Moreover, there should not be
> any modification/corruption of data in the stripe on disks C and D
> (assuming the disks are OK).

I *don't* think that's necessarily true. Yes it probably is true, but 
it's not guaranteed ...
> 
> (b) With RAID-6, assuming there are 5 member disks A, B, C, D, E, a
> write operation with its data on disk A and stripe's parity on disks
> B(p) and C(q) would involve:
> 
> 1. a read of the stripe
> 2. update of data in stripe
2.5 write A^D^E
> 3. computation and update of parity on B(p)
> 4. update of parity on C(q)

Cheers,
Wol
