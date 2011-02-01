From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH] md: do not write resync checkpoint, if max_sector has
 been reached.
Date: Tue, 1 Feb 2011 23:45:23 +0000
Message-ID: <66C59AD0932712458090B447266D638C010C91BAC9@irsmsx504.ger.corp.intel.com>
References: <20110127165015.7884.8099.stgit@gklab-128-080.igk.intel.com>
	<20110131134557.653a1db0@notabene.brown>
	<66C59AD0932712458090B447266D638C010C8D149A@irsmsx504.ger.corp.intel.com>
 <20110201120752.00a9b534@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201120752.00a9b534@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Tuesday, February 01, 2011 2:08 AM
> To: Hawrylewicz Czarnowski, Przemyslaw
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Williams, Dan J;
> Ciechanowski, Ed
> Subject: Re: [PATCH] md: do not write resync checkpoint, if max_sector has
> been reached.
> 
[cut]

> > >
> > > This is wrong.  If curr_resync has reached some value, then the array
> *is*
> > > in-sync up to that point.
> > >
> > > If a device fails then that often makes the array fully in-sync -
> because
> > > there it no longer any room for inconsistency.
> > > This is particularly true for RAID1.  If one drive in a 2-drive RAID1
> > > fails,
> > > then the array instantly becomes in-sync.
> > > For RAID5, we should arguably fail the array at that point rather than
> > > marking it in-sync, but that would probably cause more data loss than
> it
> > > avoids, so we don't.
> > > In any case - the array is now in-sync.
> > Yes, I agree. But it is not the point here, in this bug.
> >
> > >
> > > If a spare is added by mdmon at this time, then the array is not 'out
> of
> > > sync', it is 'in need for recovery'.  'recovery' and 'resync' are
> different
> > > things.
> > I fully understand the difference between recovery and resync (and
> reshape).
> >
> > >
> > > md_check_recovery should run remove_and_add_spares are this point.
> That
> > And it does.
> >
> > > should return a non-zero value (because it found the spare that mdmon
> > > added)
> > But the return value is wrong (it is correct according to current
> configuration). Please let me explain once again what's going on.
> >
> > The flow is as follows:
> > 0. resync is in progress
> > 1. one disk fails
> > 2. md_error() wakes up raid thread
> > 3. md_do_sync() gets skipped=1 from mddev->pers->sync_request() and some
> amount of skipped sectors/stripes - usually all remaining to resync. mddev-
> >recovery_cp is set to last sector (max_sector in md_do_sync)
> > 3a. md_check_recovery() sees MD_RECOVERY_INTR (clears it) and unregisters
> recovery thread (which actually does resync)
> > 3b. mdmon unblocks array member
> > 4. md_check_recovery checks if some action is required.
> > 4a. reshape is not taken into account as reshape_position==MaxSector
> > 4b. recovery is not taken into account as mdmon did not add spare yet
> > 4c. resync is started, as recovery_cp!=MaxSector (!)
> > 5. md_do_sync exists normally (gets skipped=1 from mddev->pers-
> >sync_request()) as checkpoint pointed at the last sector; it clears mddev-
> >recovery_cp.
> > 6. mdmon adds disk (via slot-store())
> > 7. md_check_recovery() does cleanup after finished resync
> > 7a. MD_RECOVERY_INTR is not set anymore, mddev->pers->spare_active() is
> started and ALL devices !In_sync available in array are set in_sync, and
> array degradation is cleared(!).
> > 7b. remove_and_add_spares() does not see spares available (mddev-
> >degraded==0) so recovery does not start.
> >
> 
> Thank you for this excellent problem description.
> 
> I think the mistake here is at step 6.
> mdmon should not be trying to add a disk until the resync has completed.
> In particular, mdmon shouldn't try, and md should not allow mdmon to
> succeed.
> 
> So slot_store should return -EBUSY if MD_RECOVERY_RUNNING is set
> 
> mdmon needs to 'know' when a sync/etc is happening, and should avoid
> processing ->check_degraded if it is.
> 
> I have added the md fix to my for-next branch.
I took a look at this change. It does no compile. It should be:

if (test_bit(MD_RECOVERY_RUNNING, &rdev->mddev->recovery)
	return -EBUSY;

> I might do the mdadm fix later.

Now (without this kernel/mdmon handshaking) there is a infinite loop in manager (it is quite well reproducible for IMSM raid5). I have noticed, that state is still "resync", mdmon continuously sends "-blocked" and manager does not add spare (because of resync). I haven't found root cause why array_state is still "resync", but at first glance after md_do_sync finishes md_check_recovery do not start.
I will make some more tests tomorrow...

Przemek
> 
> Thanks,
> NeilBrown
> 
> 
[cut]

