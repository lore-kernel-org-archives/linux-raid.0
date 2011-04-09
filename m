From: rob pfile <rpfile@gmail.com>
Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Sat, 9 Apr 2011 07:39:23 -0700
Message-ID: <39D502E7-70F9-456B-A2AF-C9A6AEA95F65@gmail.com>
References: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com> <alpine.DEB.2.00.1104070916030.14027@uplift.swm.pp.se> <242C1984-F4B5-4C34-BF4C-619875BD9CAF@gmail.com> <20110408221046.2aa5e685@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408221046.2aa5e685@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Apr 8, 2011, at 5:10 AM, NeilBrown wrote:

> When a device gives a hard read error md/raid always calculates the correct
> data from other devices (Assuming that parity is correct) and writes it out.
> It does this for check and for repair and for normal IO.
> 
> I am no expert on SMART however if there are no reallocated sectors then
> maybe what happened is that whenever md wrote to a bad sector, the drive
> determined that the media there was still usable and wrote the data there.
> But that is just a guess.
> 

excellent, thanks. this probably explains why the errors seem to be migrating around the disk - perhaps the ones that are getting corrected/rewritten are effectively being 'refreshed' and sectors that are sitting around unread for a while are rotting. 

i ran another check, and this time saw several read errors on one of the bad disks, but not on the other. strangely, i did not see raid correcting these sectors. i wonder if this means they eventually returned good data. does md/raid try more than once in the face of a hard error before correcting from parity?

given that i have backups, i decided to just fail out the disk that was still giving errors. the raid is rebuilding now, and in 20h or so i'll know if i'm out of the woods. i think i'll probably also replace the other flaky disk, even though it's SMART status now looks pretty clean.

===

update: bad news... a *different* drive in the array threw a read error while rebuilding. i wonder if my controller or enclosure might be bad, since 3 out of 4 disks have exhibited random problems (and no reallocated sectors).

anyway, now the raid is up, but in a degraded state. what i want to do is bring the array back to a clean state with 3 drives and restart the rebuild onto the new disk and see what happens. how do i get the "failed" disk back into "active sync" state? mdadm --manage /dev/md1 --add /dev/sdi1 returns "device busy", and --assemble won't take --assume-clean as an argument. do i have to stop and re-start the array? a little scared to do that.

thanks,

rob

