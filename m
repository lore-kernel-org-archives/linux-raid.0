From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sat, 31 Jul 2004 19:40:02 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040731174002.GA9738@middle.of.nowhere>
References: <Pine.LNX.4.44.0407311822460.3362-100000@uplift.swm.pp.se> <200407311742.38058.mrwatts@fast24.co.uk>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200407311742.38058.mrwatts@fast24.co.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Mark Watts <mrwatts@fast24.co.uk>
Date: Sat, Jul 31, 2004 at 05:42:38PM +0100
> 
> > This doesn't change the fact that if you need to do a lot of random writes
> > and you need to do it quickly, avoid RAID5:ing large number of drives.
> 
> So why are scsi raid-5 systems so much better?

compared to other scsi raid-arrays, they are not 'better' for small
random writes. If they are better than ide, it's probably because of the
smaller access times for 15k rpm drives.

Jurriaan
-- 
It has a name, among the Voyani.
Lumina Arden. The light that burns.
You will feel its fire, Serra Diora.
	Michelle West - The Broken Crown
Debian (Unstable) GNU/Linux 2.6.8-rc2-mm1 2x6078 bogomips load 0.72
