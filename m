Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64927EB64DA
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jul 2023 15:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjGEPPu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbjGEPPt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jul 2023 11:15:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332551724
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 08:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688570148; x=1720106148;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=NeLhh9fIIMMFtIKBg//kqzF6wEBneQL1T9sxiF1bXm8=;
  b=L7omFowF8+sQ1L/A1a7ViuMZGOF7SuWisBXeYQI3+KNWyt5yGi/h4ylS
   B9x87yXlbbPWDROXMV8tLqm3ljrHpohgg7BJn36enHr5EX1sjQN8bqVVW
   3/BJP6FaNTBf03bE65YYFuxKnSnd45xu80lQimaB4h9V9WvHgEB01zuyV
   tspIK5UruHOEeNPfnRKDdLhQpmgAS4N6cRWaL84Ryt3osKlRNiP4yZlLw
   M3Kr1KJYpZRYecz7Tx6gvqxysXUP4+RpXQXd6y0MDLSU+frDCKRyptd/B
   sXjIPLKA4EycmTCFjsGrpHtQY1g74kGk0vobGa+fbAjo8ezqlPLkJEexL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362235590"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="362235590"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 08:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="893221106"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="893221106"
Received: from mgrzonka-mobl.ger.corp.intel.com (HELO [10.249.142.197]) ([10.249.142.197])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 08:15:36 -0700
Message-ID: <a61f0f45-6419-e2cb-8edb-69a82479e996@linux.intel.com>
Date:   Wed, 5 Jul 2023 17:15:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 0/8] Mdmonitor refactor and udev event handling
 improvements
To:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <36ac759b-9505-aa7d-1efc-aaeb41dcb3eb@trained-monkey.org>
Content-Language: en-US
From:   "Grzonka, Mateusz" <mateusz.grzonka@linux.intel.com>
In-Reply-To: <36ac759b-9505-aa7d-1efc-aaeb41dcb3eb@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/2/2023 5:00 PM, Jes Sorensen wrote:
> On 2/2/23 06:26, Mateusz Grzonka wrote:
>> Along the way we observed many problems with current approach to event handling in mdmonitor.
>> It frequently doesn't report Fail and DeviceDisappeared events.
>> It's due to time races with udev, and too long delay in some cases.
>> While there was a patch intending to address time races with udev, it didn't remove them completely.
>> This patch series presents alternative approach, where mdmonitor wakes up on udev events, so that
>> there should be no more conflicts with udev we saw before.
>>
>> Additionally some code quality improvements were done, to make the code more maintainable.
>>
>> v2:
>> Fixed mismatched comment style and rebased onto master.
>>
>> v3:
>> Resend to cleanup on patchwork.
>>
>> Mateusz Grzonka (8):
>>    Mdmonitor: Make alert_info global
>>    Mdmonitor: Pass events to alert() using enums instead of strings
>>    Mdmonitor: Add helper functions
>>    Add helpers to determine whether directories or files are soft links
>>    Mdmonitor: Refactor write_autorebuild_pid()
>>    Mdmonitor: Refactor check_one_sharer() for better error handling
>>    Mdmonitor: Improve udev event handling
>>    udev: Move udev_block() and udev_unblock() into udev.c
> 
> Hi Mateusz,
> 
> 1-6 applied, 7+8 don't build on Fedora 36.
> 
> Thanks,
> Jes
> 

Hi Jes,

sorry for the late response,
I fixed the two last patches and marked the series as v4.

Thanks,
Mateusz
