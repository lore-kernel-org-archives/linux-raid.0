From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: [PATCH 2/2] mdadm: raid10.c Remove near atomic break
Date: Thu, 3 Nov 2016 23:37:48 -0600
Message-ID: <CAANLjFrXjS3HX-qv_FAXBapD6PE-n+y=d=6kzCwO3pSjajafWQ@mail.gmail.com>
References: <20161103234508.12641-1-robert@leblancnet.us> <20161103234508.12641-3-robert@leblancnet.us>
 <87k2cjq4eh.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k2cjq4eh.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 3, 2016 at 10:01 PM, NeilBrown <neilb@suse.com> wrote:
> On Fri, Nov 04 2016, Robert LeBlanc wrote:
>
>> This is always triggered for small reads preventing spreading the reads
>> across all available drives. The comments are also confusing as it is
>> supposed to apply only to 'far' layouts, but really only applies to 'near'
>> layouts. Since there isn't problems with 'far' layouts, there shouldn't
>> be a problem for 'near' layouts either. This change fairly distributes
>> reads across all drives where before only came from the first drive.
>
> Why is "fairness" an issue?
> The current code will use a device if it finds that it is completely
> idle. i.e. if nr_pending is 0.
> Why is that ever the wrong thing to do?

The code also looks for a drive that is closest to the requested
sector which doesn't get a chance to happen without this patch. The
way this part of code is written, as soon as it finds a good disk, it
cuts out of the loop searching for a better disk. So it doesn't even
look for another disk. In a healthy array with array-disks X and -p
nX, this means that the first disk gets all the reads for small I/O.
Where nY is less than X, it may be covered up because the data is
naturally striped, but it still may be picking a disk that is farther
away from the selected sector causing extra head seeks.

> Does your testing show that overall performance is improved?  If so,
> that would certainly be useful.
> But it isn't clear (to me) that simply spreading the load more "fairly"
> is a worthy goal.

I'll see if I have some mechanical drives somewhere to test (I've been
testing four loopback devices on a single NVME drive so you don't see
an improvement). You can see from the fio I posted [1] that before the
patch, one drive had all the I/O and after the patch the I/O was
distributed between all the drives (it doesn't have to be exactly
even, just not as skewed as it was before is good enough). I would
expect similar results to the 'far' tests done here [0]. Based on the
previous tests I did, when I saw this code, it just made complete
sense to me why we had great performance with 'far' and subpar
performance with 'near'. I'll come back with some results tomorrow.

[0] https://raid.wiki.kernel.org/index.php/Performance
[1] http://marc.info/?l=linux-raid&m=147821671817947&w=2

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
> Thanks,
> NeilBrown
>
>
>>
>> Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
>> ---
>>  drivers/md/raid10.c | 7 -------
>>  1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index be1a9fc..8d83802 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -777,13 +777,6 @@ static struct md_rdev *read_balance(struct r10conf *conf,
>>               if (!do_balance)
>>                       break;
>>
>> -             /* This optimisation is debatable, and completely destroys
>> -              * sequential read speed for 'far copies' arrays.  So only
>> -              * keep it for 'near' arrays, and review those later.
>> -              */
>> -             if (geo->near_copies > 1 && !atomic_read(&rdev->nr_pending))
>> -                     break;
>> -
>>               /* for far > 1 always use the lowest address */
>>               if (geo->far_copies > 1)
>>                       new_distance = r10_bio->devs[slot].addr;
>> --
>> 2.10.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
