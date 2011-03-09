From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Make OLCE workeable
Date: Wed, 9 Mar 2011 18:56:10 +1100
Message-ID: <20110309185610.789d2c99@notabene.brown>
References: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
	<20110309115312.37a04ad7@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17A8AEF75@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17A8AEF75@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Wed, 9 Mar 2011 07:45:07 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> > 
> > >
> > > 2.On the begin of reshape_array() array structure is read from md (via
> > ioctrl). Md knows nothing about raid4 working level, so spares_needed is
> > wrongly computed
> > >   Resolution: use info->array.raid_disks instead array.raid_disks to
> > compute  spares_needed.
> > 
> > md certainly should know about RAID4 working level because it is
> > assembled
> > as RAID4.... hopefully some testing will show me what you really mean.
> 
> 
> 
> During assembly - yes, but for regular reshape start no. 
> Regular reshape start:
> 1. md knows raid0
> 2. metadata reports raid4 (metadata has reshape_active == 1 already)
> 
> Reshape restart
> 1. md knows raid4
> 2. metadata reports raid4

The difference was between a container reshape and a single array reshape.


> 
> 
> > 
> > > 3.Analyse_changes() delta_parity concept doesn't match information
> > currently metadata reports. Result of this is wrongly computed
> > reshape.after.data_disks field.
> > >   Resolution: do not use delta_parity, base on information from
> > metadata handle
> > 
> > You cannot just remove delta_parity like that.  It is needed when we
> > start
> > a growth.  Maybe it is confusing when we restart a growth - I will look
> > in to in.
> 
> It looks for me that when metadata handler takes responsibility for reporting
> Different raid level and increasing raid disks by 'delta parity' we should not 
> Count delta parity in different place. 
> If you think that analyse_change() should support both cases:
> 1. reshape handler increases raid_disks by delta parity
> 2. reshape handler doesn't increase raid_disks by delta parity
> 
> I'll fix analyse_changes() for this.
> 


Before you do, have a look at the changes I just pushed out.

With those, most of the tests pass - maybe all of them, I'm not sure.


Thanks,
NeilBrown

