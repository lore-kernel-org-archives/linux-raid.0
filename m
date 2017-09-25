From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Mon, 25 Sep 2017 16:13:25 +0200
Message-ID: <5582177.Z68dcGn4Z3@merkaba>
References: <3926917.BCSovyVWdL@natalenko.name> <9658713.A4bv0G9Yjl@merkaba> <20170925025917.GA7090@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925025917.GA7090@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Ming Lei - 25.09.17, 10:59:
> On Sun, Sep 24, 2017 at 07:33:00PM +0200, Martin Steigerwald wrote:
> > Ming Lei - 21.09.17, 06:17:
> > > On Wed, Sep 20, 2017 at 07:25:02PM +0200, Martin Steigerwald wrote:
> > > > Ming Lei - 28.08.17, 21:32:
> > > > > On Mon, Aug 28, 2017 at 03:10:35PM +0200, Martin Steigerwald wrote:
> > > > > > Ming Lei - 28.08.17, 20:58:
> > > > > > > On Sun, Aug 27, 2017 at 09:43:52AM +0200, Oleksandr Natalenko 
wrote:
> > > > > > > > Hi.
> > > > 
> > > > > > > > Here is disk setup for QEMU VM:
> > > > […]
> > > > 
> > > > > > > > In words: 2 virtual disks, RAID10 setup with far-2 layout,
> > > > > > > > LUKS on
> > > > > > > > it,
> > > > > > > > then
> > > > > > > > LVM, then ext4 for boot, swap and btrfs for /.
> > > > > > > > 
> > > > > > > > I couldn't reproduce the issue with single disk without RAID.
> > > > > > > 
> > > > > > > Could you verify if the following patch fixes your issue?
> > > > > > 
> > > > > > Could this also apply to non MD RAID systems? I am using BTRFS
> > > > > > RAID
> > > > > > 1 with two SSDs. So far with CFQ it runs stable.
> > > > > 
> > > > > It is for fixing Oleksandr's issue wrt. blk-mq, and looks not for
> > > > > you.
> > > > 
> > > > My findings are different:
> > > > 
> > > > On 4.12.10 with CONFIG_HZ=1000, CONFIG_PREEMPT=y and optimizations for
> > > > Intel Core/newer Xeon I see this:
> > > > 
> > > > 1) Running with CFQ: No hang after resume
> > > > 
> > > > 2) Running with scsi_mod.use_blk_mq=1 + BFQ: Hang after resume within
> > > > first 1-2 days.
> > > 
> > > Hi Martin,
> > > 
> > > Thanks for your report!
> > > 
> > > Could you test the following patchset to see if it fixes your issue?
> > > 
> > > 	https://marc.info/?l=linux-block&m=150579298505484&w=2
> > 
> > Testing with https://github.com/ming1/linux.git, my_v4.13-safe-scsi-
> > quiesce_V5_for_test branch as of 53954fd58fb9fe6894b1635dad1acec96ca51a2f
> > I
> > now have a bit more than three days and 8 hours of uptime without a hang
> > on
> > resume from memory or disk, despite using blk-mq + BFQ.
> > 
> > So it looks like this patch set fixes the issue for me. To say for sure
> > I´d say some more days of testing are needed. But it looks like the hang
> > on resume is fixed by this patch set.
> 
> Martin, thanks for your test, it is great to see your issue is fixed
> by this patchset.
> 
> Also I remember that your issue wasn't related with MD, and actually
> you were using BTRFS(RAID), just want to double check with you,
> is that true?

Yes. But *additionally*, as I explained, the hangs only occured with 
CONFIG_HZ=1000, Low latency + CPU optimized kernel, not with CONFIG_HZ=250, 
voluntary preemption + generic x86 kernel. This hints a timing issue for me. 
So blk-mq + BFQ + CONFIG_HZ=1000 + Low Latency + CPU optimization = hang.

I did not investigate whether blk-mq without scheduler would work. And I did 
not investigate which of the three changes to the kernel configurations 
triggers the issue. I suspect its either CONFIG_HZ or the preemption option or 
both of them.

My original mail had both working and non working kernel configurations 
attached.

Thanks,
-- 
Martin
