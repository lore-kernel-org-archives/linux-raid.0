From: David Chinner <dgc@sgi.com>
Subject: Re: limits on raid
Date: Fri, 15 Jun 2007 19:13:18 +1000
Message-ID: <20070615091318.GQ86004887@sgi.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18034.3676.477575.490448@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 15, 2007 at 01:58:20PM +1000, Neil Brown wrote:
> Certainly.  But the raid doesn't need to be tightly integrated
> into the filesystem to achieve this.  The filesystem need only know
> the geometry of the RAID and when it comes to write, it tries to write
> full stripes at a time.

XFS already knows this (stripe unit, stripe width) and already
does stripe unit sized and aligned allocation where it can.

> If that means writing some extra blocks full
> of zeros, it can try to do that.  This would require a little bit
> better communication between filesystem and raid, but not much.  If
> anyone has a filesystem that they want to be able to talk to raid
> better, they need only ask...

I'm interested in what you think is necessary here, Neil.

But I think there's more to it than this - the filesystem only
writes back what the generic writeback code passes it (i.e. a page
at a time). XFs writes back extra adjacent pages in each I/O
if they are in the same state, but it might take multiple
I/Os to write out a full stripe units if we are doing things
like writing across a hole.

Also, there is no guarantee that the first page the filesystem
receives lies at the start of a stripe boundary, so that
sort of information really needs to be propagated into
the generic writeback code above the filesystem as well....

IOWs, the files can easily end I/Os on stripe boundaries
but it is much harder to start them there because that is
not in the control of the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
