From: John Lange <john.lange@bighostbox.com>
Subject: Re: So what is the bios doing, if anything ?
Date: Sat, 18 Sep 2004 21:50:01 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095562201.21386.61.camel@ws102.darkcore.net>
References: <Pine.LNX.4.44.0409180940500.12827-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0409180940500.12827-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2004-09-18 at 08:53, Mark Hahn wrote: 
> > I haven't spent much time looking into the SATA stuff yet - but it seems
> > theres 2 camps - one which makes the drives look like IDE drives and one
> > which makes the look like SCSI.. I did an install on a Dell last week
> 
> sort of but not really.  sata hardware can be shoehorned into the older
> pata-oriented infrastructure by ignoring some features.  the real problem
> is that the traditional ide driver framework is not exactly beautiful
> on the inside, and some of those ignored features are pretty important.
> I believe that the general consensus is to move towards the scsi stack,
> though this doesn't mean the ide stack will disappear any time soon,
> if ever.  I wouldn't expect 3Gb sata to ever appear in the ide stack,
> or for hotplug to work right, or command queueing or device multiplexing.
> this is not so much a criticism of the ide stack, but rather an evaluation
> that it's easier to build onto the scsi framework.

Perhaps this is the way it is but my experience is that 2.6.x kernels
recognize SATA as /dev/hdx (ide) and 2.4.x recognize them as /dev/sdx
(scsi).

-- 
John Lange

