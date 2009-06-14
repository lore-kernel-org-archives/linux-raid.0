From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID-6 mdadm disks out of sync issue (more questions)
Date: Sun, 14 Jun 2009 18:11:44 +1000 (EST)
Message-ID: <b95d48b03b2756869e786c0982e54f86.squirrel@neil.brown.name>
References: <200906132027.n5DKRquL067127@cjb.net>
    <200906140710.n5E7A5o7074412@cjb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200906140710.n5E7A5o7074412@cjb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid.vger.kernel.org@atu.cjb.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, June 14, 2009 5:10 pm, linux-raid.vger.kernel.org@atu.cjb.net wrote:
> So here I was thinking everything was fine.  My six disks were working
> for hours and the other two disks were loaded as spares and the first
> one was rebuilding, up to 30% with an ETA of 5 hours.  I left the house
> for a few hours and when I came back, the same disk with read errors
> before had spontaneously disconnected and reconnected three times (I
> saw in dmesg).  It probably got around 80% of the way through the six
> hour rebuild.
>
> The problem is that when the /dev/sdc disk reconnected itself after,
> it was marked as a "Spare", and now I can't use the same command any
> longer:

This doesn't make a lot of sense.  It should not have been marked as
a spare unless someone explicitly tried to "Add" it to the array.

I've been thinking that I need to improve mdadm in this respect
and make it harder to accidentally turn a failed drive into a spare.

However you description of event suggests that this was automatic
which is strange.
Can I get the complete kernel logs from when the rebuild started to
when you finally gave up?  It might help me understand.


>
> # mdadm --assemble /dev/md13 --verbose --force /dev/sd{a,b,c,d,e,f}1
>
> This time it doesn't work, as it says 5 disks and 1 spare isn't enough
> to start the array.  I also tried --re-add, but it already thinks it
> is disk 9 out of 8, a Spare.
>
> How can I safely put this disk back into its proper place so I can
> again try to rebuild disks 7 and 8?  I'm assuming I probably need to
> use mdadm --create, but I'm not sure, and don't want to get it wrong
> and have it overwrite this needed disk.

Yes, I suspect that you need --create, but I cannot be certain with
out seeing all the details (e.g. --examine of all devices).
When using --create you need to ensure that the drives are in the
right order with "missing" at the right places.  As long as there
are two missing devices no resync will happen so the data will not be
changed.  So after doing a --create you can fsck and mount etc and ensure
the data is safe before continuing.

But if you cannot get though a sequential read of all devices without
any read error, you wont be able to rebuild redundancy.  (There are plans
to make raid6 more robust in this scenario, but they are a long way
from fruition yet).

NeilBrown

