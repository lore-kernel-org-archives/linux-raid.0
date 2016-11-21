From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] RAID1: Avoid unnecessary loop to decrease
 conf->nr_queued in raid1d()
Date: Mon, 21 Nov 2016 18:16:35 +0800
Message-ID: <e7f866de-d0e2-818f-038d-98e3632e7c20@suse.de>
References: <1479305968-18473-1-git-send-email-colyli@suse.de>
 <785b7474-2e3a-e423-08d7-26cb6136a235@suse.de>
 <20161116200519.v6y6t4dsbl2zshk2@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161116200519.v6y6t4dsbl2zshk2@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

在 2016/11/17 上午4:05, Shaohua Li 写道:
> On Wed, Nov 16, 2016 at 10:36:32PM +0800, Coly Li wrote:
>> 在 2016/11/16 下午10:19, Coly Li 写道:
>> [snip]
>>> ---
>>>  drivers/md/raid1.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> Index: linux-raid1/drivers/md/raid1.c
>>> ===================================================================
>>> --- linux-raid1.orig/drivers/md/raid1.c
>>> +++ linux-raid1/drivers/md/raid1.c
>>> @@ -2387,17 +2387,17 @@ static void raid1d(struct md_thread *thr
>> [snip]
>>>  		while (!list_empty(&tmp)) {
>>>  			r1_bio = list_first_entry(&tmp, struct r1bio,
>>>  						  retry_list);
>>>  			list_del(&r1_bio->retry_list);
>>> +			spin_lock_irqsave(&conf->device_lock, flags);
>>> +			conf->nr_queued--;
>>> +			spin_unlock_irqrestore(&conf->device_lock, flags);
>> [snip]
>>
>> Now I work on another 2 patches for a simpler I/O barrier, and a
>> lockless I/O submit on raid1, where conf->nr_queued will be in atomic_t.
>> So spin lock expense will not exist any more. Just FYI.
> 
> I'd like to hold this patch till you post the simpler I/O barrier, as the patch
> itself currently doesn't make the process faster (lock/unlock is much heavier
> than the loop).

Yeah, I will combine this patch with the new barrier patch, and send out
a RFC patch set with two patches. One is new barrier patch, one is
lockless wait_barrier() patch.

Thanks.

Coly

