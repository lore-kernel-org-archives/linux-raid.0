From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: where to buy very very large cases
Date: Mon, 28 Jul 2003 11:38:53 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030728153853.GB22949@willow.seitz.com>
References: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net> <Pine.LNX.4.56.0307281024000.15708@router.windsormachine.com> <bWpzdHVtcGY=.4cd948dd5243da1b5289a26e6dc1ccfb@1059405399.cotse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bWpzdHVtcGY=.4cd948dd5243da1b5289a26e6dc1ccfb@1059405399.cotse.net>
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 28, 2003 at 11:16:39AM -0400, mjstumpf wrote:
> Fascinating topic.  Building these, cheaply, is easy up to a point. 
> Beyond that it gets interesting!

One idea we considered was building our own rack-mount drive enclosure.
The plan was this:

1) Have a standard case sit desktop style on a shelf in a rack.  Remove
the cover.  This way your PCI slot IDE controllers all have the ports
facing sitraight up.

2) Build an enclosure to bolt the drive in, but on the bottom of the
enclosure, cut slots for cables to come directly up from the server box
to the drives.  Stagger the drives forward and back and use longish ATA
cables.

3) Rack mount it directly above the server, as close as is possible.
Your limit will probably be PCI slots, since you can fit quite a few
drives into a bare box the size of a PC case.

Power could get insteresting, but it's a bit easier to be creative here
::-)

> I'm using a stack of promise ATA controllers with rounded ATA
> cables (some of long lengths, 36") to get the job done.  It's been up and
> running for the better part of 4 years now.

Are 36" cables within spec?  I thought 24" was max for 80-pin cables.
I've had data corruption problems due to extended cables, but if you've
been running them for 4 years, your luck looks better than mine.

> Can't easily stagger IDE powerup, can you?  Already ran into that issue...

Well, you can, but it's not pretty.  Power on, wait until the PSU trips.
Before the drives spin down, power again.  Rise and repeat until all
drives spin up.  Conservation of angular momentum is your friend here.
Then go buy a better PSU so you don't have to do this ::-)

> Because I'm a kernel hacker, I'd even been dreaming up ways have other
> linux boxen stacked with drives, similarly, and have them smoothly
> integrate into the big LVM.. but the methods are either unstable or
> clumsy.  Suggestions accepted..

NBD is probably the way to go.  I've used it some for RAID over network,
but it was mostly just me messing around for fun one weekend at home.
Nothing serious.

-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
