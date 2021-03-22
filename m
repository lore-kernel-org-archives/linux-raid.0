Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB075C433DB
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 16:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 780066199F
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 16:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhCVQ6f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:58:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:39144 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhCVQ6a (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 22 Mar 2021 12:58:30 -0400
IronPort-SDR: E6LzvFyaIU9QhFBAQNlBnlhp0jr+luLNL5UPfEqoyb9iNwPeKeDYms1IN/QgAxHI8kxP9b9sje
 BL6z0YtBrPZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="186991456"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="186991456"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:58:28 -0700
IronPort-SDR: csMAkhWw4EdnJZ9PgSGX/hZmKqjDdhbJfNvfo6dXl9HkGJfJomXlruAKVg+r0+Bw6emB6BUlBn
 BjwSGkDpf3iw==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="451803351"
Received: from oshchirs-mobl.ger.corp.intel.com (HELO [10.213.7.90]) ([10.213.7.90])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:58:27 -0700
Subject: Re: IMSM regresion
References: <0a15c6a6-e8ba-be96-4323-bddcc2b993b8 () trained-monkey ! org>
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Message-ID: <f80d8e76-8ad3-1e82-e051-00e24d44be89@linux.intel.com>
Date:   Mon, 22 Mar 2021 17:58:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <0a15c6a6-e8ba-be96-4323-bddcc2b993b8 () trained-monkey ! org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Jes,

I have analyzed this issue, and information with this analysis is posted in 
a separate thread.
The issue is caused by patch 4ae96c802203.
We have no fix for it at the moment, and if you plan to mark a release 
candidate now, it would be good to revert that patch (as Nigel already 
mentioned).

Thank you!

On 3/16/2021 9:22 PM, Jes Sorensen wrote:
> On 3/12/21 5:14 AM, Tkaczyk, Mariusz wrote:
>> Hello Jes,
>>
>> We discovered IMSM regression after last push in following scenario:
>>
>> #mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
>> #mdadm -CR volume -l0 --chunk 64 --raid-devices=1 /dev/nvme0n1 --force
>> #mdadm -G /dev/md/imsm0 -n2
>>
>> At the end of reshape, level doesn't back to RAID0.
>>
>> This is an information. We are working on fix. Please don't mark release
>> candidate yet.
> 
> Thanks for the heads up!
> 
> Jes
> 

-- 
Regards,
Oleksandr Shchirskyi
