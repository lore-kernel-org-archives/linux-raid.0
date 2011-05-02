From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/5] imsm: prepare update for level migrations reshape
Date: Mon, 2 May 2011 16:15:10 +1000
Message-ID: <20110502161510.6a226302@notabene.brown>
References: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
	<20110428220005.19632.12064.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110428220005.19632.12064.stgit@gklab-128-081.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 29 Apr 2011 00:00:05 +0200 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

		struct intel_dev *dv;
> @@ -7025,12 +7046,12 @@ static int imsm_create_metadata_update_for_reshape(
>  	struct supertype *st,
>  	struct geo_params *geo,
>  	int old_raid_disks,
> -	struct imsm_update_reshape **updatep)
> +	struct imsm_update_reshape_migration **updatep)
>  {

Why are you changing the type of 'updatep' for
imsm_create_metadata_update_for_reshape?

The subsequent code allocated memory based on the 'imsm_update_reshape'
structure, but then sets 'new_disk' entries based on the new structure.
That has got to be wrong.

Please review and fix this up.

NeilBrown

