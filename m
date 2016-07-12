From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Tue, 12 Jul 2016 13:09:40 +0300
Message-ID: <CAGRgLy4UgT_gGHL=Lx_By1fqmE4Q4pwvbhBTh0J+u=9gxuQOYQ@mail.gmail.com>
References: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com>
 <87poqpf23c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87poqpf23c.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: =?UTF-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

Hello Neil,

Thank you for your response. I read an email about you retiring from
MD/mdadm maintenance and delegating mdadm maintenance to Jes Sorensen.
But I was wondering who will be responsible for MD maintenance, and
was about to send an email asking that.

On Fri, Jul 8, 2016 at 2:41 AM, NeilBrown <neilb@suse.com> wrote:
> On Mon, Jun 27 2016, Alexander Lyakas wrote:
>
>> When we call wait_barrier, we might have some bios waiting
>> in current->bio_list, which prevents the array_freeze call to
>> complete. Those can only be internal READs, which have already
>> passed the wait_barrier call (thus incrementing nr_pending), but
>> still were not submitted to the lower level, due to generic_make_request
>> logic to avoid recursive calls. In such case, we have a deadlock:
>> - array_frozen is already set to 1, so wait_barrier unconditionally waits, so
>> - internal READ bios will not be submitted, thus freeze_array will
>> never completes
>>
>> This problem was originally fixed in commit:
>> d6b42dc md/raid1,raid10: avoid deadlock during resync/recovery.
>>
>> But then it was broken in commit:
>> b364e3d raid1: Add a field array_frozen to indicate whether raid in
>> freeze state.
>
> Thanks for the great analysis.
> I think this primarily a problem in generic_make_request().  It queues
> requests in the *wrong* order.
>
> Please try the patch from
>   https://lkml.org/lkml/2016/7/7/428
>
> and see if it helps.  If two requests for a raid1 are in the
> generic_make_request queue, this patch causes the sub-requests created
> by the first to be handled before the second is attempted.
I have read this discussion and more or less (probably less than more)
understood that the second patch by Lars is supposed to address our
issue. However, we cannot easily apply that patch:
- The patch is based on structures added by earlier patch "[RFC]
block: fix blk_queue_split() resource exhaustion".
- Both patches are not in the mainline tree yet.
- Both patches are in block core, which requires to recompile the whole kernel.
- Not sure if these patches are applicable for our production kernel
3.18 (long term)

I am sure you understand that for production with our current kernel
3.18 (long term) we cannot go with these two patches.

Since this issue is a real deadlock we are hitting in a long-term 3.18
kernel, is there any chance for cc-stable fix? Currently we applied
the rudimentary fix  I posted. It basically switches context for
problematic RAID1 READs, and runs them from a different context. With
this fix we don't see the deadlock anymore.

Also, can you please comment on another concern I expressed:
freeze_array() is now not reentrant. Meaning that if two threads call
it in parallel (and it could happen for the same MD), the first thread
calling unfreeze_array will mess up things for the second thread.

Thank you for your help,
Alex.


>
> Thanks,
> NeilBrown
