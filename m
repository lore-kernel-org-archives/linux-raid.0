From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/5] FIX: set delta_disks to 0 for raid5->raid0
 transition
Date: Tue, 15 Feb 2011 11:32:06 +1100
Message-ID: <20110215113206.4677e95d@notabene.brown>
References: <20110214130213.8540.57401.stgit@gklab-128-013.igk.intel.com>
	<20110214131249.8540.73388.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214131249.8540.73388.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 14:12:49 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> We have to set proper value of delta_disks to avoid it wrongly being set
> when it value remains UnSet for this level transition (Grow.c:1224).
> 
> This causes too small value set to "raid_disks" in sysfs
> and reshape raid5->raid0 fails.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 424d489..dba2825 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1073,6 +1073,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
>  		switch (info->new_level) {
>  		case 0:
>  			delta_parity = -1;
> +			info->delta_disks = 0;
>  		case 4:
>  			re->level = info->array.level;
>  			re->before.data_disks = info->array.raid_disks - 1;

I think we have different expectations about what a RAID5 -> RAID0 transition
means.

To me, it means getting rid of the parity information.  So a 4-device RAID5
is converted to a 3-device RAID0 and stays the same size.

I think you want it to maintain the same number of devices, so a 4-device
RAID5 becomes a 4-device RAID0 and thus has larger storage.

If you want that, you need to say:
   mdadm -G /dev/md/xxx --level=0 --raid-disks=4

I'd be happy with functionality to do:

   mdadm -G /dev/md/xxx --level=0 --raid-disks=nochange

or something like that so it could be easily scripted easily, but I want the
default to do the simplest possible change.

Am I correct about your expectations?

Thanks,
NeilBrown

