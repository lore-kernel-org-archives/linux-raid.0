From: greg@enjellic.com
Subject: Should we be trying re-write on write errors?
Date: Fri, 14 Nov 2008 15:30:06 -0600
Message-ID: <200811142130.mAELU6Io009544@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, hope the week is ending well for you and the rest of the
denizens on the linux-raid list.

Somewhat of a Gedanken question for you.

We currently attempt a re-write on read error for volumes which have
redundancy, ie. RAID[156] etc, on the bet that we can force a bad
sector remap.  Should we be attempting that (or do we) on a write
error as well?

We ran into the following on one of our many Linux storage boxes this
week:


/var/log/messages:
Nov 13 01:47:36 MACHINE kernel: sd 1:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov 13 01:47:44 MACHINE kernel: sd 1:0:1:0: [sdb] Sense Key : Hardware Error [current]
Nov 13 01:47:44 MACHINE kernel: sd 1:0:1:0: [sdb] Add. Sense: Defect list error

/var/log/syslog:
Nov 13 01:47:44 MACHINE kernel: end_request: I/O error, dev sdb, sector 3484469
Nov 13 01:47:44 MACHINE kernel: raid1: Disk failure on sdb3, disabling device.
Nov 13 01:47:44 MACHINE kernel: ^IOperation continuing on 1 devices
Nov 13 01:47:44 MACHINE kernel: RAID1 conf printout:
etc....


The sdb device is a high-end SCSI SCA drive.  I gave the machine a
thorough go over before certifying it back into service.

SMART reports that two sectors have been added to the defect list on
that drive.  Otherwise things are normal, usual collection of ECC
corrected errors etc.

I forced a full physical read of the drive without provoking any
problems.  That was followed by a CHECK run on the MD devices based on
that disk and no issues were noted.  I added the drive back into its
MD devices, resynchronization went without event and things have been
trundling along fine since then.

My analysis of this is that the drive spit a write error back to the
RAID1 driver which kicked the device after following up with a
successful write to its sibling.  The drive's firmware picked up on
the bad write and re-mapped the sector to one of its spares in the
badblock pool on the drive.

In fact the:

Nov 13 01:47:44 MACHINE kernel: sd 1:0:1:0: [sdb] Add. Sense: Defect
list error

Would seem to indicate that the device driver (aic79xx) even knew
what ended up happening on the drive.

It seems to me the RAID1 code could have attempted and probably
succeeded with a sector re-write thus avoiding a situation of dropping
the RAID1 device from full redundancy levels.

Correct analysis or are the realities of the block driver/MD interface
such that this makes a good story with little hope of implementation?

Could the fly in all this be the fact the above error message isn't
telling us about the addition of the defect but rather a problem
adding the block to the remap list?  But if that were the case I would
assume the drive would be problematic and we not be able to get it
back into service.

Thanks much for any enlightenment you can toss to the list on this.

BTW much thanks for the existing re-write code.  Countless mornings
I have said 'gee that Neil Brown was clever' when I see that one of
our machines cleaned up a potential problem before it became a bigger
one.

Best wishes for a pleasant weekend.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you think nobody cares if you're alive, try missing a couple of car
 payments."
                                -- Earl Wilson
