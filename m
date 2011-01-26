From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/6] FIX: Remove disks in mdmon for external metadata
Date: Wed, 26 Jan 2011 11:04:29 +1000
Message-ID: <20110126110429.144b9aab@nbeee.brown>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
	<20110119162333.8738.79313.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119162333.8738.79313.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 17:23:33 +0100
Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:

> For raid10 -> raid0 takeover operation we shoud reject disks
> in mirror by mark them as 'failed' and then remove them from
> array.
> For external metadata second action should be execuded by
> mdmon so additional condition is necessary.

I don't understand this..
I think you are saying that removing failed devices should be done by
mdmon rather than mdadm.  Is that what you are saying?
I don't think that is correct.  WHY do you want to make this change?
What is not working that should.

NeilBrown

> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  Grow.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 78d5b0e..c5f83a8 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -711,7 +711,9 @@ int
> remove_disks_on_raid10_to_raid0_takeover(struct supertype *st, 
>  		sysfs_set_str(sra, sd, "state", "faulty");
>  		sysfs_set_str(sra, sd, "slot", "none");
> -		sysfs_set_str(sra, sd, "state", "remove");
> +		/* for external metadata disks should be removed in
> mdmon */
> +		if (!st->ss->external)
> +			sysfs_set_str(sra, sd, "state", "remove");
>  		sd->disk.state |= (1<<MD_DISK_REMOVED);
>  		sd->disk.state &= ~(1<<MD_DISK_SYNC);
>  		sd->next = sra->devs;

