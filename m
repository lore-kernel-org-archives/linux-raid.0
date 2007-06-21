From: David Chinner <dgc@sgi.com>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 21:00:12 +1000
Message-ID: <20070621110006.GU85884050@sgi.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown> <20070618045759.GD85884050@sgi.com> <18041.59628.370832.633244@notabene.brown> <20070621063936.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755503AbXFULAt@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070621063936.GT85884050@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Neil Brown <neilb@suse.de>, Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 21, 2007 at 04:39:36PM +1000, David Chinner wrote:
> FWIW, I don't think this really removes the need for a filesystem to
> be able to keep multiple copies of stuff about. If the copy(s) on a
> device are gone, you've still got to have another copy somewhere
> else to get it back...

Speaking of knowing where you can safely put multiple copies, I'm in
the process of telling XFS about linear alignment of the underlying
array so that we can:

	- spread out the load across it faster.
	- provide workload isolation
	- know where *not* to put duplicate or EDAC data

I'm aiming at identical subvolumes so it's simple to implement.  All
I need to know is the size of each subvolume. I can supply that at
mkfs time or in a mount option, but I want something that can works
automatically so I need to query dm to find out the size of each
underlying device during mount.  We should also pass stripe
unit/width with the same interface while we are at it...

What's the correct and safe way to get this information from dm
both into the kernel and out to userspace (mkfs)?

FWIW, my end goal is to be able to map the underlying block device
address spaces directly into the filesystem so that the filesystem
is able to use the underlying devices intelligently and I can
logically separate caches and writeback for the separate subdevices.
A struct address_space per subdevice would be ideal - anyone got
ideas on how to get that?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
