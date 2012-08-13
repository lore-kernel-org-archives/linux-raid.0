From: Shaohua Li <shli@kernel.org>
Subject: Re: Re: [patch 2/2 v3]raid5: create multiple threads to handle
 stripes
Date: Mon, 13 Aug 2012 10:13:24 +0800
Message-ID: <20120813021324.GB447@kernel.org>
References: <20120809085808.GB30111@kernel.org>
 <201208111645321254409@gmail.com>
 <CANejiEVNPv6qVJ1nsvt21VMF8Py=3L8sABh9wab9eCQfdRAGeA@mail.gmail.com>
 <201208130906432967842@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201208130906432967842@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@gmail.com>
List-Id: linux-raid.ids

On Mon, Aug 13, 2012 at 09:06:45AM +0800, Jianpeng Ma wrote:
> On 2012-08-13 08:21 Shaohua Li <shli@kernel.org> Wrote:
> >2012/8/11 Jianpeng Ma <majianpeng@gmail.com>:
> >> On 2012-08-09 16:58 Shaohua Li <shli@kernel.org> Wrote:
> >>>This is a new tempt to make raid5 handle stripes in multiple threads, as
> >>>suggested by Neil to have maxium flexibility and better numa binding. It
> >>>basically is a combination of my first and second generation patches. By
> >>>default, no multiple thread is enabled (all stripes are handled by raid5d).
> >>>
> >>>An example to enable multiple threads:
> >>>#echo 3 > /sys/block/md0/md/auxthread_number
> >>>This will create 3 auxiliary threads to handle stripes. The threads can run
> >>>on any cpus and handle stripes produced by any cpus.
> >>>
> >>>#echo 1-3 > /sys/block/md0/md/auxth0/cpulist
> >>>This will bind auxiliary thread 0 to cpu 1-3, and this thread will only handle
> >>>stripes produced by cpu 1-3. User tool can further change the thread's
> >>>affinity, but the thread can only handle stripes produced by cpu 1-3 till the
> >>>sysfs entry is changed again.
> >>>
> >>>If stripes produced by a CPU aren't handled by any auxiliary thread, such
> >>>stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
> >>>stripes.
> >>>
> >> I tested and found two problem(maybe not).
> >>
> >> 1:print cpulist of auxth, you maybe lost print the '\n'.
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 7c8151a..3700cdc 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -4911,9 +4911,13 @@ struct raid5_auxth_sysfs {
> >>  static ssize_t raid5_show_thread_cpulist(struct mddev *mddev,
> >>         struct raid5_auxth *thread, char *page)
> >>  {
> >> +       int n;
> >>         if (!mddev->private)
> >>                 return 0;
> >> -       return cpulist_scnprintf(page, PAGE_SIZE, &thread->work_mask);
> >> +       n = cpulist_scnprintf(page, PAGE_SIZE - 2, &thread->work_mask);
> >> +       page[n++] = '\n';
> >> +       page[n] = 0;
> >> +       return n;
> >>  }
> >>
> >>  static ssize_t
> >
> >some sysfs entries print out '\n', some not, I don't mind add it
> I search kernel code found places which like this print out '\n';
> Can you tell rule which use or not?
> Thanks!

I'm not aware any rule about this

> >> 2: Test 'dd if=/dev/zero of=/dev/md0 bs=2M ', the performance regress remarkable.
> >> auxthread_number=0, 200MB/s;
> >> auxthread_number=4, 95MB/s.
> >
> >So multiple threads handle stripes reduce request merge. In your
> >workload, raid5d isn't a bottleneck at all. In practice, I thought only
> >array which can drive high IOPS needs enable multi thread. And
> >if you create multiple threads, better let the threads handle different
> >cpus.
> I will test for multiple threads.
Thanks
