From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Tweaking/Optimizing MD RAID: 195MB/s write, 181MB/s read (so
 far)
Date: Thu, 11 Jan 2007 18:32:06 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0701111831570.3673@p34.internal.lan>
References: <Pine.LNX.4.64.0701111804310.3847@p34.internal.lan>
 <20070111231724.GH44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070111231724.GH44411608@melbourne.sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Have not tried DM stripe btw.

On Fri, 12 Jan 2007, David Chinner wrote:

> On Thu, Jan 11, 2007 at 06:05:36PM -0500, Justin Piszcz wrote:
> > With 4 Raptor 150s & XFS (default XFS options):
> 
> I need more context for this to be meaningful in any way.
> 
> What type of md config are you using here?  RAID0, 1, 5.....?
> 
> What's the raw device throughput (i.e. read and write to /dev/md3)?
> 
> output of 'growfs_xfs -n <mntpt>'? (i.e. is XFS doing aligned
> or unaligned allocation/IO)?
> 
> If it's raid0, how does it compare with a dm stripe?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
