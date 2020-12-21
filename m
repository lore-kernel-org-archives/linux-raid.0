Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9700AC433E0
	for <linux-raid@archiver.kernel.org>; Mon, 21 Dec 2020 11:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4210422ADF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Dec 2020 11:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgLULyJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Dec 2020 06:54:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:37825 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgLULyJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 21 Dec 2020 06:54:09 -0500
IronPort-SDR: EAUz+wy7b5Q7zPQj4UND77vFfR1pnGZ8Qk3cm5UFKRNWYMO63jGKhWn4ZRPENQLRSRg7JmT1ug
 +wPYUfu2Zvyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9841"; a="173144489"
X-IronPort-AV: E=Sophos;i="5.78,436,1599548400"; 
   d="scan'208";a="173144489"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2020 03:52:23 -0800
IronPort-SDR: 1NFPxJAJxm3HUlK2Ybh2sNeyowxbgZPMn+d7NoUFVwu5vqW9gN+2hNtMXLBaTINrLneG589RvO
 JrsoxCcPRT3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,436,1599548400"; 
   d="scan'208";a="340689811"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 21 Dec 2020 03:52:22 -0800
Received: from [10.213.0.114] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.0.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 449B35808A8
        for <linux-raid@vger.kernel.org>; Mon, 21 Dec 2020 03:52:22 -0800 (PST)
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
To:     linux-raid@vger.kernel.org
Subject: why RAID10 doesn't return BB during resync?
Message-ID: <0584a0dc-8bd9-c65d-7672-eea9cb900b9d@linux.intel.com>
Date:   Mon, 21 Dec 2020 12:52:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,
I tested some scenarios with badblocks injected under same offset on each
member drive. For RAID1 and RAID5 IO errors and badblocks were reported
during resync, as expected. For RAID10 with default layout (n=2) I didn't
observe any IO error reported.

According to code, it looks like it was designed this way from the
beginning:

     /* find the first device with a block */
     for (i=0; i<conf->copies; i++)
         if (!r10_bio->devs[i].bio->bi_status)
             break;

     if (i == conf->copies)
         goto done;

There is no attempt to fix read error, it is ignored quietly.
The implementation differs from RAID1. For RAID1, there is
fix_sync_read_error() routine, and errors are well handled.

So my questions at this point are:
Is this a gap or it is intentionally omitted?
If it is a gap, is it worth to be added in the future?

Thanks,
Mariusz
