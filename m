From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 3/3] MD: hold mddev lock for md-cluster receive thread
Date: Tue, 2 Aug 2016 17:52:41 +0800
Message-ID: <57A06D69.2040703@suse.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
 <7763e508fb97d44bd61e826912055617b8be2c2d.1469922791.git.shli@fb.com>
 <579F0AA3.5090806@suse.com> <20160801214522.GA129828@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160801214522.GA129828@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids



On 08/02/2016 05:45 AM, Shaohua Li wrote:
> On Mon, Aug 01, 2016 at 04:38:59PM +0800, Guoqing Jiang wrote:
>> Hi,
>>
>> On 07/31/2016 07:54 AM, shli@kernel.org wrote:
>>> From: Shaohua Li <shli@fb.com>
>>>
>>> md-cluster receive thread calls .quiesce too, let it hold mddev lock.
>> I'd suggest hold on for the patchset, I can find lock problem easily with
>> the patchset applied. Take a resyncing  clusteed raid1 as example.
>>
>> md127_raid1 thread held reconfig_mutex then update sb, so it needs dlm
>> token lock. Meanwhile md127_resync thread got token lock and wants
>> EX on ack lock but recv_daemon can't release ack lock since recv_daemon
>> doesn't get reconfig_mutex.
> Thansk, I'll drop this one. Other two patches are still safe for md-cluster,
> right?

 From the latest test, I can't find  lock issues with the first two patches,
but I doubt it would have side effect for the performance of resync.

> I really hope to have consistent locking for .quiesce. For the
> process_recvd_msg, I'm wondering what's protecting the datas? for example,
> md-cluster uses md_find_rdev_nr_rcu, which access the disks list without
> locking. Is there a race?

Yes, it should be protected by rcu lock, I will post a patch for it, thanks
for reminder.

> Does it work if we move the mddev lock to
> process_recvd_msg?

I tried that, but It still have lock issue, eg, when node B and C have 
status
as "resync=PENDING", then try to stop the resyncing array in node A.


Thanks,
Guoqing
