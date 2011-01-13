From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/9] imsm: FIX: container content gathering is not
 needed for size set
Date: Thu, 13 Jan 2011 14:04:38 +1100
Message-ID: <20110113140438.6f62ef2b@notabene.brown>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140435.13862.5816.stgit@gklab-128-013.igk.intel.com>
	<20110112165239.720cb9e4@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176E1AD80@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176E1AD80@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 15:30:50 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Wednesday, January 12, 2011 6:53 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 6/9] imsm: FIX: container content gathering is not
> > needed for size set
> > 
> > On Tue, 11 Jan 2011 15:04:35 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > Size information is loaded already and there is no need to load it
> > again,
> > > when metadata is not reloaded.
> > 
> > Why do you say that?  It seems wrong.
> > 
> > When growing an array, the size will not change until the reshape
> > completes.
> > When it does complete, it will be mdmon which updates the metadata and
> > records in it the desired size of the array.
> > 
> > The only way mdadm can find this number out is by loading the metadata.
> > 
> > Where am I wrong?
> > 
> > NeilBrown
> 
> Size is set in metadata, before reshape start in reshape_super() and remains unchanged during whole reshape.
> After reshape this value doesn't change in metadata also.
> It is possible that this behavior is imsm specific, and for general case reload is required as you describes.
> 

If reshape_super does to that (and it looks like it does) then I strongly
suspect that it is wrong.

While an array is in the middle of a migration from one configuration to
another its effective size must be the smaller of those two sizes.
So when we add a device to a RAID5, the device size must stay unchanged until
the migration completes.  At the moment when the migration completes the size
can change, not before.  So I suspect that the size recorded in the metadata
should be the smaller size.

So I think that apply_reshape_container_disks_update and
imsm_progress_container_reshape need to be fixed to change the size after the migration.

NeilBrown

