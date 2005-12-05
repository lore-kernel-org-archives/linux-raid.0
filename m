From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 010 of 14] Convert various kmap calls to kmap_atomic
Date: Tue, 6 Dec 2005 10:43:50 +1100
Message-ID: <17300.53430.981206.9311@cse.unsw.edu.au>
References: <20051201141508.29384.patches@notabene>
	<1051201032339.29666@suse.de>
	<20051201144637.289592c8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday December 1
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 1, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >
> > +				paddr = kmap_atomic(page, KM_USER0);
> >  +				memset(paddr + offset, 0xff,
> >   				       PAGE_SIZE - offset);
> 
> This page which is being altered is a user-visible one, no?  A pagecache
> page?

It can be, but also may not be..

> 
> We must always run flush_dcache_page() against a page when the kernel
> modifies a user-visible page's contents.  Otherwise, on some architectures,
> the modification won't be visible at the different virtual address.

Ok, I'll add that at an appropriate place, thanks.

NeilBrown
