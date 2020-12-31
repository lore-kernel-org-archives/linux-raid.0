Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65037C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 31 Dec 2020 08:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D794223C8
	for <linux-raid@archiver.kernel.org>; Thu, 31 Dec 2020 08:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgLaI3j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Dec 2020 03:29:39 -0500
Received: from mail.synology.com ([211.23.38.101]:47566 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbgLaI3j (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 31 Dec 2020 03:29:39 -0500
Received: from [10.17.32.105] (unknown [10.17.32.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 057D3CE7803D;
        Thu, 31 Dec 2020 16:28:56 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1609403337; bh=RIZmLW/wT3ht4pS8LWooWsJAVmV7MXRn1pBwxsNLpB8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=psGufkjFQ5pMM2jXXolkrIWZGGFnTWL9Qtm895Xyg9YrNIJANCqDd7xp2YdO2us7F
         Q7OSchvF8hM8+2HtndGzAlW6rnhrzj3UCxzh4uJ4vMpXxKdvFLs12jDrym1wdOuPaX
         GbhRwEFADEkksTyCGHuFRM4tlOUzJLW8jY1mofm0=
Subject: Re: [PATCH 0/4] Fix order when split bio and send remaining back to
 itself
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, agk@redhat.com, dm-devel@redhat.com,
        song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
 <20201230233429.GA6456@redhat.com>
From:   Danny Shih <dannyshih@synology.com>
Message-ID: <a318fd04-4f8c-2aec-2a58-18f456c98ef0@synology.com>
Date:   Thu, 31 Dec 2020 16:28:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201230233429.GA6456@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Mike Snitzer writes:
>> submit_bio_noacct_add_head() in block device layer when we want to
>> split bio and send remaining back to itself.
> Ordering aside, you cannot split more than once.  So your proposed fix
> to insert at head isn't valid because you're still implicitly allocating
> more than one bio from the bioset which could cause deadlock in a low
> memory situation.
>
> I had to deal with a comparable issue with DM core not too long ago, see
> this commit:
>
> commit ee1dfad5325ff1cfb2239e564cd411b3bfe8667a
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Mon Sep 14 13:04:19 2020 -0400
>
>      dm: fix bio splitting and its bio completion order for regular IO
>
>      dm_queue_split() is removed because __split_and_process_bio() _must_
>      handle splitting bios to ensure proper bio submission and completion
>      ordering as a bio is split.
>
>      Otherwise, multiple recursive calls to ->submit_bio will cause multiple
>      split bios to be allocated from the same ->bio_split mempool at the same
>      time. This would result in deadlock in low memory conditions because no
>      progress could be made (only one bio is available in ->bio_split
>      mempool).
>
>      This fix has been verified to still fix the loss of performance, due
>      to excess splitting, that commit 120c9257f5f1 provided.
>
>      Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
>      Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
>      Reported-by: Ming Lei <ming.lei@redhat.com>
>      Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>
> Basically you cannot split the same bio more than once without
> recursing.  Your elaborate documentation shows things going wrong quite
> early in step 3.  That additional split and recursing back to MD
> shouldn't happen before the first bio split completes.
>
> Seems the proper fix is to disallow max_sectors_kb to be imposed, via
> blk_queue_split(), if MD has further splitting constraints, via
> chunk_sectors, that negate max_sectors_kb anyway.
>
> Mike


Hi Mike,

I think you're right that a driver should not split the same bio more
than once without recursing when using the same mempool.

If a driver only split bio once, the out-of-order issue no longer exists.
(Therefore, this problem won't occur on DM device.)

But the MD devices are using their private bioset (mddev->bio_set
or conf->bio_split) for splitting by themselves that are not the same
bioset used in blk_queue_split() (i.e. q->bio_split). The deadlock
you have mentioned might not happen to them.

I think there are two solutions:

1. In case MD devices want to change to use q->bio_split someday
    without this out-of-order issue, make them do split once would be
    a solution.

2. If MD devices should split the bio twice, so we can separately handle
    limits in blk_queue_split() and each raid level's (raid0, raid5, 
raid1, ...).
    I will try to find another solution in this case.

    My proposal is not suitable after I reconsider the problem:

    If a bio is split into A part and B part.

    +------|------+
    |   A  |   B  |
    +------|------+

    I think a driver should make sure A part is always handled before B 
part.
    Inserting bio at head of current->bio_list and submitting bio in the 
same
    time while handling A part could make bios generated from A part be
    handled before B part. This broke the order of those bios that generated
    form A part.

    (Maybe I should find a way to make B part at the head of 
bio_list_on_stack[1]
    while submitting it...)

Thanks for your comments.
I will try to figure out a better way to fix it in the next version.

Best regards,
Danny Shih

