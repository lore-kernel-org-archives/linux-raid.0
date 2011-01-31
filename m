From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] patches addresses problem with memory corruption
Date: Tue, 1 Feb 2011 10:49:03 +1100
Message-ID: <20110201104903.48891253@notabene.brown>
References: <20110131151657.13213.16328.stgit@gklab-128-013.igk.intel.com>
	<905EDD02F158D948B186911EB64DB3D17701C779@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17701C779@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 15:59:24 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Adam Kwolek
> > Sent: Monday, January 31, 2011 4:25 PM
> > To: neilb@suse.de
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: [PATCH 0/2] patches addresses problem with memory corruption
> > 
> > When for raid0 metadata is updated outside mdmon it can happen that
> > memory corruption occurs due to too amount of memory is allocated
> > for imsm device structure.
> > 
> > 1. imsm: FIX: mdmon crash during 2 raid0 arrays expansion
> >   this patch is almost the same to sent earlier except 2 changes:
> >    a) compilation problem
> >    b) size should affect anchor size also
> >       (added calculation changes extends space_needed variable also
> >        this variable is used for anchor allocation)
> >   so it replaces previous one.
> > 2.  imsm: FIX: sizeof_imsm_dev() can return too small value
> > 	size returned by sizeof_imsm_dev() describes minimum size of
> > device
> >         This is correct when both device maps has the same length
> >         When device expands or shrinks we should return size that
> > allows
> >         for storing larger device information to avoid memory
> > corruption.
> > 
> > BR
> > Adam
> 
> imsm: FIX: sizeof_imsm_dev() can return too small value
> 	This should be addressed in different way (fix in different place), I have to think about it...
> 	please review/apply first patch only (imsm: FIX: mdmon crash during 2 raid0 arrays expansion)
> 

ahhh.. ok.  Yes, I see your point.
The size adjustment has to happen at the point when we malloc.

I suspect we should get ride of the idea of always allocating enough space to
hold the migration info as well, as we don't really know in advance how big
that is going to be.  Maybe we shoul always allocated (or re-allocated)
exactly how much we know we need now...

I had applied this patch, but I have now reverted it.
Thanks,
NeilBrown
