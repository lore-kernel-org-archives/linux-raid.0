Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4682FC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 17:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190572220B
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 17:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgL3Ry1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Dec 2020 12:54:27 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:9056 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgL3Ry1 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Dec 2020 12:54:27 -0500
Received: from host86-158-105-41.range86-158.btcentralplus.com ([86.158.105.41] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kuffN-0002l6-Al; Wed, 30 Dec 2020 17:53:45 +0000
Subject: Re: [PATCH 1/4] block: introduce submit_bio_noacct_add_head
To:     John Stoffel <john@stoffel.org>,
        Danny Shih <dannyshih@synology.com>
Cc:     axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
        dm-devel@redhat.com, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
 <1609233522-25837-2-git-send-email-dannyshih@synology.com>
 <24555.49943.411197.147225@quad.stoffel.home>
 <abac671f-91f2-ca4e-7f77-8bb5da85a4cc@synology.com>
 <24556.45969.276771.345181@quad.stoffel.home>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <1b6c4709-8409-a73f-d3f0-4b4cf19bfae1@youngman.org.uk>
Date:   Wed, 30 Dec 2020 17:53:44 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <24556.45969.276771.345181@quad.stoffel.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/12/2020 17:06, John Stoffel wrote:
> Danny> "Provide a way for stacking block device to re-submit
> 
> Danny> the bio which should be handled first."
> 
> Danny> I will fix it.
> 
> Great, though my second question is*why*  it needs to be handled
> first?  What is the difference between stacked and un-stacked devices
> and how could it be done in a way that doesn't require a seperate
> function like this?

Is this anything to do with what's on my mind as a database guy? I've 
heard that things like RAID and LVM have difficulty providing write 
barriers.

I want to be confident that, at EVERY level of the stack, I can put a 
barrier in that guarantees that everything written by user-space BEFORE 
the barrier is handled before anything written AFTER the barrier. That 
way, I can be confident that, after a problem, I know whether I can 
safely roll the log forward or back.

Cheers,
Wol
