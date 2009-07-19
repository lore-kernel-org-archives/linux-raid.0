From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Sun, 19 Jul 2009 07:04:47 -0400
Message-ID: <20090719110447.GA18135@infradead.org>
References: <20090718142156.GC2682@basil.fritz.box> <20090719005450717.VSFW5000@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090719005450717.VSFW5000@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 18, 2009 at 07:54:50PM -0500, Leslie Rhorer wrote:
> > There are regular reports of xfs_repair failing on 32bit,
> > even on volumes far smaller than 16TB.
> 
> 	But is that due to the 32 bit system directly, or to the fact XFS
> requires a huge amount of memory for fsck or repair?

As mentioned earlier here 16TB is the absolute limit on 32bit right now.
Failures on smaller systems are due to memory use, and this can be
mitigated using more swap.  And once we commit Barry's patches to
optimize the memory usage the memory requirement will go down massively.

