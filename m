From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Thu, 9 Apr 2020 23:38:13 +0200
Message-ID: <204e9fd0-3712-4864-2bf5-38913511e658@cloud.ionos.com>
References: <20200402081312.32709-1-colyli@suse.de>
 <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
 <5f27365b-768f-eb69-36ec-f4ed0c292c60@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5f27365b-768f-eb69-36ec-f4ed0c292c60@suse.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-raid.ids

On 07.04.20 17:09, Coly Li wrote:
> On 2020/4/5 11:53 下午, Guoqing Jiang wrote:
>> On 02.04.20 10:13, Coly Li wrote:
>>> -    scribble = kvmalloc_array(cnt, obj_size, flags);
>>> +    scribble = kvmalloc_array(cnt, obj_size, GFP_KERNEL);
>> Maybe it is simpler to call kvmalloc_array between memalloc_noio_save
>> and memalloc_noio_restore.
>> And seems sched/mm.h need to be included per the report from LKP.
> The falgs can be,
> - GFP_KERNEL: when called from alloc_scratch_buffer()
> - GFP_NOIO: when called from resize_chunks().
>
> If the scope APIs are used inside scribble_alloc(), the first call path
> is restricted as noio, which is not expected. So I only use the scope
> APIs around the location where GFP_NOIO is used.

Thanks for the explanation. I assume it can be distinguished by check 
the flag,
eg, FYI.

if (flag == GFP_NOIO)
     memalloc_noio_save();
kvmalloc_array();
if (flag == GFP_NOIO)
     memalloc_noio_restore();
> Anyway, Michal Hocko suggests to add the scope APIs in
> mddev_suspend()/mddev_resume(). Then in the whole code path where md
> raid array is suspend, we don't need to worry the recursive memory
> reclaim I/Os onto the array. After checking the complicated raid5 code,
> I come to realize this suggestion makes sense.

Hmm, mddev_suspend/resume are called at lots of places, then it's better to
check if all the places don't allocate memory with GFP_KERNEL.

And seems In level_store(), sysfs_create_group could be called between 
suspend
and resume, then the two functions (kstrdup_const(name, GFP_KERNEL) and
kmem_cache_zalloc(kernfs_node_cache, GFP_KERNEL)) could be triggered by the
path:

sysfs_create_group ->internal_create_group -> kernfs_create_dir_ns ->
kernfs_new_node -> __kernfs_new_node

Not know memalloc_noio_{save,restore} well, but I guess it is better to 
use them
to mark a small scope, just my two cents.

Thanks,
Guoqing
