From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3 1/4] md: use memalloc scope APIs in
 mddev_suspend()/mddev_resume()
Date: Thu, 9 Apr 2020 23:16:10 +0800
Message-ID: <ef86c0b5-a3ba-1472-74ae-331d4d8832d2@suse.de>
References: <20200409141723.24447-1-colyli@suse.de>
 <20200409141723.24447-2-colyli@suse.de>
 <20200409150518.GN18386@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200409150518.GN18386@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: songliubraving@fb.com, linux-raid@vger.kernel.org, kent.overstreet@gmail.com, guoqing.jiang@cloud.ionos.com
List-Id: linux-raid.ids

On 2020/4/9 11:05 下午, Michal Hocko wrote:
> On Thu 09-04-20 22:17:20, colyli@suse.de wrote:
>> From: Coly Li <colyli@suse.de>
>>
>> In raid5.c:resize_chunk(), scribble_alloc() is called with GFP_NOIO
>> flag, then it is sent into kvmalloc_array() inside scribble_alloc().
>>
>> The problem is kvmalloc_array() eventually calls kvmalloc_node() which
>> does not accept non GFP_KERNEL compatible flag like GFP_NOIO, then
>> kmalloc_node() is called indeed to allocate physically continuous
>> pages. When system memory is under heavy pressure, and the requesting
>> size is large, there is high probability that allocating continueous
>> pages will fail.
>>
>> But simply using GFP_KERNEL flag to call kvmalloc_array() is also
>> progblematic. In the code path where scribble_alloc() is called, the
>> raid array is suspended, if kvmalloc_node() triggers memory reclaim I/Os
>> and such I/Os go back to the suspend raid array, deadlock will happen.
>>
>> What is desired here is to allocate non-physically (a.k.a virtually)
>> continuous pages and avoid memory reclaim I/Os. Michal Hocko suggests
>> to use the mmealloc sceope APIs to restrict memory reclaim I/O in
>> allocating context, specifically to call memalloc_noio_save() when
>> suspend the raid array and to call memalloc_noio_restore() when
>> resume the raid array.
>>
>> This patch adds the memalloc scope APIs in mddev_suspend() and
>> mddev_resume(), to restrict memory reclaim I/Os during the raid array
>> is suspended. The benifit of adding the memalloc scope API in the
>> unified entry point mddev_suspend()/mddev_resume() is, no matter which
>> md raid array type (personality), we are sure the deadlock by recursive
>> memory reclaim I/O won't happen on the suspending context.
> 
> I am not familiar with the mdraid code so I cannot really judge the
> correctness here but if mddev_suspend really acts as a potential reclaim
> recursion deadlock entry then this is the right way to use the API.
> Essentially all the allocations in that scope will have an implicit NOIO
> semantic.
> 
> Thing to be careful about is the make sure that mddev_suspend cannot
> be nested. And also that there are no callers of scribble_alloc outside
> of mddev_suspend scope which would be reclaim deadlock prone. If they
> are their scope should be handled in the similar way.

Thank you for the confirmation, and the always constructive discussion :-)

-- 

Coly Li
