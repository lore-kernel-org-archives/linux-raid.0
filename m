Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BA4C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 10 Aug 2021 09:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 120D661051
	for <linux-raid@archiver.kernel.org>; Tue, 10 Aug 2021 09:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhHJJrZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Aug 2021 05:47:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:25925 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238174AbhHJJrY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 10 Aug 2021 05:47:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="213012239"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="213012239"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 02:47:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="421773603"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 10 Aug 2021 02:47:02 -0700
Received: from [10.213.2.85] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.2.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 8B623580922;
        Tue, 10 Aug 2021 02:47:01 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210804
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <2D64F5A2-3D1B-4D27-BEA7-81B03B30D212@fb.com>
 <145aaf29-535b-a0b5-3c6d-25b036df6dbb@kernel.dk>
 <66c72f4f-7fa0-7491-e4ea-8d8a82483aaa@linux.intel.com>
 <54C9427A-ADEA-4627-B435-FFF5841E6296@fb.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <860cbfb2-8e9b-2965-d7ad-ca7f66c12239@linux.intel.com>
Date:   Tue, 10 Aug 2021 11:46:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <54C9427A-ADEA-4627-B435-FFF5841E6296@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,
On 10.08.2021 07:10, Song Liu wrote:
> Sure. md-next branch is for feature development. Patches applied to
> md-next will go through linux-next before merging into upstream.
> md-fixes branch is for bug fixes. Patches applied to md-fixes will
> not go through linux-next.
> 
> Does this answer your question?

Yes, It is clear now.

Thanks,
Mariusz

