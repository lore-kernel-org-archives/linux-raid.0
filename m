From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 08/13] FIX/WORKAROUND: added disks are not used by
 reshape process /md/
Date: Wed, 12 Jan 2011 15:39:18 +1100
Message-ID: <20110112153918.078ce82c@notabene.brown>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112832.10776.61385.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110112832.10776.61385.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 10 Jan 2011 12:28:32 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> md runs reshape but added disk is not touched
> /proc/mdstat reports that disk is used.
> 
> To fix this let md to set slot for reshape.
> It is possible that slot verification mechanism has to be added.
> 
> Second possibility is to investigate problem in md.
> md/raid5 treats disks as spare with disk index == -1 during raid5 reshape_start.
> Probably rqaid5 should treat as spare disks when disk index > used disks
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 0efa106..6b2889e 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1697,6 +1697,7 @@ static int reshape_array(char *container, int fd, char *devname,
>  					/* This is a spare that wants to
>  					 * be part of the array.
>  					 */
> +					d->disk.raid_disk = -1;
>  					add_disk(fd, st, info2, d);
>  				}
>  			}

We really should fix md.
I think the following might help.  I'll try testing at some stage, but if you
could let me know if it helps, that would be great.

NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d223a6c..5044bab 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5527,8 +5527,8 @@ static int raid5_start_reshape(mddev_t *mddev)
 		return -ENOSPC;
 
 	list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk < 0 &&
-		    !test_bit(Faulty, &rdev->flags))
+		if ((rdev->raid_disk < 0 || rdev->raid_disk >= conf->raid_disks)
+		     && !test_bit(Faulty, &rdev->flags))
 			spares++;
 
 	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
@@ -5588,6 +5588,11 @@ static int raid5_start_reshape(mddev_t *mddev)
 					/* Failure here is OK */;
 			} else
 				break;
+		} else if (rdev->raid_disk >= conf->previous_raid_disks
+			   && !test_bit(Faulty, &rdev->flags)) {
+			/* This is a spare that was manually added */
+			set_bit(In_sync, &rdev->flags);
+			added_devices++;
 		}
 
 	/* When a reshape changes the number of devices, ->degraded
