Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A759C433E6
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 18:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0233365287
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 18:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCHSEe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:04:34 -0500
Received: from vps.thesusis.net ([34.202.238.73]:56990 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCHSE1 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Mar 2021 13:04:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 5E39325509
        for <linux-raid@vger.kernel.org>; Mon,  8 Mar 2021 13:04:27 -0500 (EST)
Received: from vps.thesusis.net ([127.0.0.1])
        by localhost (vps.thesusis.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WYWkPen9mDcP for <linux-raid@vger.kernel.org>;
        Mon,  8 Mar 2021 13:04:27 -0500 (EST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 23E1B25508; Mon,  8 Mar 2021 13:04:27 -0500 (EST)
References: <87tuq7g5rp.fsf@vps.thesusis.net> <87ft158ul7.fsf@vps.thesusis.net>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     linux-raid@vger.kernel.org
Subject: Re: Raid10 reshape bug
Date:   Mon, 08 Mar 2021 12:01:04 -0500
In-reply-to: <87ft158ul7.fsf@vps.thesusis.net>
Message-ID: <87czw98qtw.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Phillip Susi writes:

> So it turns out all you have to do to trigger a bug is:
>
> mdadm --create -l raid10 -n 2 /dev/md1 /dev/loop0 missing
> mdadm -G /dev/md1 -p o2

I tried it again using a second disk instead of starting with a degraded
array, and the reshape says it worked, but left the array degraded with
one disk faulty and the data trashed.

After recreating the array with offset layout initially and and
formatting it, the filesystem also was trashed when I did a reshape to
convert the chunk size down to 64k with:

mdadm -G /dev/md1 -c 64

I also tried this with raid5 and raid4 instead of raid10 and they work,
so it seems to be specific to raid10.

I tried to change the chunk size on raid0 and for some reason, mdadm
wants to convert it to raid4 and can't since that would reduce the size.

Hrm... I went back and tried reshaping the chunk size on raid10 again
but in the default near layout rather than offset, and this works fine,
so it appears to be a problem only with the offset layout.  I tried the
far layout, but mdadm says it can not reshape to far.

