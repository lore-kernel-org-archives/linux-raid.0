Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3EFC11F66
	for <linux-raid@archiver.kernel.org>; Tue, 29 Jun 2021 08:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D2561DC1
	for <linux-raid@archiver.kernel.org>; Tue, 29 Jun 2021 08:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhF2Irm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Jun 2021 04:47:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:29344 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhF2Irm (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Jun 2021 04:47:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="207928755"
X-IronPort-AV: E=Sophos;i="5.83,308,1616482800"; 
   d="scan'208";a="207928755"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 01:45:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,308,1616482800"; 
   d="scan'208";a="489189145"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 29 Jun 2021 01:45:14 -0700
Received: from [10.213.23.8] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.23.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 2F48C580AB1;
        Tue, 29 Jun 2021 01:45:13 -0700 (PDT)
Subject: Fwd: max_queued_requests for raid1 and raid10 - questions
References: <6f3265d4-6750-ff8d-27ec-a19d0ce54319@linux.intel.com>
To:     NeilBrown <neilb@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
X-Forwarded-Message-Id: <6f3265d4-6750-ff8d-27ec-a19d0ce54319@linux.intel.com>
Message-ID: <db85fb94-41e4-4729-fc23-cbbcf6b88372@linux.intel.com>
Date:   Tue, 29 Jun 2021 10:45:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6f3265d4-6750-ff8d-27ec-a19d0ce54319@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,
Sorry for noise, missclick.

Mariusz


-------- Forwarded Message --------
Subject: max_queued_requests for raid1 and raid10 - questions
Date: Tue, 29 Jun 2021 10:37:58 +0200
From: Tkaczyk, Mariusz <mariusz.tkaczyk@linux.intel.com>
To: NeilBrown <neilb@suse.com>

Hello Neil,
I have some questions related to max_queued_requests implemented by you
for raid1 and raid10. See code below:

/* When there are this many requests queue to be written by
  * the raid thread, we become 'congested' to provide back-pressure
  * for writeback.
  */
static int max_queued_requests = 1024;


It was added years ago:
https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit
/?id=34db0cd60f8a1f4ab73d118a8be3797c20388223

I've reached out scenario with cache in write-only mode where
this limiter degrades performance significantly (around 4 times).
I used Open-CAS:
https://github.com/Open-CAS/open-cas-linux

So, at this point I have some basic questions:
Is "back-pressure" still a case? Do you know any scenario where it
brings benefits?
If yes, I'll move this parameter to sysfs, to make it configurable
via mdadm config file (using SYSFS line) per array.
What do you think?

 From other hand, shall be consider to bump this value up? It seems to
be small today.

TIA,
Mariusz
