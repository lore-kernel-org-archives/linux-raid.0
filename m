From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH] md: do not write resync checkpoint, if max_sector has
 been reached.
Date: Mon, 31 Jan 2011 18:48:08 +0000
Message-ID: <66C59AD0932712458090B447266D638C010C8D149A@irsmsx504.ger.corp.intel.com>
References: <20110127165015.7884.8099.stgit@gklab-128-080.igk.intel.com>
 <20110131134557.653a1db0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131134557.653a1db0@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, January 31, 2011 3:46 AM
> To: Hawrylewicz Czarnowski, Przemyslaw
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Williams, Dan J;
> Ciechanowski, Ed
> Subject: Re: [PATCH] md: do not write resync checkpoint, if max_sector has
> been reached.
> 
> On Thu, 27 Jan 2011 17:50:15 +0100 Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> 
> > If disk fails during resync, sync service of personality usually skips
> the
> > rest of not synchronized stripes. It finishes sync thread (md_do_sync())
> > and wakes up the main raid thread. md_recovery_check() starts and
> > unregisteres sync thread.
> > In the meanwhile mdmon also services failed disk - removes and replaces
> it
> > with a new one (if it was available).
> > If checkpoint is stored (with value of array's max_sector), next
> > md_recovery_check() will restart resync. It finishes normally and
> > activates ALL spares (including the one added recently) what is wrong.
> > Another md_recovery_check() will not start recovery as all disks are in
> > sync. If checkpoint is not stored, second resync does not start and
> > recovery can proceed.
> >
> > Signed-off-by: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com>
> > ---
> >  drivers/md/md.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 3e40aad..6eda858 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6929,7 +6929,8 @@ void md_do_sync(mddev_t *mddev)
> >  	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
> >  	    mddev->curr_resync > 2) {
> >  		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
> > -			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> > +			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> > +			    mddev->curr_resync < max_sectors) {
> >  				if (mddev->curr_resync >= mddev->recovery_cp) {
> >  					printk(KERN_INFO
> >  					       "md: checkpointing %s of %s.\n",
> >
> 
> This is wrong.  If curr_resync has reached some value, then the array *is*
> in-sync up to that point.
> 
> If a device fails then that often makes the array fully in-sync - because
> there it no longer any room for inconsistency.
> This is particularly true for RAID1.  If one drive in a 2-drive RAID1
> fails,
> then the array instantly becomes in-sync.
> For RAID5, we should arguably fail the array at that point rather than
> marking it in-sync, but that would probably cause more data loss than it
> avoids, so we don't.
> In any case - the array is now in-sync.
Yes, I agree. But it is not the point here, in this bug.

> 
> If a spare is added by mdmon at this time, then the array is not 'out of
> sync', it is 'in need for recovery'.  'recovery' and 'resync' are different
> things.
I fully understand the difference between recovery and resync (and reshape). 

> 
> md_check_recovery should run remove_and_add_spares are this point.  That
And it does. 

> should return a non-zero value (because it found the spare that mdmon
> added)
But the return value is wrong (it is correct according to current configuration). Please let me explain once again what's going on.

The flow is as follows:
0. resync is in progress
1. one disk fails
2. md_error() wakes up raid thread
3. md_do_sync() gets skipped=1 from mddev->pers->sync_request() and some amount of skipped sectors/stripes - usually all remaining to resync. mddev->recovery_cp is set to last sector (max_sector in md_do_sync)
3a. md_check_recovery() sees MD_RECOVERY_INTR (clears it) and unregisters recovery thread (which actually does resync)
3b. mdmon unblocks array member
4. md_check_recovery checks if some action is required. 
4a. reshape is not taken into account as reshape_position==MaxSector
4b. recovery is not taken into account as mdmon did not add spare yet
4c. resync is started, as recovery_cp!=MaxSector (!)
5. md_do_sync exists normally (gets skipped=1 from mddev->pers->sync_request()) as checkpoint pointed at the last sector; it clears mddev->recovery_cp.
6. mdmon adds disk (via slot-store())
7. md_check_recovery() does cleanup after finished resync
7a. MD_RECOVERY_INTR is not set anymore, mddev->pers->spare_active() is started and ALL devices !In_sync available in array are set in_sync, and array degradation is cleared(!).
7b. remove_and_add_spares() does not see spares available (mddev->degraded==0) so recovery does not start.

> and  should then start a recovery pass which will ignore recovery_cp (which
> is a really badly chosen variable name - it should be 'resync_cp', not
> 'recovery_cp'.
as you can see above, recovery_cp is not ignored (yes the name is confusing)

> 
> So if you are experiencing a problem where mdmon adds a spare and appears
> to
> get recovered instantly, (which is what you seem to be saying) then the
to be precise, recovery do not start at all...

> problem is else-where.

> If you can reproduce it, then it would help to put some tracing in
> md_check_recovery, particularly reporting the return value of
> remove_and_add_spares, and the value that is finally chosen for
> mddev->recovery.
if you want some logs, I have plenty:) But I think my description will suffice to understand the problem.

> 
> Thanks,
> NeilBrown

-- 
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski

