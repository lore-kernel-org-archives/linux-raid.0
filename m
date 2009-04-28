From: Neil Brown <neilb@suse.de>
Subject: Re: array_state_store: 'inactive' versus 'clean' race
Date: Tue, 28 Apr 2009 14:16:30 +1000
Message-ID: <18934.33566.354244.217291@notabene.brown>
References: <1240881843.30002.42.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday April 27
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday April 27, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> I am debugging what appears to be a race between mdadm and mdmon
> manipulating md/array_state. The following warnings were originally
> triggered by the validation team in Poland.  I was not able to reproduce
> it on my development system until I modified mdmon to hammer on
> array_state and can now produce the same failure signature:
> 
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x35/0x3d()
> Hardware name:
> sysfs: duplicate filename 'sync_action' can not be created
> Modules linked in: raid10...
...
> 
> mdadm in another thread has just finished writing 'inactive' to
> array_state which will have the effect of setting mddev->pers to NULL.
> mdmon is still managing the array and before noticing the 'inactive'
> state writes 'clean' as part of its normal operation.  The
> array_state_store() call for mdmon notices that mddev->pers is not set
> and calls do_md_run().
> 
> Is it the case that we only need array_state_store() to call do_md_run()
> when performing initial assembly?  If so it seems a flag is needed to
> prevent reactivation before the old sysfs context is destroyed.

The problem seems to be that mdmon is saying "this was 'active' but now
it is 'clean'", but because 'inactive' was written by mdadm, md thinks
that mdmon is saying "this was inactive but should now be 'clean'",
which is a very different thing to say.

We are using 'array_state' as a means of communicating between mdadm
and mdmon (to say "this array is active, clear it up"), and between
mdmon and the kernel (to do the clean/active transition).  It isn't
hard to see that this can cause confusion.

What to do?

- we could use a different mechanism to tell mdmon to stop the array,
  but that feel clumsy...
- mdadm could 'clear' the array instead of just setting it 'inactive' -
  then marking it 'clean' would fail.  But then mdmon would not be
  able to extract the resync_start information, which is not ideal.
- we could arrange that 'inactive' leaves the array in some state where
  'clean' is not sufficient to reactivate it, which is essentially 
  your suggestion.  e.g. we could clear the 'level' or 'raid_disks'.
  These would work, but again feel clumsy.
- We could add an extra stage to the transition:
   - mdadm writes 'clean', then syncs with mdmon
   - mdadm writes 'inactive',
   - mdmon notices, cleans up, and writes 'clear'.
  This would avoid the current race, but there is nothing to stop
  mdmon restoring the array to 'active' is there is write activity.
  If there is, then something is accessing the array, to setting to
  inactive would fail.
  So maybe mdadm could set to readonly, sync with mdmon, then set to
  inactive.  This would probably work...
  Currently you cannot set an array to readonly if it is active.  I
  don't like that and might get the courage to change it one day.
  So we wouldn't be able to depend on that.
  So setting to readonly when you really mean "test if the array is 
  unused and if so, stop it", isn't quite write as it might one day
  cause error to write requests.
  We could transition through read_auto instead.  But read_auto
  can spontaneously change to active (through write_pending)
  so we could still race with that.
- Maybe.... we could change the rules so that "active->inactive" was 
  not permitted.  It had to go through 'clean', 'readonly', or 'read_auto'
  first.
  Then mdadm could
    set array to 'clean'
    sync with mdmon (ping_monitor)
    set to 'inactive'.
  If the last step fails, then the array is clearly still active.
  If we were to do this we would need to think about whether any other
  transitions needed to be outlawed.
- We could go the other way and never allow inactive->clean
  transitions.  Require them to go through readonly or readauto.  I
  don't think that would be an improvement.


So I'm leaning towards:
  - a kernel change so that you can only set 'inactive' if the
    array is already clean or readonly.
    i.e. if (mddev->ro || mddev->in_sync)
    which possible is the same as simply
         if (mddev->in_sync)
  - an mdadm change so that is doesn't just set 'inactive'
    but rather
         sysfs_set_str(mdi, NULL, "array_state", "clean");
	 ping_monitor(mdi->text_version);
	 sysfs_set_str(mdi, NULL, "array_state", "inactive")
  - make sure that if mdmon sees the array as 'clean', it will
    update it's metadata etc so that it feels no further urge
    to mark the array clean.

Also, we need to fix the WARNING, which I think means moving
		list_for_each_entry(rdev, &mddev->disks, same_set)
			if (rdev->raid_disk >= 0) {
				char nm[20];
				sprintf(nm, "rd%d", rdev->raid_disk);
				sysfs_remove_link(&mddev->kobj, nm);
			}

in do_md_stop up in to the
		case 0: /* disassemble */
		case 2: /* stop */

section.

My one concern about this conclusion is that it seems to sidestep the
core problem rather than address it.
The core problem is that setting the state to 'clean' means very
different thing depending on which side you come from, so an app which
writes 'clean' might get more than it bargained for.  All I'm doing is
making that confusion avoidable rather than impossible....

I guess I could invent a syntax:
 writing "a->b" to array_state sets the state to 'b' but only if it
 was already in 'a'.
But that feels needlessly complex.

So:  do you agree with my leaning?  or my concern?  or both or neither?

Thanks,
NeilBrown
