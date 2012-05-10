From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 13:34:06 +0000
Message-ID: <4FABC3CE.6020405@pocock.com.au>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> My question..
>>
>> - does Linux md RAID actively use the more advanced features of these
>> drives, e.g. to work around errors?
> 
> TLER and its ilk simply give up quickly on errors. This may be good
> for a RAID card that otherwise would reset itself if it doesn't get a
> timely response from a drive, but it can be bad for md RAID. It
> essentially increases the chance that you won't be able to rebuild,
> you lose drive A of a 2 x 3TB RAID 1, and then during rebuild drive B
> has an error and the disk gives up after 7 seconds, rather than doing
> all of its fancy off-sector reads and whatever else it would normally
> do to save your last good copy.

Is TLER a feature that can be turned on and off, like write caches?

Or can the RAID solution (either md or hardware RAID cards) tell the
drive to keep trying the sector if they really can't find the same data
on another drive in the array?

>>
>> - for someone using SAS or enterprise SATA drives with Linux, is there
>> any particular benefit to using md RAID, dmraid or filesystem (e.g.
>> btrfs) RAID (apart from the btrfs having checksums)?
> 
> As opposed to hardware RAID? The main thing I think of is freedom from

Not quite... I was asking how the Linux RAID solutions (particularly for
RAID1) compare to each other

I'm aware that theoretically, btrfs has the advantage of checksums, if
if a disk reads successfully but the data has a bad checksum btrfs will
look for the data elsewhere.

But what about other features: does btrfs work better with a TLER drive
than md with the same drive?  Or the other way around?

> vendor lock-in. If you lose your card you don't have to run around
> finding another that is compatible with the hardware RAID's on-disk
> metadata format that was deprecated last year. Last I checked,

I'm well aware of that one - HP has some great RAID cards, but I'm
nervous about the fact they don't let you access the raw drive.

Adaptec cards that advertise `JBOD' support apparently let you bypass
the RAID functions and access the disks directly (so you can use md or
btrfs directly onto the disk)

> performance was pretty great with md, and you can get fancy and spread
> your array across multiple controllers and things like that. Finally,
> md RAID tends to have a better feature set than the hardware, for
> example N-disk mirrors. I like running a 3 way mirror over 2 way +
> hotspare.

I'd agree with those comments - I actually use md at the moment on a HP
Microserver, it just saved me from a dead drive this week and I'm just
weighing up whether to replace the drive with the same (a Barracuda) or
something better (e.g. Seagate Constellation SATA or even SAS)


