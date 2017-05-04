From: Zhilong <zlliu@suse.com>
Subject: Re: [mdadm PATCH] Create: move STOP_ARRAY to abort_locked
Date: Fri, 5 May 2017 01:42:57 +0800
Message-ID: <AA2D71C7-75F8-49D0-BE97-52A227EA6DA3@suse.com>
References: <1493190229-14329-1-git-send-email-zlliu@suse.com> <430f083a-2501-cb74-4ac1-89d1c4620a03@suse.com> <2c1c277c-2fd2-27a8-e6a5-23b1ced3ec90@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c1c277c-2fd2-27a8-e6a5-23b1ced3ec90@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



发自我的 iPhone

> 在 2017年5月4日，22:54，Jes Sorensen <jes.sorensen@gmail.com> 写道：
> 
>> On 05/04/2017 08:20 AM, Zhilong Liu wrote:
>> Hi Jes,
>> 
>> apply for review, this is a bug I ever encountered.
> 
> Zhilong,
> 
> Under what circumstances do you see this?
> 

I have tested this path after invoking create_mddev, such as issue the command:
./mdadm -CR /dev/md0 -b internal -l1 -n2 /dev/loop[0-1] --size 63
It would fail and print unsupported chunk size. But the device /dev/md0 and sysfs didn't cleanup after abort creating.
 For raid1, the chunk size is not meaningful, but mdadm doesn't allow component size is less than 64k when creating bitmap, thus I choose this command to test.

Thanks,
Zhilong 

> Thanks,
> Jes
> 
>> 
>>> On 04/26/2017 03:03 PM, Zhilong Liu wrote:
>>> The sysfs entry and devnm would be created once create_mddev()
>>> performed successfully, but the creating isn't completed here,
>>> move STOP_ARRAY to abort_locked, the purpose is to cleanup the
>>> partially created array.
>>> 
>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>> ---
>>>  Create.c | 11 ++++-------
>>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>> 
>>> diff --git a/Create.c b/Create.c
>>> index 6ca0924..fe0ab7e 100644
>>> --- a/Create.c
>>> +++ b/Create.c
>>> @@ -904,10 +904,8 @@ int Create(struct supertype *st, char *mddev,
>>>                      remove_partitions(fd);
>>>                  if (st->ss->add_to_super(st, &inf->disk,
>>>                               fd, dv->devname,
>>> -                             dv->data_offset)) {
>>> -                    ioctl(mdfd, STOP_ARRAY, NULL);
>>> +                             dv->data_offset))
>>>                      goto abort_locked;
>>> -                }
>>>                  st->ss->getinfo_super(st, inf, NULL);
>>>                  safe_mode_delay = inf->safe_mode_delay;
>>>  @@ -1008,7 +1006,6 @@ int Create(struct supertype *st, char *mddev,
>>>              sysfs_set_safemode(&info, safe_mode_delay);
>>>              if (err) {
>>>                  pr_err("failed to activate array.\n");
>>> -                ioctl(mdfd, STOP_ARRAY, NULL);
>>>                  goto abort;
>>>              }
>>>          } else if (c->readonly &&
>>> @@ -1018,7 +1015,6 @@ int Create(struct supertype *st, char *mddev,
>>>                        "array_state", "readonly") < 0) {
>>>                  pr_err("Failed to start array: %s\n",
>>>                         strerror(errno));
>>> -                ioctl(mdfd, STOP_ARRAY, NULL);
>>>                  goto abort;
>>>              }
>>>          } else {
>>> @@ -1030,7 +1026,6 @@ int Create(struct supertype *st, char *mddev,
>>>                  if (info.array.chunk_size &
>>> (info.array.chunk_size-1)) {
>>>                      cont_err("Problem may be that chunk size is not
>>> a power of 2\n");
>>>                  }
>>> -                ioctl(mdfd, STOP_ARRAY, NULL);
>>>                  goto abort;
>>>              }
>>>              /* if start_ro module parameter is set, array is
>>> @@ -1061,7 +1056,9 @@ int Create(struct supertype *st, char *mddev,
>>>      map_remove(&map, fd2devnm(mdfd));
>>>      map_unlock(&map);
>>>  -    if (mdfd >= 0)
>>> +    if (mdfd >= 0) {
>>> +        ioctl(mdfd, STOP_ARRAY, NULL);
>>>          close(mdfd);
>>> +    }
>>>      return 1;
>>>  }
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

