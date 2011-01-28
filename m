From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] FIX: delta_disk can have UnSet value
Date: Fri, 28 Jan 2011 11:18:20 +1000
Message-ID: <20110128111820.6ef1852d@nbeee.brown>
References: <20110127092828.6759.86014.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110127092828.6759.86014.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 27 Jan 2011 10:28:28 +0100
Adam Kwolek <adam.kwolek@intel.com> wrote:

> Delta_disk can be set to UnSet value.
> This can a cause to pass wrong parameter to reshape_super().
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index daf310b..bc015c6 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1575,7 +1575,9 @@ int Grow_reshape(char *devname, int fd, int
> quiet, char *backup_file, 
>  		if (reshape_super(st, info.component_size,
> info.new_level, info.new_layout, info.new_chunk,
> -				  info.array.raid_disks +
> info.delta_disks,
> +				  info.delta_disks == UnSet ?
> +				     info.array.raid_disks :
> +				     info.array.raid_disks +
> info.delta_disks, backup_file, devname, quiet)) {
>  			rv = 1;
>  			goto release;

This is clearly a problem, but I think it is the wrong fix.
If delta_disks is unset, then the new raid_disks number could vary
depending on other values.
E.g. if you has a 4-disk raid5 and ask to convert it to RAID6 without
specifying the number of devices, then it should assume a 5-disk RAID6.
Your change would make it look like a 4-disk RAID6 was requested.

So I think we need to change reshape_super to take a 'delta_disks'
parameter rather than a 'raid_disks' parameter. 
Either that, or figure out the preferred default in advance.
analyse_change does that I think, but it is called later, so we cannot
really use what it produces.

I'm not sure what the best answer is just now - hopefully I'll be able
to look properly on Monday.

NeilBrown
