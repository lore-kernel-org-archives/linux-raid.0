From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Sleeping hard drives in an array?
Date: Sun, 4 May 2008 20:12:30 -0400
Message-ID: <29a863790805041712v4eff0496hac3eedaa9003466b@mail.gmail.com>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com>
	 <481B836E.6040208@tmr.com> <481B918E.4@panix.com>
	 <481E4EFC.2050805@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <481E4EFC.2050805@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wow this has caused quite the stirrup!

I think I'll leave them spinning :-) They are WD Raid Edition drives
so I'll keep my fingers crossed. I just figured since the array does
nothing like 21 hours of the day.. why not spin it down. But if
spinup/downs are worse then I'll leave it be.

The drive temps are 32-34 degrees since they have fans right on them
and the case is nicely cooled.

Thanks,
Greg




On Sun, May 4, 2008 at 8:04 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> berk walker wrote:
>
> > Bill Davidsen wrote:
> >
> > > Greg Cormier wrote:
> > >
> > > > Is it possible to sleep hard drives in an array?
> > > >
> > > > I have a HTPC at home that's on 24x7. It does all my torrenting as
> > > > well, and is mainly a media server.
> > > >
> > > > Can I sleep the drives in my RAID5 array while it's not being used?
> > > > It's an XFS partition.
> > > >
> > > > I have each drive set as
> > > >
> > > > hdparm -S240 /dev/sdX
> > > >
> > > > But I'm fairly sure they are not spinning down :( Is there some
> > > > activity mdadm is doing in the background?
> > > >
> > > > These things are probably idle 22 hours of the day.
> > > >
> > > >
> > >
> > > I have several very similar systems, and I note that on one the disk
> light blinks every five sec or so, while the others don't do that. The one
> that blinks is the only one running LVM, all the others were partitioned by
> hand. Does that apply to your system, LVM in use?
> > >
> > >
> > Geez!!  pardon me if I don't either "get it" or am unable to communicate
> about "it".  Those thinking that I'm un-necessarily repeating myself - email
> your flames and I will be gone from here for a few months.
> >
> > Put / [and whatever ELSE that needs to be mounted] on a USB drive.  I
> recently got a 2Gb drive for pocket change!!
> >
> > Learn, or borrow someone who knows how - scripts. I don't think that you
> would give a darn if a ram-drive didn't "spin-down".  So PUT what can not be
> put to sleep on something that doesn't have mechanical wear!!!
> >
> > Your system can be set up to WAKE up with everything mounted and ready to
> go on ANY trigger/situation that YOU want - except the states need to be
> either on or off... there are lots of states that newer 'puters monitor.
> I'm sorry but THIS is not rocket science.
> >
> > NOW!!  YOU FAILED TO RESPOND!!  To my earlier response to you.  Please
> allow me to ax you again....  WHY do you want spin-down?  HMMM
> >
>  a - I didn't, the original poster did
>  b - his question was why it didn't spin down, so the WHY is irrelevant
>  c - none of the comments below are relevant to why his array won't spin
> down
>
>
> >    Less noise-    - buy new drives
> >    Less elect. co$t - If they aren't seeking, draw is LOW
> >    Less wear on the drives - I have never had a drive mfg respond
> to my questions about this.  My [totally personal] view             on this
> is if you're shutting down for a few hr., you                 will lose,
> weeks will win.
> >
>
>  Rest of post snipped, also not related to why the array won't spin down.
> The point about drive wear could be addresses by looking for studies of
> same, it appears the bearing failures are related to POH, positioning errors
> to total seeks, and electronic failures to power cycles. The data I have is
> some years old, but I doubt that's changed, but it's not relevant to the
> spin down issue.
>
>  And no one seems to have answered to my query on use of LVM causing
> frequest access.
>
>
>
>  --
>  Bill Davidsen <davidsen@tmr.com>
>   "Woe unto the statesman who makes war without a reason that will still
>   be valid when the war is over..." Otto von Bismark
>
>
