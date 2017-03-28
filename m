From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v5 3/7] raid5-ppl: Partial Parity Log write logging
 implementation
Date: Tue, 28 Mar 2017 16:12:37 +0200
Message-ID: <ab4ce9c9-46c6-4f5c-3821-964fc7c9744c@intel.com>
References: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
 <20170309090003.13298-4-artur.paszkiewicz@intel.com>
 <87wpbib88g.fsf@notabene.neil.brown.name>
 <20170324164651.hewssoahtcm4sdxh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170324164651.hewssoahtcm4sdxh@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/24/2017 05:46 PM, Shaohua Li wrote:
> On Wed, Mar 22, 2017 at 09:00:47AM +1100, Neil Brown wrote:
>> On Thu, Mar 09 2017, Artur Paszkiewicz wrote:
>>
>>> Implement the calculation of partial parity for a stripe and PPL write
>>> logging functionality. The description of PPL is added to the
>>> documentation. More details can be found in the comments in raid5-ppl.c.
>>>
>>> Attach a page for holding the partial parity data to stripe_head.
>>> Allocate it only if mddev has the MD_HAS_PPL flag set.
>>>
>>> Partial parity is the xor of not modified data chunks of a stripe and is
>>> calculated as follows:
>>>
>>> - reconstruct-write case:
>>>   xor data from all not updated disks in a stripe
>>>
>>> - read-modify-write case:
>>>   xor old data and parity from all updated disks in a stripe
>>>
>>> Implement it using the async_tx API and integrate into raid_run_ops().
>>> It must be called when we still have access to old data, so do it when
>>> STRIPE_OP_BIODRAIN is set, but before ops_run_prexor5(). The result is
>>> stored into sh->ppl_page.
>>>
>>> Partial parity is not meaningful for full stripe write and is not stored
>>> in the log or used for recovery, so don't attempt to calculate it when
>>> stripe has STRIPE_FULL_WRITE.
>>>
>>> Put the PPL metadata structures to md_p.h because userspace tools
>>> (mdadm) will also need to read/write PPL.
>>>
>>> Warn about using PPL with enabled disk volatile write-back cache for
>>> now. It can be removed once disk cache flushing before writing PPL is
>>> implemented.
>>>
>>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>>
>> Sorry for the delay in getting to this for review...
>>
>>> +static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
>>> +					  struct stripe_head *sh)
>>> +{
>>> +	struct ppl_conf *ppl_conf = log->ppl_conf;
>>> +	struct ppl_io_unit *io;
>>> +	struct ppl_header *pplhdr;
>>> +
>>> +	io = mempool_alloc(ppl_conf->io_pool, GFP_ATOMIC);
>>> +	if (!io)
>>> +		return NULL;
>>> +
>>> +	memset(io, 0, sizeof(*io));
>>> +	io->log = log;
>>> +	INIT_LIST_HEAD(&io->log_sibling);
>>> +	INIT_LIST_HEAD(&io->stripe_list);
>>> +	atomic_set(&io->pending_stripes, 0);
>>> +	bio_init(&io->bio, io->biovec, PPL_IO_INLINE_BVECS);
>>> +
>>> +	io->header_page = mempool_alloc(ppl_conf->meta_pool, GFP_NOIO);
>>
>> I'm trying to understand how these two mempool_alloc()s relate, and
>> particularly why the first one needs to be GFP_ATOMIC, while the second
>> one can safely be GFP_NOIO.
>> I see that the allocated memory is freed in different places:
>> header_page is called from the bi_endio function as soon as the write
>> completes, while 'io' is freed later.  But I'm not sure that is enough
>> to make it safe.
>>
>> When working with mempools, you need to assume that the pool only
>> contains one element, and that every time you call mempool_alloc(), it
>> waits for that one element to be available.  While that doesn't usually
>> happen, it is possible and if that case isn't handled correctly, the
>> system can deadlock.
>>
>> If no memory is available when this mempool_alloc() is called, it will
>> block.  As it is called from the raid5d thread, the whole array will
>> block.  So this can only complete safely is the write request has
>> already been submitted - or if there is some other workqueue which
>> submit requests after a timeout or similar.
>> I don't see that in the code.  These ppl_io_unit structures can queue up
>> and are only submitted later by raid5d (I think).  So if raid5d waits
>> for one to become free, it will wait forever.
>>
>> One easy way around this problem (assuming my understanding is correct)
>> is to just have a single mempool which allocates both a struct
>> ppl_io_unit and a page.  You would need to define you own alloc/free
>> routines for the pool but that is easy enough.
>>
>> Then you only need a single mempool_alloc(), which can sensibly be
>> GFP_ATOMIC.
>> If that fails, you queue for later handling as you do now.  If it
>> succeeds, then you continue to use the memory without any risk of
>> deadlocking.
> 
> Maybe Artur is following the raid5-cache code, which uses GFP_ATOMIC with
> commit: 5036c39(raid5: allow r5l_io_unit allocations to fail). A single pool
> does make sense.

That's right, I based this on raid5-cache code. I like the approach that
Neil proposed, I'll test it some more and probably send a patch soon. Do
you think GFP_ATOMIC is necessary here or would GFP_NOWAIT be enough?

Thanks,
Artur
