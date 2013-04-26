From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Fri, 26 Apr 2013 14:35:27 -0700
Message-ID: <CAA9_cmdbZ_K5Wvo7BH1nPGvttL5As1ncnbPK1ax3TFvGOch6zw@mail.gmail.com>
References: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
	<20130422142211.71a1ae8e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130422142211.71a1ae8e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
List-Id: linux-raid.ids

On Sun, Apr 21, 2013 at 9:22 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 17 Apr 2013 17:56:56 -0700 Dan Williams <djbw@fb.com> wrote:
>
>> From: Kumar Sundararajan <kumar@fb.com>
>>
>> Add support for rmw writes in raid6. This improves small write performance for most workloads.
>> Since there may be some configurations and workloads where rcw always outperforms rmw,
>> this feature is disabled by default. It can be enabled via sysfs. For example,
>>
>>       #echo 1 > /sys/block/md0/md/enable_rmw
>>
>> Signed-off-by: Kumar Sundararajan <kumar@fb.com>
>> Signed-off-by: Dan Williams <djbw@fb.com>
>> ---
>> Hi Neil,
>>
>> We decided to leave the enable in for the few cases where forced-rcw
>> outperformed rmw and there may be other cases out there.
>>
>> Thoughts?
>
> - More commentary would help.  The text at the top should explain enough so
>   when I read the code I am just verifying the text at the top, not trying to
>   figure out how it is supposed to work.

Ok, along the lines of:

"raid5 has supported sub-stripe writes by computing:

P_new = P_old + D0_old + D0_new

For raid6 we add the following:

P_new = P_old + D0_old + D0_new

Q_sub = Q_old + syndrome(D0_old)
Q_sub = Q_old + g^0*D0_old
Q_new = Q_old + Q_sub + g^0*D0_new

This has been verified with check and dual-degraded recovery operations.

> - If 'enable_rmw' really is a good idea, then it is possibly a good idea for
>   RAID5 to and so should be a separate patch and should work for RAID4/5/6.
>   The default for each array type may well be different, but the
>   functionality would be the same.

Yes, although Kumar's testing has not found a test case that makes
significant difference for raid5.  I.e. it makes sense to not
artificially prevent raid5 from disabling rmw if the knob is there for
raid6, but it would need a specific use case to flip it from the
default.

> - Can you  explain *why* rcw is sometimes better than rmw even on large
>   arrays? Even a fairly hand-wavy arguement would help.  And it would go in
>   the comment at the top of the patch that adds enable_rmw.

Hand wavy argument is that rcw guarantees that the drives will be more
busy so small sequential writes have more chance to coalesce into
larger writes.  Kumar, other thoughts?

> - patch looks fairly sane assuming that it works - but I don't really know if
>   it does.  You've reported speeds but haven't told me that you ran 'check'
>   after doing each test and it reported no mismatches.  I suspect you did but
>   I'd like to be told.  I'd also like to be told what role 'spare2' plays.

spare2 is holding the intermediate Q_sub result of subtracting out the
syndrome of the old data block(s)

> There: my complaints are longer than your explanatory text, so I think I
> can stop now :-)

:-) Thanks.

>
> Oh, and the stuff below, that should be above so that it gets captured with
> the patch and remains in the git logs of posterity.
>
> NeilBrown
>
> P.S. a couple of comments further down.
>
>>
>> Here are some numbers from Kumar's testing with a 12 disk array:
>>
>>                                      with rmw   rcw only
>> 4K random write                    887.0 KB/s  94.4 KB/s
>> 64k seq write                      291.5 MB/s 283.2 MB/s
>> 64k random write                    16.4 MB/s   7.7 MB/s
>> 64K mixed read/write                94.4 MB/s  94.0 MB/s
>> (70% random reads/30 % seq writes)   1.6 MB/s   1.8 MB/s
>>
>> --
>> Dan
>>
>>  drivers/md/raid5.c |  169 ++++++++++++++++++++++++++++++++++++++++++++++++----
>>  drivers/md/raid5.h |    4 +
>>  2 files changed, 161 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index e25520e..c9b6112 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -1015,6 +1015,40 @@ static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
>>       return syndrome_disks;
>>  }
>>
>> +static int set_rmw_syndrome_sources(struct page **srcs, struct stripe_head *sh,
>> +      struct raid5_percpu *percpu, int subtract)
>
> Arg.  Bad intending.
>
> I suspect it would look better if this were two separate functions instead of
> having a 'subtract' arg, but I'm not sure.

Will take a look.  I think I may have asked Kumar to squish it originally.

