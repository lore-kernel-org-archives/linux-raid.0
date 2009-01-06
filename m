From: Neil Brown <neilb@suse.de>
Subject: Re: Need urgent help in fixing raid5 array
Date: Wed, 7 Jan 2009 10:23:09 +1100
Message-ID: <18787.59357.94643.611681@notabene.brown>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com>
	<alpine.DEB.1.10.0901011039110.9903@p34.internal.lan>
	<467705.96388.qm@web30807.mail.mud.yahoo.com>
	<alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
	<344038.60917.qm@web30808.mail.mud.yahoo.com>
	<18786.34165.639790.37753@notabene.brown>
	<546794.45786.qm@web30802.mail.mud.yahoo.com>
	<879ae2ec7c5524fd9fa9841245772ab6.squirrel@neil.brown.name>
	<100979.40008.qm@web30803.mail.mud.yahoo.com>
	<780997576890f2ccd07a4486c2702e8d.squirrel@neil.brown.name>
	<654038.66009.qm@web30803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Myers on Monday January 5
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

On Monday January 5, mikesm559@yahoo.com wrote:
> Neil, the devices have moved around a bit since my post on the
> --examine results of each drive as an attempt to bypass a possibly bad
> sata backplane and known bad sata controller.  So I have to recheck
> the array positions of the drives.  A few questions about how md acts: 
> 
> 1)  When I grow an array, do the existing members of the array
>     maintain their slot positions?  So if I had 4 drives sda1 sdb1
>     sdc1 and sdd1 as part of a RAID5 array, and then add sde1, would
>     sde1 take slot 4 or the array, or do the array slots get reset
>     during a reshape operation?   

Slots do not get reset.

> 
> The reason I ask is that from the smartctl -a data for each drive, I
> can get the total powered on hours for the drive.  If the drive has
> a lot of hours on it, it will have been added earlier than another
> drive, and if the array positiosn are constant, then I can kind of
> reconstruct the array order on an array that's been built
> incrementally by look at drive power on times. 
> 
> 2) If a drive goes bad an is replaced by a spare, does the spare
>    take the orginal array slot of the faulty drive? 

With v1.x metadata you need to be careful of the difference between the
'slot' and the 'role' of each drive.

The 'slot' is an arbitrary number that is assigned when the devices is
added to the array, whether as a full member or as a spare.  It
doesn't change.
The 'role' is how the drive is functioning in the array.  When a device
is added to an array, its role is set to 'spare'.  When a drive
fails and this spare is used to recover that drive, the 'role' is
change to match the role of the original drive.  But the slot stays
the same.
If you look at the "Array Slot" line in the "mdadm --examine" output
you will see something like 
    Array Slot : 8 (0, failed, failed, failed, 3, 4, failed, 5, 6)

That means that this device occupies slot 8, and that for the whole
array:
  The device in slot 0 is being used in role 0 (first live device in array)
  The devices in slots 1,2,3 have all failed
  The device in slot 4 has role 3
  The device in slot 5 has role 4
  The device in slot 6 has failed
  The devices in slots 7 and 8 have roles 5 and 6
So this device is in role 6.
This can be confirmed by looking at the "Array State" line:
   Array State : u__uuuU 4 failed

There is no device ('_') with role 1 or 2, This device ('U') is in the
last role, role 6, and roles 0,3,4,5 are filled by other working
devices in the array ('u').


> 
> 3)  It appears the slot number -1 is the member number?  That is, if
      I do an examine on /dev/sdc1, it tells me it's got slot 5 of
      md1.  But when I do an assemble operation with the --verbose
      flag, it says /dev/sdc1 "as added as 4".  The reason I ask if
      that's true, what would a slot number 0 mean in terms of what
      --assemble is supposed to add it as?  When I do the assemble,
      it's added as 0, which I don't understand if the slot number is
      supposed to be one higher? 

There is no simple arithmetical relationship between slot number and
member number (aka 'role').  They are assigned independently.

> 
> 4)  /dev/sdf1 (the new device name) thinks it's part of md2 (when I
>     do an examine), but can't be, because md2 is all seagate and
>     already has 7 members in it (the right number of drives).  So it
>     must be part of md1, which is missing a member.  When I first
>     tried to reassemble md1, it said it only found 5 good drives,
>     and couldn't start.  now it says it only finds 4 good drives.
>     So I assume sdf1 is one of the 5 good ones but got a weird
>     superblock written to it.  Other than the drive hours trick I
>     thought of earlier, is there any way to determine what it's slot
>     number should have been since I am missing slots 1, 2, and 3,
>     and have 3 candidates for slot 0? 

No.  That information lives in the superblock and is displayed by
--examine.  If the superblock as been corrupted somehow, then that
information is gone.

> 
> Lasttly, it REALLY would make life a LOT easier if the devices
> wouldn't change evrytime they were plugged into a different
> controller slot, or that controller slots wouldn't change based on
> boot order etc...  It is a pain in rear when you have a hardware
> outage or a disk that isn't detected properly on boot and then hot
> added to have it's /dev/sdx1 label change.  I know it's not md's
> fault the way this works, but in a hot swap world it makes it very
> hard to document drive configurations and map devices under linux to
> physical drives. 

Yes, it can be a pain.  The various link in e.g. /dev/disk/by-uuid are
supposed to make that a bit more manageable.  Whether they succeed is
less clear.

NeilBrown
