From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant
 sub-array with failed disks is present
Date: Wed, 8 Dec 2010 14:48:51 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17676EB3F@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D17676E3C3@irsmsx503.ger.corp.intel.com>
 <20101208133208.0f62b900@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101208133208.0f62b900@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

> > disk from container to let the process of rebuilding the array with
> failed
> > member. If the disk is physically pulled out of the system, the disk
> is removed
> > from container automatically by exiting udev rules.
> 
> This mostly makes sense, though...
> 
> >
> > +	/*
> > +	 * If there are any failed disks check state of the other volume.
> > +	 * Block rebuild if the other one is failed until failed disks
> > +	 * are removed from container.
> > +	 */
> 
> This comment was a lot clearer to me that the description at the top :-
> )

OK, I will add this remark at the top of patch description.

> 
> However:
> > +	if (failed) {
> > +		dprintf("found failed disks in %s, check if there is
> another"
> > +			"sub-array\n",
> > +			dev->volume);
> > +		/* check the state of the other volume allows for rebuild
> */
> > +		allowed = imsm_rebuild_allowed(a, (inst == 0) ? 1 : 0,
> failed);
> 
>                                                    ^^^^^^^^^^^^^^^^^^
> 
> This seems to imply that there are only ever at most 2 volumes in a
> container.  Is that really true?  The rest of the code seems to assume
> that
> there could be several.


There are at most two sub-array in one array. 

This patch is based on the previous one, as it checks the state of DISK_REMOVED. 
Thanks for comments,
Marcin

