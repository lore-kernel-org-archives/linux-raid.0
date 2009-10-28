From: Dave Chinner <david@fromorbit.com>
Subject: Re: md software raid
Date: Thu, 29 Oct 2009 10:39:21 +1100
Message-ID: <20091028233921.GH9464@discord.disaster>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com> <4AE76D98.7000003@redhat.com> <4AE85E71.30807@redhat.com> <200910281706.46264.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200910281706.46264.bernd.schubert@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Eric Sandeen <sandeen@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, Richard Scobie <richard@sauce.co.nz>, "Majed B." <majedb@gmail.com>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-raid.ids

On Wed, Oct 28, 2009 at 05:06:46PM +0100, Bernd Schubert wrote:
> On Wednesday 28 October 2009, Eric Sandeen wrote:
> 
> > xfs_check is more or less deprecated; it is known to have large memory
> > requirements, and xfs_repair is the tool to use.
> 
> What about adding a warning message to it then? I guess most people don't 
> check list archives first before using it. 

IIUC, the plan is to add the one set of checks to xfs_repair that it
currently doesn't do (doesn't check free space trees because it
simply rebuilds them from scratch during the repair process), then
xfs_check will be changed to be wrapper around xfs_repair. i.e. the
xfs_check command is most likely not going away, just changing
implementation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
