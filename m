From: Brad Dameron <brad@seatab.com>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs
	running
Date: Mon, 06 Feb 2006 11:22:33 -0800
Message-ID: <1139253753.10903.2.camel@dhcpc226.office.pivotlink.com>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
	 <43E68D62.4080704@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E68D62.4080704@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

I read somewhere, still looking for the link, that the constant on/off
of a drive actually decrease's the drives lifespan due to the
heating/cooling of the bearings. It was actually determined to be best
to leave the drive spinning. 

Brad Dameron
SeaTab Software
www.seatab.com


