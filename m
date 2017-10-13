From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] md: ensure sectors is nonzero when change component size
Date: Fri, 13 Oct 2017 10:47:29 +0800
Message-ID: <111b18f3-4db6-bf53-3a9f-15db452192ba@suse.com>
References: <1507797051-18545-1-git-send-email-zlliu@suse.com>
 <20171012173743.nocrm6ejov3pvhjd@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171012173743.nocrm6ejov3pvhjd@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids



On 10/13/2017 01:37 AM, Shaohua Li wrote:
> On Thu, Oct 12, 2017 at 04:30:51PM +0800, Zhilong Liu wrote:
>> Against the raids which chunk_size is meaningful, the component_size
>> must be >= chunk_size when require resize. If "new_size < chunk_size"
>> has required, the "mddev->pers->resize" will set sectors as '0', and
>> then the raids isn't meaningful any more due to mddev->dev_sectors is
>> '0'.
>>
>> Cc: Neil Brown <neilb@suse.com>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> Not sure about this, does size 0 disk really harm?
>

 From my site, I think changing the component size as '0' should be avoided.
When resize changing required and new_size < current_chunk_size, such as
raid5:

raid5.c: raid5_resize()
...
7727         sectors &= ~((sector_t)conf->chunk_sectors - 1);
...

'sectors' got '0'.

then:
...
7743         mddev->dev_sectors = sectors;
...

the dev_sectors(the component size) got '0'.
same scenario happens in raid10.

So, it's really not meaningful if changing the raid component_size to 
'0', md
should give this scenario a test, otherwise, it's a trouble thing to 
restore after
doing such invalid re-size.

Thanks,
-Zhilong

>> ---
>>   drivers/md/raid10.c | 2 ++
>>   drivers/md/raid5.c  | 2 ++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 374df57..f3891f6 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -3871,6 +3871,8 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
>>   
>>   	oldsize = raid10_size(mddev, 0, 0);
>>   	size = raid10_size(mddev, sectors, 0);
>> +	if (size == 0)
>> +		return -EINVAL;
>>   	if (mddev->external_size &&
>>   	    mddev->array_sectors > size)
>>   		return -EINVAL;
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 928e24a..768767c 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7725,6 +7725,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
>>   	if (conf->log || raid5_has_ppl(conf))
>>   		return -EINVAL;
>>   	sectors &= ~((sector_t)conf->chunk_sectors - 1);
>> +	if (sectors == 0)
>> +		return -EINVAL;
>>   	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
>>   	if (mddev->external_size &&
>>   	    mddev->array_sectors > newsize)
>> -- 
>> 2.6.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

