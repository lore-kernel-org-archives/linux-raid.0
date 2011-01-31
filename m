From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: do not write resync checkpoint, if max_sector has
 been reached.
Date: Mon, 31 Jan 2011 13:45:57 +1100
Message-ID: <20110131134557.653a1db0@notabene.brown>
References: <20110127165015.7884.8099.stgit@gklab-128-080.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110127165015.7884.8099.stgit@gklab-128-080.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 27 Jan 2011 17:50:15 +0100 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> If disk fails during resync, sync service of personality usually skips the
> rest of not synchronized stripes. It finishes sync thread (md_do_sync())
> and wakes up the main raid thread. md_recovery_check() starts and
> unregisteres sync thread.
> In the meanwhile mdmon also services failed disk - removes and replaces it
> with a new one (if it was available).
> If checkpoint is stored (with value of array's max_sector), next
> md_recovery_check() will restart resync. It finishes normally and
> activates ALL spares (including the one added recently) what is wrong.
> Another md_recovery_check() will not start recovery as all disks are in
> sync. If checkpoint is not stored, second resync does not start and
> recovery can proceed.
> 
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>  drivers/md/md.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3e40aad..6eda858 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6929,7 +6929,8 @@ void md_do_sync(mddev_t *mddev)
>  	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
>  	    mddev->curr_resync > 2) {
>  		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
> -			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> +			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> +			    mddev->curr_resync < max_sectors) {
>  				if (mddev->curr_resync >= mddev->recovery_cp) {
>  					printk(KERN_INFO
>  					       "md: checkpointing %s of %s.\n",
> 

This is wrong.  If curr_resync has reached some value, then the array *is*
in-sync up to that point.

If a device fails then that often makes the array fully in-sync - because
there it no longer any room for inconsistency.
This is particularly true for RAID1.  If one drive in a 2-drive RAID1 fails,
then the array instantly becomes in-sync.
For RAID5, we should arguably fail the array at that point rather than
marking it in-sync, but that would probably cause more data loss than it
avoids, so we don't.
In any case - the array is now in-sync.

If a spare is added by mdmon at this time, then the array is not 'out of
sync', it is 'in need for recovery'.  'recovery' and 'resync' are different
things.

md_check_recovery should run remove_and_add_spares are this point.  That
should return a non-zero value (because it found the spare that mdmon added)
and  should then start a recovery pass which will ignore recovery_cp (which
is a really badly chosen variable name - it should be 'resync_cp', not
'recovery_cp'.

So if you are experiencing a problem where mdmon adds a spare and appears to
get recovered instantly, (which is what you seem to be saying) then the
problem is else-where.
If you can reproduce it, then it would help to put some tracing in
md_check_recovery, particularly reporting the return value of
remove_and_add_spares, and the value that is finally chosen for
mddev->recovery.

Thanks,
NeilBrown
