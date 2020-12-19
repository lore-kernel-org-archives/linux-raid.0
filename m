Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36048C4361B
	for <linux-raid@archiver.kernel.org>; Sat, 19 Dec 2020 20:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0176223131
	for <linux-raid@archiver.kernel.org>; Sat, 19 Dec 2020 20:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgLSUCy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Dec 2020 15:02:54 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:14103 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727352AbgLSUCy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 19 Dec 2020 15:02:54 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kqiQd-000BHA-9x; Sat, 19 Dec 2020 20:02:11 +0000
Subject: Re: [RFC PATCH] badblocks: Improvement badblocks_set() for handling
 multiple ranges
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
References: <20201203171535.67715-1-colyli@suse.de>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <3f4bf4c4-1f1f-b1a6-5d91-2dbe02f61e67@youngman.org.uk>
Date:   Sat, 19 Dec 2020 20:02:11 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203171535.67715-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/12/2020 17:15, Coly Li wrote:
> This patch is an initial effort to improve badblocks_set() for setting
> bad blocks range when it covers multiple already set bad ranges in the
> bad blocks table, and to do it as fast as possible.

Is this your patch, or submitted as part of the bug report?

"Heavily based on MD badblocks code from Neil Brown"

How much has this code got to do with the mdraid subsystem? Because 
badblocks in mdraid has an appalling reputation, with many people 
wanting to just rip it out.

If this code is separate from the mdraid implementation, any chance you 
can work with it, and fix that at the same time? Or make it redundant! I 
don't quite see why mdraid should need a badblocks list given modern 
disk drives.

And it's on my to-do list (if I can find the time!!!) to integrate 
dm-integrity into mdraid, at which point md badblocks should be irrelevant.

Hope I'm not being a shower of cold water, and if you want to fix all 
this, good on you, but to the extent that this is relevant to 
linux-raid, I think a lot of people will be asking "What's the point?"

Cheers,
Wol
