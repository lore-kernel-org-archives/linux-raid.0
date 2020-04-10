From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Fri, 10 Apr 2020 17:36:13 +0800
Message-ID: <3c878bde-bba8-fa75-15d4-051d826dbcdc@suse.de>
References: <20200402081312.32709-1-colyli@suse.de>
 <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
 <5f27365b-768f-eb69-36ec-f4ed0c292c60@suse.de>
 <204e9fd0-3712-4864-2bf5-38913511e658@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <204e9fd0-3712-4864-2bf5-38913511e658@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: songliubraving@fb.com, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-raid.ids

On 2020/4/10 5:38 上午, Guoqing Jiang wrote:
> On 07.04.20 17:09, Coly Li wrote:
>> On 2020/4/5 11:53 下午, Guoqing Jiang wrote:
>>> On 02.04.20 10:13, Coly Li wrote:
>>>> -    scribble = kvmalloc_array(cnt, obj_size, flags);
>>>> +    scribble = kvmalloc_array(cnt, obj_size, GFP_KERNEL);
>>> Maybe it is simpler to call kvmalloc_array between memalloc_noio_save
>>> and memalloc_noio_restore.
>>> And seems sched/mm.h need to be included per the report from LKP.
>> The falgs can be,
>> - GFP_KERNEL: when called from alloc_scratch_buffer()
>> - GFP_NOIO: when called from resize_chunks().
>>
>> If the scope APIs are used inside scribble_alloc(), the first call path
>> is restricted as noio, which is not expected. So I only use the scope
>> APIs around the location where GFP_NOIO is used.
> 
> Thanks for the explanation. I assume it can be distinguished by check
> the flag,
> eg, FYI.
> 
> if (flag == GFP_NOIO)
>     memalloc_noio_save();
> kvmalloc_array();
> if (flag == GFP_NOIO)
>     memalloc_noio_restore();

This was similar to my original idea, but finally I decide to accept
Michal's suggestion to add them into mddev_suspend()/mddev_resume. Let
me explain.

>> Anyway, Michal Hocko suggests to add the scope APIs in
>> mddev_suspend()/mddev_resume(). Then in the whole code path where md
>> raid array is suspend, we don't need to worry the recursive memory
>> reclaim I/Os onto the array. After checking the complicated raid5 code,
>> I come to realize this suggestion makes sense.
> 
> Hmm, mddev_suspend/resume are called at lots of places, then it's better to
> check if all the places don't allocate memory with GFP_KERNEL.
> 

When mddev_suspend() is called, then all I/Os on the suspending raid
array have to wait until mddev_resume() is called. Inside the suspending
region, all memory allocation should be careful to avoid memory reclaim
I/Os going back to the suspending raid array. If such recursive I/Os
happen, we will experience deadlock.

Therefore we should be very careful to use GFP_KERNEL to allocate memory
during the period when the raid array is suspending. No matter
physically continuous or virtually continuous pages.

> And seems In level_store(), sysfs_create_group could be called between
> suspend
> and resume, then the two functions (kstrdup_const(name, GFP_KERNEL) and
> kmem_cache_zalloc(kernfs_node_cache, GFP_KERNEL)) could be triggered by the
> path:
> 
> sysfs_create_group ->internal_create_group -> kernfs_create_dir_ns ->
> kernfs_new_node -> __kernfs_new_node
> 

From your information, the above code path is suspicious. Although the
deadlock might not happen in practice, unless the raid array is used as
the only fs volume, and all memory writeback or swap I/Os will only go
into this array.

Checking all the location of memory allocation is trivial but possible,
how to prevent new code with memory allocation to avoid the potential
deadlock risk during the suspending period is still a problem.

> Not know memalloc_noio_{save,restore} well, but I guess it is better to
> use them
> to mark a small scope, just my two cents.

Since mddev_suspend() is the entry point to prevent I/Os on the array,
it is the good location to restrict memory reclaim I/Os of memory
allocation. Finally I realize this is a brilliant idea after Michal
Hocko suggests me for a while.

Thanks.

-- 

Coly Li
