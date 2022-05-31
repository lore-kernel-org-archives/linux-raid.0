Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5F9C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 08:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbiEaIZg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 04:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiEaIZf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 04:25:35 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39C591572
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 01:25:33 -0700 (PDT)
Received: from [192.168.0.4] (ip5f5aeb8b.dynamic.kabel-deutschland.de [95.90.235.139])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3FE8861EA192C;
        Tue, 31 May 2022 10:25:32 +0200 (CEST)
Message-ID: <1cbeaaa7-4b49-478a-9333-1885e8047a3f@molgen.mpg.de>
Date:   Tue, 31 May 2022 10:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5/5] get_vd_num_of_subarray: fix memleak
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Wu Guanghao <wuguanghao3@huawei.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org, linfeilong@huawei.com,
        lixiaokeng@huawei.com
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
 <f1bee99f-a9b0-0e58-36fb-e5eee110dcc9@huawei.com>
 <20220531101132.00002141@linux.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220531101132.00002141@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Mariusz,


Am 31.05.22 um 10:11 schrieb Mariusz Tkaczyk:
> On Tue, 31 May 2022 14:51:13 +0800 Wu Guanghao wrote:
> 
>> sra = sysfs_read() should be free before return in
>> get_vd_num_of_subarray()
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>   super-ddf.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/super-ddf.c b/super-ddf.c
>> index 8cda23a7..827e4ae7 100644
>> --- a/super-ddf.c
>> +++ b/super-ddf.c
>> @@ -1599,15 +1599,20 @@ static unsigned int get_vd_num_of_subarray(struct
>> supertype *st) sra = sysfs_read(-1, st->devnm, GET_VERSION);
>>   	if (!sra || sra->array.major_version != -1 ||
>>   	    sra->array.minor_version != -2 ||
>> -	    !is_subarray(sra->text_version))
>> +	    !is_subarray(sra->text_version)) {
>> +		if (sra)
>> +			sysfs_free(sra);
>>   		return DDF_NOTFOUND;
>> +	}
>>
>>   	sub = strchr(sra->text_version + 1, '/');
>>   	if (sub != NULL)
>>   		vcnum = strtoul(sub + 1, &end, 10);
>>   	if (sub == NULL || *sub == '\0' || *end != '\0' ||
>> -	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries))
>> +	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries)) {
>> +		sysfs_free(sra);
>>   		return DDF_NOTFOUND;
>> +	}
>>
>>   	return vcnum;
>>   }
> 
> Acked-by:mariusz.tkaczyk@linux.intel.com

Thank you for your review. The common format is:

Acked-by: Name <address>


Kind regards,

Paul
