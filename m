Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824E9C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 07:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AEDC60FDC
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 07:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhJNHfA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 03:35:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:2205 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhJNHfA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Oct 2021 03:35:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="214778812"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="214778812"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 00:32:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="442632666"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 14 Oct 2021 00:32:55 -0700
Received: from [10.249.129.206] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.129.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id EA525580699;
        Thu, 14 Oct 2021 00:32:54 -0700 (PDT)
Subject: Re: [PATCH] imsm: Remove possibility for get_imsm_dev to return NULL
To:     Jes Sorensen <jes@trained-monkey.org>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210920111032.19195-1-mateusz.grzonka@intel.com>
 <be5f8bd5-9434-a403-a982-fd41cf1fe9a2@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <85b62315-4651-cb9e-5001-6d2faa8bbfc8@linux.intel.com>
Date:   Thu, 14 Oct 2021 09:32:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <be5f8bd5-9434-a403-a982-fd41cf1fe9a2@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

On 08.10.2021 18:05, Jes Sorensen wrote:
> On 9/20/21 7:10 AM, Mateusz Grzonka wrote:
>> Returning NULL from get_imsm_dev or __get_imsm_dev will cause segfault.
>> Guarantee that it never happens.
>>
>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
>> ---
>>   super-intel.c | 122 +++++++++++++++++++-------------------------------
>>   1 file changed, 46 insertions(+), 76 deletions(-)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index 83ddc000..2c3df58a 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -858,30 +858,29 @@ static struct imsm_dev *__get_imsm_dev(struct imsm_super *mpb, __u8 index)
>>   	void *_mpb = mpb;
>>   
>>   	if (index >= mpb->num_raid_devs)
>> -		return NULL;
>> +		goto error;
>>   
>>   	/* devices start after all disks */
>>   	offset = ((void *) &mpb->disk[mpb->num_disks]) - _mpb;
>>   
>> -	for (i = 0; i <= index; i++)
>> +	for (i = 0; i <= index; i++, offset += sizeof_imsm_dev(_mpb + offset, 0))
>>   		if (i == index)
>>   			return _mpb + offset;
>> -		else
>> -			offset += sizeof_imsm_dev(_mpb + offset, 0);
>> -
>> -	return NULL;
>> +error:
>> +	pr_err("matching failed, index: %u\n", index);
>> +	abort();
>>   }
> 
> Can we please fix the error handling properly instead of throwing in
> abort() and assert() to avoid it. That's really sloppy in my book.
> 

This situation is unexpected and shall never happen. I don't see any
advantage of handling it. Abort() is the most elegant solution.
If it happens, it shall fail loudly. Verifying that we don't get
NULL in each place where it is called is harmful and unnecessary.

Passing wrong index means that code is broken and we definitely cannot
continue.

Thanks,
Mariusz

