From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Subject: 1.X metadata: Resuming an interrupted incremental recovery for RAID1.
Date: Tue, 11 Oct 2011 20:45:25 -0400
Message-ID: <CANz0V+567wM8dfW0-3mQbWhJjNHf_j4qxH0Da9Agi9xYggAJmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi group, Neil,

I've seen the following behavior -
1) Create a RAID1 array with two devices with an internal bitmap.
2) Degrade the array.
3) Write data in the array.
4) Re-add the removed member - this start an incremental recovery.
5) Interrrupt the recovery (cause I/O failure in the just re-added
disk) - array degraded again.
6) Re-add the removed member - this starts a full recovery.

If I understand, the choice behind incremental/full is based on the
In_Sync bit, which for the two
possibilities of an interrupted recovery, namely, an "active but
recovering" disk (with a role) and "a spare prior
to role assignment" (i.e. before remove_and_add_spares is run, I
think), the In_Sync bit is never set.

It seems like it should be safe enough to resume an incremental
recovery from where it left off, after all,
the intent bitmap will still reflect the unsynchornized data, right?

How about something like the following?

1) Add another SB feature - MD_FEATURE_IN_RECOVERY.
2) MD_FEATURE_IN_RECOVERY is set in in super_1_sync if
rdev->saved_raid_disk != -1 and mddev->bitmap.
3) MD_FEATURE_IN_RECOVERY is unset in super_1_sync otherwise.
4) If MD_FEATURE_IN_RECOVERY is for the 'default' case in
super_1_validate, set the In_Sync bit, causing an
    incremental recovery to happen.

The above handles 99% (as far as I tested).

The only case left is dealing with the 'spare' transition - in which
case I also need to remember rdev->saved_raid_disk someplace
in the superblock (and restore raid_disk and the In_Sync bit in
super_1_validate as well).  If I understand correctly,
sb->resync_offset is a
safe place, since it's disregarded for a bitmapped rdev.

What do you think? Am I missing something or is there a better way of
achieving what I am trying to do? I am basically
trying to ensure that if an rdev went away during incremental
recovery, then incremental recovery will resume if it is re-added.
This
will not affect adding a 'clean' spare (it will cause a full recovery).

-- 
A
