From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v7 0/3] md/raid5: set STRIPE_SIZE as a configurable value
Date: Tue, 21 Jul 2020 21:58:22 -0700
Message-ID: <CAPhsuW4MQK06f6weM2NPpDRMbOdLfpfXsH75Y2V178XpD92BPw@mail.gmail.com>
References: <20200718092909.4020424-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200718092909.4020424-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Sat, Jul 18, 2020 at 2:28 AM Yufen Yu <yuyufen@huawei.com> wrote:
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
>
>  Normally, using default stripe_size can get better performance. So, NeilBrown
>  have suggested just to fix the it as 4096. But, out test result shows that
>  a big value of stripe_size may have better performance when size of issued
>  IOs are mostly bigger than 4096. Thus, in this patchset, we still want to
>  set stripe_size as a configurable value.
>
>  This patchset just set STRIPE_SIZE as a configurable value for "PAGE_SIZE != 4096"
>  system, likely arm64 with 'PAGE_SIZE=64KB'. It doesn't make any difference for
>  'PAGE_SIZE == 4096' system, likely x86.
>
>  To save memory used by stripe_head, I will send the related optimiation patchset later.

Applied to md-next. Thanks!
