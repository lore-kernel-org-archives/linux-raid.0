Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1D0C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 06:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF7E64DE9
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 06:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhBQGS6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Feb 2021 01:18:58 -0500
Received: from rin.romanrm.net ([51.158.148.128]:56470 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231341AbhBQGS6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Feb 2021 01:18:58 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2021 01:18:57 EST
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id B48F17F9;
        Wed, 17 Feb 2021 06:09:23 +0000 (UTC)
Date:   Wed, 17 Feb 2021 11:09:23 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     d tbsky <tbskyd@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: use ssd as write-journal or lvm-cache?
Message-ID: <20210217110923.62fd685f@natsu>
In-Reply-To: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
References: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 17 Feb 2021 11:27:58 +0800
d tbsky <tbskyd@gmail.com> wrote:

> Hi:
>    I was to use ssd to cache my mdadm-raid5 + lvm storage. but I
> wonder if I should use them as lvm-cache or mdadm write journal.
> lvm-cache has benefits that it can do also read-cache. but I wonder if
> full-stripe write is the key point I need. I prefer to use the ssd as
> mdadm write journal. is there other reason I should use lvm-cache
> instead of  mdadm write-journal?
> 
> ps: my ssd is intel dc grade, so I think enable write-back mode of
> cache is not problem.

Why not both? It's not like you have to use the entire SSD for one or the
other. And it's very unlikely anything will be bottlenecked by concurrent
access to the SSD from both mechanisms.

Choosing one, I would prefer LVM caching, since it also gives benefit for
reads. And the mdadm write journal feature sounds[1] more like of a
reliability, not a performance enhancement.

In any case, in order to not add a single point of failure to the array,
better rely not on SSD being a "datacenter" one (anything can fail), but use a
RAID1 of two SSDs.

[1] https://lwn.net/Articles/665299/

-- 
With respect,
Roman
