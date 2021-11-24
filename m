Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE4DC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 13:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347002AbhKXNf4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 08:35:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:5430 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352008AbhKXNdz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Nov 2021 08:33:55 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="232770748"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="232770748"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 05:27:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="509874764"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 24 Nov 2021 05:27:11 -0800
Received: from [10.213.25.233] (unknown [10.213.25.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 0525C58045A;
        Wed, 24 Nov 2021 05:27:10 -0800 (PST)
Message-ID: <16d735b4-3ac9-44d9-af83-9f664c187cf0@linux.intel.com>
Date:   Wed, 24 Nov 2021 14:27:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2] Incremental: Fix possible memory and resource leaks
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20211124115819.7568-1-mateusz.grzonka@intel.com>
 <16c18e54-fb84-7b97-1aa7-f31979b87a9e@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <16c18e54-fb84-7b97-1aa7-f31979b87a9e@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24.11.2021 13:13, Jes Sorensen wrote:
> On 11/24/21 6:58 AM, Mateusz Grzonka wrote:
>> map allocated through map_by_uuid() is not freed if mdfd is invalid.
>> In addition mdfd is not closed, and mdinfo list is not freed too.
>>
>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
>> ---
>>   Incremental.c | 32 +++++++++++++++++++++++---------
>>   1 file changed, 23 insertions(+), 9 deletions(-)
> 
> I already applied the previous version. Could you please send an updated
> version on top of current tree.
> 
> Thanks,
> Jes
> 

Hi Jes,
I cannot see previous version in mdadm tree.
Could you verify?

Thanks,
Mariusz
