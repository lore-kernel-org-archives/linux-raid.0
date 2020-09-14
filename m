Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A3DC433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 17:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F6320771
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 17:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgINR1M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 13:27:12 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:49261 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgINR0j (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Sep 2020 13:26:39 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kHsFN-0001ql-AS; Mon, 14 Sep 2020 18:26:33 +0100
Subject: Re: Linux raid-like idea
To:     Phillip Susi <phill@thesusis.net>
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
 <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
 <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
 <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
 <87k0ww6ztv.fsf@vps.thesusis.net>
Cc:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        linux-raid@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5F5FA7C8.6010001@youngman.org.uk>
Date:   Mon, 14 Sep 2020 18:26:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <87k0ww6ztv.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/09/20 18:19, Phillip Susi wrote:
> 
> antlists writes:
> 
>> Yup. Raid 6 has two parity disks, and that's mirrored to give four 
>> parity disks. So as an *absolute* *minimum*, raid-61 could lose four 
>> disks with no data loss.
> 
> Don't you mean 5 disks?
> 
> At best 4 lost disks paired off in each raid1 means the raid6 sees two
> failures.  One more disk failing isn't enough to take out another mirror
> so the raid6 keeps ticking.
> 
Well caught !!!

Cheers,
Wol
