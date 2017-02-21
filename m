From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Tue, 21 Feb 2017 17:45:53 +0800
Message-ID: <f36e85b1-cca1-5be4-a171-d64057cc56a3@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <87shnevcpr.fsf@notabene.neil.brown.name>
 <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de>
 <87shn9spsy.fsf@notabene.neil.brown.name>
 <87k28lshg5.fsf@notabene.neil.brown.name>
 <20170220070430.4mca7clpaw7kpj4j@kernel.org>
 <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
 <878tp0s7w8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tp0s7w8.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/21 上午8:29, NeilBrown wrote:
> On Mon, Feb 20 2017, Coly Li wrote:
> 
>>> 在 2017年2月20日，下午3:04，Shaohua Li <shli@kernel.org> 写道：
>>> 
>>>> On Mon, Feb 20, 2017 at 01:51:22PM +1100, Neil Brown wrote:
>>>>> On Mon, Feb 20 2017, NeilBrown wrote:
>>>>> 
>>>>>> On Fri, Feb 17 2017, Coly Li wrote:
>>>>>> 
>>>>>>> On 2017/2/16 下午3:04, NeilBrown wrote: I know you are
>>>>>>> going to change this as Shaohua wantsthe spitting to 
>>>>>>> happen in a separate function, which I agree with, but
>>>>>>> there is something else wrong here. Calling
>>>>>>> bio_split/bio_chain repeatedly in a loop is dangerous.
>>>>>>> It is OK for simple devices, but when one request can
>>>>>>> wait for another request to the same device it can 
>>>>>>> deadlock. This can happen with raid1.  If a resync
>>>>>>> request calls raise_barrier() between one request and
>>>>>>> the next, then the next has to wait for the resync
>>>>>>> request, which has to wait for the first request. As
>>>>>>> the first request will be stuck in the queue in 
>>>>>>> generic_make_request(), you get a deadlock.
>>>>>> 
>>>>>> For md raid1, queue in generic_make_request(), can I
>>>>>> understand it as bio_list_on_stack in this function? And
>>>>>> queue in underlying device, can I understand it as the
>>>>>> data structures like plug->pending and 
>>>>>> conf->pending_bio_list ?
>>>>> 
>>>>> Yes, the queue in generic_make_request() is the
>>>>> bio_list_on_stack.  That is the only queue I am talking
>>>>> about.  I'm not referring to plug->pending or
>>>>> conf->pending_bio_list at all.
>>>>> 
>>>>>> 
>>>>>> I still don't get the point of deadlock, let me try to
>>>>>> explain why I don't see the possible deadlock. If a bio
>>>>>> is split, and the first part is processed by
>>>>>> make_request_fn(), and then a resync comes and it will 
>>>>>> raise a barrier, there are 3 possible conditions, - the
>>>>>> resync I/O tries to raise barrier on same bucket of the
>>>>>> first regular bio. Then the resync task has to wait to
>>>>>> the first bio drops its conf->nr_pending[idx]
>>>>> 
>>>>> Not quite. First, the resync task (in raise_barrier()) will
>>>>> wait for ->nr_waiting[idx] to be zero.  We can assume this
>>>>> happens immediately. Then the resync_task will increment
>>>>> ->barrier[idx]. Only then will it wait for the first bio to
>>>>> drop ->nr_pending[idx]. The processing of that first bio
>>>>> will have submitted bios to the underlying device, and they
>>>>> will be in the bio_list_on_stack queue, and will not be
>>>>> processed until raid1_make_request() completes.
>>>>> 
>>>>> The loop in raid1_make_request() will then call
>>>>> make_request_fn() which will call wait_barrier(), which
>>>>> will wait for ->barrier[idx] to be zero.
>>>> 
>>>> Thinking more carefully about this.. the 'idx' that the
>>>> second bio will wait for will normally be different, so there
>>>> won't be a deadlock after all.
>>>> 
>>>> However it is possible for hash_long() to produce the same
>>>> idx for two consecutive barrier_units so there is still the
>>>> possibility of a deadlock, though it isn't as likely as I
>>>> thought at first.
>>> 
>>> Wrapped the function pointer issue Neil pointed out into Coly's
>>> original patch. Also fix a 'use-after-free' bug. For the
>>> deadlock issue, I'll add below patch, please check.
>>> 
>>> Thanks, Shaohua
>>> 
>> 

Neil,

Thanks for your patient explanation, I feel I come to follow up what
you mean. Let me try to re-tell what I understand, correct me if I am
wrong.


>> Hmm, please hold, I am still thinking of it. With barrier bucket
>> and hash_long(), I don't see dead lock yet. For raid10 it might
>> happen, but once we have barrier bucket on it , there will no
>> deadlock.
>> 
>> My question is, this deadlock only happens when a big bio is
>> split, and the split small bios are continuous, and the resync io
>> visiting barrier buckets in sequntial order too. In the case if
>> adjacent split regular bios or resync bios hit same barrier
>> bucket, it will be a very big failure of hash design, and should
>> have been found already. But no one complain it, so I don't
>> convince myself tje deadlock is real with io barrier buckets
>> (this is what Neil concerns).
> 
> I think you are wrong about the design goal of a hash function. 
> When feed a sequence of inputs, with any stride (i.e. with any
> constant difference between consecutive inputs), the output of the
> hash function should appear to be random. A random sequence can
> produce the same number twice in a row. If the hash function
> produces a number from 0 to N-1, you would expect two consecutive
> outputs to be the same about once every N inputs.
> 

