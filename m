From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] md: ensure sectors is nonzero when change component size
Date: Mon, 23 Oct 2017 17:23:10 +0800
Message-ID: <54ff0bef-e6f3-a94b-af94-5014db2143a0@suse.com>
References: <1507797051-18545-1-git-send-email-zlliu@suse.com>
 <20171012173743.nocrm6ejov3pvhjd@kernel.org>
 <111b18f3-4db6-bf53-3a9f-15db452192ba@suse.com>
 <20171013190558.svbyj35i7xtls4wr@kernel.org>
 <31970279-37d7-e8bc-b37f-955f23434f7f@suse.com>
 <871sm2lj3o.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sm2lj3o.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/17/2017 08:21 AM, NeilBrown wrote:
> On Mon, Oct 16 2017, Zhilong Liu wrote:
>
>> On 10/14/2017 03:05 AM, Shaohua Li wrote:
>>> On Fri, Oct 13, 2017 at 10:47:29AM +0800, Zhilong Liu wrote:
>>>> On 10/13/2017 01:37 AM, Shaohua Li wrote:
>>>>> On Thu, Oct 12, 2017 at 04:30:51PM +0800, Zhilong Liu wrote:
>>>>>> Against the raids which chunk_size is meaningful, the component_size
>>>>>> must be >= chunk_size when require resize. If "new_size < chunk_size"
>>>>>> has required, the "mddev->pers->resize" will set sectors as '0', and
>>>>>> then the raids isn't meaningful any more due to mddev->dev_sectors is
>>>>>> '0'.
>>>>>>
>>>>>> Cc: Neil Brown <neilb@suse.com>
>>>>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>>>> Not sure about this, does size 0 disk really harm?
>>>>>
>>>>   From my site, I think changing the component size as '0' should be avoided.
>>>> When resize changing required and new_size < current_chunk_size, such as
>>>> raid5:
>>>>
>>>> raid5.c: raid5_resize()
>>>> ...
>>>> 7727         sectors &= ~((sector_t)conf->chunk_sectors - 1);
>>>> ...
>>>>
>>>> 'sectors' got '0'.
>>>>
>>>> then:
>>>> ...
>>>> 7743         mddev->dev_sectors = sectors;
>>>> ...
>>>>
>>>> the dev_sectors(the component size) got '0'.
>>>> same scenario happens in raid10.
>>>>
>>>> So, it's really not meaningful if changing the raid component_size to '0',
>>>> md
>>>> should give this scenario a test, otherwise, it's a trouble thing to restore
>>>> after
>>>> doing such invalid re-size.
>>> Yes, I understand how it could be 0. My question is what's wrong with a size-0
>>> disk? For example, if you don't setup file for a loop block device, its size is
>>> 0.
>> I'm sorry I'm not very clear with your question, I try to describe more
>> on this scenario.
>> the 0-component_size isn't a 0-size disk. resize doesn't change
>> raid_member_disk size
>> to 0.
>>
>> For example: mdadm -CR /dev/md0 -b internal -l5 -n2 -x1 /dev/sd[b-d]
>> if set the component_size to 0, how would the 'internal bitmap' be? And
>> if I want to make
>> a file-system on this raid, how would it be? it's out of my control.
>>
>> I would continue to provide infos for you if any questions needs further
>> discussion.
>>
>> Hope this information is useful for you.
>> Here is piece of dmesg for the following steps:
>> 1. mdadm -CR /dev/md0 -b internal -l5 -n2 -x1 /dev/sd[b-d]
>> 2. mdadm -G /dev/md0 --size 511
>> 3. mkfs.ext3 /dev/md0
>> the mkfs would be stuck all time, cannot kill the mkfs process and have to
>> force to reboot, then lots of same call trace prints in dmesg.
> I think the cause of this problem is that raid5_size() treats zero
> values for 'sectors' and 'raid_disks' as "don't change".
>
> So setting the size to zero will change mddev->dev_sectors but not
> mddev->array_size.
> This causes internal confusion.
> Maybe we should use a different number of "don't change" ??
>
> This could affect any of the ->size() functions.

Thanks for the clarification, yes, this causes the array unusable, such 
as the mkfs
causes the process stuck or continue to resize the array refused by 
mdadm due to
the component_size is '0', .etc.

Thanks,
-Zhilong

>
> NeilBrown

