From: Neil Brown <neilb@suse.de>
Subject: Re: Distributed spares
Date: Mon, 20 Oct 2008 12:11:26 +1100
Message-ID: <18683.55998.145056.757423@notabene.brown>
References: <48F3C2A1.3080607@tmr.com>
	<18676.28329.93345.30205@notabene.brown>
	<48F7D32A.4040306@tmr.com>
	<A20315AE59B5C34585629E258D76A97C024F81A1@34093-C3-EVS3.exchange.rackspace.com>
	<48F89749.5030500@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Friday October 17
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Lethe <david@santools.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday October 17, davidsen@tmr.com wrote:
> David Lethe wrote:
> >
> > With all due respect, RAID5E isn't practical.  Too many corner cases
> > dealing
> > With performance implications, and where you even just put the parity
> > block, to insure
> > That when a disk fails you didn't put yourself into situation where the
> > Hot spare chunk
> > is located on the disk drive that just died.  
> >
> >   
> Having run 38 multi-TB machines for an ISP using RAID5e in the SCSI 
> controller, I feel pretty sure that the practicality is established, and 
> only the ability to reinvent that particular wheel is in question. The 
> complexity is that the hot spare drive needs to be defined after the 1st 
> drive failure, using the spare sectors on the functional drives.

I don't think that will be particularly complex.  It will just be a
bit of code in raid5_compute_sector.  The detail of 'which device has
failed' would be stored in ->algorithm somehow.

There is an interesting question of how general do we want the code to
be.
e.g do we want to be able to configure an array with 2 distributed
spares?  I suspect that people would rarely want 2, and never want 3,
so it would be worth making 2 work if the code didn't get too complex,
which I don't think it would (but I'm not certain).

> > Algorithms dealing
> > with drive failures, unrecoverable read/write errors on normal
> > operations as well as rebuilds, expansions, 
> > and journalization/optimization are not well understood.  It is new
> > territory.
> >   
> 
> That's why I'm being quite cautious about saying I can do this, the 
> coding is easy, it's finding out what to code that's hard. It appears 
> that configuration decisions need to be made after the failure event, 
> before the rebuild. Yes, it's complex. But from experience I can say 
> that performance during rebuild is far better with a distributed spare 
> than beating the snot out of one newly added spare with other RAID 
> levels. So there's a performance benefit for both the normal case and 
> the rebuild case, and a side benefit of faster rebuild time.

I cannot see why rebuilding a raid5e would be faster than rebuilding a
raid5 to a fresh device.
In each case, you need to read from n-1 devices, and write to 1
device.  So all devices are constantly doing IO at the same rate.
In the raid5 case you could get better streaming as each device is
either "always reading" or "always writing", where as in a raid5e
rebuild, devices will sometimes read and sometimes write.  So if
anything, I would expect raid5e to rebuild more slowly, but you would
probably only notice this with small chunk sizes.

I agree that (with suitably large chunk sizes) you should be able to
get better throughput on raid5e.

NeilBrown
