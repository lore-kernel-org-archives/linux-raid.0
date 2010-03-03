From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Raid1 backup solution.
Date: Wed, 03 Mar 2010 11:59:28 +0100
Message-ID: <87k4ttllgv.fsf@frosties.localdomain>
References: <1267523407.5869.1181.camel@localhost.localdomain>
	<20100302212202.061ffba1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100302212202.061ffba1@notabene.brown> (Neil Brown's message of
	"Tue, 2 Mar 2010 21:22:02 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Tue, 02 Mar 2010 22:50:07 +1300
> Daniel Reurich <daniel@centurion.net.nz> wrote:
>
>> Hi Guys.
>> 
>> I'm considering implementing a rotating offsite backup solution using
>> raid 1.  This solution uses 1 or more internal drives and 2 external
>> e-sata harddrives.  The raid setup would be a whole disk partitionable
>> raid1 volume.
>> 
>> The idea is that by swapping the external drives,  I can have a
>> boot-able ready to run offsite backup of the machine, as well as
>> redundancy on the machine itself.  Backups of the important data would
>> be replicated via an incremental daily backup process onto the raid
>> volume itself.  
>> 
>> The part that concerns me is how to get a clean removal of the drive
>> being swapped out, and how will the raid handle having a stale drive
>> inserted/re-added.
>> 
>> I have been considering a couple of ways to handle this:
>> 
>> 1) Power the machine down to swap the drives.  This has the advantage
>> that the backup is always in a clean bootable state with filesystem
>> consistency pretty much guaranteed.
>> 
>> 2) Use mdadm to fail and remove the drives, and then re-add the newly
>> attached stale drive.  (Perhaps a udev rule could be made handle the
>> re-add).  The disadvantage is this will potentially leave the backup in
>> an inconsistent and possibly un-bootable state unless there is a way to
>> quiesce and sync disk activity before the removal.  It will also mark
>> the drive as failed and require     It's advantage is that the machine
>> doesn't need to be turned off.
>
> How could it fail to boot?
>
> If your machine crashes, it still boots - right?
> So if you fail the drive at any random time, then it is like a crash, and
> should still boot.
>
> I would:
>   sync ; sync; mdadm /dev/mdX -f /dev/whatever
>   unplug the device
>   mdadm /dev/mdX --remove detached

You can improve on that with lvm and suspending the filesystems. That
ensures that nothing starts just between the sysnc and --fail. But if
you want to suspend / too (in case it isn't read-only) you will need an
tmpfs or ramdisk holding everything needed to suspend and fail the disk.

Having / and /usr read-only will basically garanty a bootable system
alraedy so suspending might be overkill.

> Also, if you want two rotating backups I would create two stacked raid1s.
>
> mdadm -C /dev/md0 -l1 -n2 -b internal  /dev/main-device /dev/first-backup
> mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 /dev/second-backup
> mkfs -j /dev/md1
>
> Then when you add either device back in, it will just resync the bits that
> have changed since that device was last attached.  Make sure you add the
> device to the correct array of course.
>
> NeilBrown

MfG
        Goswin
