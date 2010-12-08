From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant
 sub-array with failed disks is present
Date: Wed, 8 Dec 2010 13:32:08 +1100
Message-ID: <20101208133208.0f62b900@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17676E3C3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17676E3C3@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Tue, 7 Dec 2010 16:10:48 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> >From ee52735e3576dc998a837229ac5b9fb3ed1faeaf Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Wed, 30 Nov 2010 15:47:19 +0100
> Subject: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant sub-array with failed disks is present
> 
> Now Intel metadata handler rebuilds all sub-arrays even if one of them
> is non-redundant. In case of failed sub-array, failed disks are just replaced
> with new ones in the metadata mapping. The data for failed disk is not restored
> even the disk is present in the system. This fix requests to remove the failed
> disk from container to let the process of rebuilding the array with failed
> member. If the disk is physically pulled out of the system, the disk is removed
> from container automatically by exiting udev rules.

This mostly makes sense, though...

>  
> +	/* 
> +	 * If there are any failed disks check state of the other volume. 
> +	 * Block rebuild if the other one is failed until failed disks
> +	 * are removed from container.
> +	 */

This comment was a lot clearer to me that the description at the top :-)

However:
> +	if (failed) {
> +		dprintf("found failed disks in %s, check if there is another"
> +			"sub-array\n",
> +			dev->volume);
> +		/* check the state of the other volume allows for rebuild */
> +		allowed = imsm_rebuild_allowed(a, (inst == 0) ? 1 : 0, failed);

                                                   ^^^^^^^^^^^^^^^^^^

This seems to imply that there are only ever at most 2 volumes in a
container.  Is that really true?  The rest of the code seems to assume that
there could be several.
If there can be more than two, then you need a loop over all the 'other'
devices to check that they are allowed to rebuild.

Thanks,
NeilBrown

