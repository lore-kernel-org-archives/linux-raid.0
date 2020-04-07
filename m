From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Tue, 7 Apr 2020 23:09:21 +0800
Message-ID: <5f27365b-768f-eb69-36ec-f4ed0c292c60@suse.de>
References: <20200402081312.32709-1-colyli@suse.de>
 <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-raid.ids

On 2020/4/5 11:53 下午, Guoqing Jiang wrote:
> On 02.04.20 10:13, Coly Li wrote:
>> -    scribble = kvmalloc_array(cnt, obj_size, flags);
>> +    scribble = kvmalloc_array(cnt, obj_size, GFP_KERNEL);
> 
> Maybe it is simpler to call kvmalloc_array between memalloc_noio_save
> and memalloc_noio_restore.
> And seems sched/mm.h need to be included per the report from LKP.

The falgs can be,
- GFP_KERNEL: when called from alloc_scratch_buffer()
- GFP_NOIO: when called from resize_chunks().

If the scope APIs are used inside scribble_alloc(), the first call path
is restricted as noio, which is not expected. So I only use the scope
APIs around the location where GFP_NOIO is used.

Anyway, Michal Hocko suggests to add the scope APIs in
mddev_suspend()/mddev_resume(). Then in the whole code path where md
raid array is suspend, we don't need to worry the recursive memory
reclaim I/Os onto the array. After checking the complicated raid5 code,
I come to realize this suggestion makes sense.

I will try to compose a v2 patch following Michal's suggestion.
-- 

Coly Li
