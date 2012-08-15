From: Shaohua Li <shli@kernel.org>
Subject: Re: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Wed, 15 Aug 2012 11:51:16 +0800
Message-ID: <CANejiEUjxR1Rt=2APf+kGXmzKYbcg_ZOztR3LirKbDERj7FG0A@mail.gmail.com>
References: <20120809085808.GB30111@kernel.org>
	<201208111645321254409@gmail.com>
	<CANejiEVNPv6qVJ1nsvt21VMF8Py=3L8sABh9wab9eCQfdRAGeA@mail.gmail.com>
	<201208130906432967842@gmail.com>
	<20120813021324.GB447@kernel.org>
	<CANejiEUoguBD8PRAAuj=ATk+gd0RAqCTNjV12odSChejX-+R6Q@mail.gmail.com>
	<201208141839308288603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208141839308288603@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>, Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2012/8/14 Jianpeng Ma <majianpeng@gmail.com>:
> On 2012-08-13 10:20 Shaohua Li <shli@kernel.org> Wrote:
>>2012/8/13 Shaohua Li <shli@kernel.org>:
>>> On Mon, Aug 13, 2012 at 09:06:45AM +0800, Jianpeng Ma wrote:
>>>> On 2012-08-13 08:21 Shaohua Li <shli@kernel.org> Wrote:
>>>> >2012/8/11 Jianpeng Ma <majianpeng@gmail.com>:
>>>> >> On 2012-08-09 16:58 Shaohua Li <shli@kernel.org> Wrote:
>>>> >>>This is a new tempt to make raid5 handle stripes in multiple threads, as
>>>> >>>suggested by Neil to have maxium flexibility and better numa binding. It
>>>> >>>basically is a combination of my first and second generation patches. By
>>>> >>>default, no multiple thread is enabled (all stripes are handled by raid5d).
>>>> >>>
>>>> >>>An example to enable multiple threads:
>>>> >>>#echo 3 > /sys/block/md0/md/auxthread_number
>>>> >>>This will create 3 auxiliary threads to handle stripes. The threads can run
>>>> >>>on any cpus and handle stripes produced by any cpus.
>>>> >>>
>>>> >>>#echo 1-3 > /sys/block/md0/md/auxth0/cpulist
>>>> >>>This will bind auxiliary thread 0 to cpu 1-3, and this thread will only handle
>>>> >>>stripes produced by cpu 1-3. User tool can further change the thread's
>>>> >>>affinity, but the thread can only handle stripes produced by cpu 1-3 till the
>>>> >>>sysfs entry is changed again.
>>>> >>>
>>>> >>>If stripes produced by a CPU aren't handled by any auxiliary thread, such
>>>> >>>stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
>>>> >>>stripes.
>>>> >>>
>>>> >> I tested and found two problem(maybe not).
>>>> >>
>>>> >> 1:print cpulist of auxth, you maybe lost print the '\n'.
>>>> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> >> index 7c8151a..3700cdc 100644
>>>> >> --- a/drivers/md/raid5.c
>>>> >> +++ b/drivers/md/raid5.c
>>>> >> @@ -4911,9 +4911,13 @@ struct raid5_auxth_sysfs {
>>>> >>  static ssize_t raid5_show_thread_cpulist(struct mddev *mddev,
>>>> >>         struct raid5_auxth *thread, char *page)
>>>> >>  {
>>>> >> +       int n;
>>>> >>         if (!mddev->private)
>>>> >>                 return 0;
>>>> >> -       return cpulist_scnprintf(page, PAGE_SIZE, &thread->work_mask);
>>>> >> +       n = cpulist_scnprintf(page, PAGE_SIZE - 2, &thread->work_mask);
>>>> >> +       page[n++] = '\n';
>>>> >> +       page[n] = 0;
>>>> >> +       return n;
>>>> >>  }
>>>> >>
>>>> >>  static ssize_t
>>>> >
>>>> >some sysfs entries print out '\n', some not, I don't mind add it
>>>> I search kernel code found places which like this print out '\n';
>>>> Can you tell rule which use or not?
>>>> Thanks!
>>>
>>> I'm not aware any rule about this
>>>
>>>> >> 2: Test 'dd if=/dev/zero of=/dev/md0 bs=2M ', the performance regress remarkable.
>>>> >> auxthread_number=0, 200MB/s;
>>>> >> auxthread_number=4, 95MB/s.
>>>> >
>>>> >So multiple threads handle stripes reduce request merge. In your
>>>> >workload, raid5d isn't a bottleneck at all. In practice, I thought only
>>>> >array which can drive high IOPS needs enable multi thread. And
>>>> >if you create multiple threads, better let the threads handle different
>>>> >cpus.
>>>> I will test for multiple threads.
>>> Thanks
> I used fio for randwrite test using four thread which run different cpus.
> The bs is 4k/8k/16k.
> The result isn't increase regardless of whether using authread(four authread which run different cpu) or not?
> Maybe my test config had problem?

how fast is your raid? If your raid can't drive high IOPS, it's
not strange multithread makes no difference.

>>BTW, can you try below patch for the above dd workload?
>>http://git.kernel.dk/?p=linux-block.git;a=commitdiff;h=274193224cdabd687d804a26e0150bb20f2dd52c
>>That one is reverted in upstream, but eventually we should make it
>>enter again after some CFQ issues are fixed.
> I tested this patch.And not found problem.And the performance did not increase.

Ok, each thread delivers request in random time, so merge doesn't
work even with that patch. I didn't worry about big size request too
much, since if you set correct affinity for the auxthread, the issue
should go away. And mulithread is for fast storage, I suppose it has
no advantages for harddisk raid. On the other hand, maybe we can
make MAX_STRIPE_BATCH bigger. Currently it's 8, so the auxthread
will dispatch 8*4k request for the workload. Changing it to 16
(16*4=64k) should be good enough even for hard disk raid.

Thanks,
Shaohua
