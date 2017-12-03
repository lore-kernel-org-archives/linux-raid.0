From: Phil Turmel <philip@turmel.org>
Subject: Re: ERC for raid [forked from "mdadm reshaping stuck problem"]
Date: Sun, 3 Dec 2017 16:23:15 -0500
Message-ID: <d5e02aca-bad3-7fe7-49ea-0b1d422401f1@turmel.org>
References: <73f07f38fb71986fe71be67f00c77698@posteo.de>
 <fed720e2-fd55-6458-2d68-9b87c96254fc@turmel.org>
 <83ee590a545d4de7938b535b952729b7@posteo.de>
 <b795ed1f-cfcb-4b8f-c25c-a46297bf2614@turmel.org>
 <ff1c0581-c901-e4d5-df14-943845ef7dd9@walther.xyz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff1c0581-c901-e4d5-df14-943845ef7dd9@walther.xyz>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Walther <matthias@walther.xyz>, rene.feistle@posteo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matthias,

On 12/03/2017 01:14 PM, Matthias Walther wrote:
> Hello,
> 
> Am 03.12.2017 um 18:20 schrieb Phil Turmel:
>> Very good.  At some point you need to replace the desktop drive -- it's
>> unsafe to use in a raid array -- but it doesn't look like it's blowing
>> up at the moment.  Use the following workaround on every boot until you
>> replace it:
>>
>> echo 180 > /sys/block/sde/device/timeout
>>
>> Search the archives for "timeout mismatch" to see many discussions on
>> why that drive is a time bomb.
> 
> this is an interesting point. As far as I understand it, there's no
> difference between a) the device tells the kernel, that an error
> occurred (ERC) or b) the kernel just waits three minutes.

From MD raid's perspective, as long as the link doesn't time out, no.
Many services that one might want to use with such a server will have
problems with a 3-minute filesystem freeze, which is why I highly
recommend replacing the drives with something that'll respond quicker.

> From my point of understanding, I see no reason to avoid those disks.
> Just raise this timeout to 180 on all disks. Even those with ERC can be
> set to 180 seconds, because on some mainboards the order of sdX changes
> every boot. On your home nas it doesn't really matter if there's an
> access delay. This is of course not acceptable on enterprise systems.

No, lots of protocols can't wait that long.  Lots of humans can't wait
that long either, and will start physical interventions.

> By the way, the kernel doesn't just easily throw the device out. From my
> experiences it hard resets the link and completely reinitializes the
> device. Only if that fails, the raid will be degraded and if this fails,> the device probably has a problem and should be replaced.

MD raid tries to fix read errors.  When a read returns an error, MD
retrieves the data from a mirror (raid1, raid10) or reconstructs it from
parity and/or syndrome (raid4,5,6) and then writes it back to the
problem sector.  This is entirely appropriate as large modern hard
drives do occassionally experience transient read errors.  Transient
read errors are fixable by writing new content to that sector location.
Even if the error is not transient, modern drives use the write
operation to verify that problem and then relocate the sector.

If the link resets because the driver timed out before the device
responded, then MD gets another error message *while* the link is
resetting.  The follow-up write to correct the sector fails immediately
because the link is down.  The *write error* kicks the drive out.

A quick burst of read errors will kick out a drive (20 in one hour), or
a steady stream of read errors (10 per hour sustained), or *any* write
error.

> I run a raid-6 on six really cheap old second hand 4 TB drives and never
> had an issue with that in the past two years. I had no real failures and
> no accidentally or prematurely dropped devices. Mdadm just runs. And
> this raid writes about 50 GB each and every single day and never goes to
> sleep. This is what differs mdadm from hardware raid controllers, which
> really shouldn't used with non ERC drives due to exactly that timing
> problem.

If you are using the driver timeout workaround, of course you would see
your array collapse.  And for household use, you probably don't care if
your movie playback freezes for the occassional minute or two.

> Though I run a check every month, where all data is read, just to make
> sure it doesn't rot on the discs.

During scrubs, the long timeout on a URE won't impact the filesystem, so
your users are even less likely to notice.  This is very good practice.

> In my opinion a (monitored) raid-6 on
> old, cheap non ERC drives is safer, than a raid-5 on „premium
> overpriced“ drives.

No question about it.  Raid6 is *always* safer than raid5.  That doesn't
mean non-ERC drives are a good idea.

> Never forget, it's call raid - random array of
> inexpensive disks.

The original name is "Redundant Array of Inexpensive Disks".  The
current standard uses "Independent" instead of "Inexpensive" because the
standards body is made up of manufacturers.  /-:

> In cynical words, I see it this way: The hdd and nas manufactures came
> together and found a way to push the prices up.

Oh, I'm pretty cynical.  You should read my posts in 2011 when I worked
all this out -- after Seagate screwed me by taking scterc out of their
desktop drives.

But timeout mismatch is a real problem.  The NAS drives didn't exist as
an option back then, and I'm sure it was complaints like ours that
caused that niche to come into existence.  At a 10% or so price premium.
 (Vs. 2x pricing for enterprise drives.)

> Regards,
> Matthias

Phil
