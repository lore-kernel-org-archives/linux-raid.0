From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v3 00/11] md/raid5: set STRIPE_SIZE as a configurable value
Date: Mon, 1 Jun 2020 23:59:18 -0700
Message-ID: <CAPhsuW4UMDKhpGL71R6FY1-Q_u6On68ku4C=xp0UzSaEaCNGkg@mail.gmail.com>
References: <20200527131933.34400-1-yuyufen@huawei.com> <f0ab9a2d-696b-b21f-faec-370cd7c3ed3a@cloud.ionos.com>
 <e373279d-9cc0-3a47-e6dd-887de0162d63@huawei.com> <71f662d7-9aee-a130-c41d-67a691514ef6@cloud.ionos.com>
 <555121b6-fe76-4827-7b8f-7a22ba04ed82@huawei.com> <9acfb512-88ee-b4b0-88d4-94841e72d31a@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9acfb512-88ee-b4b0-88d4-94841e72d31a@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Yufen Yu <yuyufen@huawei.com>, linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Mon, Jun 1, 2020 at 7:02 AM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> On 5/30/20 4:15 AM, Yufen Yu wrote:
> >
> >
> > On 2020/5/29 20:22, Guoqing Jiang wrote:
> >> On 5/29/20 1:49 PM, Yufen Yu wrote:
> >>>> The 4k rand write performance drops from 100MB/S to 15MB/S?! How
> >>>> about other
> >>>> io sizes? Say 16k, 64K and 256K etc, it would be more convincing if
> >>>> 64KB stripe
> >>>> has better performance than 4KB stripe overall.
> >>>>
> >>>
> >>> Maybe I have not explain clearly. Here, the fio test result shows
> >>> that 4KB
> >>> STRIPE_SIZE is not always have better performance. If applications
> >>> request
> >>> IO size mostly are bigger than 4KB, likely 1MB in test, set
> >>> STRIPE_SIZE with
> >>> a bigger value can get better performance.
> >>>
> >>> So, we try to provide a configurable STRIPE_SIZE, rather than fix
> >>> STRIPE_SIZE as 4096.
> >>
> >> Which means if you set stripe size to 64KB then you should guarantee
> >> the io size should
> >> always bigger then 1MB, right? Given that, I don't think it makes
> >> lots of sense.
> >>
> >
> > No, I think you misunderstood. This patchset just want to optimize
> > RAID5 performance
> > for systems whose PAGE_SIZE is bigger than 4KB, likely 64KB on ARM64.
> > Without this
> > patchset, STRIPE_SIZE is equal to 64KB, means each IO size issued to
> > array disk at
> > least 64KB each time, Right? But filesystems usually issue bio in the
> > unit of 4KB,
> > means sometimes required 4KB but read or write 64KB on disk actually.
> > That would
> > waste resources.
>
> Yes,, it is hard for me to understand your way is better than just make
> stripe size equals to
> 4KB.
>
> >
> > After this patchset, we set STRIPE_SIZE as default 4KB. For systems
> > like X86, which
> > just support 4KB PAGE_SIZE, it will not have any effect. But for 64KB
> > arm64 system,
> > it **normally** can get better performance on filesystems base on
> > raid5, like dbench test.
> >
> > fio test just want to say that, we can also configure STRIPE_SIZE with
> > a bigger value
> > than default 4KB on 64KB ARM64 system when applications mostly issue
> > big IO. It can
> > get better performance for reducing IO split in RAID5.
>
> I do think the flexibility is not enough, if someone set stripe size to
> 64KB by any chance,
> people could complain the performance of raid5 really sucks if the io is
> not big. And it is
> not realistic to let people rebuild the module in case the io size is
> changed, so it would be
> more helpful if the stripe size can be changed dynamically without
> recompile code.

Agreed that it is not ideal to recompile the kernel/module to change stripe
size. It is also possible that multiple arrays in one system have different
optimal stripe sizes. I guess it shouldn't be too complicated to make this
configurable per array?

Thanks,
Song
