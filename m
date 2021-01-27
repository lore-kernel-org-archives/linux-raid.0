Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3B4C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 11:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82DF32076B
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 11:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhA0Ln6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jan 2021 06:43:58 -0500
Received: from mga07.intel.com ([134.134.136.100]:15339 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236730AbhA0Llf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Jan 2021 06:41:35 -0500
IronPort-SDR: NHf8+icDIRyri0d8HYnC79ewdBDhLdz8rHYt7FzrN8UbUYLlB1zkFZWVCgdB5Y9xrtqjVI9ItD
 Ml3M+a6fU6xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="244131678"
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="244131678"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 03:39:48 -0800
IronPort-SDR: izU7PJSyxj/BLuqlBKSZGH6Nn3kBRZ/L71qhQfsbJEAsgb+teQeCGvvrGU7HbamglHkAreuo5I
 HbqvS/W1LHNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="574357735"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jan 2021 03:39:48 -0800
Received: from [10.213.2.78] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.2.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 568995807C8;
        Wed, 27 Jan 2021 03:39:47 -0800 (PST)
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: release plan for mdadm
Message-ID: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
Date:   Wed, 27 Jan 2021 12:39:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

It's been a while since last mdadm release. Mdadm-4.2 release that was
mentioned back in July does not happened yet. It's getting messy to
manage mdadm across multiple distributions.

Also, not all OSVs are willing to cherry-pick the patches, especially
for stable project - like mdadm, so only critical bugfixes are landing
in the distros.
As a result - new OSes has various forks of mdadm-4.1 and the difference
is growing with every backported patch. It leads us to situation where
those forks may have own bugs, caused by many missing bugfixes or wrongly
resolved merge conflicts.
To be honest - it becomes more and more problematic for us to track all
fixes in different supported distros.

We are searching for solutions for those problems and we are counting on
your support:
Short term - is there any way that we can help you to release next version
of mdadm soon?

Long term - what do you think about smaller, more frequent releases of
mdadm? Maybe twice a year is an option (similar to RedHat/Ubuntu
schedule)? That would be better for us and for vendors. They will need
to follow upstream instead resolving bugs reported by us or community.

The benefits will be gained by everyone. User will get up-to-date
software much faster, with minimal vendor input and modifications.
Mdadm bugs will be predictable across distros. We could help with
testing IMSM and basic functionality of native metadata.

What are your thoughts?
Regards,
Mariusz
