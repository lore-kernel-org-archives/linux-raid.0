From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: best common practice in case of degraded array with read
 errors
Date: Mon, 16 Nov 2009 23:15:45 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0911162309000.14550@uplift.swm.pp.se>
References: <alpine.DEB.1.10.0911162224530.14550@uplift.swm.pp.se> <20091116220722.GC14699@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091116220722.GC14699@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 16 Nov 2009, Robin Hill wrote:

> Are you running any regular array checks?  These should verify the 
> readability of the drives (and accuracy of the checksums).  This type of 
> failure's also why I've switched to RAID6 for most of my arrays.

Yes, I'm running those checks (ubuntu default) and the array was fine a 
week ago. I learnt that a few years back how important that is.

> Technically, the best practice is probably to recreate the array from
> scratch (replacing any failed drives) and restore from backup.  Short of
> that, your approach would seem to be the best option.  I've done this in
> the past, though I ended up restoring pretty much everything from backup
> anyway (as I had no other way of verifying the integrity of the data).

Well, I don't really have a full backup and integrity of the files isn't a 
real priority, so if I would have corrupted a few files it doesn't matter.

> I'd leave that to later.  Once you've imaged the disk you can try SMART 
> tests, read/write tests, etc. to verify whether there's actually a 
> physical problem or not (and how much of one - a bad block or two might 
> be acceptable, but a lot of them would point to a failing disk).  Until 
> then you're better putting as little trust in the disk as possible.

There is a problem with the drive, it's been having bad blocks before 
which has been remapped (during the check phase), I was going to get it 
replaced on warranty and I even purchased a replacement but before I got 
around to all this, I ended up with a total of 2 completey dead drives and 
one with errors.

I'm seriously considering going RAID6, been pondering it for quite a 
while, only thing that kept me back was that I wanted to migrate to RAID6 
but the code wasn't really ready (as has been discussed here before).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