Yes, you are right. But when I mentioned hash conflict, I limit the
integers in range [0, 1<<38]. 38 is (64-17-9), when a 64bit LBA
address divided by 64MB I/O barrier unit size, its value range is
reduced to [0, 1<<38].

Maximum size of normal bio is 1MB, it could be split into 2 bios at most.

For DISCARD bio, its maximum size is 4GB, it could be split into 65
bios at most.

Then in this patch, the hash question is degraded to: for any
consecutive 65 integers in range [0, 1<<38], use hash_long() to hash
these 65 integers into range [0, 1023], will any hash conflict happen
among these integers ?

I tried a half range [0, 1<<37] to check hash conflict, by writing a
simple code to emulate hash calculation in the new I/O barrier patch,
to iterate all consecutive {2, 65, 128, 512} integers in range [0,
1<<37] for hash conflict.

On a 20 core CPU each run spent 7+ hours, finally I find no hash
conflict detected up to 512 consecutive integers in above limited
condition. For 1024, there are a lot hash conflict detected.

[0, 1<<37] range back to [0, 63] LBA range, this is large enough for
almost all existing md raid configuration. So for current kernel
implementation and real world device, for a single bio, there is no
possible hash conflict the new I/O barrier patch.

If bi_iter.bi_size changes from unsigned int to unsigned long in
future, the above assumption will be wrong. There will be hash
conflict, and potential dead lock, which is quite implicit. Yes, I
agree with you. No, bio split inside loop is not perfect.

> Even if there was no possibility of a deadlock from a resync
> request happening between two bios, there are other possibilities.
> 

The bellowed text makes me know more about raid1 code, but confuses me
more as well. Here comes my questions,

> It is not, in general, safe to call mempool_alloc() twice in a
> row, without first ensuring that the first allocation will get
> freed by some other thread.  raid1_write_request() allocates from
> r1bio_pool, and then submits bios to the underlying device, which
> get queued on bio_list_on_stack.  They will not be processed until
> after raid1_make_request() completes, so when raid1_make_request
> loops around and calls raid1_write_request() again, it will try to
> allocate another r1bio from r1bio_pool, and this might end up
> waiting for the r1bio which is trapped and cannot complete.
> 

Can I say that it is because blk_finish_plug() won't be called before
raid1_make_request() returns ? Then in raid1_write_request(), mbio
will be added into plug->pending, but before blk_finish_plug() is
called, they won't be handled.


> As r1bio_pool preallocates 256 entries, this is unlikely  but not 
> impossible.  If 256 threads all attempt a write (or read) that
> crosses a boundary, then they will consume all 256 preallocated
> entries, and want more. If there is no free memory, they will block
> indefinitely.
> 

If raid1_make_request() is modified into this way,
+	if (bio_data_dir(split) == READ)
+		raid1_read_request(mddev, split);
+	else
+		raid1_write_request(mddev, split);
+	if (split != bio)
+		generic_make_request(bio);

Then the original bio will be added into the bio_list_on_stack of top
level generic_make_request(), current->bio_list is initialized, when
generic_make_request() is called nested in raid1_make_request(), the
split bio will be added into current->bio_list and nothing else happens.

After the nested generic_make_request() returns, the code back to next
code of generic_make_request(),
2022                         ret = q->make_request_fn(q, bio);
2023
2024                         blk_queue_exit(q);
2025
2026                         bio = bio_list_pop(current->bio_list);

bio_list_pop() will return the second half of the split bio, and it is
continuously handled in raid1_make_request() by calling,
2022                         ret = q->make_request_fn(q, bio);

Then there is no dead lock, at all.


> bio_alloc_bioset() has punt_bios_to_rescuer() to attempt to work
> around a deadlock very similar to this, but it is a very specific
> solution, wouldn't help raid1, and is much more complex than just
> rearranging the code.
> 

Yes, it is, definitely.

> 
>> 
>> For the function pointer asignment, it is because I see a brach 
>> happens in a loop. If I use a function pointer, I can avoid
>> redundant brach inside the loop. raid1_read_request() and
>> raid1_write_request() are not simple functions, I don't know
>> whether gcc may make them inline or not, so I am on the way to
>> check the disassembled code..
> 
> It is a long time since I studied how CPUs handle different sorts
> of machine code, but I'm fairly sure that and indirect branch (i.e.
> a branch through a function pointer) is harder to optimize than a 
> conditional branch.
> 

It makes sense to me, yes, you are right.

> But I think the readability of the code is more important, and
> having an if-then-else in a loop is more familiar to most readers
> than using a function pointer like this.
> 

Copied, I agree with you.


>> 
>> The loop in raid1_make_request() is quite high level, I am not
>> sure whether CPU brach pridiction may work correctly, especially
>> when it is a big DISCARD bio, using function pointer may drop a
>> possible brach.
>> 
>> So I need to check what we get and lose when use function pointer
>> or not. If it is not urgent, please hold this patch for a while.
>> 
>> 
>> The only thing I worry in the bellowed patch is, if a very big
>> DISCARD bio comes, will the kernel space stack trend to be
>> overflow？
> 
> How would a large request cause extra stack space to be used?

If my understand is correct, there is no worry here.

Please correct me.

Coly
