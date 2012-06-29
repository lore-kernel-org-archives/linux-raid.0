From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast
 storage
Date: Thu, 28 Jun 2012 20:29:21 -0500
Message-ID: <4FED04F1.8010902@hardwarefreak.com>
References: <20120613091143.508417333@kernel.org> <20120628190352.4dc1dd76@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628190352.4dc1dd76@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On 6/28/2012 4:03 AM, NeilBrown wrote:
> On Wed, 13 Jun 2012 17:11:43 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
>> In raid1/10, all write requests are dispatched in a single thread. In fast
>> storage, the thread is a bottleneck, because it dispatches request too slow.
>> Also the thread migrates freely, which makes request completion cpu not match
>> with submission cpu even driver/block layer has such capability. This will
>> cause bad cache issue. Both these are not a big deal for slow storage.
>>
>> Switching the dispatching to percpu/perthread based dramatically increases
>> performance.  The more raid disk number is, the more performance boosts. In a
>> 4-disk raid10 setup, this can double the throughput.
>>
>> percpu/perthread based dispatch doesn't harm slow storage. This is the way how
>> raw device is accessed, and there is correct block plug set which can help do
>> request merge and reduce lock contention.
>>
>> V2->V3:
>> rebase to latest tree and fix cpuhotplug issue
>>
>> V1->V2:
>> 1. droped direct dispatch patches. That has better performance imporvement, but
>> is hopelessly made correct.
>> 2. Add a MD specific workqueue to do percpu dispatch.


> I still don't like the per-cpu allocations and the extra work queues.

Why don't you like this method Neil?  Complexity?  The performance seems
to be there.

-- 
Stan
