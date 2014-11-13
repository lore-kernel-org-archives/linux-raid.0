From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Thu, 13 Nov 2014 09:05:49 -0500
Message-ID: <20141113090549.296a13ee@jlaw-desktop.mno.stratus.com>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
	<20141029084113.57f6ae6a@notabene.brown>
	<20141029133604.59f9549a@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141029133604.59f9549a@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

On Wed, 29 Oct 2014 13:36:04 -0400
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> On Wed, 29 Oct 2014 08:41:13 +1100
> NeilBrown <neilb@suse.de> wrote:
> 
> > On Mon, 27 Oct 2014 16:27:48 -0400 Joe Lawrence <joe.lawrence@stratus.com>
> > wrote:
> > 
> > > Hi Neil,
> > > 
> > > We've encountered changes in MD and mdadm that have broken our automated
> > > disk removal script.  In the past, we've been able to run the following
> > > after a RAID1 disk component removal:
> > > 
> > > % echo fail > /sys/block/md3/md/dev-sdr5/state
> > > % echo remove > /sys/block/md3/md/dev-sdr5/state
> > > 
> > > However, the latest RHEL6.6 code drop has rebased to sufficiently recent
> > > MD kernel and mdadm changes, in which the previous commands occasionally
> > > fail like so:
> > > 
> > > * MD array is usually resyncing or checking
> > > * Component disk /dev/sdr removed via HBA sysfs PCI removal
> > > * Following UDEV rule fires:
> > > 
> > > SUBSYSTEM=="block", ACTION=="remove", ENV{ID_PATH}=="?*", \
> > >         RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
> > > 
> > > % mdadm --detail /dev/md3
> > > /dev/md3:
> > >         Version : 1.1
> > >   Creation Time : Tue Oct 14 17:31:59 2014
> > >      Raid Level : raid1
> > >      Array Size : 25149440 (23.98 GiB 25.75 GB)
> > >   Used Dev Size : 25149440 (23.98 GiB 25.75 GB)
> > >    Raid Devices : 2
> > >   Total Devices : 2
> > >     Persistence : Superblock is persistent
> > > 
> > >   Intent Bitmap : Internal
> > > 
> > >     Update Time : Wed Oct 15 14:22:34 2014
> > >           State : active, degraded
> > >  Active Devices : 1
> > > Working Devices : 1
> > >  Failed Devices : 1
> > >   Spare Devices : 0
> > > 
> > >            Name : localhost.localdomain:3
> > >            UUID : 40ed68ee:ba41d4cd:28c361ed:be7470b8
> > >          Events : 142
> > > 
> > >     Number   Major   Minor   RaidDevice State
> > >        0      65       21        0      faulty
> > >        1      65        5        1      active sync   /dev/sdj5
> > > 
> > > All attempts to remove this device fail: 
> > > 
> > > % echo remove > /sys/block/md3/md/dev-sdr5/state
> > > -bash: echo: write error: Device or resource busy
> > > 
> > > This can be traced to state_store():
> > > 
> > >         } else if (cmd_match(buf, "remove")) {
> > >                 if (rdev->raid_disk >= 0)
> > >                         err = -EBUSY;
> > > 
> > > After much debugging and systemtapping, I think I've figured out that the
> > > sysfs scripting may fail after the following combination of changes:
> > > 
> > > mdadm  8af530b07fce "Enhance incremental removal."
> > > kernel 30b8feb730f9 "md/raid5: avoid deadlock when raid5 array has unack
> > >                      badblocks during md_stop_writes"
> > > 
> > > With these two changes:
> > > 
> > > 1 - On the user side, mdadm is trying to set the array_state to read-auto
> > >     on incremental removal (as invoked by UDEV rule). 
> > > 
> > > 2 - Kernel side, md_set_readonly() will set the MD_RECOVERY_FROZEN flag,
> > >     wake up the mddev->thread and if there is a sync_thread, it will set
> > >     MD_RECOVERY_INTR and then wait until the sync_thread is set to NULL.
> > > 
> > >     When md_check_recovery() gets a chance to run as part of the
> > >     raid1d() mddev->thread, it may or may not ever get to
> > >     an invocation of remove_and_add_spares(), for there are but *many*
> > >     conditional early exits along the way -- for example, if
> > >     MD_RECOVERY_FROZEN is set, the following condition will bounce out of
> > >     the routine:
> > > 
> > >                 if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> > >                     test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))             
> > >                         goto unlock;
> > > 
> > >     the next time around, MD_RECOVERY_NEEDED will have been cleared, so
> > >     all future tests will return 0 and the negation will always take the
> > >     early exit path.
> > > 
> > >     Back in md_set_readonly(), it may notice that the MD is still in use,
> > >     so it clears the MD_RECOVERY_FROZEN and then returns -EBUSY, without
> > >     setting mddev->ro.  But the damage has been done as conditions have
> > >     been set such that md_check_recovery() will never call
> > >     remove_and_add_spares().
> > > 
> > > This would also explain why an "idle" sync_action clears the wedge: it
> > > sets MD_RECOVERY_NEEDED allowing md_check_recovery() to continue executing
> > > to remove_and_add_spares().
> > > 
> > > As far as I can tell, this is what is happening to prevent the "remove"
> > > write to /sys/block/md3/md/dev-sdr5/state from succeeding.  There are
> > > certainly a lot of little bit-states between disk removal, UDEV mdadm, and
> > > various MD kernel threads, so apologies if I missed an important
> > > transition.
> > > 
> > > Would you consider writing "idle" to the MD array sync_action file as a
> > > safe and reasonable intermediate workaround step for our script?
> > > 
> > > And of course, any suggestions to whether this is intended behavior (ie,
> > > the removed component disk is failed, but stuck in the array)?
> > > 
> > > This is fairly easy for us to reproduce with multiple MD arrays per disk
> > > (one per partition) and interrupting a raid check on all of them
> > > (especially when they are delayed waiting for the first to finish) by
> > > removing the component disk via sysfs PCI removal.  We can provide
> > > additional debug or testing if required.
> > > 
> > 
> > Hi Joe,
> >  thanks for the details analysis!!
> > 
> > I think the correct fix would be that MD_RECOVERY_NEEDED should be set after
> > clearing MD_RECOVERY_FROZEN, like the patch below.
> > Can you confirm that it works for you?
> > 
> > Writing 'idle' should in general be safe, so that could be used as an interim.
> > 
> > Thanks,
> > NeilBrown
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index c03d87b6890a..2c73fcb82593 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5261,6 +5261,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
> >  		printk("md: %s still in use.\n",mdname(mddev));
> >  		if (did_freeze) {
> >  			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> > +			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >  			md_wakeup_thread(mddev->thread);
> >  		}
> >  		err = -EBUSY;
> > @@ -5275,6 +5276,8 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
> >  		mddev->ro = 1;
> >  		set_disk_ro(mddev->gendisk, 1);
> >  		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> > +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > +		md_wakeup_thread(mddev->thread);
> >  		sysfs_notify_dirent_safe(mddev->sysfs_state);
> >  		err = 0;
> >  	}
> > @@ -5318,6 +5321,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
> >  		mutex_unlock(&mddev->open_mutex);
> >  		if (did_freeze) {
> >  			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> > +			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >  			md_wakeup_thread(mddev->thread);
> >  		}
> >  		return -EBUSY;
> 
> Hi Neil,
> 
> In my tests, the UDEV "mdadm -If" invocation fails *and* removes the
> pulled disk from the MD array.  This is okay for our intentions, but I
> wanted to make sure that it's okay to skip any failed-but-not-removed
> state.
> 
> Tested-by: Joe Lawrence <joe.lawrence@stratus.com>
> 
> and should this have a
> 
> Fixes: 30b8feb730f9 ("md/raid5: avoid deadlock when raid5 array has unack badblocks during md_stop_writes")
> 
> tag to mark for stable?


Hi Neil,

Would you like me to write up a proper patch, or is this one in the queue?

Thanks,

-- Joe
