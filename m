Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764ADC433E0
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 10:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F15264E24
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 10:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhBQKFu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Feb 2021 05:05:50 -0500
Received: from SMTP.sabi.co.UK ([72.249.182.114]:40162 "EHLO sabi.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhBQKFq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Feb 2021 05:05:46 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2021 05:05:46 EST
Received: from b2b-5-147-245-68.unitymedia.biz ([5.147.245.68] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.2:RSA_AES_256_CBC_SHA1:256)(Exim 4.82 id 1lCIsx-0006Dm-Ae        id 1lCIsx-0006Dm-Aeby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 09:12:39 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1lCIso-006dCg-Pw
        for <linux-raid@vger.kernel.org>; Wed, 17 Feb 2021 10:12:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24620.56829.93946.65275@cyme.ty.sabi.co.uk>
Date:   Wed, 17 Feb 2021 10:12:29 +0100
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: use ssd as write-journal or lvm-cache?
In-Reply-To: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
References: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I was to use ssd to cache my mdadm-raid5 + lvm storage.

Not that sure that layering MDADM on top of DM/LVM2 is always a
good idea, I tend to prefer to keep things simple.

> but I wonder if I should use them as lvm-cache or mdadm write
> journal.  lvm-cache has benefits that it can do also
> read-cache. but I wonder if full-stripe write is the key point
> I need.

It depends on your load; does the small chance of RAID5 "write
hole" matter to your load? MDRAID has been used for a long time
without having a write journal, as the "write hole" issue
happens rarely and does not always matter. Anyhow with a write
journal, slow "resyncs" are avoided, which may also be
convenient (using the journal as a write buffer is not not that
coherent).

Also, the MDRAID write journal is usually (and should be) a lot
smaller than a whole flash SSD unit, so you can use a small part
of a flash SSD for write journaling and most of it for caching.

Whether caching is useful, and whether DM/LVM2 caching in
particular is useful, depends a lot on the specific load.

Apart from DM/LVM2 caching there is also "bcache", and there is
a new and fairly reliable filesystem type, "bcachefs", that
integrates it and gives quite neatly multiple tiers of storage
(it also has some RAID aspects, but those can be ignored).

https://www.reddit.com/r/bcachefs/comments/l44lmj/list_of_some_useful_links_for_bcachefs/
