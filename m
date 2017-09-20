From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Thu, 21 Sep 2017 06:17:08 +0800
Message-ID: <20170920221703.GA5105@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <3567128.t9myNOm9ia@merkaba>
 <20170828133218.GB19670@ming.t460p>
 <2260365.vTb2K2ZmgF@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2260365.vTb2K2ZmgF@merkaba>
Sender: linux-block-owner@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 20, 2017 at 07:25:02PM +0200, Martin Steigerwald wrote:
> Ming Lei - 28.08.17, 21:32:
> > On Mon, Aug 28, 2017 at 03:10:35PM +0200, Martin Steigerwald wrote:
> > > Ming Lei - 28.08.17, 20:58:
> > > > On Sun, Aug 27, 2017 at 09:43:52AM +0200, Oleksandr Natalenko wrote:
> > > > > Hi.
> > > > > 
> > > > > Here is disk setup for QEMU VM:
> […]
> > > > > In words: 2 virtual disks, RAID10 setup with far-2 layout, LUKS on it,
> > > > > then
> > > > > LVM, then ext4 for boot, swap and btrfs for /.
> > > > > 
> > > > > I couldn't reproduce the issue with single disk without RAID.
> > > > 
> > > > Could you verify if the following patch fixes your issue?
> > > 
> > > Could this also apply to non MD RAID systems? I am using BTRFS RAID
> > > 1 with two SSDs. So far with CFQ it runs stable.
> > 
> > It is for fixing Oleksandr's issue wrt. blk-mq, and looks not for you.
> 
> My findings are different:
> 
> On 4.12.10 with CONFIG_HZ=1000, CONFIG_PREEMPT=y and optimizations for Intel 
> Core/newer Xeon I see this:
> 
> 1) Running with CFQ: No hang after resume
> 
> 2) Running with scsi_mod.use_blk_mq=1 + BFQ: Hang after resume within first 1-2 
> days.

Hi Martin,

Thanks for your report!

Could you test the following patchset to see if it fixes your issue?

	https://marc.info/?l=linux-block&m=150579298505484&w=2


-- 
Ming
