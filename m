From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: md: raid5 resync corrects read errors on data block - is this correct?
Date: Wed, 12 Sep 2012 10:15:40 +0300
Message-ID: <CAGRgLy5oDC5NjysCNOwiUPh5YvdqQmgm+7rSDADrnLDsCrM4Jg@mail.gmail.com>
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

Thanks for clarifying, Neil.

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
