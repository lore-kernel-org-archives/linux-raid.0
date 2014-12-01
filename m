From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: LVM RAID1 syncing component
Date: Mon, 1 Dec 2014 16:27:55 -0500
Message-ID: <20141201162755.0235e84e@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
	<20141127074158.2a3472f3@notabene.brown>
	<20141201161947.1d503df9@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141201161947.1d503df9@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 Dec 2014 16:19:47 -0500
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> On Thu, 27 Nov 2014 07:41:58 +1100
> NeilBrown <neilb@suse.de> wrote:
> 
> > On Mon, 24 Nov 2014 23:07:32 -0500 Joe Lawrence <joe.lawrence@stratus.com>
> > wrote:
> > 
> > > Does anyone know how its possible to determine which side of an LVM RAID 1 
> > > is the stale partner during RAID resync?
> > > 
> > > In ordinary MD RAID, I believe you can check 
> > > /sys/block/md0/md/dev-XXX/state,
> > 
> > Why do you believe that?
> > 
> > During a resync (after an unclean shutdown) the devices are indistinguishable.
> > RAID1 reads all drives and if there is a difference it chooses one data block
> > to write to the others - always the one with the lowest index number.
> > 
> > So with md or LVM it is the same: first "first" is "copied" to the "second".
> 
> Hi Neil,
> 
> Here's a quick example of my thought-process, where md2 is an in-sync
> RAID1 of sdq2 and sdr2 with an internal write bitmap:
> 
> % mdadm --fail /dev/md3 /dev/sdr2
> % mdadm --remove /dev/md3 /dev/sdr2
> 
> [ ... File I/O to /dev/md3 ... ]
> 
> % mdadm -X /dev/sd[qr]2
>         Filename : /dev/sdq2
>            Magic : 6d746962
>          Version : 4
>             UUID : 073511ee:0b0c20e0:662ae8da:b53c7979
>           Events : 8526                                              << ECq
>   Events Cleared : 8498
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 16768896 (15.99 GiB 17.17 GB)
>           Bitmap : 256 bits (chunks), 5 dirty (2.0%)
>         Filename : /dev/sdr2
>            Magic : 6d746962
>          Version : 4
>             UUID : 073511ee:0b0c20e0:662ae8da:b53c7979
>           Events : 8513                                              << ECr
>   Events Cleared : 8498
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 16768896 (15.99 GiB 17.17 GB)
>           Bitmap : 256 bits (chunks), 5 dirty (2.0%)
> 
> [ Note that ECq > ECr, which makes sense since sdq was the remaining
>   disk standing in the RAID. ]
> 
> % mdadm --add /dev/md3 /dev/sdr2
> % mdadm --detail /dev/md3
> /dev/md3:
>         Version : 1.2
>   Creation Time : Thu Nov 13 15:47:19 2014
>      Raid Level : raid1
>      Array Size : 16768896 (15.99 GiB 17.17 GB)
>   Used Dev Size : 16768896 (15.99 GiB 17.17 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Mon Dec  1 16:07:55 2014
>           State : active, degraded, recovering 
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
> 
>  Rebuild Status : 0% complete
> 
>            Name : dhcp-linux-2192-2025:3
>            UUID : 073511ee:0b0c20e0:662ae8da:b53c7979
>          Events : 8528
> 
>     Number   Major   Minor   RaidDevice State
>        0      65        2        0      active sync   /dev/sdq2
>        1      65       18        1      spare rebuilding   /dev/sdr2
> 
> % head /sys/block/md3/md/dev-sd*/state
> ==> /sys/block/md3/md/dev-sdq2/state <==
> in_sync
> 
> ==> /sys/block/md3/md/dev-sdr2/state <==
> spare
> 
> In this scenario, sdr was re-added to the RAID and with a lower events-
> cleared count.  I assume that MD will only need to read the data
> represented by the dirty bitmap bits from the "active sync" disk to the
> "spare rebuilding" disk.  Is this not the case?

D'oh!  Sorry for the edit, I meant the "events" count and not the "events
cleared" count to determine sync direction.  I put the "<<" arrows in
the right place but then used the wrong term everywhere else.

-- Joe
