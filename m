From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Raid1 backup solution.
Date: Tue, 02 Mar 2010 22:50:07 +1300
Message-ID: <1267523407.5869.1181.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Guys.

I'm considering implementing a rotating offsite backup solution using
raid 1.  This solution uses 1 or more internal drives and 2 external
e-sata harddrives.  The raid setup would be a whole disk partitionable
raid1 volume.

The idea is that by swapping the external drives,  I can have a
boot-able ready to run offsite backup of the machine, as well as
redundancy on the machine itself.  Backups of the important data would
be replicated via an incremental daily backup process onto the raid
volume itself.  

The part that concerns me is how to get a clean removal of the drive
being swapped out, and how will the raid handle having a stale drive
inserted/re-added.

I have been considering a couple of ways to handle this:

1) Power the machine down to swap the drives.  This has the advantage
that the backup is always in a clean bootable state with filesystem
consistency pretty much guaranteed.

2) Use mdadm to fail and remove the drives, and then re-add the newly
attached stale drive.  (Perhaps a udev rule could be made handle the
re-add).  The disadvantage is this will potentially leave the backup in
an inconsistent and possibly un-bootable state unless there is a way to
quiesce and sync disk activity before the removal.  It will also mark
the drive as failed and require     It's advantage is that the machine
doesn't need to be turned off.

3) Hot pull the drive e-sata cable, then power down the drive.  This is
likely to leave the filesystems in really nasty state if there just
happens to be a write going on at the time.

My preference is for option 2 as option 1 may not always be feasible due
to the downtime, but I'm wondering about how best to handle the re-add,
as I suspect that the metadata on the failed then removed drive, would
make it more difficult to re-add the drive into the array.

If option 1 was used (cold swap), how would md handle assembly with the
stale but not failed member disk?  Would it simply force a resync, or
would it fail the disk and require manual intervention to re-add it.

Any thoughts on my hair brained scheme would be appreciated.

Daniel Reurich.

