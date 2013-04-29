From: Kumar Sundararajan <kumar@fb.com>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Mon, 29 Apr 2013 17:54:08 +0000
Message-ID: <BA07AEDCFD3B5B4DAB0FF1D7B35E42DC5544BD83@PRN-MBX01-4.TheFacebook.com>
References: <20130429112957.4bd6cd71@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130429112957.4bd6cd71@notabene.brown>
Content-Language: en-US
Content-ID: <3E879CCFD213034A88A6995E69D816B4@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Dan Williams <djbw@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 4/28/13 6:29 PM, "NeilBrown" <neilb@suse.de> wrote:

>On Fri, 26 Apr 2013 14:35:27 -0700 Dan Williams <djbw@fb.com> wrote:
>
>> On Sun, Apr 21, 2013 at 9:22 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Wed, 17 Apr 2013 17:56:56 -0700 Dan Williams <djbw@fb.com> wrote:
>> >
>> >> From: Kumar Sundararajan <kumar@fb.com>
>> >>
>> >> Add support for rmw writes in raid6. This improves small write
>>performance for most workloads.
>> >> Since there may be some configurations and workloads where rcw
>>always outperforms rmw,
>> >> this feature is disabled by default. It can be enabled via sysfs.
>>For example,
>> >>
>> >>       #echo 1 > /sys/block/md0/md/enable_rmw
>> >>
>> >> Signed-off-by: Kumar Sundararajan <kumar@fb.com>
>> >> Signed-off-by: Dan Williams <djbw@fb.com>
>> >> ---
>> >> Hi Neil,
>> >>
>> >> We decided to leave the enable in for the few cases where forced-rcw
>> >> outperformed rmw and there may be other cases out there.
>> >>
>> >> Thoughts?
>> >
>> > - More commentary would help.  The text at the top should explain
>>enough so
>> >   when I read the code I am just verifying the text at the top, not
>>trying to
>> >   figure out how it is supposed to work.
>> 
>> Ok, along the lines of:
>> 
>> "raid5 has supported sub-stripe writes by computing:
>> 
>> P_new = P_old + D0_old + D0_new
>
>The '0' looks out of place.  All 'D's are treated the same, so I would
>write
>it
>   P_new = P_old + D_old + D_new
>though that is a small point.
>
>> 
>> For raid6 we add the following:
>> 
>> P_new = P_old + D0_old + D0_new
>> 
>> Q_sub = Q_old + syndrome(D0_old)
>> Q_sub = Q_old + g^0*D0_old
>> Q_new = Q_old + Q_sub + g^0*D0_new
>
>But here the different Ds are different, so I would be using "Di" or
>similar.
>
>  P_new = P_old + Di_old + Di_new
>
>and I assume the two 'Q_sub' lines are meant to mean the same thing, so
>let's
>take the second:
>
>  Q_sub = Q_old + g^i * Di_old
>  Q_new = Q_old + Q_sub + g^i * Di_new
>
>which looks odd as when that expands out, we add Q_old to Q_old and as
>'+'
>is 'xor', it disappears.  Maybe you mean:
>
>  Q_new = Q_sub + g^i * Di_new
>??
>
>This is exactly the sort of thing I wanted to see, but I hoped it wouldn't
>confuse me like it seems to be doing :-)
>
>
>> 
>> This has been verified with check and dual-degraded recovery operations.
>
>Good, thanks.
>
>> 
>> > - If 'enable_rmw' really is a good idea, then it is possibly a good
>>idea for
>> >   RAID5 to and so should be a separate patch and should work for
>>RAID4/5/6.
>> >   The default for each array type may well be different, but the
>> >   functionality would be the same.
>> 
>> Yes, although Kumar's testing has not found a test case that makes
>> significant difference for raid5.  I.e. it makes sense to not
>> artificially prevent raid5 from disabling rmw if the knob is there for
>> raid6, but it would need a specific use case to flip it from the
>> default.
>
>Agreed.
>
>> 
>> > - Can you  explain *why* rcw is sometimes better than rmw even on
>>large
>> >   arrays? Even a fairly hand-wavy arguement would help.  And it would
>>go in
>> >   the comment at the top of the patch that adds enable_rmw.
>> 
>> Hand wavy argument is that rcw guarantees that the drives will be more
>> busy so small sequential writes have more chance to coalesce into
>> larger writes.  Kumar, other thoughts?
>
>So it goes faster because it goes slower?  We seem to see that a lot with
>RAID5/6 :-(  But that argument seems to work adequately for both.  If
>there
>is a measured difference it would be nice to know where it comes from.
>Not
>essential, but nice.
>
>I had guessed that rcw spreads the load over more devices which might
>help on
>very busy arrays.
>
>My concern is that rcw being faster might be due to a bug somewhere
>because
>it is counter intuitive.
>Or maybe the trade off is different for RAID6 than RAID5.  Or maybe it is
>wrong for RAID5 but we haven't noticed.
>
>We currently count the number of devices we will need to read from to
>satisfy
>the demands of rcw and rmw, and choose the fewest.
>Maybe it is more expensive to read from a device that we are about to
>write
>to by - say - 50% because it keeps the head in the same region for longer
>(or more often). So we could scale the costs appropriately.
>Maybe a useful tunable would be "read-before-write penalty" rather than
>"allow rmw".
>With a high read-before-write penalty it would choose rcw more (as it
>reads
>from different devices to where it writes.  With a low read-before-write
>penalty it would be more likely to choose rmw where possible.


Performance with rmw + RAID6 also seems to depend on the workload.

With our setup -- 10+2 7200 RPM disks and 256K chunk size + internal
bitmap, we see
70-80% gains for purely random write workloads. With the same setup, 64K
sequential writes
perform about the same while smaller sequential writes are faster with rcw
-- 
the degradation with rmw is about 5-6%. In all cases, disk utilization is
lower with rmw.

Our thinking behind adding an "enable_rmw" flag was that it seems safe to
enable
rmw for raid6 when the write workload is known to be random. With
sequential writes,
the user can either leave it off (the default) or turn it on if they see
any
benefit during testing.

As to why rcw is faster sometimes, one reason for this maybe the higher
coalescing
of smaller writes with rcw that Dan referred to -- we do see higher disk
utilization
and higher merge rates with rcw.

And as you point out, rmw can add extra rotational latency -- in the worst
case,
a full disk rotation is needed to write the data to the modified disk.
This can be
significant for lower RPM disks.

What puzzles me is that these arguments should apply to raid5 too but we
don't
see similar degradation with rmw.



>
>> 
>> > - patch looks fairly sane assuming that it works - but I don't really
>>know if
>> >   it does.  You've reported speeds but haven't told me that you ran
>>'check'
>> >   after doing each test and it reported no mismatches.  I suspect you
>>did but
>> >   I'd like to be told.  I'd also like to be told what role 'spare2'
>>plays.
>> 
>> spare2 is holding the intermediate Q_sub result of subtracting out the
>> syndrome of the old data block(s)
>
>That makes sense.  I wonder if we should call it "Q_sub" rather than
>"spare2".
>Maybe there is a better name for spare_page too.
>
>....
>> > The continual switching on 'subtract' make this hard to read too.  It
>>is
>> > probably a bit big to duplication ... Is there anything you can do to
>>make it
>> > easier to read?
>> >
>> 
>> Is this any better? Kumar?
>
>Yes thanks.  Together with the above description of what it is trying to
>achieve, I can almost say I understand it :-)
>
>Thanks,
>NeilBrown
>
>
>> 
>> static struct dma_async_tx_descriptor *
>> ops_run_rmw(struct stripe_head *sh, struct raid5_percpu *percpu,
>>             struct dma_async_tx_descriptor *tx, int subtract)
>> {
>>         int pd_idx = sh->pd_idx;
>>         int qd_idx = sh->qd_idx;
>>         struct page **blocks = percpu->scribble;
>>         struct page *xor_dest, *result, *src, *qresult, *qsrc;
>>         struct async_submit_ctl submit;
>>         dma_async_tx_callback done_fn;
>>         int count;
>> 
>>         /* the spare pages hold the intermediate P and Q results */
>>         if (subtract) {
>>                 result = percpu->spare_page;
>>                 src = sh->dev[pd_idx].page;
>> 
>>                 qresult = percpu->spare_page2;
>>                 qsrc = sh->dev[qd_idx].page;
>> 
>>                 /* we'll be called once again after new data arrives */
>>                 done_fn = NULL;
>>         } else {
>>                 /* this is the final stage of the reconstruct */
>>                 result = sh->dev[pd_idx].page;
>>                 src = percpu->spare_page;
>> 
>>                 qresult = sh->dev[qd_idx].page;
>>                 qsrc = percpu->spare_page2;
>>                 done_fn = ops_complete_reconstruct;
>>                 atomic_inc(&sh->count);
>>         }
>> 
>>         pr_debug("%s: stripe %llu\n", __func__,
>>                 (unsigned long long)sh->sector);
>> 
>>         count = set_rmw_syndrome_sources(blocks, sh, percpu, subtract);
>> 
>>         init_async_submit(&submit, ASYNC_TX_ACK, tx, NULL, NULL,
>>                           to_addr_conv(sh, percpu));
>>         tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,
>>&submit);
>> 
>>         xor_dest = blocks[0] = result;
>>         blocks[1] = src;
>> 
>>         init_async_submit(&submit,
>>ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
>>                           NULL, sh, to_addr_conv(sh, percpu));
>>         tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
>> 
>>         xor_dest = blocks[0] = qresult;
>>         blocks[1] = qsrc;
>> 
>>         init_async_submit(&submit,
>>ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
>>                           done_fn, sh, to_addr_conv(sh, percpu));
>>         tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
>> 
>>         return tx;
>> }
>

