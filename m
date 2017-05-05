From: Liu Zhilong <zlliu@suse.com>
Subject: Re: [mdadm PATCH] Create: move STOP_ARRAY to abort_locked
Date: Fri, 5 May 2017 11:31:26 +0800
Message-ID: <be1df636-2bbb-2757-7a96-264d2d1a4b65@suse.com>
References: <1493190229-14329-1-git-send-email-zlliu@suse.com>
 <430f083a-2501-cb74-4ac1-89d1c4620a03@suse.com>
 <2c1c277c-2fd2-27a8-e6a5-23b1ced3ec90@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c1c277c-2fd2-27a8-e6a5-23b1ced3ec90@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/04/2017 10:54 PM, Jes Sorensen wrote:
> On 05/04/2017 08:20 AM, Zhilong Liu wrote:
>> Hi Jes,
>>
>> apply for review, this is a bug I ever encountered.
>
> Zhilong,
>
> Under what circumstances do you see this?
>

Issued the command:
linux-g0sr:/home/test # ./mdadm -CR /dev/md0 -l1 -n2 -b internal 
/dev/loop[0-1] --size 63
... ... ...
mdadm: Given bitmap chunk size not supported.
linux-g0sr:/home/test # ls /dev/md0
/dev/md0
linux-g0sr:/home/test # ls /sys/block/md0/md/
array_size   bitmap      component_size  level metadata_version  
raid_disks         reshape_position safe_mode_delay
array_state  chunk_size  layout          max_read_errors 
new_dev           reshape_direction  resync_start

create_mddev() writes the devnm to /sys/module/md_mod/parameter/new_array,
then in md.c, module_param_call() called the 'set' function of 
add_named_array(),
md_alloc() init_and_add the kobject for devm, finally the devnm device 
has created
and sysfs has registered after create_mddev executed successfully. Thus 
it's better
to STOP_ARRAY in any case after create_mddev() invoked.

Thanks,
-Zhilong

> Thanks,
> Jes
>
>>
>> On 04/26/2017 03:03 PM, Zhilong Liu wrote:
>>> The sysfs entry and devnm would be created once create_mddev()
>>> performed successfully, but the creating isn't completed here,
>>> move STOP_ARRAY to abort_locked, the purpose is to cleanup the
>>> partially created array.
>>>
>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>> ---
>>>   Create.c | 11 ++++-------
>>>   1 file changed, 4 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/Create.c b/Create.c
>>> index 6ca0924..fe0ab7e 100644
>>> --- a/Create.c
>>> +++ b/Create.c
>>> @@ -904,10 +904,8 @@ int Create(struct supertype *st, char *mddev,
>>>                       remove_partitions(fd);
>>>                   if (st->ss->add_to_super(st, &inf->disk,
>>>                                fd, dv->devname,
>>> -                             dv->data_offset)) {
>>> -                    ioctl(mdfd, STOP_ARRAY, NULL);
>>> +                             dv->data_offset))
>>>                       goto abort_locked;
>>> -                }
>>>                   st->ss->getinfo_super(st, inf, NULL);
>>>                   safe_mode_delay = inf->safe_mode_delay;
>>>   @@ -1008,7 +1006,6 @@ int Create(struct supertype *st, char *mddev,
>>>               sysfs_set_safemode(&info, safe_mode_delay);
>>>               if (err) {
>>>                   pr_err("failed to activate array.\n");
>>> -                ioctl(mdfd, STOP_ARRAY, NULL);
>>>                   goto abort;
>>>               }
>>>           } else if (c->readonly &&
>>> @@ -1018,7 +1015,6 @@ int Create(struct supertype *st, char *mddev,
>>>                         "array_state", "readonly") < 0) {
>>>                   pr_err("Failed to start array: %s\n",
>>>                          strerror(errno));
>>> -                ioctl(mdfd, STOP_ARRAY, NULL);
>>>                   goto abort;
>>>               }
>>>           } else {
>>> @@ -1030,7 +1026,6 @@ int Create(struct supertype *st, char *mddev,
>>>                   if (info.array.chunk_size &
>>> (info.array.chunk_size-1)) {
>>>                       cont_err("Problem may be that chunk size is not
>>> a power of 2\n");
>>>                   }
>>> -                ioctl(mdfd, STOP_ARRAY, NULL);
>>>                   goto abort;
>>>               }
>>>               /* if start_ro module parameter is set, array is
>>> @@ -1061,7 +1056,9 @@ int Create(struct supertype *st, char *mddev,
>>>       map_remove(&map, fd2devnm(mdfd));
>>>       map_unlock(&map);
>>>   -    if (mdfd >= 0)
>>> +    if (mdfd >= 0) {
>>> +        ioctl(mdfd, STOP_ARRAY, NULL);
>>>           close(mdfd);
>>> +    }
>>>       return 1;
>>>   }
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

