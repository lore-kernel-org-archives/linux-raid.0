From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 6] md: udev events and cache bypass for reads
Date: Tue, 31 Oct 2006 17:00:40 +1100
Message-ID: <20061031164814.4884.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, gregkh@suse.de
List-Id: linux-raid.ids

Following are 6 patches for md in -lastest which I have been sitting
on for a while because I hadn't had a chance to test them properly.
I now have so there shouldn't be too many bugs left :-)

First is suitable for 2.6.19 (if it isn't too late and gregkh thinks it
is good).  Rest are for 2.6.20.

First two make md play a bit more nicely with udev.  Currently udev gets an
'add' event once and never any remove event or anything else.  And the the 'add'
event comes before the array is ready to be used.

The first patch added online/offline events when the array becomes
ready to be used, and when the array ceases to be usable.

The second patch changes the lifetime rules of md devices so they
disappear when not in use.  This means that udev will normally dev a
'remove' event sometime after the offline, and then another 'add' if a
new array is started with a the same name.  I'm not sure if this helps 
udev particularly, but it is a lot neater.

Then we have 4 patches that cause raid5 to not use the stripe-cache
for reads when that is appropriate.  This avoids copies and improves
read throughput by as much as 30% in some tests.  These patches
are largely due to  "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>.

NeilBrown



 [PATCH 001 of 6] md: Send online/offline uevents when an md array starts/stops.
 [PATCH 002 of 6] md: Change lifetime rules for 'md' devices.
 [PATCH 003 of 6] md: Define raid5_mergeable_bvec
 [PATCH 004 of 6] md: Handle bypassing the read cache (assuming nothing fails).
 [PATCH 005 of 6] md: Allow reads that have bypassed the cache to be retried on failure.
 [PATCH 006 of 6] md: Enable bypassing cache for reads.
