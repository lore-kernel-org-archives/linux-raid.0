From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sat, 04 Jan 2014 11:24:41 -0500
Message-ID: <52C835C9.3050707@turmel.org>
References: <1388829881.16265.20.camel@vessel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388829881.16265.20.camel@vessel>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Knorr <knorrfab@fim.uni-passau.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Fabian,

We might be able to save you here, but it isn't certain.

On 01/04/2014 05:04 AM, Fabian Knorr wrote:
> Good morning folks,
> 
> I have a MD-RAID5 with 8 disks, 7 of them active, 1 spare. They are
> connected to two SATA controllers, 4 disks each.

Side note: If you have a live spare available for a raid5, there's no
good reason not to reshape to a raid6, and very good reasons to do so.

> A few days ago, the disks connected to one of the controllers stopped
> operating (some sort of controller hiccup, I guess). Now those disks are
> marked as "possibly outdated" and the array refuses to assemble or
> start, telling me there are only 4 out of 7 devices operational (See
> attachment "assemble.status")
> 
> On boot, "/proc/mdstat" reports an inactive array with 7 spares, trying
> to "mdadm --run" the array fails with the message mentioned above,
> changing "/proc/mdstat" to now show an array of 4 disks. 

"mdadm --assemble --force" would have fixed you up if you'd done it
right at this point.  That's what "--force" is intended for.

> I tried "--add" with a missing device, getting the message "re-added
> device /dev/sd...", but failing for subsequent devices with the message
> "/dev/md0 failed to start, not adding device ..., You should stop and
> re-assemble the array".

Using "--add" changed those devices' superblocks, losing their original
identity in the array.  Which is why ...

> Then I tried "--assemble --scan --force", which yielded the same result
> as above.

... this didn't work.

> The next thing I would try is recreating the array with the layout
> stored in the superblocks, but I was surprised to find it to be
> inconsistent between the disks. I attached the output of "--examine
> --verbose" as "raid.status". 

Device names are not guaranteed to remain identical from one boot to
another.  And often won't be if a removable device is plugged in at that
time.  The linux MD driver keeps identity data in the superblock that
makes the actual device names immaterial.

It is really important that we get a "map" of device names to drive
serial numbers, and adjust all future operations to ensure we are
working with the correct names.  An excerpt from "ls -l
/dev/disk/by-id/" would do.  And you need to verify it after every boot
until this crisis is resolved.

> Could "--add"ing have changed one superblock, and can I safely try to
> re-create the array with the layout given by /dev/sda and /dev/sdc?
> Also, what parameters would I need to keep the layout (As mentioned in
> the wiki at https://raid.wiki.kernel.org/index.php/RAID_Recovery)
> consistent with the one I have now?

Some additional questions/notes before proceeding:

1) raid.status appears to be from *after* your --add attempts.  That
means anything in those reports from those devices is useless.  So we
will have to figure out what that data was.

2) You attempted to recreate the array.  If you left out
"--assume-clean", your data is toast.  Please show the precise command
line you used in your re-create attempt.  Also generate a fresh
"raid.status" for the current situation.

3) The array seems to think it's member devices were /dev/sda through
/dev/sdh (not in that order).  Your "raid.status" has /dev/sd[abcefghi],
suggesting a rescue usb or some such is /dev/sdd.  So device names have
to be re-interpreted between old metadata and recovery attempts.

4) Please describe the structure of the *content* of the array, so we
can suggest strategies to *safely* recognize when our future attempts to
--create --assume-clean have succeeded.  LVM?  Partitioned?  One big
filesystem?

Phil
