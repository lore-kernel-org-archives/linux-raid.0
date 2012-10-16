From: Borislav Petkov <bp@alien8.de>
Subject: Re: Strange crash on Dell R720xd
Date: Tue, 16 Oct 2012 14:48:25 +0200
Message-ID: <20121016124825.GA8509@x1.osrc.amd.com>
References: <20121015213522.kaiyahro@trusted.unix-scripts.info>
 <20121016090353.GB7428@liondog.tnic>
 <20121016112301.lavahnga@trusted.unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121016112301.lavahnga@trusted.unix-scripts.info>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent CARON <lcaron@unix-scripts.info>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
List-Id: linux-raid.ids

On Tue, Oct 16, 2012 at 11:26:01AM +0200, Laurent CARON wrote:
> On Tue, Oct 16, 2012 at 11:03:53AM +0200, Borislav Petkov wrote:
> > That's:
> > 
> >                 BUG_ON(async_tx_test_ack(depend_tx) || txd_next(depend_tx) ||
> > 			txd_parent(tx));
> > 
> > but probably the b0rkage happens up the stack. And this __raid_run_ops
> > is probably starting the whole TX so maybe we should add
> > linux-raid@vger.kernel.org to CC. Added.
> 
> 
> Hi,
> 
> The machines seem stable after disabling I/O AT DMA at the BIOS level.

That's a good point because the backtrace goes through I/O AT DMA so it
could very well be the culprit. Let's add some more people to Cc.

Vinod/Dan, here's the BUG_ON Laurent is hitting:

http://marc.info/?l=linux-kernel&m=135033064724794&w=2

and it has ioat2_tx_submit_unlock in the backtrace. Disabling ioat dma
in the BIOS makes the issue disappear so ...

> > What is that "r510" thing in the kernel version? You have your patches
> > ontop? If yes, please try reproducing this with a kernel.org kernel
> > without anything else ontop.
> 
> My kernel is vanilla from Kernel.org. The -r510 string is because I
> tried it on a -r510 also.

Ok, good.

> > Also, it might be worth trying plain 3.6 to rule out a regression
> > introduced in the stable 3.6 series.
> 
> I tried 3.5.x, 3.6, 3.6.1, 3.6.2 with exactly the same results.
> 
> For now, I did create more volumes, rsync lors of data over the network
> to the disks with no crashs (after disabling I/O AT DMA).

And when you do this with ioat dma enabled, you get the bug, right? So
it is reproducible...?

Thanks.

-- 
Regards/Gruss,
Boris.
