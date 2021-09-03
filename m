Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EBAC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 06:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB9D6101A
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 06:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhICGJi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Sep 2021 02:09:38 -0400
Received: from out0.migadu.com ([94.23.1.103]:12951 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234109AbhICGJg (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 3 Sep 2021 02:09:36 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1630649316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjRnS0id496xIETv0keQRRfh37kmAFxhzSDm3aw3lVI=;
        b=G6kbQ4xZ+PaPqOTicng1JsDhF5x40a0iIVBNm+RtRcBptuJxbIUly/UeHUfOU1owNxPlfD
        a/DPNsNS3m1F1pjJvKUHnWO/WcIT3HoLNa/3SMD7ebWeadK/BuftbQjRe9u+qu9RfR8zwt
        Va9shcSb8AN4MokEM5vN+BpagLceeHk=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 1/5] md: fix a lock order reversal in md_alloc
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-raid@vger.kernel.org,
        syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com,
        Neil Brown <neilb@suse.de>
References: <20210901113833.1334886-1-hch@lst.de>
 <20210901113833.1334886-2-hch@lst.de>
Message-ID: <2861229a-c9ff-3811-85eb-4362e46d2fe2@linux.dev>
Date:   Fri, 3 Sep 2021 14:08:29 +0800
MIME-Version: 1.0
In-Reply-To: <20210901113833.1334886-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 9/1/21 7:38 PM, Christoph Hellwig wrote:
> Commit b0140891a8cea3 ("md: Fix race when creating a new md device.")
> not only moved assigning mddev->gendisk before calling add_disk, which
> fixes the races described in the commit log, but also added a
> mddev->open_mutex critical section over add_disk and creation of the
> md kobj.  Adding a kobject after add_disk is racy vs deleting the gendisk
> right after adding it, but md already prevents against that by holding
> a mddev->active reference.

Assuming you mean md_open calls mddev_find -> mddev_get
  -> atomic_inc(&mddev->active), but the path had already existed
before b0140891a8c,  and md_alloc also called mddev_find at
that time, not sure how it prevents the race though I probably missed
something. Cc Neil.

> On the other hand taking this lock added a lock order reversal with what
> is not disk->open_mutex (used to be bdev->bd_mutex when the commit was
> added) for partition devices, which need that lock for the internal open
> for the partition scan, and a recent commit also takes it for
> non-partitioned devices, leading to further lockdep splatter.
>
> Fixes: b0140891a8ce ("md: Fix race when creating a new md device.")
> Fixes: d62633873590 ("block: support delayed holder registration")

IIUC, the issue appeared after d6263387359 (which was for dm issue),
perhaps stable maintainer should not apply this to any stable kernel
if it only includes b0140891a8ce.

Thanks,
Guoqing
