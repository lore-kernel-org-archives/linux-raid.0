From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue
 take3
Date: Fri, 13 Jul 2007 17:01:47 -0700
Message-ID: <20070713170147.6129fc3b.akpm@linux-foundation.org>
References: <20070713160117.0db9d36d.akpm@linux-foundation.org>
	<0C7297FA1D2D244A9C7F6959C0BF1E5202234496@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5202234496@azsmsx413.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: neilb@suse.de, raziebe@gmail.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Nelson, Shannon" <shannon.nelson@intel.com>
List-Id: linux-raid.ids

On Fri, 13 Jul 2007 16:28:30 -0700
"Williams, Dan J" <dan.j.williams@intel.com> wrote:

> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > 
> > But your ongoing maintenance activity will continue to be held in
> those
> > trees, won't it?
> 
> For now:
> 	git://lost.foo-projects.org/~dwillia2/git/iop
> ioat-md-accel-for-linus
> 
> is where the latest combined tree is located.  However, Shannon Nelson
> is coming online to own the i/oat driver so we may need to revisit this
> situation.  We want to avoid the git-ioat/git-md-accel collisions that
> happened in the past.  I will talk with Shannon about how we will
> coordinate this going forward.
> 
> The code ownership looks like this:
> ioat dma driver - Shannon
> net dma offload implementation - Shannon
> dmaengine core - shared
> async_tx api - shared
> iop-adma dma driver - Dan
> md-accel implementation - Dan

oh my, how scary.  I'll go into hiding until the dust has settled.  Please
send me the git URLs when it's all set up, thanks.

