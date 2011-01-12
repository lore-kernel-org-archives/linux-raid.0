From: NeilBrown <neilb@suse.de>
Subject: Re: 0001-md-FIX-raid5-should-accept-slot-set-by-mdadm
Date: Thu, 13 Jan 2011 08:41:12 +1100
Message-ID: <20110113084112.0f18faad@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D176E1ACEB@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176E1ACEB@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 14:49:22 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> When reshape process is invoked in mdadm, new disks are added with set slot information.
> raid5_start_reshape() should count devices with slot set as spares when slot is set outside array.
> Those disks has to be added to array for reshape process also.
> 
> Changes allows to accept spares with slot set to raid5 configuration.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>  drivers/md/raid5.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc574f3..fa2b085 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5528,8 +5528,9 @@ static int raid5_start_reshape(mddev_t *mddev)
>  		return -ENOSPC;
>  
>  	list_for_each_entry(rdev, &mddev->disks, same_set)
> -		if (rdev->raid_disk < 0 &&
> -		    !test_bit(Faulty, &rdev->flags))
> +		if (((rdev->raid_disk < 0) ||
> +		    ((mddev->raid_disks -1 -mddev->degraded) < rdev->raid_disk)) &&
> +		      !test_bit(Faulty, &rdev->flags))
>  			spares++;
>  
>  	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
> @@ -5574,8 +5575,9 @@ static int raid5_start_reshape(mddev_t *mddev)
>  	 */
>  	if (mddev->delta_disks >= 0)
>  	    list_for_each_entry(rdev, &mddev->disks, same_set)
> -		if (rdev->raid_disk < 0 &&
> -		    !test_bit(Faulty, &rdev->flags)) {
> +		if (((rdev->raid_disk < 0) ||
> +		    ((mddev->raid_disks -1 -mddev->degraded) < rdev->raid_disk)) &&
> +		      !test_bit(Faulty, &rdev->flags)) {
>  			if (raid5_add_disk(mddev, rdev) == 0) {
>  				char nm[20];
>  				if (rdev->raid_disk >= conf->previous_raid_disks) {


I found the same issue and fixed it with this:

http://neil.brown.name/git?p=md;a=commitdiff;h=f50181a05893d9bc7f2804c7e0fcb888feb34126


Thanks,
NeilBrown

From: NeilBrown <neilb@suse.de>
Date: Wed, 12 Jan 2011 04:41:55 +0000 (+1100)
Subject: md/raid5: handle manually-added spares in start_reshape.
X-Git-Url: http://neil.brown.name/git?p=md;a=commitdiff_plain;h=f50181a05893d9bc7f2804c7e0fcb888feb34126

md/raid5: handle manually-added spares in start_reshape.

It is possible to manually add spares to specific slots before
starting a reshape.
raid5_start_reshape should recognised this possibility and include
it in the accounting.

Signed-off-by: NeilBrown <neilb@suse.de>
---

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
