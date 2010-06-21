From: Neil Brown <neilb@suse.de>
Subject: Re: migrating from RAID5 to RAID10
Date: Tue, 22 Jun 2010 08:09:21 +1000
Message-ID: <20100622080921.21997f6a@notabene.brown>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
	<20100611005231.401529c0@natsu>
	<20100610195851.GA8408@libra.CS.Berkeley.EDU>
	<4C18F39E.8010600@tmr.com>
	<20100617072631.09641f48@notabene.brown>
	<20100617174445.GB8450@libra.CS.Berkeley.EDU>
	<20100618083053.7df5248b@notabene.brown>
	<20100618084028.GA23230@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100618084028.GA23230@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: Gilad Arnold <arnold@cs.berkeley.edu>, Bill Davidsen <davidsen@tmr.com>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 18 Jun 2010 10:40:28 +0200
Keld Simonsen <keld@keldix.com> wrote:

> On Fri, Jun 18, 2010 at 08:30:53AM +1000, Neil Brown wrote:
> > 
> > 2-drive RAID10 f2  would be expected to provide better read throughput
> > (possibly twice as fast) at some cost to write throughput.  For many people
> > this is a worthwhile trade-off.  So it might be better for you.
> > Read throughput would degraded down to write throughput (i.e. slower than
> > RAID1) if the RAID10 were degraded.
> 
> The slowdown of write thruput is on the raw raid, and on file systems
> without elevator algorithms. If you employ a file system with an
> elevator algorithm, then there will be no noticeable slowdown for
> writes, as witnessed by many benchmarks.

Filesystems don't implement the elevator algorithm.
It is the driver for the disk drive which does that.
So if you have a filesystem on RAID10 on 4 disk drives, then there are 4
instances of the elevator algorithm between the RAID10 and each disk drive.

With RAID10 f2, consecutive chunks needs to be written to widely different
locations on the device.  The elevator certainly helps here by sorting the
write requests so that all the even chunks go to one end of the device, then
all the odd chunks go to the other end.
The only difference that I can imagine between a filesystem and raw-device
access is that maybe one allows the queue to fill up with more write requests
before flushing them out, thus giving the elevator more opportunity to
improve things. However I cannot see that difference in the code (though I
might be missing it).

One difference between writing to a raw device and writing to a filesystem is
that when you close the raw device, all pending writes are flushed, while
when you close a file the data can stay 'dirty' in memory for several more
seconds.  So writing to a raw device might seem slower because the close is
slower.

NeilBrown
