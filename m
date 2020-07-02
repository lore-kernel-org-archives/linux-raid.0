From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 00/16] md/raid5: set STRIPE_SIZE as a configurable value
Date: Thu, 2 Jul 2020 16:00:34 -0700
Message-ID: <CAPhsuW7PgJV-bjaa8v=Zrhd0MqPmjew1dF-Qi0FP6i-809YAQg@mail.gmail.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> Hi, all
>
>  For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5
>  will issue each bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64.
>  However, filesystem usually issue bio in the unit of 4KB. Then, RAID5 may
>  waste resource of disk bandwidth.
>
>  To solve the problem, this patchset try to set stripe_size as a configuare
>  value. The default value is 4096. We will add a new sysfs entry and set it
>  by writing a new value, likely:
>
>         echo 16384 > /sys/block/md1/md/stripe_size

Higher level question: do we need to support page size that is NOT 4kB
times power
of 2? Meaning, do we need to support 12kB, 20kB, 24kB, etc. If we only
supports, 4kB,
8kB, 16kB, 32kB, etc. some of the logic can be simpler.

Thanks,
Song
