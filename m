From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID1: deadlock between freeze_array and blk plug?
Date: Thu, 16 Jun 2016 18:01:13 +0300
Message-ID: <CAGRgLy7iQqGFfAvAMfdYYXR_YXqFh0wMrKiqf4HMeJM-awOMMA@mail.gmail.com>
References: <CAGRgLy52+zCq8iA98g2bVf6yKV7YJ8kfWRnX_D-uZc2pYnOiGA@mail.gmail.com>
 <CY1PR0801MB2252D339C65DF97375E3949C98560@CY1PR0801MB2252.namprd08.prod.outlook.com>
 <CAGRgLy7nsB7affa--6DK0hXzyoLmRxZuMkgLuxr4CktvAiBAzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7nsB7affa--6DK0hXzyoLmRxZuMkgLuxr4CktvAiBAzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Lawrence, Joe" <Joe.Lawrence@stratus.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

By further analysis I found out that this deadlock is not possible.
Reason is that when wait_barrier goes into waiting by calling
schedule(), then it will call sched_submit_work(), and it will do:

       /*
        * If we are going to sleep and we have plugged IO queued,
        * make sure to submit it to avoid deadlocks.
        */
       if (blk_needs_flush_plug(tsk))
                blk_schedule_flush_plug(tsk);

So it will flush all the plugged WRITEs, and they will go into
conf->pending_bio_list. And freeze_array will call
flush_pending_writes, so eventually these writes will complete, and
freeze_array will also complete.

So this problem does not exist, but the problems I mentioned in
http://www.spinics.net/lists/raid/msg52678.html
are real.

Thanks,
Alex.



On Thu, Jun 16, 2016 at 10:48 AM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Hello Joe,
>
> I think the commit you mention is related to handling read errors, in
> which case freeze_array is called, and it may hang due to incorrect
> accounting of IO requests. Also, this commit is only relevant since
> kernel 4.3. For example, in kernel 3.18 there is no "bio_end_io_list"
> at all.
>
> Looking more at this issue, I don't think this is related to the new
> freeze_array code using array_frozen since
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/md/raid1.c?id=b364e3d048e49b1d177eb7ee7853e77aa0560464
>
> Because the same plugging infrastructure already existed, for example,
> in kernel 3.8, but we did not observe similar deadlocks. I will have
> to dig more to understand how this deadlock is avoided.
>
> I am more worried now about the freeze_array deadlock I reported in
> http://www.spinics.net/lists/raid/msg52678.html
>
> This is a real deadlock that we see now.
>
> Thanks,
> Alex.
>
>
>
> On Thu, Jun 16, 2016 at 6:38 AM, Lawrence, Joe <Joe.Lawrence@stratus.com> wrote:
>> Hi Alexander,
>>
>> Any chance this was handled by commit "raid1: include bio_end_io_list in
>> nr_queued to prevent freeze_array hang" [1]
>>
>> [1]
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/md/raid1.c?id=ccfc7bf1f09d6190ef86693ddc761d5fe3fa47cb
>> ________________________________
>> From: linux-raid-owner@vger.kernel.org <linux-raid-owner@vger.kernel.org> on
>> behalf of Alexander Lyakas <alex.bolshoy@gmail.com>
>> Sent: Monday, June 13, 2016 7:02:38 AM
>> To: Neil Brown; Jes Sorensen; linux-raid
>> Subject: RAID1: deadlock between freeze_array and blk plug?
>>
>> Hello Neil, Jes,
>>
>> I wonder if the following deadlock is possible:
>>
>> - Caller calls blk_start_plug and wants to submit two WRITE bios
>>
>> - First bio successfully calls wait_barrier() and is appended to
>> plug->pending list
>>
>> - Now somebody does freeze_array()
>>
>> - freeze_array() unconditionally sets:
>>    conf->array_frozen = 1;
>>    and starts waiting for conf->nr_pending to go down
>>
>> - Second WRITE bio calls wait_barrier, but it will wait for
>> "!conf->array_frozen" until it can proceed
>>
>> - Now we have a deadlock: first bio will not be submitted because it
>> sits on the plug list of the caller, and caller is stuck in
>> wait_barrier, so it cannot do blk_finish_plug.
>>
>> I am about to try to reproduce it on kernel 3.18, but looking at the
>> latest Linus tree, I don't see something preventing this from
>> happening either. Am I missing something?
>>
>> Thanks,
>> Alex.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
