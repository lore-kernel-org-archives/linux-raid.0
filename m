From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: LVM RAID1 syncing component
Date: Tue, 2 Dec 2014 14:05:20 -0500
Message-ID: <20141202140520.2b9160c9@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
 <20141127074158.2a3472f3@notabene.brown>
 <20141201161947.1d503df9@jlaw-desktop.mno.stratus.com>
 <20141202084111.6514ec79@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141202084111.6514ec79@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Dec 2014 08:41:11 +1100
NeilBrown <neilb@suse.de> wrote:

> On Mon, 1 Dec 2014 16:19:47 -0500 Joe Lawrence <joe.lawrence@stratus.com>
> wrote:
> 
> > On Thu, 27 Nov 2014 07:41:58 +1100
> > NeilBrown <neilb@suse.de> wrote:
> > 
> > > On Mon, 24 Nov 2014 23:07:32 -0500 Joe Lawrence <joe.lawrence@stratus.com>
> > > wrote:
> > > 
> > > > Does anyone know how its possible to determine which side of an LVM RAID 1 
> > > > is the stale partner during RAID resync?
> > > > 
> > > > In ordinary MD RAID, I believe you can check 
> > > > /sys/block/md0/md/dev-XXX/state,
> > > 
> > > Why do you believe that?
> > > 
> > > During a resync (after an unclean shutdown) the devices are indistinguishable.
> > > RAID1 reads all drives and if there is a difference it chooses one data block
> > > to write to the others - always the one with the lowest index number.
> > > 
> > > So with md or LVM it is the same: first "first" is "copied" to the "second".
> > 
> > Hi Neil,
> > 
> > Here's a quick example of my thought-process, where md2 is an in-sync
> > RAID1 of sdq2 and sdr2 with an internal write bitmap:
> > 
> > % mdadm --fail /dev/md3 /dev/sdr2
> > % mdadm --remove /dev/md3 /dev/sdr2
> 
> You are referring to what I would call "recovery", not "resync"
> (which is why I put "(after an unclean shutdown)" in my answer to make it
> clear what circumstances I was talking about).
> 
> resync: fixing things after an unclean shutdown
> recovery: restoring data after a device has been removed an another
>           (or possibly the same) added.
> 
> I think
> 
>   dmsetup info 
> 
> should provide the info you want.
> One of the fields is a sequence of letters 'D', 'a', 'A'.
> 
> 		 * Status characters:
> 		 *  'D' = Dead/Failed device
> 		 *  'a' = Alive but not in-sync
> 		 *  'A' = Alive and in-sync
> 
> Does that provide the information you wanted?

Yes!  When I add a disk back to the array, I see the status characters
you mentioned during _recovery_:

% while [ true ]
do
  dmsetup status vg0-lvraid0
  sleep 10s
done
0 18857984 raid raid1 2 DA 18857984/18857984 idle 0
0 18857984 raid raid1 2 DA 18857984/18857984 idle 0
0 18857984 raid raid1 2 DA 18857984/18857984 idle 0
0 18857984 raid raid1 2 aA 0/18857984 recover 0
0 18857984 raid raid1 2 aA 0/18857984 recover 0
0 18857984 raid raid1 2 aA 256/18857984 recover 0
0 18857984 raid raid1 2 aA 8519680/18857984 recover 0
0 18857984 raid raid1 2 AA 18857984/18857984 idle 0

So now, determining which disk is which in the raid_set.  Can I use a
command like lvs to tie the n-th character status back to a device?

% lvs -a -o name,devices vg0
  LV                 Devices
  lvraid0            lvraid0_rimage_0(0),lvraid0_rimage_1(0)
  [lvraid0_rimage_0] /dev/sdr1(1)
  [lvraid0_rimage_1] /dev/sdt1(1)
  [lvraid0_rmeta_0]  /dev/sdr1(0)
  [lvraid0_rmeta_1]  /dev/sdt1(0)

Where the first character represents [lvraid0_rimage_0] and the second
[lvraid0_rimage_1].

Thanks,

-- Joe
