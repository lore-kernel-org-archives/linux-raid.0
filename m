Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74517C11F66
	for <linux-raid@archiver.kernel.org>; Tue, 29 Jun 2021 10:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5578861D7A
	for <linux-raid@archiver.kernel.org>; Tue, 29 Jun 2021 10:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhF2Kj1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Jun 2021 06:39:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52096 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhF2Kj1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Jun 2021 06:39:27 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7255622688;
        Tue, 29 Jun 2021 10:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624963019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NKcfE4f5MKzjSvOGqMTCrNYUQRegyzyK+vyXo0CWv4=;
        b=gVuc6ldqcxeOJd+bvhvnOGvODKhOVNDE3X5mWfWnFIN838+FPjIN/MuD0n7+TqodLWfZwB
        PICmhsk0CNRR+qbgK9z2mn3PmVWUZsIh3wS/bA6mp39mvheDF0dFGPs9qJly/Q98+UwrQJ
        N8177B+Xr2PY1FUV71XsxV66+XaR1Us=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624963019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NKcfE4f5MKzjSvOGqMTCrNYUQRegyzyK+vyXo0CWv4=;
        b=+AUcaJa8Mru/cyWN3hPa/0BKPFl7YO1NuwxNNKDH0KMFyuW31hevdIf2gQ+TXwLEaOBa2n
        9OIXzG+WHyNkoJCw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 6D00C11906;
        Tue, 29 Jun 2021 10:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624963019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NKcfE4f5MKzjSvOGqMTCrNYUQRegyzyK+vyXo0CWv4=;
        b=gVuc6ldqcxeOJd+bvhvnOGvODKhOVNDE3X5mWfWnFIN838+FPjIN/MuD0n7+TqodLWfZwB
        PICmhsk0CNRR+qbgK9z2mn3PmVWUZsIh3wS/bA6mp39mvheDF0dFGPs9qJly/Q98+UwrQJ
        N8177B+Xr2PY1FUV71XsxV66+XaR1Us=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624963019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NKcfE4f5MKzjSvOGqMTCrNYUQRegyzyK+vyXo0CWv4=;
        b=+AUcaJa8Mru/cyWN3hPa/0BKPFl7YO1NuwxNNKDH0KMFyuW31hevdIf2gQ+TXwLEaOBa2n
        9OIXzG+WHyNkoJCw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id A2zbB8r32mBgCgAALh3uQQ
        (envelope-from <neilb@suse.de>); Tue, 29 Jun 2021 10:36:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     "linux-raid" <linux-raid@vger.kernel.org>
Subject: Re: max_queued_requests for raid1 and raid10 - questions
In-reply-to: <db85fb94-41e4-4729-fc23-cbbcf6b88372@linux.intel.com>
References: <6f3265d4-6750-ff8d-27ec-a19d0ce54319@linux.intel.com>,
 <db85fb94-41e4-4729-fc23-cbbcf6b88372@linux.intel.com>
Date:   Tue, 29 Jun 2021 20:36:54 +1000
Message-id: <162496301481.7211.18031090130574610495@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 29 Jun 2021, Tkaczyk, Mariusz wrote:
> 
> Hello Neil,
> I have some questions related to max_queued_requests implemented by you
> for raid1 and raid10. See code below:
> 
> /* When there are this many requests queue to be written by
>   * the raid thread, we become 'congested' to provide back-pressure
>   * for writeback.
>   */
> static int max_queued_requests = 1024;
> 
> 
> It was added years ago:
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit
> /?id=34db0cd60f8a1f4ab73d118a8be3797c20388223
> 
> I've reached out scenario with cache in write-only mode where
> this limiter degrades performance significantly (around 4 times).
> I used Open-CAS:
> https://github.com/Open-CAS/open-cas-linux
> 
> So, at this point I have some basic questions:
> Is "back-pressure" still a case? Do you know any scenario where it
> brings benefits?

As you say, it was years ago.  Things have probably changed.

At the time, the mm system would write to a device until it got marked
"congested".  If there wasn't some sort of limit on the device queue
size, you would end up with an enormous queue that would take a long
time to flush and so high-priority reads would get stuck behind
low-priority writes and weird things like that.

The writeback now has a much more sophisticated approach, measuring the
actually throughput of each device and adjusting writes accordingly.

> If yes, I'll move this parameter to sysfs, to make it configurable
> via mdadm config file (using SYSFS line) per array.
> What do you think?
> 
>  From other hand, shall be consider to bump this value up? It seems to
> be small today.

I suspect that the best thing to do would be to remove the limit
completely.
Certainly that is the first thing I would try.  Try removing the limit,
but monitor the count of queued requests and see if something else stops
it from consuming all memory.

NeilBrown
