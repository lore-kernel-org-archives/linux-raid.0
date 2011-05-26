From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: creating degraded raid1 with imsm metadata
Date: Thu, 26 May 2011 09:40:16 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D50490856E0F@azsmsx504.amr.corp.intel.com>
References: <20110526074259.GA31623@r00t3d.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110526074259.GA31623@r00t3d.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: FDi <fld@r00t3d.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of FDi
> Sent: Thursday, May 26, 2011 12:43 AM
> To: linux-raid@vger.kernel.org
> Subject: creating degraded raid1 with imsm metadata
> 
> Hello *,
> 
> Since Intel's Matrix Storage Manager option ROM doesn't support creating of
> degraded arrays I was wondering if I could use mdadm to make one? I had a
> very hard time finding documentation about how mdadm is supposed to
> work with imsm.
> 
> The plan is to make a 2x1TB raid1 with one device missing and then later add
> the other disk in once all the data has been copied to the degraded array. So
> a typical raid1 migration scenario, which Intel oddly enough doesn't seem to
> support with their option ROM.

Not sure if that's possible but have you looked at the Linux RAID wiki on IMSM information?
https://raid.wiki.kernel.org/index.php/RAID_setup#External_Metadata
