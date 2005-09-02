From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware RAID (was Re: RAID resync stalled at 99.7% ?)
Date: Fri, 2 Sep 2005 15:34:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.58.0509021532490.5341@chaos.egr.duke.edu>
References: <1125652202.3454.10.camel@chris.syd.nighthawkrad.net>
 <87vf1jsqjj.fsf@rimspace.net>  <1125678437.28420.1.camel@dhcpc226.office.pivotlink.com>
  <43173F4F.1020505@panix.com> <1125684560.30693.6.camel@dhcpc226.office.pivotlink.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1125684560.30693.6.camel@dhcpc226.office.pivotlink.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Dameron <brad@seatab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Sep 2005 at 11:09am, Brad Dameron wrote

> On Thu, 2005-09-01 at 13:50 -0400, berk walker wrote:
> > I guess if we were all wholesalers with a nice long lead time, that
> > would be great, Brad.  But where, and for how much might one purchase these?
> > 
> > b-
> > 
> 
> http://www.topmicrousa.com/controllers--tekram.html
> http://www.rackmountpro.com/productsearch.php?catid=199
> http://www.pc-pitstop.com/sata_raid_controllers/
> 
> Just for starters. Google found those by the way. And yes they are a
> little more than 3ware. But I can say they do twice the performance of
> the 3ware cards. Mainly due to their 800Mhz processor and faster memory.
> Their driver support is also more upt to date.

But has it made it into the mainline kernel yet?  3w-xxxx has been in 
mainline for a *long* time.  3w-9xxx is still settling a bit, that's true, 
but it's doing so in mainline.  Personally, I wouldn't put important data 
on an Areca controller until the drivers have been through wider testing 
than the -mm series (where I believe they're currently percolating).

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
