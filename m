From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Mon, 20 Feb 2017 16:30:51 +0800
Message-ID: <7B540BA1-081B-4D14-B56E-41CFCF833A2E@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de> <87shnevcpr.fsf@notabene.neil.brown.name> <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de> <87shn9spsy.fsf@notabene.neil.brown.name> <87k28lshg5.fsf@notabene.neil.brown.name> <20170220070430.4mca7clpaw7kpj4j@kernel.org> <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids


> 在 2017年2月20日，下午4:07，Coly Li <colyli@suse.de> 写道：
> 
> 
> 
> 
> 发自我的 iPhone
>>> 在 2017年2月20日，下午3:04，Shaohua Li <shli@kernel.org> 写道：
>>> 
>>>> On Mon, Feb 20, 2017 at 01:51:22PM +1100, Neil Brown wrote:
>>>>> On Mon, Feb 20 2017, NeilBrown wrote:
>>>>> 
>>>>>> On Fri, Feb 17 2017, Coly Li wrote:
>>>>>> 
>>>>>> On 2017/2/16 下午3:04, NeilBrown wrote:
>>>>>> I know you are going to change this as Shaohua wantsthe spitting to
>>>>>> happen in a separate function, which I agree with, but there is 
>>>>>> something else wrong here. Calling bio_split/bio_chain repeatedly
>>>>>> in a loop is dangerous. It is OK for simple devices, but when one
>>>>>> request can wait for another request to the same device it can
>>>>>> deadlock. This can happen with raid1.  If a resync request calls
>>>>>> raise_barrier() between one request and the next, then the next has
>>>>>> to wait for the resync request, which has to wait for the first
>>>>>> request. As the first request will be stuck in the queue in 
>>>>>> generic_make_request(), you get a deadlock.
>>>>> 
>>>>> For md raid1, queue in generic_make_request(), can I understand it as
>>>>> bio_list_on_stack in this function? And queue in underlying device,
>>>>> can I understand it as the data structures like plug->pending and
>>>>> conf->pending_bio_list ?
>>>> 
>>>> Yes, the queue in generic_make_request() is the bio_list_on_stack.  That
>>>> is the only queue I am talking about.  I'm not referring to
>>>> plug->pending or conf->pending_bio_list at all.
>>>> 
>>>>> 
>>>>> I still don't get the point of deadlock, let me try to explain why I
>>>>> don't see the possible deadlock. If a bio is split, and the first part
>>>>> is processed by make_request_fn(), and then a resync comes and it will
>>>>> raise a barrier, there are 3 possible conditions,
>>>>> - the resync I/O tries to raise barrier on same bucket of the first
>>>>> regular bio. Then the resync task has to wait to the first bio drops
>>>>> its conf->nr_pending[idx]
>>>> 
>>>> Not quite.
>>>> First, the resync task (in raise_barrier()) will wait for ->nr_waiting[idx]
>>>> to be zero.  We can assume this happens immediately.
>>>> Then the resync_task will increment ->barrier[idx].
>>>> Only then will it wait for the first bio to drop ->nr_pending[idx].
>>>> The processing of that first bio will have submitted bios to the
>>>> underlying device, and they will be in the bio_list_on_stack queue, and
>>>> will not be processed until raid1_make_request() completes.
>>>> 
>>>> The loop in raid1_make_request() will then call make_request_fn() which
>>>> will call wait_barrier(), which will wait for ->barrier[idx] to be
>>>> zero.
>>> 
>>> Thinking more carefully about this.. the 'idx' that the second bio will
>>> wait for will normally be different, so there won't be a deadlock after
>>> all.
>>> 
>>> However it is possible for hash_long() to produce the same idx for two
>>> consecutive barrier_units so there is still the possibility of a
>>> deadlock, though it isn't as likely as I thought at first.
>> 
>> Wrapped the function pointer issue Neil pointed out into Coly's original patch.
>> Also fix a 'use-after-free' bug. For the deadlock issue, I'll add below patch,
>> please check.
>> 
>> Thanks,
>> Shaohua
>> 
> 
> Hmm, please hold, I am still thinking of it. With barrier bucket and hash_long(), I don't see dead lock yet. For raid10 it might happen, but once we have barrier bucket on it , there will no deadlock.
> 
> My question is, this deadlock only happens when a big bio is split, and the split small bios are continuous, and the resync io visiting barrier buckets in sequntial order too. In the case if adjacent split regular bios or resync bios hit same barrier bucket, it will be a very big failure of hash design, and should have been found already. But no one complain it, so I don't convince myself tje deadlock is real with io barrier buckets (this is what Neil concerns).
> 
> For the function pointer asignment, it is because I see a brach happens in a loop. If I use a function pointer, I can avoid redundant brach inside the loop. raid1_read_request() and raid1_write_request() are not simple functions, I don't know whether gcc may make them inline or not, so I am on the way to check the disassembled code..
> 
> The loop in raid1_make_request() is quite high level, I am not sure whether CPU brach pridiction may work correctly, especially when it is a big DISCARD bio, using function pointer may drop a possible brach.
> 
> So I need to check what we get and lose when use function pointer or not. If it is not urgent, please hold this patch for a while.
> 
> The only thing I worry in the bellowed patch is, if a very big DISCARD bio comes, will the kernel space stack trend to be overflow？
> 

Before calling generic_make_request(), if we can do a check whether the stack is about to full, and schedule a small time out if there are too many bios stacked, maybe the stack oveflow can be avoided.

Coly


