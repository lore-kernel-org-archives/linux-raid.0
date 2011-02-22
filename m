From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] set default chunk in validate_geometry
Date: Tue, 22 Feb 2011 11:25:28 +1100
Message-ID: <20110222112528.074589d5@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F011197D8D5@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F011197D8D5@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 21 Feb 2011 10:09:37 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 33fa2700b9911b0815112b223a4df7b1f1716659 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Mon, 21 Feb 2011 10:24:26 +0100
> Subject: [PATCH] set default chunk in validate_geometry
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> When chunk size is not set from command line we need to guess it
> depending on metadata given on command line or found on listed devices.
> 
> Validate_geometry sets the default for it's metadata if chunk is not set.
> For external metadata chunk is set only when creating in a container.
> For imsm validate_geometry_imsm_orom is responsible for finding default
> chunk depending on container metadata loaded. Container will already know
> which controller it is attached to, and have this controllers orom
> available.
> do_default_chunk indicates that we need to find default chunk and
> if validate_geometry fails for some metadata it tells us to reset chunk
> that may have been set.
> 
> Current solution would set default chunk correctly for imsm only if
> container device was given on command line. With the list of devices
> chunk was always set to 512.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>

Thanks for this Anna.

Applied.

NeilBrown

