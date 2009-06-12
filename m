From: Neil Brown <neilb@suse.de>
Subject: Re: RAID-6 mdadm disks out of sync issue (five questions)
Date: Fri, 12 Jun 2009 11:26:04 +1000
Message-ID: <18993.44716.150839.661647@notabene.brown>
References: <ed308b763e18e168a98f977857663bed.squirrel@neil.brown.name>
	<200906111843.n5BIhlcN024789@cjb.net>
	<4A319453.3060503@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Friday June 12
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid.vger.kernel.org@atu.cjb.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 12, mjt@tls.msk.ru wrote:
> linux-raid.vger.kernel.org@atu.cjb.net wrote:
> > NeilBrown <neilb@suse.de> wrote :
> >> Once you are sure you have the 6 drives with the highest
> >> event counts working, assemble them with
> >>
> >> mdadm --assemble /dev/md13 --force /dev/sd?1
> > 
> > I had a few questions before I went ahead with the
> > reassembly:
> > 
> > 1) Does it matter which order the disks are listed in when
> > reassembling the array (e.g. /dev/sda1 /dev/sdh1 ...)?
> 
> No, the order does not matter.  In superblock of each
> device there's the device number so mdadm will figure
> it all out automatically.
> 
> On the other hand, if you want to RECREATE the array
> (with mdadm --create), order DOES matter - it's pretty
> much essential to get the same order as original array.
> 
> > 2) Is there any risk to the data stored on the disks by
> > merely reassembling the six working disks with the above
> > command?
> 
> If you original set (raid6) was 8 disks, there's nothing
> to do with the data.  I mean, mdadm/kernel will not
> start any sort of reconstruction because there's no
> drives to resync data to.  The data will not be
> changed.  Superblocks will be updated (event counts)
> but that's not data.
> 
> > 3) Does /sys/module/md_mod/parameters/start_ro being
> > set to 1 prevent the array from syncing/rebuilding/etc.,
> > or does it only prevent new user data being written to
> > the array?  If it only prevents user data being written
> > to the /dev/md*, is there some way to also prevent mdadm
> > from doing syncing/rebuilding/etc. so I can be sure the
> > data is not at risk of further damage while testing?
> 
> See above.  I really am not sure for start_ro vs
> rebuilding - will check ;)

If an array started read-only, then no resync/rebuild etc will happen
until the first write, or until the array is explicitly set to
read-write.


> > 
> > 4) Having checked what the "Events" refers to (I thought it
> > was write-syncing operations before), should I be worried
> > at the Event count being above 1,000,000?  I have rebuilt
> > two failed disks and the distro performed a few data
> > integrity checks on all the disks.  The array is about
> > nine to ten months old.
> 
> Well, 1.000.000 is a bit too high for that time.
> Mine has 28 - half a year old raid array.  But I don't
> reboot machine often, it has been rebooted about 10
> times in that time.  Events are like - array assembly
> and disassembly, drive failed, drive added and the like.

Events also can increase every time the array switched between
'active' and 'clean'.  It will switch to 'clean' after 200ms without
writes and then switch back to 'active' on the first write.
So you could get nearly 10 changes per second with a workload that
generates 1 write every 201 ms.

If you have spare drives, then md drive to avoid increases the event
count so much so that it doesn't have to write the the otherwise-idle
drives.  It does this be decrementing the event count on an
active->clean transition if that seems safe.

So on an array with no spares, 1,000,000 is entirely possible - it is
very workload-dependant.

> 
> > 5) Any idea why "shutdown -h now" would cause three of
> > the six working disks to gain 4 events each (happened with
> > the filesystem unmounted from /dev/md13)?
> 
> It shouldn't be that high really.  I think.  *Especially*
> on only some of the disks.

You would definitely expect them to be all updated by the same amount
unless there were drive failures.
Unmounting the filesystem would cause a write of the filesystem
superblock which could switch the array to active.  Then it would
switch to clean, and there could be another double-switch in the when
stopping the array.  So 4 isn't particularly surprising.

NeilBrown

> 
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
