From: Derek Piper <derek.piper@gmail.com>
Subject: Re: Joys of spare disks!
Date: Thu, 10 Mar 2005 14:24:50 -0500
Message-ID: <eaa6dfe05031011245d798d88@mail.gmail.com>
References: <eaa6dfe0503080915276466a1@mail.gmail.com>
	 <200503091704.j29H4l517152@www.watkins-home.com>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503091704.j29H4l517152@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmmm, yea.. I'm hoping I get a better one next time. I'll bore you to
tears, I mean, let you know when it comes in :D

Derek

PS: Make sure the 'saveauto' is set to on for SMART data to be saved
automatically through power-cycles

i.e.

> smartctl --saveauto=on /dev/hda

you might want to do this too:

> smartctl --offlineauto=on /dev/hda


On Wed, 9 Mar 2005 12:04:41 -0500, Guy <bugzilla@watkins-home.com> wrote:
> My drives reset the "power on time" when they power on.  So I can't be sure
> how long my drives have been on.  But at least 6 of them have been in use
> 24/7 for 2.5 years.  I have powered them down on occasion.  sdh was replaced
> a few months ago.  But the problem was with the power cable, not the drive.
> But did not determine this until after I swapped the drives.  On Jan 18 sdg
> had only 19 entries.  Anyway, 2 of them still have zero bad blocks.
> 
> And for what it's worth, I have had many problems with re-built disks.
> Once, out of 5 disks, 3 were bad, out of the box.  I have learned that
> repaired disks suck, even Seagate.
> 
> Guy
> 
> Status of my 2.5 year old disks:
> /dev/sdd -  5 entries (40 bytes) in grown table.
> /dev/sde -  0 entries (0 bytes) in grown table.
> /dev/sdf -  12 entries (96 bytes) in grown table.
> /dev/sdg -  21 entries (168 bytes) in grown table.
> /dev/sdh -  0 entries (0 bytes) in grown table.
> /dev/sdi -  6 entries (48 bytes) in grown table.
> /dev/sdj -  0 entries (0 bytes) in grown table.
> 
> -----Original Message-----
> From: Derek Piper [mailto:derek.piper@gmail.com]
> Sent: Tuesday, March 08, 2005 12:15 PM
> To: Guy
> Subject: Re: Joys of spare disks!
> 
> Heh.. I too have Seagate drives and have RMA'd even the drive they
> sent back to replace the one I RMA'd a month or so ago. Normally
> they're great, so I'm hoping the next replacement will fair better.
> 
> The one they sent back had more than 10000 unrecoverable sector errors
> (!) according to smartctl by the time I RMA'd it (the first one, my
> original drive, that I sent back had 3). It failed its self-tests and
> all of Seagate's SeaTools tests too. The drive wasn't mishandled by
> me, although I thought Seagate's own packaging looked a bit crap (two
> pieces of black plastic suspending the drive within a plastic 'shell'
> (the so called 'SeaShell' :>) within the box. No peanuts or bubble
> wrap or anything else. Still, the drive worked at first and then
> within 48hrs had problems.
> 
> I have other Seagate drives that have been run for over 15000 without
> a single even reallocated bad sector. I might have to try Peter's
> patch though, since I am running them in RAID-1.
> 
> Derek
> 
> /trying to un-lurk on the list (i.e. read the 120 threads that have
> appeared since I forgot about checking my gmail account)
> 
> On Wed, 2 Mar 2005 00:53:51 -0500, Guy <bugzilla@watkins-home.com> wrote:
> > That has not been my experience, but I have Seagate drives!
> >
> > Guy
> >
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
> > Sent: Tuesday, March 01, 2005 11:57 PM
> > To: Robin Bowes
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: Joys of spare disks!
> >
> > Robin Bowes wrote:
> >
> > > Thanks to some advice from Guy the "failed" disk is now back up and
> > > running.
> > >
> > > To fix it I did the following;
> > >
> > <snip>
> >
> > Just watch that disk like a hawk. I had two disks fail recently in the
> same
> > way, I did exactly what
> > you did and 2 days later they both started to grow defects again and got
> > kicked out of the array. I
> > RMA'd both of them last week as they would not stay stable for more than a
> > day or two after
> > re-allocation.
> >
> > Regards,
> > Brad
> > --
> > "Human beings, who are almost unique in having the ability
> > to learn from the experience of others, are also remarkable
> > for their apparent disinclination to do so." -- Douglas Adams
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> Derek Piper - derek.piper@gmail.com
> http://doofer.org/
> 
> 


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
