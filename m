From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: RAID1 removing failed disk returns EBUSY
Date: Mon, 27 Oct 2014 16:27:48 -0400
Message-ID: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

Hi Neil,

We've encountered changes in MD and mdadm that have broken our automated
disk removal script.  In the past, we've been able to run the following
after a RAID1 disk component removal:

% echo fail > /sys/block/md3/md/dev-sdr5/state
% echo remove > /sys/block/md3/md/dev-sdr5/state

However, the latest RHEL6.6 code drop has rebased to sufficiently recent
MD kernel and mdadm changes, in which the previous commands occasionally
fail like so:

* MD array is usually resyncing or checking
* Component disk /dev/sdr removed via HBA sysfs PCI removal
* Following UDEV rule fires:

SUBSYSTEM=="block", ACTION=="remove", ENV{ID_PATH}=="?*", \
        RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"

% mdadm --detail /dev/md3
/dev/md3:
        Version : 1.1
  Creation Time : Tue Oct 14 17:31:59 2014
     Raid Level : raid1
     Array Size : 25149440 (23.98 GiB 25.75 GB)
  Used Dev Size : 25149440 (23.98 GiB 25.75 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Oct 15 14:22:34 2014
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : localhost.localdomain:3
           UUID : 40ed68ee:ba41d4cd:28c361ed:be7470b8
         Events : 142

    Number   Major   Minor   RaidDevice State
       0      65       21        0      faulty
       1      65        5        1      active sync   /dev/sdj5

All attempts to remove this device fail: 

% echo remove > /sys/block/md3/md/dev-sdr5/state
-bash: echo: write error: Device or resource busy

This can be traced to state_store():

        } else if (cmd_match(buf, "remove")) {
                if (rdev->raid_disk >= 0)
                        err = -EBUSY;

After much debugging and systemtapping, I think I've figured out that the
sysfs scripting may fail after the following combination of changes:

mdadm  8af530b07fce "Enhance incremental removal."
kernel 30b8feb730f9 "md/raid5: avoid deadlock when raid5 array has unack
                     badblocks during md_stop_writes"

With these two changes:

1 - On the user side, mdadm is trying to set the array_state to read-auto
    on incremental removal (as invoked by UDEV rule). 

2 - Kernel side, md_set_readonly() will set the MD_RECOVERY_FROZEN flag,
    wake up the mddev->thread and if there is a sync_thread, it will set
    MD_RECOVERY_INTR and then wait until the sync_thread is set to NULL.

    When md_check_recovery() gets a chance to run as part of the
    raid1d() mddev->thread, it may or may not ever get to
    an invocation of remove_and_add_spares(), for there are but *many*
    conditional early exits along the way -- for example, if
    MD_RECOVERY_FROZEN is set, the following condition will bounce out of
    the routine:

                if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
                    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))             
                        goto unlock;

    the next time around, MD_RECOVERY_NEEDED will have been cleared, so
    all future tests will return 0 and the negation will always take the
    early exit path.

    Back in md_set_readonly(), it may notice that the MD is still in use,
    so it clears the MD_RECOVERY_FROZEN and then returns -EBUSY, without
    setting mddev->ro.  But the damage has been done as conditions have
    been set such that md_check_recovery() will never call
    remove_and_add_spares().

This would also explain why an "idle" sync_action clears the wedge: it
sets MD_RECOVERY_NEEDED allowing md_check_recovery() to continue executing
to remove_and_add_spares().

As far as I can tell, this is what is happening to prevent the "remove"
write to /sys/block/md3/md/dev-sdr5/state from succeeding.  There are
certainly a lot of little bit-states between disk removal, UDEV mdadm, and
various MD kernel threads, so apologies if I missed an important
transition.

Would you consider writing "idle" to the MD array sync_action file as a
safe and reasonable intermediate workaround step for our script?

And of course, any suggestions to whether this is intended behavior (ie,
the removed component disk is failed, but stuck in the array)?

This is fairly easy for us to reproduce with multiple MD arrays per disk
(one per partition) and interrupting a raid check on all of them
(especially when they are delayed waiting for the first to finish) by
removing the component disk via sysfs PCI removal.  We can provide
additional debug or testing if required.

Regards,

-- Joe
