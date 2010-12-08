From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] IMSM: Fix problem in mdmon monitor of using removed
 disk from in imsm container.
Date: Wed, 8 Dec 2010 13:29:42 +1100
Message-ID: <20101208132942.1a59efb1@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17676E3B8@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17676E3B8@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Tue, 7 Dec 2010 16:07:35 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> >From 4bd19fb7b8a4258bf6cf34288be635bdb9af3dbe Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Wed, 30 Nov 2010 03:55:18 +0100
> Subject: [PATCH 1/2] IMSM: Fix problem in mdmon monitor of using removed disk from in imsm container.
> 
> Manager thread shall pass the information to monitor thread (mdmon)
> that some devices are removed from container. Otherwise, monitor (mdmon)
> might use such devices (spares) to rebuild the array that has gone degraded.
> 
> This problem happens for imsm containers, since a list of the container disks
> is maintained in intel_super structure. When array goes degraded, the list is
> searched to find a spare disks to start rebuild.
> Without this fix the rebuild could be stared on the spare device that was
> a member of the container, but has been removed from it.
> 
> New super type function handler has been introduced to prepare metadata
> format specific information about removed devices.
> int (*remove_from_super)(struct supertype *st, mdu_disk_info_t *dinfo,
>                          int fd);
> The message prepared in remove_from_super is later processed
> by proceess_update handler in monitor thread.

I don't like this.  There is unnecessary complexity.

adding a disk and removing a disk are very different sorts of operations.
When adding a disk, you need to pass extra information about how the disk
might be used - whether it is already part of the array, or if it is a fresh
spare or whatever.
When removing a device there is none of that.  Just remove the device.

So when mdadm removes a device from a container it should
  - get a lock so mdmon won't assign the device as spare
  - check that the device is still a spare
  - remove the device from the container
  - unlock
  - ping mdmon

mdmon should notice that the device has gone and should update the metadata
accordingly.

So you may still need a 'remove_from_super' method, but it will not send a
metadata update request to mdmon.
Rather it will be run by mdmon when it notices the device is gone.

It is probably appropriate to pass an mdu_disk_info_t or maybe just a device
number.  I don't think there is any need to pass an 'fd'.

Does that approach seem OK to you?

Thanks,
NeilBrown


