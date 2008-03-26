From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 vs raid5 - strange performance
Date: Wed, 26 Mar 2008 20:29:35 +0100
Message-ID: <20080326192935.GB18621@rap.rap.dk>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com> <20080325233649.GA632@rap.rap.dk> <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com> <20080326072416.GA8674@rap.rap.dk> <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 26, 2008 at 06:16:30PM +0100, Christian Pernegger wrote:
> >  OK, I think the normal hype on raid10 is to use the far layout for its
> >  better striping performance.
> 
> Wasn't f2 supposed to improve *reads*? Maybe I've got it backwards.
> 
> >  Are the disks SATA disks or SCSI disks?
> 
> PATA. It's a how-to-best-utilize-some-older-stuff project.
> 
> >  you could probably get some more performance by moving 2 disks
> >  to the PATA controller of the motherboard,
> 
> The board is newish and has just one PATA channel and that's
> explicitly for CDROM use.
> 
> >  I think it is interesting that your 3ware controller is not maxing out
> >  the PCI bus! With 6 disks of nominally 60 MB/s the  theoretical max is
> >  360 MB/s. So the 3ware controller really has IO bandwidth available
> >  which it is not getting close on putting to use.
> 
> Yes, that's the juicy part :)
> 
> >  What is the specifics for the 3ware controller?
> 
> http://www.3ware.com/products/parallel_ata.asp
> 
> It's the 8port version. Maybe their newer controllers are better but
> this one frankly sucks at anything but raid1 and maybe raid0 ...

I don't know if it is any worse than other hardware controllers.
I have two on-board sata controller chips with each their version of HW
RAID (NVIDIA and SIL) but I hesitate to try them out as I do not believe
I can configure raids on the partition level (only on disk level, I
believe). 

I think there is a tendency that SW raid like Linux kernel MD and Sun ZFS
etc are more intelligent and can thus obtain better performance than HW
RAID. HW RAID has the advantage as Bill says that you only need to
transfer the data once when writing, and that parity calculation is
offloaded from the main CPUs. 

If you reuse older hw, then I would say that you really have a problem
with the PCI bus here, and that a motherboard with better bus
performance could really boost the overall performance of your older HW. 
You should be able to get something like a 3-fold IO improvement if you
could avoid the PCI botleneck.

best regards
keld
