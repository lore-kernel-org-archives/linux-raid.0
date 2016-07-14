From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Thu, 14 Jul 2016 16:35:46 +0300
Message-ID: <CAGRgLy47B1QJrHgGP6L1VFpBwF+g8Uk2QED9MJ1oZr0KNv6kQw@mail.gmail.com>
References: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com>
 <87poqpf23c.fsf@notabene.neil.brown.name> <CAGRgLy4UgT_gGHL=Lx_By1fqmE4Q4pwvbhBTh0J+u=9gxuQOYQ@mail.gmail.com>
 <87d1miec7q.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1miec7q.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: =?UTF-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hello Neil, Shaohua,


On Wed, Jul 13, 2016 at 1:14 AM, NeilBrown <neilb@suse.com> wrote:
> On Tue, Jul 12 2016, Alexander Lyakas wrote:
>
>> Hello Neil,
>>
>> Thank you for your response. I read an email about you retiring from
>> MD/mdadm maintenance and delegating mdadm maintenance to Jes Sorensen.
>> But I was wondering who will be responsible for MD maintenance, and
>> was about to send an email asking that.
>
> Yes, I no longer have maintainership responsibilities, though I'm still
> involved to some extent.  Jes Sorensen is looking after mdadm and
> Shaohua Li is looking after the kernel driver (as listed in MAINTAINERS).
>
>
>>
>> On Fri, Jul 8, 2016 at 2:41 AM, NeilBrown <neilb@suse.com> wrote:
>>> On Mon, Jun 27 2016, Alexander Lyakas wrote:
>>>
>>>> When we call wait_barrier, we might have some bios waiting
>>>> in current->bio_list, which prevents the array_freeze call to
>>>> complete. Those can only be internal READs, which have already
>>>> passed the wait_barrier call (thus incrementing nr_pending), but
>>>> still were not submitted to the lower level, due to generic_make_request
>>>> logic to avoid recursive calls. In such case, we have a deadlock:
>>>> - array_frozen is already set to 1, so wait_barrier unconditionally waits, so
>>>> - internal READ bios will not be submitted, thus freeze_array will
>>>> never completes
>>>>
>>>> This problem was originally fixed in commit:
>>>> d6b42dc md/raid1,raid10: avoid deadlock during resync/recovery.
>>>>
>>>> But then it was broken in commit:
>>>> b364e3d raid1: Add a field array_frozen to indicate whether raid in
>>>> freeze state.
>>>
>>> Thanks for the great analysis.
>>> I think this primarily a problem in generic_make_request().  It queues
>>> requests in the *wrong* order.
>>>
>>> Please try the patch from
>>>   https://lkml.org/lkml/2016/7/7/428
>>>
>>> and see if it helps.  If two requests for a raid1 are in the
>>> generic_make_request queue, this patch causes the sub-requests created
>>> by the first to be handled before the second is attempted.
>> I have read this discussion and more or less (probably less than more)
>> understood that the second patch by Lars is supposed to address our
>> issue. However, we cannot easily apply that patch:
>> - The patch is based on structures added by earlier patch "[RFC]
>> block: fix blk_queue_split() resource exhaustion".
>> - Both patches are not in the mainline tree yet.
>> - Both patches are in block core, which requires to recompile the whole kernel.
>> - Not sure if these patches are applicable for our production kernel
>> 3.18 (long term)
>>
>> I am sure you understand that for production with our current kernel
>> 3.18 (long term) we cannot go with these two patches.
>
> This patch takes the basic concept of those two and applies it just to
> raid1 and raid10.  I think it should be sufficient.  Can you test?  The
> patch is against 3.18
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 40b35be34f8d..99208aa2c1c8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1229,7 +1229,7 @@ read_again:
>                                 sectors_handled;
>                         goto read_again;
>                 } else
> -                       generic_make_request(read_bio);
> +                       bio_list_add_head(current->bio_list, read_bio);
>                 return;
>         }
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 32e282f4c83c..c528102b80b6 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1288,7 +1288,7 @@ read_again:
>                                 sectors_handled;
>                         goto read_again;
>                 } else
> -                       generic_make_request(read_bio);
> +                       bio_list_add_head(&current->bio_list, read_bio);
>                 return;
>         }

Unfortunately, this patch doesn't work. It is super elegant, and seems
like it really should work. But the problem is that the "rdev", to
which we want to send the READ bio, might also be a remapping device
(dm-linear, for example). This device will create its own remapped-bio
and will call generic_make_request(), which will stick the bio onto
current->bio_list TAIL:(:(:( So we are back at square one. This patch
would work if *all* the remapping drivers in the stack were doing
bio_list_add_head() instead of generic_make_request()  :(:(:(

It seems the real fix should be that generic_make_request() would use
bio_list_add_head(), but as pointed in
http://www.spinics.net/lists/raid/msg52756.html, there are some
concerns about changing the order of remapped bios.


>
>
>>
>> Since this issue is a real deadlock we are hitting in a long-term 3.18
>> kernel, is there any chance for cc-stable fix? Currently we applied
>> the rudimentary fix  I posted. It basically switches context for
>> problematic RAID1 READs, and runs them from a different context. With
>> this fix we don't see the deadlock anymore.
>>
>> Also, can you please comment on another concern I expressed:
>> freeze_array() is now not reentrant. Meaning that if two threads call
>> it in parallel (and it could happen for the same MD), the first thread
>> calling unfreeze_array will mess up things for the second thread.
>
> Yes, that is a regression.  This should be enough to fix it.  Do you
> agree?
>
> Thanks,
> NeilBrown
>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 40b35be34f8d..5ad25c7d7453 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -984,7 +984,7 @@ static void freeze_array(struct r1conf *conf, int extra)
>          * we continue.
>          */
>         spin_lock_irq(&conf->resync_lock);
> -       conf->array_frozen = 1;
> +       conf->array_frozen += 1;
>         wait_event_lock_irq_cmd(conf->wait_barrier,
>                                 conf->nr_pending == conf->nr_queued+extra,
>                                 conf->resync_lock,
> @@ -995,7 +995,7 @@ static void unfreeze_array(struct r1conf *conf)
>  {
>         /* reverse the effect of the freeze */
>         spin_lock_irq(&conf->resync_lock);
> -       conf->array_frozen = 0;
> +       conf->array_frozen -= 1;
>         wake_up(&conf->wait_barrier);
>         spin_unlock_irq(&conf->resync_lock);
>  }
I partially agree. The fix that you suggest makes proper accounting of
whether the array is considered frozen or not.
But the problem is that even with this fix, both threads will think
that they "own" the array. And both will do things, like writing data
or so, which might interfere. The proper fix would ensure that only
one thread "owns" the array, and the second thread waits until the
first calls unfreeze_array(), and then the second thread becomes
"owner" of the array. And of course while there are threads that want
to "freeze" the array, other threads that want to do raise_barrier
etc, should wait.

I am sorry for giving two negative responses in one email:)

Thanks,
Alex.
