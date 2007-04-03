From: Stefan Seyfried <seife@suse.de>
Subject: Re: [Suspend-devel] s2disk and raid
Date: Tue, 3 Apr 2007 18:34:26 +0200
Message-ID: <20070403163425.GC5798@suse.de>
References: <20070403175521.70e6c876@commensaal.drs.p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070403175521.70e6c876@commensaal.drs.p>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Dijkstra <newsuser@famdijkstra.org>
Cc: suspend-devel List <suspend-devel@lists.sourceforge.net>, linux-raid@vger.kernel.org, 415441@bugs.debian.org
List-Id: linux-raid.ids

On Tue, Apr 03, 2007 at 05:55:21PM +0200, Tim Dijkstra wrote:
> Hi,
> 
> I've got a bugreport [0] from a user trying to use raid and uswsusp. He's
> using initramfs-tools available in debian. I'll describe the problem
> and my analysis, maybe you can comment on what you think. A warning: I only
> have a casual understanding of raid, never looked at any code related to it.
> 
> This is a setup where root maybe on raid, but swap isn't. Swap on raid
> will be very difficult to support, I think.

"it depends" :-)

> Now comes a crucial point. The script that finds the raid array, finds
> the array in an unclean state and starts syncing.

bad. Don't do that. Data will be lost.

> After this, resume finds an image in the swap partition and starts the
> resume process. Part of this process is freezing everything but itself,
> which fails on the process/thread that does the syncing.
> 
> IMO, the problem comes from the fact we started syncing, before we could
> start resume. 

Yes.
 
> Now the problem could theoretically be solved by not starting the
> assembly of the array once it is discovered, but modifying the 
> initramfs to do the assembly after we have had the chance to resume.

Yes.

> The debian-maintainer of mdadm thinks that the suspend process should
> have left the array in a clean state, but this is IMHO impossible. We
> are freezing userspace. A mdamd process looking after the array will
> probably get into trouble if we come back from suspend and we have
> done something to the array in the mean time.

Yes.
 
> What do you think?

You are right, he is wrong.
Do not touch anything before resume.
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out." 
