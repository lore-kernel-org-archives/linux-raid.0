From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: md: raid5 resync corrects read errors on data block - is this correct?
Date: Wed, 12 Sep 2012 19:49:52 +0300
Message-ID: <CAGRgLy6Syso2dfELFhpK9nCyEgvuD6k3F=MRJBnrVU=btKqKVw@mail.gmail.com>
References: <CAGRgLy6Cqxyf2im+tG2JiaQFooLBBzT76hGpfTb47Cr_sFLr6g@mail.gmail.com>
	<20120912082909.33c8eec0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120912082909.33c8eec0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
I have done some more investigation on that.

I see that according to handle_stripe_dirtying(), raid6 always does
reconstruct-write, while raid5 checks what will be cheaper in terms of
IOs - read-modify-write or reconstruct-write. For example, for a
3-drive raid5, both are the same, so because of:

if (rmw < rcw && rmw > 0)
... /* this is not picked, because in this case rmw==rcw==1 */

reconstruct-write is always performed for such 3-drvie raid5. Is this correct?

The issue with doing read-modify-writes is that later we have no
reliable way to know whether the parity block is correct - when we
later do reconstruct-write because of a read error, for example. For
read requests we could have perhaps checked the bitmap, and do
reconstruct-write if the relevant bit is not set, but for write
requests the relevant bit will always be set, because it is set when
the write is started.

I tried the following scenario, which showed a data corruption:
# Create 4-drive raid5 in "--force" mode, so resync starts
# Write one sector on a stripe that resync has not handled yet. RMW is
performed, but the parity is incorrect because two other data blocks
were not taken into account (they contain garbage).
# Induce a read-error on the sector that I just wrote to
# Let resync handle this stripe

As a result, resync corrects my sector using other two data blocks +
parity block, which is out of sync. When I read back the sector, data
is incorrect.

I see that I can easily enforce raid5 to always do reconstruct-write,
the same way like you do for raid6. However, I realize that for
performance reasons, it is better to do RMW if possible.

What do you think about the following rough suggestion: in
handle_stripe_dirtying() check whether resync is ongoing or should be
started - using MD_RECOVERY_SYNC, for example. If there is an ongoing
resync, there is a good reason for that, probably parity on some
stripes is out of date. So in that case, always force
reconstruct-write. Otherwise, count what is cheaper like you do now.
(Can RCW be really cheaper than RMW?)

So during resync, array performance will be lower, but we will ensure
that all stripe-blocks are consistent. What do you think?

Thanks!
Alex.


On Wed, Sep 12, 2012 at 1:29 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 11 Sep 2012 22:10:01 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> I have been doing some investigation about resync on raid5, and I
>> induced a repairable read error on a drive that contains a data block
>> for a particular stripe_head. I saw that resync corrects the read
>> error by recomputing the missing data block, rewriting it (twice) and
>> then re-reading back.
>>
>> Then I dug into code and eventually saw that fetch_block():
>>
>> if ((s->uptodate == disks - 1) &&
>>     (s->failed && (disk_idx == s->failed_num[0] ||
>>                  disk_idx == s->failed_num[1]))) {
>>       /* have disk failed, and we're requested to fetch it;
>>        * do compute it
>>        */
>>
>> doesn't care whether disk_idx holds data or parity for this
>> stripe_head. It only checks that stripe_head has enough redundancy to
>> recompute the block.
>>
>> My question: is this behavior correct? I mean that if we are doing
>> resync, it means that we are not sure that parity is correct (e.g.,
>> after an unclean shutdown). But we still use this possibly-incorrect
>> parity to recompute the missing data block. So is this a potential
>> bug?
>>
>
> Maybe.
> I guess that if bad-block recording is enabled, then recording a bad block
> there would be the "right" thing to do.
> However if bad-block recording is not enabled then there are two options:
>  1/ kick the device from the array
>  2/ re-write the failing block based on the parity block which might be
>     incorrect, but very probably is correct.
>
> I suspect that the second option (which is currently implemented) will cause
> less data loss than the first.
>
> So I think the current code is the best option (unless we want to add some
> bad-block-recording support).
>
> NeilBrown
