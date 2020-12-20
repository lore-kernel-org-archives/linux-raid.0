Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E719C2BBCD
	for <linux-raid@archiver.kernel.org>; Sun, 20 Dec 2020 09:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38FA233A0
	for <linux-raid@archiver.kernel.org>; Sun, 20 Dec 2020 09:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgLTJrA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Dec 2020 04:47:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:33048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgLTJrA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 20 Dec 2020 04:47:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8CDCAC7B;
        Sun, 20 Dec 2020 09:46:18 +0000 (UTC)
To:     antlists <antlists@youngman.org.uk>, axboe@kernel.dk,
        dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
References: <20201203171535.67715-1-colyli@suse.de>
 <3f4bf4c4-1f1f-b1a6-5d91-2dbe02f61e67@youngman.org.uk>
From:   Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH] badblocks: Improvement badblocks_set() for handling
 multiple ranges
Message-ID: <c50e7c65-d7bf-e957-d8eb-efed6c24f089@suse.de>
Date:   Sun, 20 Dec 2020 17:46:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <3f4bf4c4-1f1f-b1a6-5d91-2dbe02f61e67@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/20/20 4:02 AM, antlists wrote:
> On 03/12/2020 17:15, Coly Li wrote:
>> This patch is an initial effort to improve badblocks_set() for setting
>> bad blocks range when it covers multiple already set bad ranges in the
>> bad blocks table, and to do it as fast as possible.
> 
> Is this your patch, or submitted as part of the bug report?

This is not finished yet. The final version should go into upstream as a
fix for current badblocks routines.

> 
> "Heavily based on MD badblocks code from Neil Brown"
> 
> How much has this code got to do with the mdraid subsystem? Because
> badblocks in mdraid has an appalling reputation, with many people
> wanting to just rip it out.

This is in-memory data structure management which is almost irrelevant
to md raid or other on-disk layout.


> 
> If this code is separate from the mdraid implementation, any chance you
> can work with it, and fix that at the same time? Or make it redundant! I

This is 100% separated from md raid, as well as current badblocks code,
it is just about combine or split some [start, length] extent in a
table. The purpose of this patch is to fixing some reported issue from
users and our customers.

> don't quite see why mdraid should need a badblocks list given modern
> disk drives.
> 

For me the motivation is just people report bugs and I fix it. If there
is new code to replace it in upstream, then I just continue to maintain
the new code for our users and customers.

> And it's on my to-do list (if I can find the time!!!) to integrate
> dm-integrity into mdraid, at which point md badblocks should be irrelevant.
> 
> Hope I'm not being a shower of cold water, and if you want to fix all
> this, good on you, but to the extent that this is relevant to
> linux-raid, I think a lot of people will be asking "What's the point?"

Currently blocks/badblocks.c is used by md raid and nvdimm code, and the
badblocks table is irrelevant to any of these two subsystems.

If there will be better code for similar or better functionality, it
should be cool. For me, if the reporting bug is fixed, no difference in
my view :-)

Thanks.

Coly Li
