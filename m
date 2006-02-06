From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs
	running
Date: Mon, 06 Feb 2006 13:15:53 -0800
Message-ID: <1139260553.3067.55.camel@seki.nac.uci.edu>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
	 <43E68D62.4080704@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E68D62.4080704@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


Drives are probably going to have a lifetime that is proportionate to a
variety of things, and while I'm not a physicist or mechanical engineer,
nor in the hard disk business, the things that come to mind first are:

1) Thermal stress due to temperate changes - with more rapid changes
being more severe (expansion and contraction, I assume - viiz one of
those projectors or cars that run hot, and leave a fan running for a
while before fully powering off)

2) The amount of time a disk spends in a powered-off state (EG,
lubricants may congeal, and about every time my employer, UCI, has a
campus-wide power outage, -some- piece of equipment somewhere on campus
fails to come back up - probably due to thermal stress)

3) The number of times a disk goes to a powered-off state (thermal
stress again)

4) The amount of bumping around the disk undergoes, which may to an
extent be greater in disks that are surrounded by other disks, with
disks on the physical periphery of your RAID solution bumping around a
little less - those little rubber things that you screw the drive into
may help here.

5) The materials used in the platters, heads, servo, etc.

6) The number of alternate blocks for remapping bad blocks

7) The degree of tendency for a head crash to peel off a bunch of
material, or to just make a tiny scratch, and the degree of tendency for
scratched-off particles to bang into platters or heads later and scrape
off more particles - which can sometimes yield an exponential decay of
drive usability

8) How good the clean room(s) the drive was built in was/were

9) How good a drive is at parking the hards over unimportant parts of
the platters, when bumped, dropped, in an earth quake, when turned off,
etc.

If you want to be thorough with this, you probably want to employ some
materials scientists, some statisticians, get a bunch of different kinds
of drives and characterize their designs somehow, do multiple
longitudinal studies, hunt for correlations between drive attributes and
lifetimes, etc.

And I totally agree with a previous poster - this stuff may all change
quite a bit by the time the study is done, so it'd be a really good idea
to look for ways of increasing your characterizations longevity somehow,
possibly by delving down into individual parts of the drives and looking
at their lifetime.  But don't rule out holistic/chaotic effects
unnecessarily, even if "the light's better over here" when looking at
the reductionistic view of drives.

PS: Letting a drive stay powered without spinning is sometimes called a
"warm spare", while a drive that's spinning all the time even while not
in active use in a RAID array is called a "cold spare".

HTH :)

On Sun, 2006-02-05 at 15:42 -0800, David Liontooth wrote:
> In designing an archival system, we're trying to find data on when it
> pays to power or spin the drives down versus keeping them running. 
> 
> Is there a difference between spinning up the drives from sleep and from
> a reboot? Leaving out the cost imposed on the (separate) operating
> system drive.
> 
> Temperature obviously matters -- a linear approximation might look like
> this,
> 
>      Lifetime = 60 - 12 [(t-40)/2.5]
> 
> where 60 is the average maximum lifetime, achieved at 40 degrees C and
> below, and lifetime decreases by a year for every 2.5 degree rise in
> temperature.  Does anyone have an actual formula?
> 
> To keep it simple, let's assume we keep temperature at or below what is
> required to reach average maximum lifetime. What is the cost of spinning
> up the drives in the currency of lifetime months?
> 
> My guess would be that the cost is tiny -- in the order of minutes.
> 
> Or are different components stressed in a running drive versus one that
> is spinning up, so it's not possible to translate the cost of one into
> the currency of the other?
> 
> Finally, is there passive decay of drive components in storage?
> 
> Dave
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

