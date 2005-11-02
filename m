From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH md 009 of 10] Improve 'scan_mode' and rename it to 'sync_action'
Date: Wed, 2 Nov 2005 13:49:38 -0800
Message-ID: <20051102214937.GH23247@kroah.com>
References: <20051102205640.22689.patches@notabene> <1051102101555.23969@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051102101555.23969@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2005 at 09:15:55PM +1100, NeilBrown wrote:
> 
> The current sync_action for an array can be one of 
> 
>    idle  - nothing happening
>    resync - reduncancy being recalcualted
>    recover - missing device being recoverred to spare
>    check   - user initiated check of redundancy
>    repair  - like resync but user-initiated and ignores 
>              bitmap optimisation.
> 
> Each of these strings can also be written to the 'sync_action'
> file to cause that action to happen (if appropriate).
> 
> While 'sync' is not technically correct, as a recovery is *not* a 
> 'sync', I think it is the most servicable word here.  Also
> 'action' is a strong word than 'mode'.
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/md.c |   48 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 29 insertions(+), 19 deletions(-)
> 
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> --- ./drivers/md/md.c~current~	2005-11-02 17:33:34.000000000 +1100
> +++ ./drivers/md/md.c	2005-11-02 17:33:35.000000000 +1100
> @@ -1746,9 +1746,9 @@ raid_disks_show(mddev_t *mddev, char *pa
>  static struct md_sysfs_entry md_raid_disks = __ATTR_RO(raid_disks);
>  
>  static ssize_t
> -md_show_scan(mddev_t *mddev, char *page)
> +action_show(mddev_t *mddev, char *page)
>  {
> -	char *type = "none";
> +	char *type = "idle";
>  	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
>  	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery)) {
>  		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
> @@ -1765,27 +1765,37 @@ md_show_scan(mddev_t *mddev, char *page)
>  }
>  
>  static ssize_t
> -md_store_scan(mddev_t *mddev, const char *page, size_t len)
> +action_store(mddev_t *mddev, const char *page, size_t len)
>  {
> -	int canscan=0;
> +	if (!mddev->pers || !mddev->pers->sync_request)
> +		return -EINVAL;
> +
> +	if (strcmp(page, "idle")==0 || strcmp(page, "idle\n")==0) {
> +		if (mddev->sync_thread) {
> +			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +			md_unregister_thread(mddev->sync_thread);
> +			mddev->sync_thread = NULL;
> +			mddev->recovery = 0;
> +			printk("stop at %llu\n", (unsigned long long)mddev->recovery_cp);

Your printk() needs a KERN_ level.  Or is this debugging code left over?

thanks,

greg k-h
