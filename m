From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: Tiobench results LOWER with more threads
Date: Thu, 17 Oct 2002 19:31:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021018023137.GC18294@peeps.cable.rcn.com>
References: <3DABCFE7.9070701@webmail.co.za> <20021017215014.GA7875@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021017215014.GA7875@unthought.net>
To: Vladimir Milovanovic <vlad@webmail.co.za>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 17, 2002 at 11:50:14PM +0200, Jakob Oestergaard wrote:
> On Tue, Oct 15, 2002 at 10:20:55AM +0200, Vladimir Milovanovic wrote:
> > OK, just joined the list and rad the faq, and something caught my eye. 
> > Tiobench results are apparently supposed to INCREASE when there are more 
> > threads.
> 
> No, what gave you that idea?
> 
> It is so much easier for the kernel to handle one sequential stream of
> I/O, instead of many streams.
> 
> If you have more than one stream, you need to seek. Seeking is bad. One
> sequential I/O is almost always (with the notable exception of RAID-1
> reads) faster in total sustained throughput, and always (as in really
> always) faster in per-thread sustained throughput.

Err, so are you saying that a single sequential I/O is slower on RAID
1 when compared with a single disk?  That doesn't make a lot of
sense.  There -are- instances where parallel I/O is required.  In
these cases, any RAID-1 should be much faster than a single disk, as
should RAID 10.  I'm not sure that RAID 5 should give a similar
benefit, but given the cost of disks, I don't care about RAID 5.

> > Celeron 633
> > 196 MB PC 133
> > Adaptec 29160 SCSI controller (PCI)
> > 5 IBM Ultrastar 18XP (18gig, SCSI-3) disks hanging off the Adaptec 
> > controller
> > Red Hat 7.3 Linux (2.4.18-3)
> > 
> > Experimenting with different RAID configurations, I have found that I 
> > can not get more than 32 MB/s from this array with 4 disks, one spare. I 
> > have actually found out that the disks set the SCSI bus at 40 MB/s 
> > (since the disks are old) and that in RAID 0 it scales well, the speed 
> > doubles for two disks, and then the third disk brings in a little more 
> > performance, and then things topp off at 32 MB/s with four disks. Adding 
> > the fifth disk gains no extra performance.

Interesting.  How fast are you getting single-threaded reads from a
single disk?  And what are the real specs on the drives (RPM, cache,
SCSI version support (SCSI 3 is a family, not a version)).

> > Apparently VIA chipsets have problems with PCI bursting, so that is why 
> > I can't see the full 40 MB/s. That's fine.
> 
> There's some SCSI overhead as well.  And probably you have some RAM
> bandwidth limitation also - although that is probably not very important
> at the speed you're seeing.  But it all adds up.

Yeah, if this is a 40MB/sec bus, you shouldn't expect to get more than
35MB/sec out of the bus.  It'd be slick to get more, but overhead eats
the rest.
    Greg
