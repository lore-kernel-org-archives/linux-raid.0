From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: How to identify a failed md array
Date: Sun, 1 Jun 2014 19:23:39 +0200
Message-ID: <20140601192339.000062d9@localhost>
References: <20140526200711.000030e2@localhost>
	<20140529151851.2508bdb6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140529151851.2508bdb6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-raid.ids

NeilBrown wrote:
> 
> On Mon, 26 May 2014 20:07:11 +0200 Sebastian Herbszt <herbszt@gmx.de> wrote:
> 

[snip]

> > How can I identify a failed array?
> > array_state reports "clean", the last raid member stays "in_sync" and
> > the value in degraded doesn't equal raid_disks.
> 
> You know the array is "failed" when you get an IO error.
> 
> When a RAID1 array gets down to just one drive remaining, it starts acting
> like it is just one drive.
> How do you tell if is single plain ordinary drive is failed?  You get an IO
> error.  ditto with RAID1.
> 
> NeilBrown
> 

Since md knows the current state I hoped it would provide the required
information for an application to distinguish between degraded and failed
arrays. Any reason this is not the case?
This would allow mdadm to not only report "DegradedArray" but also
"FailedArray". Currently it does not generate any event when the last drive
fails.

Sebastian
