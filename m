From: David Shaw <dshaw@jabberwocky.com>
Subject: Re: Possible data corruption sata_sil24?
Date: Wed, 18 Jul 2007 08:31:00 -0400
Message-ID: <20070718123100.GB3932@jabberwocky.com>
References: <20070706012432.GB29789@jabberwocky.com> <4693A5A0.5070306@gmail.com> <20070713014252.GA17811@jabberwocky.com> <46972AEE.2040805@gmail.com> <20070713115919.GC17811@jabberwocky.com> <469DD513.7070202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <469DD513.7070202@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 18, 2007 at 05:53:39PM +0900, Tejun Heo wrote:
> David Shaw wrote:
> >>> It fails whether I use a raw /dev/sdd or partition it into one large
> >>> /dev/sdd1, or partition into multiple partitions.  sata_sil24 seems to
> >>> work by itself, as does dm, but as soon as I mix sata_sil24+dm, I get
> >>> corruption.
> >> Hmmmm.... Can you reproduce the corruption by accessing both devices
> >> simultaneously without using dm?  Considering ich5 does fine, it looks
> >> like hardware and/or driver problem and I really wanna rule out dm.
> > 
> > I think I wasn't clear enough before.  The corruption happens when I
> > use dm to create two dm mappings that both reside on the same real
> > device.  Using two different devices, or two different partitions on
> > the same physical device works properly.  ich5 does fine with these 3
> > tests, but sata_sil24 fails:
> > 
> >  * /dev/sdd, create 2 dm linear mappings on it, mke2fs and use those
> >    dm "devices" == corruption
> > 
> >  * Partition /dev/sdd into /dev/sdd1 and /dev/sdd2, mke2fs and use
> >    those partitions == no corruption
> > 
> >  * Partition /dev/sdd into /dev/sdd1 and /dev/sdd2, create 2 dm linear
> >    mappings on /dev/sdd1, mke2fs and use those dm "devices" ==
> >    corruption
> 
> I'm not sure whether this is problem of sata_sil24 or dm layer.  Cc'ing
> linux-raid for help.  How much memory do you have?  One big difference
> between ata_piix and sata_sil24 is that sil24 can handle 64bit DMA.
> Maybe dma mapping or something interacts weirdly with dm there?

The machine has 640 megs of RAM.  FWIW, I tried this with 512 megs of
RAM with the same results.  Running Memtest86+ shows the memory is
good.

David
