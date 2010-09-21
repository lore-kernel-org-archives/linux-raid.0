From: Neil Brown <neilb@suse.de>
Subject: Re: Why does MD overwrite the superblock upon temporary disconnect?
Date: Tue, 21 Sep 2010 14:09:14 +1000
Message-ID: <20100921140914.6a92e794@notabene>
References: <20100921025058.79B24E3096C@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100921025058.79B24E3096C@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 20 Sep 2010 20:49:48 -0600
Jim Schatzman <james.schatzman@futurelabusa.com> wrote:

> I have seen quite a number of people writing about what happens to their SATA RAID5 arrays when several drives get accidentally unplugged. Especially with port multipliers and external drive boxes with eSata cables, this can happen rather easily.
> 
> In my case, an 8-drive RAID6 array had this happen to it. Even though the array was not in active use at the time, MD immediately marked the 4 temporarily-disconnected drives as "Spare". No combination of "assemble" options seems able to fix this. 4 drives still have "active slot N" status; the other 4 are "spare", wiping out the slot metadata. Apparently, you have to use "create" to recreate the metadata, marking two slots as "missing" (for RAID 6); check the resulting RAID data; then add the "missing" drives back in. Presumably, you should write down the slot numbers or this may be difficult.
> 
> This procedure works, but for a 12 TB array, the resyncs take a long time. 1 second of cable disconnect for 2 days of resync.
> 
> I have some questions-
> 
> 1) When MD detects that so many drives are offline that the RAID can't function, why not just put the RAID in "stop" state and avoid changing any metadata? Yes, I know that there is a risk of data corruption, but isn't minor data corruption often better than total data loss? 

This is essentially what MD does to.  It marks the devices as having failed
but otherwise doesn't change the metadata.  I've occasionally thought about
leaving the metadata alone once enough devices have failed that the array
cannot work, but I'm not sure it would really gain anything.

The 'destruction' of the metadata happens later, not at the time of device
failure.

> 
> 2) Couldn't there be a way to put the RAID back together tentatively (with all 8 drives), check the parity, and go with the result if the parity is o.k.? That would save some time as compared to resyncing two disks from scratch.
> 

How is 'check the parity' different from 'resync two disks from scratch' ??
Both require reading every block on every disk.

When you create a new RAID6, md does just check the parity - if all the
parity is correct it won't write anything to the devices.

If you believe the parity to be correct, you can create the array with
'--assume-clean'.  If you were wrong and you lose a device, then you could
get data corruption though.

And the '2 days' of resync isn't two wasted days.  You can still use the
array.  If you tune min_sync_speed right down it should only do resync while
nothing else is happening so you shouldn't notice.


> 3) In my case, I am more concerned about catastrophic data loss than 100% up time. I want to have the raids assembled with "--no-degraded". Is it possible to tell the kernel to do this, or would it be better to specify "AUTO -1.x" in mdadm.conf and use a cron.reboot script to start the RAID? 

The kernel doesn't auto-assemble 1.x metadata arrays.
Presumably your arrays are being assembled by the initrd - possibly you could
put the --no-degraded flag in the initrd somewhere.

> 
> 4) Also, would "--no-degraded" help prevent MD from overwriting the metadata (switching drives to "spare" state)?
> 

So here is the crux of the matter - what is over-writing the metadata and
converting the devices to spares?  So far: I don't know.
I have tried to reproduce this and cannot.  Where I assemble the array with 
"mdadm --assemble" or "mdadm --incremental" the superblocks stay unchanged.
If I remove a device from a incompletely assembled array and try to re-add it,
that just fails, superblock is still fine.

If I assemble with '--force' it does the best it can and creates an array with
two missing devices.  The superblocks on the others are unchanged... until I
add them of course, then it has to do a rebuilt.

If I create the array with an internal bitmap and do all the same, then they
get --re-added quite quickly as you would expect.

So while I'm sure you have a problem, I cannot see how it could happen.  I
must be missing something important.
If anyone is able to reproduce this (on a test-array presumably) I would love
to see details.

Just for completeness: what distro are you using, what kernel version, and
what mdadm version?

Thanks,
NeilBrown

