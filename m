From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: RE: Busted disks caused healthy ones to fail
Date: Tue, 14 Dec 2004 15:54:40 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1041214154622.17352A-100000@Maggie.Linux-Consulting.com>
References: <200412142147.iBELlv911030@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412142147.iBELlv911030@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Brad Campbell' <brad@wasp.net.au>, comsatcat@earthlink.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 14 Dec 2004, Guy wrote:

> My disk drives are rated to use 19.1 watts while active.
> My disk drives also get very hot without forced air movement.
> 14 such disks use 267.4 watts.  That would give you 152.6 watts for
> everything else.  I bet your disks use less power than mine.  I agree with
> Michael, you may be exceeding the power rating of your power supply.

an overworked power supply will fail "faster"

for "wattage" ... using a sharp needle, "pop" ... that is NOT how "wattage
works"

	- for a given voltage, you should be operating at 1/2 of its rated
	amperage

	- at 12v ... what are the disks rated at for power up ( spinup )
	vs ambeint normal operation
		- typically 1A to power up and 0.5A for normal spinning
		operation

	for a powersupply rated at 12V for 10A .. you can run 5 disks

	if you run more disks ... your power supply will die faster
	and/or your data gets corrupted during power ups when the
	system and the drives think you're in "normal operation"
	and enables write  while in fact, its is still in its bootup

> Also, I would not want to push a power supply to the max rating.  It should
> be sized 50 watts or more beyond what you need.

make that 2x the total wattage needed by the system .. NOT 50W 
	- add up the amps needed on the 3.3V, 5V, 12V 
	- use the MAX needed for operation, which is the power up sequence
	to get a "random number" of operating current ..

	Total watts == 12 * 12v(maxcurrent) + 5v * 5v(maxcurrent)
			3.3V * 3.3v(maxcurrent)

	- normal operation usually does NOT need as much current

- switched power supplies can output higher current than it is rated
  at, but it will not be able to sustain that "extra current load"
  for more than a few seconds before its over-current circuitry kicks
  in to shut itself down

	- you will be bouncing up and down in current on each power
	line till the system is all booted

	- put a digital storage scope on the 12V and 5V and 3.3V line
	and an ampmeter on each power line and watch it go bonkers

c ya
alvin

