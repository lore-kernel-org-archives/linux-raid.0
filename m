From: NeilBrown <neilb@suse.de>
Subject: Re: Raid Checks
Date: Sun, 3 Apr 2011 21:19:37 +1000
Message-ID: <20110403211937.0a6efdee@notabene.brown>
References: <4D983064.30808@abpni.co.uk>
	<4D98346F.8090502@abpni.co.uk>
	<20110403210157.2c3ac83d@notabene.brown>
	<4D98544E.9000107@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D98544E.9000107@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 03 Apr 2011 12:04:46 +0100 Jonathan Tripathy <jonnyt@abpni.co.uk>
wrote:

> 
> >> My main concern, is that during these resyncs, I loose redundancy, don't I?
> > No.
> >
> > NeilBrown
> >
> Ah right, so by letting the raid-check script resync my RAID1 arrays 
> every Sunday, the only thing I loose is disk performance during the 
> resync?

Correct.

>         This is what state my server is currently in:
> 
> State : clean, resyncing

With mdadm 3.2.1, this will show "checking" when it is checking, rather than
"resyncing".

NeilBrown


>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
> 
>   Rebuild Status : 77% complete
> 
> Thanks

