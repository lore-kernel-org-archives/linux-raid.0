From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 09/13] md-cluster: always setup in-memory bitmap
Date: Wed, 27 Apr 2016 22:59:51 -0400
Message-ID: <57217CA7.4070600@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
 <1461218294-4960-10-git-send-email-gqjiang@suse.com>
 <20160425174521.GB11993@kernel.org> <571EDEFD.3090103@suse.com>
 <20160427152449.GA17061@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160427152449.GA17061@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids




On 04/27/2016 11:24 AM, Shaohua Li wrote:
>>   static bitmap_counter_t *bitmap_get_counter(struct bitmap_counts *bitmap,
>>   					    sector_t offset, sector_t *blocks,
>> -					    int create)
>> +					    int create, int no_hijack)
>>   __releases(bitmap->lock)
>>   __acquires(bitmap->lock)
>>   {
>> @@ -1321,7 +1324,7 @@ __acquires(bitmap->lock)
>>   	sector_t csize;
>>   	int err;
>> -	err = bitmap_checkpage(bitmap, page, create);
>> +	err = bitmap_checkpage(bitmap, page, create, 0);
>>   	if (bitmap->bp[page].hijacked ||
>>   	    bitmap->bp[page].map == NULL)
>>> bitmap_get_counter doesn't use the new no_hijack parameter. And you always pass
>>> 0 to this function. so looks this change isn't required.
>>>
>> The below part of this patch pass 1 to bitmap_checkpage, so it is needed.
>>
>> +	/* For cluster raid, need to pre-allocate bitmap */
>> +	if (mddev_is_clustered(bitmap->mddev)) {
>> +		unsigned long page;
>> +		for (page = 0; page < pages; page++) {
>> +			ret = bitmap_checkpage(&bitmap->counts, page, 1, 1);
> I mean bitmap_get_counter(). You add no_hijack parameter, but not use it

Yes, I misunderstood it, thanks for point it out and will remove it.

Regards,
Guoqing
