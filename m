From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 21:31:56 -0500
Message-ID: <20060203023156.GA32621@lug.udel.edu>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de> <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se> <Pine.LNX.4.56.0602021651370.19057@lion.drogon.net> <43E27716.10506@dynaconnections.com> <20060202223859.GA26059@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060202223859.GA26059@sam.triumf.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Konstantin Olchanski <olchansk@triumf.ca>
Cc: "J. Ryan Earl" <ryan@dynaconnections.com>, Gordon Henderson <gordon@drogon.net>, Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 02, 2006 at 02:38:59PM -0800, Konstantin Olchanski wrote:
> Despite the claims for the opposite, hot-swap SATA does work,
> albeit with caveats and depending on chipsets and drivers.
> 
> Hot-unplug and hot-plug works for me with 3ware (8506) and LSI
> Megaraid (8-port SATA) controllers. Take a drive out, put it back in,
> type in a magic controller dependant command to enable it, then
> run mdadm --add.

But in both of these cases, the Linux kernel never interacts directly
with individual drives, only with SCSI disks presented to the OS by
the controller.

In other words, the cards and controllers take care of the hotswap so
libata doesn't need to.

> With Promise PDC20319 (4-port SATA), I hot swap by "rmmod sata_promise;
> remove old disk; connect new disk; modprobe sata_promise". I am sure
> this "rmmod" trick works for hot-swapping disks on any SATA controller.

I used to do this to hot swap ISA cards ::-)

I had a box with two ISA slots.  I only had ISA modem, sound card, and
NIC.  The NIC stayed in.  The modem and the sound card were both PnP,
so I could run isapnp to bring them up after a swap.  Never fried
anything, despite it being a horribly bad idea!

Don't try that at home...

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
