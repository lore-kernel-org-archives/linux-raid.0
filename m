Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82D1C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 18 Feb 2021 12:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67A564D79
	for <linux-raid@archiver.kernel.org>; Thu, 18 Feb 2021 12:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBRMHE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Feb 2021 07:07:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:60109 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhBRJcn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 18 Feb 2021 04:32:43 -0500
IronPort-SDR: egxTiSJE6rgFfD1UxzNhlhSMjvQ/Ul4vzUYO3KyNsg9uypL7HztOWY/rzwCpBf7pz4L8wFRN86
 VHN8Y1U16FNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9898"; a="170581367"
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="170581367"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 01:30:54 -0800
IronPort-SDR: i34OQFXi8O5Y62An2baQrob5dvcxAU3lx5KsvwFlwdkLhx0nMz+XEZsqlgfm+qeyBMe8IgJTMN
 utKRYWw++XJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="427085944"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2021 01:30:54 -0800
Received: from [10.249.158.176] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.158.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id B56AC580514;
        Thu, 18 Feb 2021 01:30:53 -0800 (PST)
Subject: Re: md read-only fixes
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20210201131721.750412-1-hch@lst.de>
 <656b8eb7-b2a1-b6ac-5620-29cb59fe5def@kernel.dk>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <60682445-c768-f003-157d-9c768c54983e@linux.intel.com>
Date:   Thu, 18 Feb 2021 10:30:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <656b8eb7-b2a1-b6ac-5620-29cb59fe5def@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01.02.2021 17:35, Jens Axboe wrote:
> On 2/1/21 6:17 AM, Christoph Hellwig wrote:
>> Hi all,
>>
>> patch 1 fixes a regression in md in for-5.12/block, and patch 2
>> fixes a little inconsistency in the same area.
> 
> Applied, thanks.
> 

Hi Song,
Could you cherry-pick those fixes? The issue blocks our daily tests.

Thanks,
Mariusz
