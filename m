Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F68C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 07:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiGSHBA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbiGSHAy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 03:00:54 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE1721255
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 00:00:50 -0700 (PDT)
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658214049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLiGWalpeRWw59MB9WSoA8yPrr4fWS0bq6G8LC7gQoI=;
        b=SJgndZti6aLH2POiLQcqk/oE0J9Kv90kBV7JrTXH7lci2L1hpDy8WvLPnrFQyIunWpquLY
        S1lzDr1orTslKwt0CsupLT/iHSCJ7YOpx4odPBRv9qCrXLRIVXTECh9EZWKrMMLAUw/AiB
        3jtpFpy7IVg6qEJwHCq7FmR2/FiyM6I=
To:     Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
References: <87o7xmsjcv.fsf@esperi.org.uk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <fed30ed9-68e3-ce8b-ec27-45c48cf6a7a1@linux.dev>
Date:   Tue, 19 Jul 2022 15:00:42 +0800
MIME-Version: 1.0
In-Reply-To: <87o7xmsjcv.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 7/18/22 8:20 PM, Nix wrote:
> So I have a pair of RAID-6 mdraid arrays on this machine (one of which
> has a bcache layered on top of it, with an LVM VG stretched across
> both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
> rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
> anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
> simply didn't find anything to assemble, and after that nothing else was
> going to work. But rebooting into 5.16 worked fine, so everything was
> (thank goodness) actually still there.
>
> Alas I can't say what the state of the blockdevs was (other than that
> they all seemed to be in /dev, and I'm using DEVICE partitions so they
> should all have been spotte

I suppose the array was built on top of partitions, then my wild guess is
the problem is caused by the change in block layer (1ebe2e5f9d68?),
maybe we need something similar in loop driver per b9684a71.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7ecb0bffda0..e5f2e55cb86a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5700,6 +5700,7 @@ static int md_alloc(dev_t dev, char *name)
         mddev->queue = disk->queue;
         blk_set_stacking_limits(&mddev->queue->limits);
         blk_queue_write_cache(mddev->queue, true, true);
+       set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
         disk->events |= DISK_EVENT_MEDIA_CHANGE;
         mddev->gendisk = disk;
         error = add_disk(disk);


Thanks,
Guoqing
