From: Neil Brown <neilb@suse.de>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Mon, 1 Feb 2010 09:37:13 +1100
Message-ID: <20100201093713.7ee33041@notabene.brown>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se>
	<alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se>
	<20100129211719.04595761@notabene>
	<alpine.DEB.1.10.1001291306170.15329@uplift.swm.pp.se>
	<alpine.DEB.1.10.1001291326430.15329@uplift.swm.pp.se>
	<alpine.DEB.1.10.1001301546400.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001301546400.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 30 Jan 2010 22:20:34 +0100 (CET)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Fri, 29 Jan 2010, Mikael Abrahamsson wrote:
> 
> > Yes, that solved the problem. Thanks a bunch!
> 
> Now I have another problem. Last time one other drive was kicked out 
> during the resync due to UNC read errors. I ddrescued this drive to 
> another drive on another system, and inserted the drive I copied to. So 
> basically I have 5 drives which contain valid information of which one has 
> a lower event count, and one drive being resync:ed. This state doesn't 
> seem to be ok...
> 
> I guess if I removed the drive being resync:ed to and assembled it with 
> --force it would update the event count of sdh (the copy of the drive that 
> previously had read errors) and all would be fine. The bad part is that I 
> don't really know which of the drives was being resync:ed to. Is this 
> indicated by the "feature map" (guess 0x2 means partially sync:ed).

0x2 means "the 'recovery_offset' fields is valid" which does correlate well
with "is partially sync:ed".

> 
> (6 hrs later: Ok, I physically removed the 0x2 drive and used --assemble 
> --force and then I added a different drive and that seemed to work)
> 
> I don't know what the default action should be when there is a partially 
> resync:ed drive and a drive with lower event count, but I tend to lean 
> towards that it should take the drive with the lower event count and 
> insert it, and then start sync:ing to the 0x2 drive. This might require 
> some new options to mdadm to handle this behaviour?

You might know that nothing has been written to the array since the device
with the lower event count was removed, but md doesn't know that.  Any device
with an old event count could have old and so cannot be trusted (unless you
assemble with --force meaning that you are taking responsibility).

My planned way to address this situation is to store a bad-block-list per
device and when we get an unrecoverable failure, record the address in the
bad-block-list and continue as best we can.

NeilBrown


