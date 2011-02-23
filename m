From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Tue, 22 Feb 2011 23:52:02 -0600
Message-ID: <4D64A082.9000601@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ik0gkm$nn$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 2/22/2011 8:18 AM:

> Yes, this is definitely true - RAID10 is less affected by running
> degraded, and recovering is faster and involves less disk wear.  The
> disadvantage compared to RAID6 is, of course, if the other half of a
> disk pair dies during recovery then your raid is gone - with RAID6 you
> have better worst-case redundancy.

The odds of the mirror partner dying during rebuild are very very long,
and the odds of suffering a URE are very low.  However, in the case of
RAID5/6, moreso with RAID5, with modern very large drives (1/2/3TB),
there is being quite a bit written these days about unrecoverable read
error rates.  Using a sufficient number of these very large disks will
at some point guarantee a URE during an array rebuild, which may very
likely cost you your entire array.  This is because every block of every
remaining disk (assuming full disk RAID not small partitions on each
disk) must be read during a RAID5/6 rebuild.  I don't have the equation
handy but Google should be able to fetch it for you.  IIRC this is one
of the reasons RAID6 is becoming more popular today.  Not just because
it can survive an additional disk failure, but that it's more resilient
to a URE during a rebuild.

With a RAID10 rebuild, as you're only reading entire contents of a
single disk, the odds of encountering a URE are much lower than with a
RAID5 with the same number of drives, simply due to the total number of
bits read.

> Once md raid has support for bad block lists, hot replace, and non-sync
> lists, then the differences will be far less clear.  If a disk in a RAID
> 5/6 set has a few failures (rather than dying completely), then it will
> run as normal except when bad blocks are accessed.  This means for all
> but the few bad blocks, the degraded performance will be full speed. And

You're muddying the definition of a "degraded RAID".

> if you use "hot replace" to replace the partially failed drive, the
> rebuild will have almost exactly the same characteristics as RAID10
> rebuilds - apart from the bad blocks, which must be recovered by parity
> calculations, you have a straight disk-to-disk copy.

Are you saying you'd take a "partially failing" drive in a RAID5/6 and
simply do a full disk copy onto the spare, except "bad blocks",
rebuilding those in the normal fashion, simply to approximate the
recover speed of RAID10?

I think your logic is a tad flawed here.  If a drive is already failing,
why on earth would you trust it, period?  I think you'd be asking for
trouble doing this.  This is precisely one of the reasons many hardware
RAID controllers have historically kicked drives offline after the first
signs of trouble--if a drive is acting flaky we don't want to trust it,
but replace it as soon as possible.

The assumption is that the data on the array is far more valuable than
the cost of a single drive or the entire hardware for that matter.  In
most environments this is the case.  Everyone seems fond of the WD20EARS
drives (which I disdain).  I hear they're loved because Newegg has them
for less than $100.  What's your 2TB of data on that drive worth?  In
the case of a MythTV box, to the owner, that $100 is worth more than the
content.  In a business setting, I'd dare say the data on that drive is
worth far more than the $100 cost of the drive and the admin $$ time
required to replace/rebuild it.

In the MythTV case what you propose might be a worthwhile risk.  In a
business environment, definitely not.

-- 
Stan
