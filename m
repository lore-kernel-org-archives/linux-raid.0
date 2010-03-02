From: Neil Brown <neilb@suse.de>
Subject: Re: Raid1 backup solution.
Date: Tue, 2 Mar 2010 21:22:02 +1100
Message-ID: <20100302212202.061ffba1@notabene.brown>
References: <1267523407.5869.1181.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1267523407.5869.1181.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 02 Mar 2010 22:50:07 +1300
Daniel Reurich <daniel@centurion.net.nz> wrote:

> Hi Guys.
> 
> I'm considering implementing a rotating offsite backup solution using
> raid 1.  This solution uses 1 or more internal drives and 2 external
> e-sata harddrives.  The raid setup would be a whole disk partitionable
> raid1 volume.
> 
> The idea is that by swapping the external drives,  I can have a
> boot-able ready to run offsite backup of the machine, as well as
> redundancy on the machine itself.  Backups of the important data would
> be replicated via an incremental daily backup process onto the raid
> volume itself.  
> 
> The part that concerns me is how to get a clean removal of the drive
> being swapped out, and how will the raid handle having a stale drive
> inserted/re-added.
> 
> I have been considering a couple of ways to handle this:
> 
> 1) Power the machine down to swap the drives.  This has the advantage
> that the backup is always in a clean bootable state with filesystem
> consistency pretty much guaranteed.
> 
> 2) Use mdadm to fail and remove the drives, and then re-add the newly
> attached stale drive.  (Perhaps a udev rule could be made handle the
> re-add).  The disadvantage is this will potentially leave the backup in
> an inconsistent and possibly un-bootable state unless there is a way to
> quiesce and sync disk activity before the removal.  It will also mark
> the drive as failed and require     It's advantage is that the machine
> doesn't need to be turned off.

How could it fail to boot?

If your machine crashes, it still boots - right?
So if you fail the drive at any random time, then it is like a crash, and
should still boot.

I would:
  sync ; sync; mdadm /dev/mdX -f /dev/whatever
  unplug the device
  mdadm /dev/mdX --remove detached

Also, if you want two rotating backups I would create two stacked raid1s.

mdadm -C /dev/md0 -l1 -n2 -b internal  /dev/main-device /dev/first-backup
mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 /dev/second-backup
mkfs -j /dev/md1

Then when you add either device back in, it will just resync the bits that
have changed since that device was last attached.  Make sure you add the
device to the correct array of course.

NeilBrown


> 
> 3) Hot pull the drive e-sata cable, then power down the drive.  This is
> likely to leave the filesystems in really nasty state if there just
> happens to be a write going on at the time.
> 
> My preference is for option 2 as option 1 may not always be feasible due
> to the downtime, but I'm wondering about how best to handle the re-add,
> as I suspect that the metadata on the failed then removed drive, would
> make it more difficult to re-add the drive into the array.
> 
> If option 1 was used (cold swap), how would md handle assembly with the
> stale but not failed member disk?  Would it simply force a resync, or
> would it fail the disk and require manual intervention to re-add it.
> 
> Any thoughts on my hair brained scheme would be appreciated.
> 
> Daniel Reurich.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

