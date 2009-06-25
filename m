From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O  sizes
Date: Thu, 25 Jun 2009 12:24:53 -0400
Message-ID: <yq1ocscqo16.fsf@sermon.lab.mkp.net>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
	<yq1vdmlsgqo.fsf@sermon.lab.mkp.net>
	<19010.57942.43011.108889@notabene.brown>
	<yq163elrksl.fsf@sermon.lab.mkp.net>
	<19011.5723.905426.951624@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19011.5723.905426.951624@notabene.brown> (Neil Brown's message
	of "Thu, 25 Jun 2009 16:16:59 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, jens.axboe@oracle.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil> Here you're thinking seems be very specific.  This value comes
Neil> from that spec.  That value is used for this particular
Neil> application.  Yet....

[...]

Neil> ...here you are being deliberately vague.  But with the exact same
Neil> values.  I find this confusing.

That's because I distinguish between hardware-imposed limits and
software-imposed ditto.  You don't think there's a difference.  I do.
We don't have any control whatsoever over the hardware limits.  We do
have full control over the software ones.

hw_sector_size is dead and has been replaced with logical_block_size and
physical_block_size to accommodate new hardware devices.  That's all
there is to that.  Full stop.

The presence of lbs and pbs is completely orthogonal to I/O hints
provided by hardware as well as software RAID devices.  The only thing
the two concepts have in common is that we need to make sure that any
hints applied by stacking drivers are compatible with the underlying
storage limitations.

You could argue that an MD device shouldn't have logical and physical
block size exposed at all.  To some extent I agree.  However, some
applications actually *do* require intimate knowledge about the
hardware.  Consequently I am in favor of having the knobs exposed.
Besides, the values are also being used extensively by the stacking
logic.

The desire to have knowledge about the hardware is not exclusively a
storage thing.  Page size, for instance.  Most applications don't care
about the page size.  That doesn't mean we remove getpagesize() or pack
it into something that applies equally well to all applications
(memory_allocation_granularity() !?).  It is a knob that available for
the few applications that need it.  The same goes for
physical_block_size.

-- 
Martin K. Petersen	Oracle Linux Engineering
