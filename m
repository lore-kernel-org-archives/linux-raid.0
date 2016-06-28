From: Chris Murphy <lists@colorremedies.com>
Subject: Re: URE, link resets, user hostile defaults
Date: Tue, 28 Jun 2016 11:33:36 -0600
Message-ID: <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57721A47.8070203@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 28, 2016 at 12:33 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 06/27/2016 06:42 PM, Chris Murphy wrote:
>> Hi,
>>
>> Drives with SCT ERC not supported or unset, result in potentially long
>> error recoveries for marginal or bad sectors: upwards of 180 second
>> recovers are suggested.
>>
>> The kernel's SCSI command timer default of 30 seconds, i.e.
>>
>> cat /sys/block/<dev>/device/timeout
>>
>> conspires to  undermine the deep recovery of most drives now on the
>> market. This by default misconfiguration results in problems list
>> regulars are very well aware of. It affects all raid configurations,
>> and even affects the non-RAID single drive use case. And it does so in
>> a way that doesn't happen on either Windows or macOS. Basically it is
>> linux kernel induced data loss, the drive very possibly could present
>> the requested data upon deep recovery being permitted, but the
>> kernel's command timer is reached before recovery completes, and
>> obliterates any possibility of recovering that data. By default.
>>
>> This now seems to affect the majority of use cases. At one time 30
>> seconds might have been sane for a world with drives that had less
>> than 30 second recoveries for bad sectors. But that's no longer the
>> case.
>>
> 'Majority of use cases'.
> Hardly. I'm not aware of any issues here.

This list is prolific with this now common misconfiguration. It
manifests on average about weekly, as a message from libata that it's
"hard resetting link". In every single case where the user is
instructed to either set SCT ERC lower than 30 seconds if possible, or
increase the kernel SCSI command timer well above 30 seconds (180 is
often recommended on this list), suddenly the user's problems start to
go away.

Now the md driver gets an explicit read failure from the drive, after
30 seconds, instead of a link reset. And this includes the LBA for the
bad sector, which is apparently what md wants to write the fixup back
to that drive.

However the manifestation of the problem and the nature of this list
self-selects the user reports. Of course people with failed mdadm
based RAID come here. But this problem is also manifesting on Btrfs
for the same reasons. It also manifests, more rarely, with users who
have just a single drive if the drive does "deep recovery" reads on
marginally bad sectors, but the kernel flips out at 30 seconds
preventing that recovery. Of course not every drive model has such
deep recoveries, but by now it's extremely common. I have yet to see a
single consumer hard drive, ever, configured out of the box with SCT
ERC enabled.


> The problem with SCT ERC (or TLER or whatever the currrent acronym of
> the day is called) is that it's a non-standard setting, where every
> vendor basically does its own thing.
> Plus you can only influence this on higher end-disks; on others you are
> at the mercy of the drive firmware, hoping you got the timeout right.

WDC Scorpio Blue laptop drive supports SCT ERC. But it's disabled. Not
a high end drive.

TOSHIBA MQ01ABD100, also an inexpensive laptop drive, supports SCT
ERC, is disabled, not a high end drive.

Samsung 840 EVO, inexpensive SSD, supports SCT ERC, is disabled, not a
high end drive.

That the maximum recovery time is unpublished or difficult to
determine is beside the point. Clearly 30 seconds for the command
timer isn't long enough or this list wouldn't be full of problems
resulting directly from link resets obscuring the actual problem and
fix: either recovering the data, or explicitly failing with a read
error and an LBA so that md (or even Btrfs) can do their job and
overwrite the bad sector thereby causing in-drive remapping by its
firmware.

When this doesn't happen, those bad sectors just accumulate. And it's
a time bomb for data loss waiting to happen.


> Can you post a message log detailing this problem?

http://www.spinics.net/lists/raid/msg50289.html

There are hundreds, maybe thousands, of these on this list alone in
the form of "raid 5 failure help me recover my data!" because what's
happening is the bad sectors accumulate, finally one drive dies, and
of the remaining drives that survive one or more have one or more bad
sectors that were permitted to persist despite scrubs. And that's
because the kernel is f'ing resetting the goddamn link instead of
waiting for the drive to do its job and either recover the data or
explicitly report a read error.

The 30 second default is simply impatient.

Just over the weekend Phil Turmel posted an email with a bunch of back
reading on the subject of timeout mismatches for someone to read. I've
lost track of how many user emails he's replied to, discovering this
common misconfiguration, and get it straightened out and more often
than not helping the user recover data that otherwise would have been
lost *because* of hard link resetting instead of explicit read errors.


http://www.spinics.net/lists/raid/msg52789.html

He isn't the only list regular who helps educate users tirelessly with
this very repetitive work around for a very old misconfiguration that
as far as I can tell only exists on Linux. And it's the default
behavior.

Now we could say that 30 seconds is already too long, and 180 seconds
is just insane. But that's the reality of how a massive pile of
consumer hard drives actually behave. They can do so called "deep
recoveries" that take minutes during which time they appear to hang.

Usually recoveries don't take minutes. But they can take minutes. And
that's where the problem comes in. I don't see why the user should be
the one punished by the kernel, which is in effect what a 30 second
default command timer is doing.

Perhaps there's a better way to do this than change the default
timeout in the kernel? Maybe what we need is an upstream udev rule
that polls SCT ERC for each drive, and if it's
disabled/unsupported/unknown then it sets a much higher command timer
for that block device. And maybe it only does this on USB and SATA.
For anything enterprise or NAS grade, they do report (at least to
smartctl) SCT ERC in deciseconds. The most common value is 70
deciseconds, so a 30 second command timer is OK. Maybe it could even
be lower but that's a separate optimization conversation.

In any case, the current situation is pretty much crap for the user.
And the idea we can educate users on what to buy isn't working, and
the esoteric crap they need to change to avoid the carnage from this
misconfiguration is still mostly unknown even to seasoned sysadmins
and uber storage geeks. They have no idea this is the way things are,
until they have a problem, come on this list, and get schooled. It's a
big reason why so many people have thrown raid 6 at the problem, which
really just papers over the real issue by throwing more redundancy at
it. But this list has in fact seen raid 6 implosions as a result of
this problem where two drives fail, and a 3rd drive has bad sectors
allowed to accumulate because of this misconfiguration and the array
collapses.


> We surely have ways of influencing the timeout, but first we need to
> understand what actually is happening.

I think the list regulars on this list understand what's actually
happening. Users are buying cheap drives that were never designed for,
or even are explicitly excluded from use in raid 5 or raid 6. But the
problem impacts non-RAID users, linear/concat layouts, and RAID 0.

It even impacts Btrfs DUP profile, where there are two copies of
metadata on disk. If one of those fs metadata sectors reads slow
enough, the drive gets reset, the command queue is flushed and now the
fs has to rerequest everything *and* it has no idea, due to lack of a
read error, where to get the mirrored copy of metadata on that drive,
and no idea where to write it back to in order to fix the slow sector
read.

It screws users who merely use ext4, because instead of getting a slow
computer, they get one that starts to face plant with obscure messages
like link resets. The problem isn't the link. The problem is bad
sectors. But they don't see that message because the link reset
happens before the drive reports the read failure.

Where is Phil and Stan to back me up on this?


-- 
Chris Murphy
