From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 00/16] md/raid5: set STRIPE_SIZE as a configurable value
Date: Wed, 8 Jul 2020 16:55:17 -0700
Message-ID: <CAPhsuW7m7qYGe3g2XyZNWZch4Wy0y2URNeUprKAm4si+nyBB8g@mail.gmail.com>
References: <20200702120628.777303-1-yuyufen@huawei.com> <CAPhsuW7PgJV-bjaa8v=Zrhd0MqPmjew1dF-Qi0FP6i-809YAQg@mail.gmail.com>
 <0dd1ebed-2802-2bef-48f0-87bbdd2ee8e5@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0dd1ebed-2802-2bef-48f0-87bbdd2ee8e5@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Wed, Jul 8, 2020 at 6:15 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
>
>
> On 2020/7/3 7:00, Song Liu wrote:
> > On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
> >>
> >> Hi, all
> >>
> >>   For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5
> >>   will issue each bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64.
> >>   However, filesystem usually issue bio in the unit of 4KB. Then, RAID5 may
> >>   waste resource of disk bandwidth.
> >>
> >>   To solve the problem, this patchset try to set stripe_size as a configuare
> >>   value. The default value is 4096. We will add a new sysfs entry and set it
> >>   by writing a new value, likely:
> >>
> >>          echo 16384 > /sys/block/md1/md/stripe_size
> >
> > Higher level question: do we need to support page size that is NOT 4kB
> > times power
> > of 2? Meaning, do we need to support 12kB, 20kB, 24kB, etc. If we only
> > supports, 4kB,
> > 8kB, 16kB, 32kB, etc. some of the logic can be simpler.
>
> Yeah, I think we just support 4kb, 8kb, 16kb, 32kb... is enough.
> But Sorry that I don't know what logic can be simpler in current implementation.
> I mean it also need to allocate page, and record page offset.

I was thinking about replacing multiplication/division with bit
operations (shift left/right).
But I am not very sure how much that matters in modern ARM CPUs. Would you mind
running some benchmarks with this?

Thanks,
Song
