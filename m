From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 15:37:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0605261533090.20378-100000@coffee.psychology.mcmaster.ca>
References: <20060526183826.GE8203@percy.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060526183826.GE8203@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> i strongly believe it is not correct to let kernel auto-assemble devices
> kernel auto-assembly should be disable and activation should be handled
> by mdadm only!

it's a convenience/safety tradeoff, like so many other cases.
without kernel auto-assembly, it's somewhat more annoying to 
boot onto MD raid, right?  you are forced to put MD config stuff
into your initrd, etc.

I don't see why auto-assembly is such a bad thing.  it means you 
shouldn't leave 0xfd partitions sitting around, but that's OK,
since 0xfd means exactly and nothing but "please autoassemble this".
no worse than leaving inconsistent or erroneous stuff in your 
mdadm.conf or /etc/rc.d/rc.sysinit.

the only argument I see against (kernel) auto-assembly is the 
general principle of moving things out of the kernel where possible.
but that's not a hard/fast rule anyway, so...

