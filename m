Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F89C433E2
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 05:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68D2208A9
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 05:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgH2FC7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 01:02:59 -0400
Received: from rin.romanrm.net ([51.158.148.128]:57568 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgH2FC6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 29 Aug 2020 01:02:58 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 5F2023F0;
        Sat, 29 Aug 2020 05:02:56 +0000 (UTC)
Date:   Sat, 29 Aug 2020 10:02:56 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     "R. Ramesh" <rramesh@verizon.net>
Cc:     antlists <antlists@youngman.org.uk>,
        Ram Ramesh <rramesh2400@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Best way to add caching to a new raid setup.
Message-ID: <20200829100256.57e8d57b@natsu>
In-Reply-To: <d0aeb41b-09d4-b756-05ee-f0b3da486532@verizon.net>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <6872a42c-5c27-e38a-33ab-10ec01723961@youngman.org.uk>
 <d0aeb41b-09d4-b756-05ee-f0b3da486532@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 28 Aug 2020 22:08:22 -0500
"R. Ramesh" <rramesh@verizon.net> wrote:

> I do not know how SSD caching is implemented. I assumed it will be 
> somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that 
> with SSD caching, reads/writes to disk will be larger in size and 
> sequential within a file (similar to cache line fill in memory cache 
> which results in memory bursts that are efficient). I thought that is 
> what SSD caching will do to disk reads/writes. I assumed, once reads 
> (ahead) and writes (assuming writeback cache) buffers data sufficiently 
> in the SSD, all reads/writes will be to SSD with periodic well organized 
> large transfers to disk. If I am wrong here then I do not see any point 
> in SSD as a cache. My aim is not to optimize by cache hits, but optimize 
> by preventing disks from thrashing back and forth seeking after every 
> block read. I suppose Linux (memory) buffer cache alleviates some of 
> that. I was hoping SSD will provide next level. If not, I am off in my 
> understanding of SSD as a disk cache.

Just try it, as I said before with LVM it is easy to remove if it doesn't work
out. You can always go to the manual copying method or whatnot, but first why
not check if the automatic caching solution might be "good enough" for your
needs.

Yes it usually tries to avoid caching long sequential reads or writes, but
there's also quite a bit of other load on the FS, i.e. metadata. I found that
browsing directories and especially mounting the filesystem had a great
benefit from caching.

You are correct that it will try to increase performance via writeback
caching, however with LVM that needs to be enabled explicitly:
https://www.systutorials.com/docs/linux/man/7-lvmcache/#lbAK
And of course a failure of that cache SSD will mean losing some data, even if
the main array is RAID. Perhaps should consider a RAID of SSDs for cache in
that case then.

-- 
With respect,
Roman