>
>
>> +{
>> +     int disks = sh->disks;
>> +     int syndrome_disks = sh->ddf_layout ? disks : (disks - 2);
>> +     int d0_idx = raid6_d0(sh);
>> +     int count;
>> +     int i;
>> +
>> +     for (i = 0; i < disks; i++)
>> +             srcs[i] = NULL;
>> +
>> +     count = 0;
>> +     i = d0_idx;
>> +     do {
>> +             int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
>> +
>> +             if (subtract) {
>> +                     if (test_bit(R5_Wantdrain, &sh->dev[i].flags))
>> +                             srcs[slot] = sh->dev[i].page;
>> +                     else if (i == sh->pd_idx)
>> +                             srcs[slot] = percpu->spare_page;
>> +                     else if (i == sh->qd_idx)
>> +                             srcs[slot] = percpu->spare_page2;
>> +             } else if (sh->dev[i].written || i == sh->pd_idx ||
>> +                         i == sh->qd_idx)
>> +                     srcs[slot] = sh->dev[i].page;
>> +
>> +             i = raid6_next_disk(i, disks);
>> +     } while (i != d0_idx);
>> +
>> +     return syndrome_disks;
>> +}
>> +
>>  static struct dma_async_tx_descriptor *
>>  ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
>>  {
>> @@ -1401,6 +1435,50 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
>>       async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
>>  }
>>
>> +static struct dma_async_tx_descriptor *
>> +ops_run_rmw(struct stripe_head *sh, struct raid5_percpu *percpu,
>> +         struct dma_async_tx_descriptor *tx, int subtract)
>> +{
>> +     int pd_idx = sh->pd_idx;
>> +     int qd_idx = sh->qd_idx;
>> +     struct page **blocks = percpu->scribble;
>> +     struct page *xor_dest;
>> +     struct r5dev *dev;
>> +     struct async_submit_ctl submit;
>> +     int count;
>> +
>> +     pr_debug("%s: stripe %llu\n", __func__,
>> +             (unsigned long long)sh->sector);
>> +
>> +     count = set_rmw_syndrome_sources(blocks, sh, percpu, subtract);
>> +
>> +     init_async_submit(&submit, ASYNC_TX_ACK, tx, NULL, NULL,
>> +                       to_addr_conv(sh, percpu));
>> +     tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
>> +
>> +     dev = &sh->dev[pd_idx];
>> +     xor_dest = blocks[0] = subtract ? percpu->spare_page : dev->page;
>> +     blocks[1] = subtract ? dev->page : percpu->spare_page;
>> +
>> +     init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
>> +                       NULL, sh, to_addr_conv(sh, percpu));
>> +     tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
>> +
>> +     dev = &sh->dev[qd_idx];
>> +     xor_dest = blocks[0] = subtract ? percpu->spare_page2 : dev->page;
>> +     blocks[1] = subtract ? dev->page : percpu->spare_page2;
>> +
>> +     if (!subtract)
>> +             atomic_inc(&sh->count);
>> +
>> +     init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
>> +                       subtract ? NULL : ops_complete_reconstruct, sh,
>> +                       to_addr_conv(sh, percpu));
>> +     tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
>> +
>> +     return tx;
>
> The continual switching on 'subtract' make this hard to read too.  It is
> probably a bit big to duplication ... Is there anything you can do to make it
> easier to read?
>

Is this any better? Kumar?

static struct dma_async_tx_descriptor *
ops_run_rmw(struct stripe_head *sh, struct raid5_percpu *percpu,
            struct dma_async_tx_descriptor *tx, int subtract)
{
        int pd_idx = sh->pd_idx;
        int qd_idx = sh->qd_idx;
        struct page **blocks = percpu->scribble;
        struct page *xor_dest, *result, *src, *qresult, *qsrc;
        struct async_submit_ctl submit;
        dma_async_tx_callback done_fn;
        int count;

        /* the spare pages hold the intermediate P and Q results */
        if (subtract) {
                result = percpu->spare_page;
                src = sh->dev[pd_idx].page;

                qresult = percpu->spare_page2;
                qsrc = sh->dev[qd_idx].page;

                /* we'll be called once again after new data arrives */
                done_fn = NULL;
        } else {
                /* this is the final stage of the reconstruct */
                result = sh->dev[pd_idx].page;
                src = percpu->spare_page;

                qresult = sh->dev[qd_idx].page;
                qsrc = percpu->spare_page2;
                done_fn = ops_complete_reconstruct;
                atomic_inc(&sh->count);
        }

        pr_debug("%s: stripe %llu\n", __func__,
                (unsigned long long)sh->sector);

        count = set_rmw_syndrome_sources(blocks, sh, percpu, subtract);

        init_async_submit(&submit, ASYNC_TX_ACK, tx, NULL, NULL,
                          to_addr_conv(sh, percpu));
        tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);

        xor_dest = blocks[0] = result;
        blocks[1] = src;

        init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
                          NULL, sh, to_addr_conv(sh, percpu));
        tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);

        xor_dest = blocks[0] = qresult;
        blocks[1] = qsrc;

        init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
                          done_fn, sh, to_addr_conv(sh, percpu));
        tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);

        return tx;
}
