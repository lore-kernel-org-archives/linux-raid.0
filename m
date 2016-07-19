From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Tue, 19 Jul 2016 12:20:08 +0300
Message-ID: <CAGRgLy6QhpWr5f07w3jT04oX4aA-aKTAr44JOih-DkK+dn5ABQ@mail.gmail.com>
References: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com>
 <87poqpf23c.fsf@notabene.neil.brown.name> <CAGRgLy4UgT_gGHL=Lx_By1fqmE4Q4pwvbhBTh0J+u=9gxuQOYQ@mail.gmail.com>
 <87d1miec7q.fsf@notabene.neil.brown.name> <CAGRgLy47B1QJrHgGP6L1VFpBwF+g8Uk2QED9MJ1oZr0KNv6kQw@mail.gmail.com>
 <87lh13dd1a.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lh13dd1a.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: =?UTF-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hello Neil,
Thank you for your response.

On Fri, Jul 15, 2016 at 2:18 AM, NeilBrown <neilb@suse.com> wrote:
> On Thu, Jul 14 2016, Alexander Lyakas wrote:
>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 32e282f4c83c..c528102b80b6 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -1288,7 +1288,7 @@ read_again:
>>>                                 sectors_handled;
>>>                         goto read_again;
>>>                 } else
>>> -                       generic_make_request(read_bio);
>>> +                       bio_list_add_head(&current->bio_list, read_bio);
>>>                 return;
>>>         }
>>
>> Unfortunately, this patch doesn't work. It is super elegant, and seems
>> like it really should work. But the problem is that the "rdev", to
>> which we want to send the READ bio, might also be a remapping device
>> (dm-linear, for example). This device will create its own remapped-bio
>> and will call generic_make_request(), which will stick the bio onto
>> current->bio_list TAIL:(:(:( So we are back at square one. This patch
>> would work if *all* the remapping drivers in the stack were doing
>> bio_list_add_head() instead of generic_make_request()  :(:(:(
>>
>> It seems the real fix should be that generic_make_request() would use
>> bio_list_add_head(), but as pointed in
>> http://www.spinics.net/lists/raid/msg52756.html, there are some
>> concerns about changing the order of remapped bios.
>>
>
> While those concerns are valid, they are about hypothetical performance
> issues rather than observed deadlock issues.  So I wouldn't be too
> worried about them.
I am thinking of a hypothetical driver that splits say a 12Kb WRITE
into 3x4kb WRITEs, and submits them in a proper order, hoping they
will get to the disk in the same order, and the disk will work
sequentially. But now we are deliberately hindering this. But I see
that people much smarter than me are in this discussion, so I will
leave it to them:)

> However I think you said that you didn't want to touch core code at all
> (maybe I misunderstood) so that wouldn't help you anyway.
Yes, this is correct. Recompiling the kernel is a bit of a pain for
us. We were smart enough to configure the md_mod as loadable module,
so at least now I can patch MD code easily:)

>
> One option would be to punt the request requests to raidXd:
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 40b35be34f8d..f795e27b2124 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1229,7 +1229,7 @@ read_again:
>                                 sectors_handled;
>                         goto read_again;
>                 } else
> -                       generic_make_request(read_bio);
> +                       reschedule_retry(r1_bio);
>                 return;
>         }
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 32e282f4c83c..eec38443075b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1288,7 +1288,7 @@ read_again:
>                                 sectors_handled;
>                         goto read_again;
>                 } else
> -                       generic_make_request(read_bio);
> +                       reschedule_retry(r10_bio);
>                 return;
>         }
This is more or less what my rudimentary patch is doing, except it is
doing it only when we really need to wait for the barrier.

>
>
> That might hurt performance, you would need to measure.
> The other approach would be to revert the patch that caused the problem.
> e.g.
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 40b35be34f8d..062bb86e5fd8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -884,7 +884,8 @@ static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
>                         wait = false;
>                 else
>                         wait = true;
> -       }
> +       } else if (conf->barrier)
> +               wait = true;
>
>         return wait;
>  }
>
>
I am not sure how this patch helps. You added another condition, and
now READs will also wait in some cases. But still if array_frozen is
set, everybody will wait unconditionally, which is the root cause for
the deadlock I think.

