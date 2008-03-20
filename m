From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Redundancy check using "echo check > sync_action": error
	reporting?
Date: Thu, 20 Mar 2008 14:02:41 -0400
Message-ID: <20080320180241.GJ13719@mit.edu>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <20080320173906.GN32242@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080320173906.GN32242@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 20, 2008 at 06:39:06PM +0100, Andre Noll wrote:
> On 12:35, Theodore Tso wrote:
> 
> > If a mismatch is detected in a RAID-6 configuration, it should be
> > possible to figure out what should be fixed
> 
> It can be figured out under the assumption that exactly one drive has
> bad data and all other ones have good data. But that seems to be an
> assumption that is hard to verify in reality.

True, but it's what ECC memory does.  :-)   And most people agree that
it's a useful thing to do with memory.  

If you do ECC syndrome checking on every read, and follow that up with
periodic scrubbing so that you catch (and correct) errors quickly, it
is a reasonable assumption to make.

Obviously a warning should be given when you do this kind of ECC
fixups, and if there is an increasing number of ECC fixups that are
being done, that should set off alarms that maybe there is a hardware
problem that needs to be addressed.

Regards,

						- Ted
