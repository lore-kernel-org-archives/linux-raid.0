From: Neil Brown <neilb@suse.de>
Subject: Re: Need clarification on raid1 resync behavior with bitmap support
Date: Mon, 23 Jul 2007 17:21:35 +1000
Message-ID: <18084.22271.122052.80056@notabene.brown>
References: <170fa0d20707210959q11153d38u3281062c98d3adb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Saturday July 21
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 21, snitzer@gmail.com wrote:
> On 6/1/06, NeilBrown <neilb@suse.de> wrote:
> >
> > When an array has a bitmap, a device can be removed and re-added
> > and only blocks changes since the removal (as recorded in the bitmap)
> > will be resynced.
> 
> Neil,
> 
> Does the same apply when a bitmap-enabled raid1's member goes faulty?
> Meaning even if a member is faulty, when the user removes and re-adds
> the faulty device the raid1 rebuild _should_ leverage the bitmap
> during a resync right?

Yes and no.

While the array is degraded, bits are never cleared from the bitmap.
So if you remove and re-add a device from a degraded array, then all
the block that have changed since the array became degraded will need
to be recovered.  This will likely be more than where changed while
the device was temporarily removed from the array, but probably much
less than the entire array.

> 
> I've seen messages like:
> [12068875.690255] raid1: raid set md0 active with 2 out of 2 mirrors
> [12068875.690284] md0: bitmap file is out of date (0 < 1) -- forcing
> full recovery
> [12068875.690289] md0: bitmap file is out of date, doing full recovery
> [12068875.710214] md0: bitmap initialized from disk: read 5/5 pages,
> set 131056 bits, status: 0
> [12068875.710222] created bitmap (64 pages) for device md0
> 
> Could you share the other situations where a bitmap-enabled raid1
> _must_ perform a full recovery?

When you add a new drive.  When you create a new bitmap.  I think that
should be all.

> - Correct me if I'm wrong, but one that comes to mind is when a server
> reboots (after cleanly stopping a raid1 array that had a faulty
> member) and then either:
> 1) assembles the array with the previously faulty member now
> available
> 
> 2) assembles the array with the same faulty member missing.  The user
> later re-adds the faulty member
> 
> AFAIK both scenarios would bring about a full resync.

Only if the drive is not recognised as the original member.
Can you test this out and report a sequence of events that causes a
full resync?

NeilBrown