I see that there will be no magic solution for this problem:(

>
>>
>>>
>>>
>>>>
>>>> Since this issue is a real deadlock we are hitting in a long-term 3.18
>>>> kernel, is there any chance for cc-stable fix? Currently we applied
>>>> the rudimentary fix  I posted. It basically switches context for
>>>> problematic RAID1 READs, and runs them from a different context. With
>>>> this fix we don't see the deadlock anymore.
>>>>
>>>> Also, can you please comment on another concern I expressed:
>>>> freeze_array() is now not reentrant. Meaning that if two threads call
>>>> it in parallel (and it could happen for the same MD), the first thread
>>>> calling unfreeze_array will mess up things for the second thread.
>>>
>>> Yes, that is a regression.  This should be enough to fix it.  Do you
>>> agree?
>>>
>>> Thanks,
>>> NeilBrown
>>>
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 40b35be34f8d..5ad25c7d7453 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -984,7 +984,7 @@ static void freeze_array(struct r1conf *conf, int extra)
>>>          * we continue.
>>>          */
>>>         spin_lock_irq(&conf->resync_lock);
>>> -       conf->array_frozen = 1;
>>> +       conf->array_frozen += 1;
>>>         wait_event_lock_irq_cmd(conf->wait_barrier,
>>>                                 conf->nr_pending == conf->nr_queued+extra,
>>>                                 conf->resync_lock,
>>> @@ -995,7 +995,7 @@ static void unfreeze_array(struct r1conf *conf)
>>>  {
>>>         /* reverse the effect of the freeze */
>>>         spin_lock_irq(&conf->resync_lock);
>>> -       conf->array_frozen = 0;
>>> +       conf->array_frozen -= 1;
>>>         wake_up(&conf->wait_barrier);
>>>         spin_unlock_irq(&conf->resync_lock);
>>>  }
>> I partially agree. The fix that you suggest makes proper accounting of
>> whether the array is considered frozen or not.
>> But the problem is that even with this fix, both threads will think
>> that they "own" the array. And both will do things, like writing data
>> or so, which might interfere. The proper fix would ensure that only
>> one thread "owns" the array, and the second thread waits until the
>> first calls unfreeze_array(), and then the second thread becomes
>> "owner" of the array. And of course while there are threads that want
>> to "freeze" the array, other threads that want to do raise_barrier
>> etc, should wait.
>
> Is that really a problem?
> A call to "freeze_array()" doesn't mean "I want to own the array", but
> rather "No regular IO should be happening now".
>
> Most callers of freeze_array():
>     raid1_add_disk(), raid1_remove_disk(), stop(), raid1_reshape()
> are called with the "mddev_lock()" mutex held, so they cannot interfere
> with each other.
>
> handle_read_error() is called with one pending request, which will block
> any call on freeze_array(mddev, 0); - handle_read_error() itself calls
> freeze_array(mddev, 1) so it gets access.
> So these are already locked against the first four (as lock that
> ->array_frozen doesn't get corrupted).
>
> That just leaves raid1_quiesce().
> That is mostly called under mddev_lock() so it won't interfere with the
> others.
> The one exception is where md_do_sync() calls
>                         mddev->pers->quiesce(mddev, 1);
>                         mddev->pers->quiesce(mddev, 0);
>
> As this doesn't "claim" the array, but just needs to ensure all pending
> IO completes, I don't think there is a problem.
>
> So it seems to me that your concerns are not actually a problem.
> Did I miss something?
I think you are correct. The only exception is mddev_suspend/resume,
which can be called from another module. But for my case, this is not
happening.

Thanks,
Alex.

>
>>
>> I am sorry for giving two negative responses in one email:)
>
> Better a negative response than no response :-)
>
> NeilBrown
