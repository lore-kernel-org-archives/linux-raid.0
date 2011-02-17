From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 01:00:58 +0100
Message-ID: <20110217000058.GA16130@www2.open-std.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5A7198.7060607@hardwarefreak.com> <ijdvmn$4ff$1@dough.gmane.org> <4D5C5EAA.3020208@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5C5EAA.3020208@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 16, 2011 at 05:32:58PM -0600, Stan Hoeppner wrote:
> David Brown put forth on 2/15/2011 7:39 AM:
> 
> RAID level space/cost efficiency from a TCO standpoint is largely irrelevant
> today due to the low price of mech drives.  Using the SATABeast as an example,
> the cost per TB of a 20TB RAID 10 is roughly $1600/TB and a 20TB RAID 6 is about
> $1200/TB.  Given all the advantages of RAID 10 over RAID 6 the 33% premium is
> more than worth it.

I assume that you with 20 TB mean the payload space in both places, that
is for the Linux MD RAID10 you actually have 40 TB of raw disk space.
With the Linux MD raid10 solution you furthermore can enjoy an almost
double up of the IO reading speed, involving 20 * 2 TB spindles compared
to 12 * 2 TB spindles.

best regards
keld
