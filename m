Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E8DC4332B
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B880E60233
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbhCCX74 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Mar 2021 18:59:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:8946 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237775AbhCCIPM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 3 Mar 2021 03:15:12 -0500
IronPort-SDR: NvlTuAt6JEeDyD6NxM5sWm144Fv9ZIGpfuc68iUtKG8jFDBXCsH/Ew1EG/zuxvdaKIuSfMGMAK
 OPC32zMkRIEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="251185993"
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="251185993"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 00:13:22 -0800
IronPort-SDR: QS+33L1rf+xwxVVpWZtAb4R6VC/ZQSGfZo15Y+Y08Z66ho9MGncpPmO340YqLgy5IGdotqZQv3
 Yp9XSD0GhJDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="596273073"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 03 Mar 2021 00:13:22 -0800
Received: from [10.249.159.200] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.159.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 92F4A5808BA;
        Wed,  3 Mar 2021 00:13:21 -0800 (PST)
Subject: Re: release plan for mdadm
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org
References: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
 <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <ec3f3d78-5a63-0541-6f87-3836c6026e5a@linux.intel.com>
Date:   Wed, 3 Mar 2021 09:13:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02.03.2021 23:50, Jes Sorensen wrote:
> On 1/27/21 6:39 AM, Tkaczyk, Mariusz wrote:
>> Hi Jes,
>>
>> It's been a while since last mdadm release. Mdadm-4.2 release that was
>> mentioned back in July does not happened yet. It's getting messy to
>> manage mdadm across multiple distributions.
>>
>> Also, not all OSVs are willing to cherry-pick the patches, especially
>> for stable project - like mdadm, so only critical bugfixes are landing
>> in the distros.
>> As a result - new OSes has various forks of mdadm-4.1 and the difference
>> is growing with every backported patch. It leads us to situation where
>> those forks may have own bugs, caused by many missing bugfixes or wrongly
>> resolved merge conflicts.
>> To be honest - it becomes more and more problematic for us to track all
>> fixes in different supported distros.
>>
>> We are searching for solutions for those problems and we are counting on
>> your support:
>> Short term - is there any way that we can help you to release next version
>> of mdadm soon?
>>
>> Long term - what do you think about smaller, more frequent releases of
>> mdadm? Maybe twice a year is an option (similar to RedHat/Ubuntu
>> schedule)? That would be better for us and for vendors. They will need
>> to follow upstream instead resolving bugs reported by us or community.
>>
>> The benefits will be gained by everyone. User will get up-to-date
>> software much faster, with minimal vendor input and modifications.
>> Mdadm bugs will be predictable across distros. We could help with
>> testing IMSM and basic functionality of native metadata.
> 
> Hi Mariusz,
> 
> Sorry for the slow response. Our daughter was born in late December and
> I was on paternity leave through Feb 5, so still catching up. I also
> switched teams at work back in July so my focus was shifted.
Hi Jes,
Congratulations:)
> 
> I'd very much like to see a release, and we should do one quick. Doing
> more regular releases will also make it easier to ship them, so I am not
> against that at all.
> 
> I am not aware of anything major pending right now, so if we can get
> focus on any pending patches and get them in over the next week or two,
> then I can cut an -rc and we can do a release soon. Especially if you
> can help out regression testing the -rc candidate(s).
> 
> Cheers,
> Jes
> 
Thanks for answer. Please review all patches in queue, and mark -rc.
Then I will schedule regression.

Mariusz
