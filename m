From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Wed, 15 Apr 2020 16:10:08 +0200
Message-ID: <a1e83cb5-366c-17a7-3a4b-9cd8a54c3b48@cloud.ionos.com>
References: <20200402081312.32709-1-colyli@suse.de>
 <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
 <5f27365b-768f-eb69-36ec-f4ed0c292c60@suse.de>
 <204e9fd0-3712-4864-2bf5-38913511e658@cloud.ionos.com>
 <20200415114814.GJ4629@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200415114814.GJ4629@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Coly Li <colyli@suse.de>, songliubraving@fb.com, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids

On 15.04.20 13:48, Michal Hocko wrote:
> On Thu 09-04-20 23:38:13, Guoqing Jiang wrote:
> [...]
>> Not know memalloc_noio_{save,restore} well, but I guess it is better
>> to use them to mark a small scope, just my two cents.
> This would go against the intentio of the api. It is really meant to
> define reclaim recursion problematic scope.

Well, in current proposal, the scope is just when 
scribble_allo/kvmalloc_array is called.

memalloc_noio_save
scribble_allo/kvmalloc_array
memalloc_noio_restore

With the new proposal, the marked scope would be bigger than current one 
since there
are lots of places call mddev_suspend/resume.

mddev_suspend
memalloc_noio_save
...
memalloc_noio_restore
mddev_resume

IMHO, if the current proposal works then what is the advantage to 
increase the scope.
If all the callers of mddev_suspend/resume could suffer from the 
deadlock issue due to
recursing fs io, then it is definitely need to use the new proposal.

> If there is a clear entry point where any further allocation recursing to FS/IO could deadlock
> then it should be used at that level.

Agree.

At the end of mddev_suspend, I guess there is no FS/IO could happen to 
the array,
because mddev->suspended++ and quiesce(mddev, 1) are called previously in
mddev_suspend. And it makes me curious to go through to the call chain:

layout_store / chunk_size_store / update_raid_disks / update_array_info 
/ md_check_recovery
         => pers->check_reshape => raid{5,6}_check_reshape => check_reshape
         => resize_chunks => scribble_alloc(..., GFP_NOIO)

Perhaps I missed something, but seems all the 5 original callers are not 
called between
mddev_suspend and mddev_resume, if so, then with the new proposal, 
scribble_alloc()
could not be protected by the memalloc_noio_{save,restore}.

> This might be a lock which is
> taken from the reclaim or like this case a device is suspended and no IO
> is processed so anything that would wait for an IO or rely on IO making
> progress in the reclaim path would deadlock.

Thanks for teaching.

> Please have a look at Documentation/core-api/gfp_mask-from-fs-io.rst
> and let me know is something could be made more clear or explicit.
> I am more than happy to improve the documentation.

Thanks again for your lighting, will read it.

Regards,
Guoqing
