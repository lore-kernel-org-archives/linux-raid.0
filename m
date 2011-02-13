From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: Detect raid1->raid0 takeover when comparing
 raid_disks
Date: Mon, 14 Feb 2011 10:02:52 +1100
Message-ID: <20110214100252.1bac689a@notabene.brown>
References: <20110210093043.7890.16300.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110210093043.7890.16300.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 10 Feb 2011 10:30:43 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Takeover raid1->raid0 not succeded. Kernel message is shown:
> "md/raid0:md126: too few disks (1 of 2) - aborting!"
> 
> After takeover process we have only one active disk
> (rest of raid1's disks have been removed before takeover)
> mddev->raid_disks stores initial number of disks so comparing
> mddev->raid_disks with "cnt" calculated in create_strip_zones()
> returns error.
> 
> Patch introduces fix for this- skip comparing number of disk if
> takeover is detected.
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  drivers/md/raid0.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 637a968..9255d52 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -215,7 +215,8 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
>  			smallest = rdev1;
>  		cnt++;
>  	}
> -	if (cnt != mddev->raid_disks) {
> +	/* compare number of disk if not taking over raid1 */
> +	if ((cnt != mddev->raid_disks) && (mddev->level != 1)) {
>  		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
>  		       "aborting!\n", mdname(mddev), cnt, mddev->raid_disks);
>  		goto abort;


Patch is wrong.  Just ignoring a consistency test is rarely a good
idea.

The problem is that we didn't update ->raid_disks.
I think that might have been my fault.

I have applied this patch instead.

Thanks,
NeilBrown

commit f7bee80945155ad0326916486dabc38428c6cdef
Author: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Date:   Mon Feb 14 10:01:41 2011 +1100

    md: Fix raid1->raid0 takeover
    
    Takeover raid1->raid0 not succeded. Kernel message is shown:
    "md/raid0:md126: too few disks (1 of 2) - aborting!"
    
    Problem was that we weren't updating ->raid_disks for that
    takeover, unlike all the others.
    
    Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 637a968..75671df 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -670,6 +670,7 @@ static void *raid0_takeover_raid1(mddev_t *mddev)
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = 128; /* by default set chunk size to 64k */
 	mddev->delta_disks = 1 - mddev->raid_disks;
+	mddev->raid_disks = 1;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
 
