From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Date: Fri, 21 Sep 2007 13:52:24 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52027D909B@azsmsx413.amr.corp.intel.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com> <20070921114823.49d00263.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20070921114823.49d00263.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, yur@emcraft.com, saeed.bishara@gmail.com, "Nelson, Shannon" <shannon.nelson@intel.com>
List-Id: linux-raid.ids

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > Fix a couple bugs and provide documentation for the async_tx api.
> >
> > Neil, please 'ack' patch #3.
> >
> > git://lost.foo-projects.org/~dwillia2/git/iop
async-tx-fixes-for-linus
> 
> Well it looks like Neil is on vacation or is hiding from us or
something.
> 
> In which case our options would be to go ahead and merge your #3 with
> our fingers crossed, or wait and do it in 2.6.23.1 or .2.
> 
> How serious is this bug which you're fixing?  Will it affect users
> of "legacy" MD setups, or only those who have enabled fancy dma-engine
> features?
> 
The symptom is raid array that fails to complete a read request.

It has only been triggered by Yuri when he tried a dma-engine
configuration on his PPC platform with PAGE_SIZE=64K, this opens a large
window for the bug to hit.  The window is much smaller but not 100%
closed in the !dma-engine case, although no one else has hit it. 

2.6.22 returned reads from handle_stripe under the stripe lock so this
patch can be seen as 'reverting a botched micro-optimization' versus
'introducing a new way to handle reads'.

> Either way, we need to get #2 (at least) in to Linus.

#2 is less critical and cannot hit with any of the current drivers in
the kernel, so it is ok if this one misses 2.6.23.
