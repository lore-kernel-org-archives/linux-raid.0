Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F37EC43334
	for <linux-raid@archiver.kernel.org>; Fri, 17 Jun 2022 17:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiFQRJ7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Jun 2022 13:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiFQRJ5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Jun 2022 13:09:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B56EF3A5EC
        for <linux-raid@vger.kernel.org>; Fri, 17 Jun 2022 10:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655485795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wjwts4tPn2T+sH/BgNjKnDnRAID0YFsj0Rwa/UfDMk=;
        b=i4ogh2xZBAOxvyAwycbROHpaSUEhAgT8KwaujzW7+4LCkNkJ4ZxrsH2oO9bJRUHu2Djn4w
        SHEENFV2LTZxBsYot1C5hk/Nb3D2FO6IvIMQAbmxb54jjYk2TihVKkMTR3fYXT5ieb3ncr
        1P6Ki8PCHIuYyN9Hzp/xNqbEJAhon6o=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-wm7K3M_NPGO-T-r07Hxfyw-1; Fri, 17 Jun 2022 13:09:54 -0400
X-MC-Unique: wm7K3M_NPGO-T-r07Hxfyw-1
Received: by mail-qk1-f198.google.com with SMTP id o10-20020a05620a2a0a00b006a77a64cd23so5551039qkp.21
        for <linux-raid@vger.kernel.org>; Fri, 17 Jun 2022 10:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=1wjwts4tPn2T+sH/BgNjKnDnRAID0YFsj0Rwa/UfDMk=;
        b=Rl8V5SB9Vu77NdtHZrnaLxY2NuLtAjxgGTpEszG3UhdTHuEfXDmNF+VSp+qYsZnp60
         mf4eAOTXUyl/R/I7lwbV/3CyFwV2OicXWrSGH3AvGhYQqBTGC0bixZENtoHFgTR1Er2E
         6UliQ/pTc1JVhG0tDQQucNpar/WE6TvfKAefv5LoFgTt4imSFRsknJANlr6IaKIn7hHO
         SsmYi6EZeEcinJmjqW/nKdfxvN3WLwR/E0hlgMhQDo8lPDz24iqHpuWy9nxJfWirT8mX
         cPPJByjKJOoKxrzJMhtoj8BnBy0YOmXEoywe9fHUiKR3hAl3CJefhFEN/Po5Pyenyg0G
         GIQg==
X-Gm-Message-State: AJIora8p7OUIerIe11QAG+KKiAnXTJuLzyrBc9PC0oAEugOwxVf26fye
        t43r7tbZEU+qf9aKfk2+XPaZTYX43o2RyK3CZMoEyZZHfWPIIUuSRdcvNMdN3F6OvO+S31e05WG
        vL87xWwXbRAO6Ybwq2JFDqA==
X-Received: by 2002:a05:622a:103:b0:305:89b:f159 with SMTP id u3-20020a05622a010300b00305089bf159mr9539314qtw.488.1655485793271;
        Fri, 17 Jun 2022 10:09:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ttj5IEphbPnhiFP3V0jqOFK+SW0i7z8mxhSUimsAR/8tpxZw4lgS4xS4v5Ravi7X5O08X30Q==
X-Received: by 2002:a05:622a:103:b0:305:89b:f159 with SMTP id u3-20020a05622a010300b00305089bf159mr9539285qtw.488.1655485792952;
        Fri, 17 Jun 2022 10:09:52 -0700 (PDT)
Received: from [192.168.1.211] (d-137-103-110-215.nh.cpe.atlanticbb.net. [137.103.110.215])
        by smtp.gmail.com with ESMTPSA id h8-20020ac87148000000b003050af740e6sm4452138qtp.22.2022.06.17.10.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 10:09:52 -0700 (PDT)
Message-ID: <62ec6c6e-76b7-e705-7326-a82b59f337b8@redhat.com>
Date:   Fri, 17 Jun 2022 13:09:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
Content-Language: en-US
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com, wuguanghao3@huawei.com,
        colyli@suse.de
References: <20220418174423.846026-1-ncroxon@redhat.com>
 <54144438-5b6a-60dd-6f62-e90e052772ee@redhat.com>
In-Reply-To: <54144438-5b6a-60dd-6f62-e90e052772ee@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/14/22 10:11 AM, Nigel Croxon wrote:
> On 4/18/22 1:44 PM, Nigel Croxon wrote:
>> This reverts commit 546047688e1c64638f462147c755b58119cabdc8.
>>
>> The change from commit mdadm: fix coredump of mdadm
>> --monitor -r broke the printing of the return message when
>> passing -r to mdadm --manage, the removal of a device from
>> an array.
>>
>> If the current code reverts this commit, both issues are
>> still fixed.
>>
>> The original problem reported that the fix tried to address
>> was:  The --monitor -r option requires a parameter,
>> otherwise a null pointer will be manipulated when
>> converting to integer data, and a core dump will appear.
>>
>> The original problem was really fixed with:
>> 60815698c0a Refactor parse_num and use it to parse optarg.
>> Which added a check for NULL in 'optarg' before moving it
>> to the 'increments' variable.
>>
>> New issue: When trying to remove a device using the short
>> argument -r, instead of the long argument --remove, the
>> output is empty. The problem started when commit
>> 546047688e1c was added.
>>
>> Steps to Reproduce:
>> 1. create/assemble /dev/md0 device
>> 2. mdadm --manage /dev/md0 -r /dev/vdxx
>>
>> Actual results:
>> Nothing, empty output, nothing happens, the device is still
>> connected to the array.
>>
>> The output should have stated "mdadm: hot remove failed
>> for /dev/vdxx: Device or resource busy", if the device was
>> still active. Or it should remove the device and print
>> a message:
>>
>> mdadm: set /dev/vdd faulty in /dev/md0
>> mdadm: hot removed /dev/vdd from /dev/md0
>>
>> The following commit should be reverted as it breaks
>> mdadm --manage -r.
>>
>> commit 546047688e1c64638f462147c755b58119cabdc8
>> Author: Wu Guanghao <wuguanghao3@huawei.com>
>> Date:   Mon Aug 16 15:24:51 2021 +0800
>> mdadm: fix coredump of mdadm --monitor -r
>>
>> -Nigel
>>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>> ---
>>   ReadMe.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/ReadMe.c b/ReadMe.c
>> index 8f873c48..bec1be9a 100644
>> --- a/ReadMe.c
>> +++ b/ReadMe.c
>> @@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " 
>> VERS_DATE EXTRAVERSION "\n";
>>    *     found, it is started.
>>    */
>> -char 
>> short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k"; 
>>
>> +char 
>> short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:"; 
>>
>>   char short_bitmap_options[]=
>> -        
>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>> +        
>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>>   char short_bitmap_auto_options[]=
>> -        
>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
>> +        
>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
>>   struct option long_options[] = {
>>       {"manage",    0, 0, ManageOpt},
> 
> Jes, That is the status of this patch?
> 
> Thanks, Nigel


Jes, Is there an issue with reverting this patch?

-Nigel

