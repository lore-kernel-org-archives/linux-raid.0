From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Problem with 5disk RAID5 array - two drives lost
Date: Sat, 22 Apr 2006 05:54:27 +0200
Message-ID: <62b0912f0604212054m40283fdbybdb6cd89e61dd153@mail.gmail.com>
References: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@writemem.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Bostrom wrote:
> It appears that /dev/hdf1 failed this past week and /dev/hdh1 failed  back in February.

An obvious question would be, how much have you been altering the
contents of the array since February?

> I tried a mdadm --assemble --force and was able to get the following:
> ==========================
> mdadm: forcing event count in /dev/hdf1(1) from 777532 upto 777535
> mdadm: clearing FAULTY flag for device 2 in /dev/md0 for /dev/hdf1
> raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
> mdadm: /dev/md0 has been started with 4 drives (out of 5).
> ==========================

Looks good.

> I then tried to mount /dev/md0

A bit premature, I'd say.

> ====================
> raid5: Disk failure on hdf1, disabling device.

MD doesn't like to find errors when it's rebuilding.
It will kick that disk off the array, which will cause MD to return
crap (instead of stopping the array and removing the device - I
wonder), again causing 'mount' etc. to fail.

Quite unfortunate for you, since you have absolutely no redundancy
with 4/5 drives, and you really can't afford to have the 4th disk
kicked just because there's a bad block on it.

This is something that MD could probably handle much better than it does now.
In your case, you probably want to try and reconstruct from all 5
disks, but without loosing the information in their event counters -
you want MD to use as much data as it can from the 4 fresh disks
(assuming that they're at least 99% readable), and only when there's a
rare bad block on one of them should it use data from the 5th.

Seeing as
1) MD doesn't automatically check your array unless you ask it to
2) Modern disks have a habit of developing lots of bad blocks

It would be very nice if MD could help out in these kind of situations.
Unfortunately implementation is tricky as I see it, and currently MD
can do no such thing.

> spurious 8259A interrupt: IRQ7.

Oops.
I'd look into that, I think it's a known bug.

(Then again, maybe it's just the IDE drivers - I've experienced really
bad IRQ handling both with old style IDE and with atalib.)

> hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6720

Hey, it's telling you where your data used to be.  Cute.

> raid5: Disk failure on hdf1, disabling device.
> Operation continuing  on 3 devices

Haha!  Real bright there, MD, continuing raid5 operation with 3/5 devices.
Still not a bug, eh? :-)
*poke, poke*

> I'm guessing /dev/hdf is shot.

Actually, there's a lot of sequential sector numbers in the output you posted.
I think it's unusual for a drive to develop that many bad blocks in a row.
I could be wrong, and it could be a head crash or something (have you
been moving the system around much?).

But if I had to guess, I'd say that there's a real likelihood that
it's a loose cable or a controller problem or a driver issue.

Could you try and run:
# dd if=/dev/hdf of=/dev/null bs=1M count=100 skip=1234567

You can play around with different random numbers instead of 1234567.
If it craps out *immediately*, then I'd say it's a cable problem or
so, and not a problem with what's on the platters.


> I haven't tried an fsck though.
> Would this be advisable?

No, get the array running first, then fix the filesystem.

You can initiate array checks and repairs like this:
# cd /sys/block/md0/md/
# echo check > sync_action
or
# echo repair > sync_action

Or something like that.

> Is there a way that I can try and  build the array again with /dev/hdh
> instead of /dev/hdf with some possible data corruption on files that
> were added since Feb?

Let's first see if we can't get hdf online.
