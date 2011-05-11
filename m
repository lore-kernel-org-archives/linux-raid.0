From: NeilBrown <neilb@suse.de>
Subject: Re: reshape failure
Date: Thu, 12 May 2011 07:34:46 +1000
Message-ID: <20110512073446.0d8fa2b9@notabene.brown>
References: <AANLkTikniCc3NNxgf9tW8Gb4qvUM-UfCJDazYC6Th1jZ@mail.gmail.com>
	<20110217073247.2dbc9299@notabene.brown>
	<AANLkTin__CDHu4qxAJe2NACXBFdE7EV1kuFOMoG7-P-h@mail.gmail.com>
	<20110217080634.510b017e@notabene.brown>
	<AANLkTi=gP5QGbq-JguHuA3T91_+U1XYLP1xiK9nSQ_LO@mail.gmail.com>
	<BANLkTimeeTY5MXoijD_uCdss6Ny+rB5dNw@mail.gmail.com>
	<20110512071257.79795756@notabene.brown>
	<BANLkTi=3-PgTqeGqyu5fPZMporA1vk6-Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=3-PgTqeGqyu5fPZMporA1vk6-Tw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias McNulty <tobias@caktusgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 May 2011 17:18:14 -0400 Tobias McNulty <tobias@caktusgroup.com>
wrote:

> On Wed, May 11, 2011 at 5:12 PM, NeilBrown <neilb@suse.de> wrote:
> 
> > On Wed, 11 May 2011 14:06:23 -0400 Tobias McNulty <tobias@caktusgroup.com>
> > wrote:
> >
> > > On Thu, Feb 17, 2011 at 4:39 PM, Tobias McNulty <tobias@caktusgroup.com>
> > wrote:
> > > >
> > > > On Wed, Feb 16, 2011 at 4:06 PM, NeilBrown <neilb@suse.de> wrote:
> > > > >
> > > > > On Wed, 16 Feb 2011 15:41:46 -0500 Tobias McNulty <
> > tobias@caktusgroup.com>
> > > > > wrote:
> > > > > >
> > > > > > Now I see this in /etc/mdstat:
> > > > > >
> > > > > > md0 : active raid6 sdf[0] sdg[5](S) sdh[4] sdc[3] sdd[2] sde[1]
> > > > > >       5860543488 blocks super 0.91 level 6, 64k chunk, algorithm 2
> > [5/5] [UUUUU]
> > > > > >       [=>...................]  reshape =  9.9%
> > (193691648/1953514496)
> > > > > > finish=97156886.4min speed=0K/sec
> > > > > >
> > > > > > Is the 0K/sec something I need to worry about?
> > > > >
> > > > > Maybe.  If the stays at 0K/sec and the 9.9% stays at 9.9%, then yes.
> >  It is
> > > > > something to worry about.
> > > >
> > > > It seems like it was another buggy SATA HBA?? I moved everything back
> > > > to the on-board SATA ports (1 of the 2 drives in the OS RAID1 device
> > > > and the 5 non-spare devices in the RAID6 -> RAID5 device) and it's
> > > > happily reshaping again (even without the MDADM_GROW_ALLOW_OLD magic
> > > > this time):
> > > >
> > > > md0 : active raid6 sda[0] sde[4] sdd[3] sdc[2] sdb[1]
> > > >       5860543488 blocks super 0.91 level 6, 64k chunk, algorithm 2
> > [5/5] [UUUUU]
> > > >       [==>..................]  reshape = 10.0% (196960192/1953514496)
> > > > finish=11376.9min speed=2572K/sec
> > > >
> > > > Is it really possible that I had two buggy SATA cards, from different
> > > > manufacturers?  Perhaps the motherboard is at fault?  Or am I missing
> > > > something very basic about connecting SATA drives to something other
> > > > than the on-board ports?
> > > >
> > > > Currently I'm using a SuperMicro X7SPA-HF [1] motherboard with a
> > > > AOC-SASLP-MV8 [2] HBA, and the machine is running Debian squeeze
> > > > (2.6.32-5-amd64).
> > > >
> > > > Tobias
> > > >
> > > > [1]
> > http://www.supermicro.com/products/motherboard/ATOM/ICH9/X7SPA.cfm?typ=H&IPMI=Y
> > > > [2]
> > http://www.supermicro.com/products/accessories/addon/AOC-SASLP-MV8.cfm
> > >
> > > So, after figuring out the hardware issues, the reshape appears to
> > > have completed successfully (hurray!), but /proc/mdstat still says
> > > that the array is level 6.  Is there another command I have to run to
> > > put the finishing touches on the conversion?
> > >
> > > md0 : active raid6 sda[0] sde[4] sdd[3] sdc[2] sdb[1]
> > >       5860543488 blocks level 6, 64k chunk, algorithm 18 [5/5] [UUUUU]
> > >
> >
> > Just
> >   mdadm --grow /dev/md0 --level=5
> >
> > should complete instantly. (assuming I'm correct in thinking that you want
> > this to be a raid5 array - I don't really remember the details anymore :-)
> 
> 
> Bingo!  Thanks.
> 
> md0 : active raid5 sda[0] sde[4](S) sdd[3] sdc[2] sdb[1]
>       5860543488 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> And I even ended up with a spare disk (wasn't sure how that part was going
> to work).
> 
> Do you always have to run that command twice, or only if the reshape is
> interrupted?  At least, I thought that was the same command I ran originally
> to kick it off.

Only if it is interrupted.  The array doesn't know that a level change is
needed after the layout change is completed, only the mdadm process knows
that.  And it has died.

I could probably get the array itself to 'know' this... one day.

NeilBrown


> 
> Thanks again.
> 
> Tobias

