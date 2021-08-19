Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F0EC4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 11:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971BD61051
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 11:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbhHSLpi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 07:45:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:10489 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238210AbhHSLpi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 19 Aug 2021 07:45:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="214691803"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="214691803"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 04:45:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="463027579"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 19 Aug 2021 04:45:02 -0700
Received: from [10.213.2.38] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.2.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9343458041D;
        Thu, 19 Aug 2021 04:45:00 -0700 (PDT)
Subject: Re: [PATCH]mdadm: fix coredump of mdadm --monitor -r
To:     Wu Guanghao <wuguanghao3@huawei.com>, linux-raid@vger.kernel.org,
        jsorensen@fb.com, jes@trained-monkey.org
Cc:     liuzhiqiang26@huawei.com, linfeilong@huawei.com
References: <41edfa76-4327-7468-b861-1c1140ee9725@huawei.com>
 <07c4f930-cc9b-2fe8-7d01-04ff383ef90e@huawei.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <eae02f51-41dd-a7f4-ba67-cfe51b596d9e@linux.intel.com>
Date:   Thu, 19 Aug 2021 13:44:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <07c4f930-cc9b-2fe8-7d01-04ff383ef90e@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19.08.2021 10:21, Wu Guanghao wrote:
> ping
> 
> 在 2021/8/16 15:24, Wu Guanghao 写道:
>> Hi,
>>
>> The --monitor -r option requires a parameter, otherwise a null pointer will be manipulated
>> when converting to integer data, and a coredump will appear.
>>
>> # mdadm --monitor -r
>> Segmentation fault (core dumped)
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>   ReadMe.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/ReadMe.c b/ReadMe.c
>> index 06b8f7e..070a164 100644
>> --- a/ReadMe.c
>> +++ b/ReadMe.c
>> @@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
>>    *     found, it is started.
>>    */
>>
>> -char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>> +char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
>>   char short_bitmap_options[]=
>> -               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>> +               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
>>   char short_bitmap_auto_options[]=
>> -               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
>> +               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:RSow1tye:k";
>>
>>   struct option long_options[] = {
>>       {"manage",    0, 0, ManageOpt},
>> --
>> 2.23.0
>> .
>>

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
