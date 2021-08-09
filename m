Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BC9C4338F
	for <linux-raid@archiver.kernel.org>; Mon,  9 Aug 2021 12:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB8460FF2
	for <linux-raid@archiver.kernel.org>; Mon,  9 Aug 2021 12:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhHIMjj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Aug 2021 08:39:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:25820 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhHIMjh (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 9 Aug 2021 08:39:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214669474"
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="214669474"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 05:39:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="438911441"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 09 Aug 2021 05:39:01 -0700
Received: from [10.213.0.184] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.0.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 11D89580922;
        Mon,  9 Aug 2021 05:39:00 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210804
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <2D64F5A2-3D1B-4D27-BEA7-81B03B30D212@fb.com>
 <145aaf29-535b-a0b5-3c6d-25b036df6dbb@kernel.dk>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <66c72f4f-7fa0-7491-e4ea-8d8a82483aaa@linux.intel.com>
Date:   Mon, 9 Aug 2021 14:38:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <145aaf29-535b-a0b5-3c6d-25b036df6dbb@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 04.08.2021 23:50, Jens Axboe wrote:
> On 8/4/21 3:47 PM, Song Liu wrote:
>> Hi Jens,
>>
>> Please consider pulling the following fix on top of your for-5.14/block> branch.
> 

Hi Song,

Could you describe idea behind of "md-next" and "md-fixes" branches?
I'm asking because we are running regression on "md-next", but since
development has been divided into two separate branches I probably
need to change current approach.

Thanks,
Mariusz
