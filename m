From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v3 00/11] md/raid5: set STRIPE_SIZE as a configurable value
Date: Thu, 28 May 2020 07:28:43 -0700
Message-ID: <CAPhsuW7DOdPTWX5MNRJULvojFrCQF9_zNH+_ZwkQs4Qug9CpdQ@mail.gmail.com>
References: <20200527131933.34400-1-yuyufen@huawei.com> <CAPhsuW7hVgM7yiaBg0Pkaci4NStEdyduCp1+yMf9aguKfm4jKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW7hVgM7yiaBg0Pkaci4NStEdyduCp1+yMf9aguKfm4jKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Thu, May 28, 2020 at 7:10 AM Song Liu <song@kernel.org> wrote:
>
> On Wed, May 27, 2020 at 6:20 AM Yufen Yu <yuyufen@huawei.com> wrote:
> >
> > Hi, all
> >
> >  For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5 will
> >  issus echo bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64. However,
> >  filesystem usually issue bio in the unit of 4KB. Then, RAID5 will waste resource
> >  of disk bandwidth.
> >
>
> Thanks for the patch set.
>
> Since this is a big change, I am planning to process this set after
> upcoming merge window.
> Please let me know if you need it urgently.

I haven't thought about this in detail yet: how about compatibility?
Say we create an
array with STRIPE_SIZE of 4kB, does it work well after we upgrade kernel to have
STRIPE_SIZE of 8kB?

Thanks,
Song
