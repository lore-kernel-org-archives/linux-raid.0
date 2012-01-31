From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH 5/5] imsm: verify maximum supported active volumes in
 assembly
Date: Tue, 31 Jan 2012 15:27:36 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D40AF971@IRSMSX101.ger.corp.intel.com>
References: <F9123E44003394499FDD2B17C60621D4075DE9@IRSMSX101.ger.corp.intel.com>
	<20120130120232.236c5343@notabene.brown>
	<F9123E44003394499FDD2B17C60621D408AE9B@IRSMSX101.ger.corp.intel.com>
 <20120131091056.4c64c089@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120131091056.4c64c089@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

> 
> > Hi,
> > >
> > > hi,
> > >  I've applied the first four in this series, but I don't like this
> one.
> > >
> > > 1/ I don't think there is any need to impose this restriction when
> > >    assembling an array - only when creating a new volume in an
> array.
> > We want to support only as many volumes as OROM (platform) supports.
> Disks with IMSM metadata may be carried from other systems.
> 
> I don't think that makes sense.
> 
> There are two important issues here.
> 
> 1/ we don't want to make a change to an array which will make that
> array
>   inaccessible to the OROM.
> 2/ we don't want to make it difficult for users to get their data.
> 
> 
> So any create or grow attempt which could lead to the OROM being unable
> to access the array should be stopped (unless explicitly over-ridden).
> 
> But any attempt to access data on any array (i.e. assemble an array)
> should succeed no matter whether it is compatible with the OROM or not.
> 
> So --create and --grow should check for platform compatibility.
> --assemble should not.
> 
> --examine and --detail should probably report if the array is
> incompatible with the OROM.
Yes, I think that it is enough to give the information about the OROM compatibility for a volume (bootable, and visible) in --examine and --detail.
In that case we need to scan all disks attached to the controller of the disk in the volume to "--examine".

> 
> 
> >
> > >
> > > 2/ The check_volumes_number approach feels clumsy ... there must be
> a
> > >    a better way (Assuming it is needed at all).
> > container_content handler is to check OROM capabilities and mark
> > unsupported volumes with disable bits
> > (array.state:MD_SB_BLOCK_CONTAINER_RESHAPE and MD_SB_BLOCK_VOLUME).
> > The caller function shall interpret the bits and act accordingly to
> the context (for instance block activation but display the volume
> information). I think that this restriction falls into that area.
> However, there are only a few situations when this info is really
> needed ie. When volumes are activated in various ways.
> > Therefore I thought it makes sense to pass the info if counting of
> activate volumes is really needed.
> > More straightforward option is to add another input parameters to
> container_content and change it in numerous places.
> > Do you prefer this way? Or add a specialized handler to count the
> volumes when it is needed?
> 
> Hmmm.. so the issue is that a single controller can have multiple
> separate containers (families?) with their own metadata.
> So a controller with 4 ports could have a 2-device container with a
> RAID1 and a RAID0, and a separate 2-device container with just a
> RAID10.
> 
> And maybe the controller has a limit of 3 arrays, so adding another
> array to the second pair would be an error.
A single family (container) can have up to 2 volumes. 
The limit of number of volumes is per controller. It does not matter how they are split among families.
> 
> Is that the right sort of scenario?
Yes.
> 
> So when assembling the second container we don't need to look at the
> first one, but when adding an array to the second, we do need to look
> at the first one.

I think we always need to count all volumes to be sure that activated or created volume is OROM compatible.
This is exactly the same as in creation. When a volume is created on sda, sdb and sdc, we take take the first disk controller
(because all disks must share the same controller) and count the volumes on all disks attached to the controller.
Marcin Labun

