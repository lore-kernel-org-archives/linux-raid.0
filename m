From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] Create: move STOP_ARRAY to abort_locked
Date: Mon, 8 May 2017 13:54:11 -0400
Message-ID: <8275d868-ad51-209b-e46f-9d7f1c60d1a3@gmail.com>
References: <1493190229-14329-1-git-send-email-zlliu@suse.com>
 <430f083a-2501-cb74-4ac1-89d1c4620a03@suse.com>
 <2c1c277c-2fd2-27a8-e6a5-23b1ced3ec90@gmail.com>
 <be1df636-2bbb-2757-7a96-264d2d1a4b65@suse.com>
 <2b947e61-36b6-0c6c-c25c-a9d2831cca11@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2b947e61-36b6-0c6c-c25c-a9d2831cca11@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/07/2017 09:50 PM, Zhilong Liu wrote:
>
>
> On 05/05/2017 11:31 AM, Liu Zhilong wrote:
>>
>>
>> On 05/04/2017 10:54 PM, Jes Sorensen wrote:
>>> On 05/04/2017 08:20 AM, Zhilong Liu wrote:
>>>> Hi Jes,
>>>>
>>>> apply for review, this is a bug I ever encountered.
>>>
>>> Zhilong,
>>>
>>> Under what circumstances do you see this?
>>>
>>
>> Issued the command:
>> linux-g0sr:/home/test # ./mdadm -CR /dev/md0 -l1 -n2 -b internal
>> /dev/loop[0-1] --size 63
>> ... ... ...
>> mdadm: Given bitmap chunk size not supported.
>> linux-g0sr:/home/test # ls /dev/md0
>> /dev/md0
>> linux-g0sr:/home/test # ls /sys/block/md0/md/
>> array_size   bitmap      component_size  level metadata_version
>> raid_disks         reshape_position safe_mode_delay
>> array_state  chunk_size  layout          max_read_errors
>> new_dev           reshape_direction  resync_start
>>
>> create_mddev() writes the devnm to
>> /sys/module/md_mod/parameter/new_array,
>> then in md.c, module_param_call() called the 'set' function of
>> add_named_array(),
>> md_alloc() init_and_add the kobject for devm, finally the devnm device
>> has created
>> and sysfs has registered after create_mddev executed successfully.
>> Thus it's better
>> to STOP_ARRAY in any case after create_mddev() invoked.
>>
>
> this patch depends on the kernel commit:
> 039b7225e6e9 ("md: allow creation of mdNNN arrays via
> md_mod/parameters/new_array")
> Neil's patch has set "mddev->hold_active = UNTIL_STOP", thus the
> STOP_ARRAY can work
> well on this situation.

OK now I am confused - are you saying this change will only work after 
Neil's kernel patch has been applied? That would be no good, mdadm needs 
to work on older kernels too.

Jes


