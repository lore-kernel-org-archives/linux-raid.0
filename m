From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH v2] mdadm/grow: adding a test to ensure resize was
 required
Date: Wed, 18 Oct 2017 16:01:43 +0800
Message-ID: <c3ec4c9d-f7ff-db9a-325c-ff107bdd6690@suse.com>
References: <1507537274-29350-2-git-send-email-zlliu@suse.com>
 <1507711992-11548-1-git-send-email-zlliu@suse.com>
 <1c66e9b1-59fd-cfe6-bc03-df735421b7a5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1c66e9b1-59fd-cfe6-bc03-df735421b7a5@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/12/2017 01:31 AM, Jes Sorensen wrote:
> On 10/11/2017 04:53 AM, Zhilong Liu wrote:
>> To fix the commit: 4b74a905a67e
>> (mdadm/grow: Component size must be larger than chunk size)
>>
>> array.level > 1 : against the raids which chunk_size is meaningful.
>> s->size > 0 : ensure that changing component size has required.
>> array.chunk_size / 1024 > s->size : ensure component size should
>> be always >= current chunk_size when requires resize, otherwise,
>> mddev->pers->resize would be set mddev->dev_sectors as '0'.
>>
>> Reported-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>> Suggested-by: NeilBrown <neilb@suse.com>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>>
>> v1: [PATCH 1/3] mdadm/Grow: fix the broken raid level conversion
>>
>> changes:
>>    correct the test 's->level == UnSet' as 's->size > 0'
>>
>>   Grow.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Grow.c b/Grow.c
>> index 4d79d83..8c2d50c 100644
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -1810,6 +1810,7 @@ int Grow_reshape(char *devname, int fd,
>>       }
>>         if (array.level > 1 &&
>> +        s->size > 0 &&
>>          (array.chunk_size / 1024) > (int)s->size) {
>>           pr_err("component size must be larger than chunk size.\n");
>>           return 1;
>
> Applied, however I fixed the broken formatting in the process.
>

I'm sorry that I have re-checked the code, this patch is buggy.
The correct fix should be "s->size > 1" or "s->level == UnSet",
I forgot the parameter of "--size max".

Thanks,
-Zhilong

> Thanks,
> Jes
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

