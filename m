From: Adam Luter <luterac@bellsouth.net>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 12:41:18 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030201184118.GH21736@smeagol>
References: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu> <Pine.LNX.4.44.0302011327180.2908-100000@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302011327180.2908-100000@datavibe.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The green pin on the adaptor is the signal for power on.  You need to
ground it.  I don't know how to signal a power off.

If you are curious, the reason I know this is because I have a nail
attached to that pin, and my normal power switch alligator clipped to
that nail, and a grounded portion of my case.  I use this to turn my
box on (you have to hold down for a few seconds).

The reason is that my motherboard decided (probably traumatized) not
to listen to power on requests anymore.  But it still knows how to
turn itself off through the normal hardware.

-Gryn (Adam Luter)

> You could try hacking together another powersupply to run some of the
> harddisks... I'm not sure of the ATX pinouts, but it shouldn't be too hard
> to hack up a 12vdc relay or array of relays to one of the 12VDC pins on a
> molex connector of the existing power supply to turn on the second power
> supply, kind of slaving it to the first.
> 
> Let me know if you need further data on doing this, it's a websearch away.
> 
> -j
> 
> --------------------------------------------------------
>   Jeffrey Paul      -datavibe-      sneak@datavibe.net
>  aim: x736e65616b   phone: 130*21*16749 or 877-748-3467
> --------------------------------------------------------
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
