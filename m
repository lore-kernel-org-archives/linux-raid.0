From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast
 storage
Date: Fri, 29 Jun 2012 23:37:59 -0500
Message-ID: <4FEE82A7.4060602@hardwarefreak.com>
References: <20120613091143.508417333@kernel.org> <20120628190352.4dc1dd76@notabene.brown> <4FED04F1.8010902@hardwarefreak.com> <20120629125256.31de1c2b@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120629125256.31de1c2b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On 6/28/2012 9:52 PM, NeilBrown wrote:
> On Thu, 28 Jun 2012 20:29:21 -0500 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>> On 6/28/2012 4:03 AM, NeilBrown wrote:
>>> On Wed, 13 Jun 2012 17:11:43 +0800 Shaohua Li <shli@kernel.org> wrote:
>>>
>>>> In raid1/10, all write requests are dispatched in a single thread. In fast
>>>> storage, the thread is a bottleneck, because it dispatches request too slow.
>>>> Also the thread migrates freely, which makes request completion cpu not match
>>>> with submission cpu even driver/block layer has such capability. This will
>>>> cause bad cache issue. Both these are not a big deal for slow storage.
>>>>
>>>> Switching the dispatching to percpu/perthread based dramatically increases
>>>> performance.  The more raid disk number is, the more performance boosts. In a
>>>> 4-disk raid10 setup, this can double the throughput.
>>>>
>>>> percpu/perthread based dispatch doesn't harm slow storage. This is the way how
>>>> raw device is accessed, and there is correct block plug set which can help do
>>>> request merge and reduce lock contention.
>>>>
>>>> V2->V3:
>>>> rebase to latest tree and fix cpuhotplug issue
>>>>
>>>> V1->V2:
>>>> 1. droped direct dispatch patches. That has better performance imporvement, but
>>>> is hopelessly made correct.
>>>> 2. Add a MD specific workqueue to do percpu dispatch.
>>
>>
>>> I still don't like the per-cpu allocations and the extra work queues.
>>
>> Why don't you like this method Neil?  Complexity?  The performance seems
>> to be there.
>>
> 
> Not an easy question to answer.  It just doesn't "taste" nice.
> I certainly like the performance and if this is the only way to get that
> performance then we'll probably go that way.  But I'm not convinced it is the
> only way and I want to explore other options first.

I completely agree with the philosophy of exploring multiple options.

> I guess it feels a bit heavy handed.  On machines with 1024 cores, per-cpu
> allocations and per-cpu threads are not as cheap as they are one 2-core
> machines.  And I'm hoping for a 1024-core phone soon :-)

The only 1024 core machines on the planet are SGI Altix UV (up to 2560
cores).  And they make extensive use of per-cpu allocations and threads
in both XVM (the SGI Linux volume manager) and XFS.  Keep in mind that
the CpuMemSets API which enables this originated at SGI.  The storage is
FC SAN RAID, and XVM is used to stripe or concatenate the hw RAID LUNs.
 Without per-cpu threads this machine's IO couldn't scale.

Quoting Geoffrey Wehrman of SGI, from a post to the XFS list:

"With an SGI IS16000 array which supports up to 1,200 drives,
filesystems with large numbers of drives isn't difficult.  Most
configurations using the IS16000 have 8+2 RAID6 luns.  I've seen
sustained 15 GB/s to a single filesystem on one of the arrays with a 600
drive configuration.  The scalability of XFS is impressive."

Without per-cpu threads in XVM and XFS this level of throughput wouldn't
be possible.  XVM is closed source, but the XFS devs would probably be
open to discussing how they do this, their beef with your current
default stripe chunk size not withstanding. ;)

-- 
Stan
