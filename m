Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97882C12002
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jul 2021 13:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8216761019
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jul 2021 13:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhGUNK7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jul 2021 09:10:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:61392 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238855AbhGUNK7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 21 Jul 2021 09:10:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211436789"
X-IronPort-AV: E=Sophos;i="5.84,258,1620716400"; 
   d="scan'208";a="211436789"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 06:51:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,258,1620716400"; 
   d="scan'208";a="632651224"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 21 Jul 2021 06:51:35 -0700
Received: from [10.213.7.111] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.7.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 632F75807D2;
        Wed, 21 Jul 2021 06:51:34 -0700 (PDT)
Subject: Re: mdadm 4.2-rc2
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Xiao Ni <xni@redhat.com>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>,
        blazej.kucman@intel.com, linux-raid <linux-raid@vger.kernel.org>
References: <614b0f39-0a1d-5c86-be88-42f65a72911b@linux.intel.com>
 <1efd204f-917f-d812-2089-c651f492f8f9@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <c02437eb-8ad0-8183-6f29-070c5aadd85a@linux.intel.com>
Date:   Wed, 21 Jul 2021 15:51:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1efd204f-917f-d812-2089-c651f492f8f9@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
Could you please include my latest patch in rc2?
https://lore.kernel.org/linux-raid/20210721114220.19399-1-
mariusz.tkaczyk@linux.intel.com/T/#u

Thanks,
Mariusz

On 16.07.2021 16:33, Jes Sorensen wrote:
> On 6/28/21 9:48 AM, Tkaczyk, Mariusz wrote:
>> Hello Jes,
>> A lot of mdadm patches are waiting, could you look into them?
>>
>> IMO it is good time to mark rc2. Do you agree?
> 
> Hi Mariusz,
> 
> I finally had time to go through the pending changes, I think I got
> everything. Sorry it's been chaotic as usual here.
> 
> Unless I missed something urgent, then I think rc2 is appropriate.
> Please speak up loudly if I missed anything.
> 
> Thanks,
> Jes
> 

