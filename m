From: Redeeman <redeeman@metanurb.dk>
Subject: Re: upgrade advice
Date: Tue, 16 Dec 2008 15:15:50 +0100
Message-ID: <1229436950.22331.45.camel@localhost>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com>
	 <alpine.DEB.1.10.0812160641130.725@p34.internal.lan>
	 <1229428184.22331.43.camel@localhost>
	 <alpine.DEB.1.10.0812160807200.725@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812160807200.725@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Max Waterman <davidmaxwaterman@fastmail.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2008-12-16 at 08:07 -0500, Justin Piszcz wrote:
> 
> On Tue, 16 Dec 2008, Redeeman wrote:
> 
> > On Tue, 2008-12-16 at 06:44 -0500, Justin Piszcz wrote:
> >>
> >> On Tue, 16 Dec 2008, Max Waterman wrote:
> >>
> >>> Hi,
> >>>
> >>> I have a 8x200GB RAID5 array - 4 SATA and 4 EIDE. It has 2 spare, so
> >>> that's only 6 drives actually in the array, making 1TB of space (I
> >>> think that's right).
> >>>
> >>> The drives are quite old now, and people are asking what I want for
> >>> Christmas...so I'm wondering how to upgrade this setup. Clearly I
> >>> don't want to retire my existing drives prematurely, since they've
> >>> shown no sign of problem.
> >>>
> >>> My initial thought was to make a RAID1 out of a new 1TB disk and my
> >>> existing RAID5 array, but perhaps that doesn't make much sense...
> >>>
> >>> Perhaps I could get a 400GB drive (or more likely 500GB) and make a
> >>> RAID1 with a couple of the existing 200GBs?
> >>>
> >>> ...but I'm just guessing and the purpose of this email is to get advice.
> >>>
> >>> What do you guys think?
> >>>
> >>> Max.
> >>
> >> Tough call, depends on what you want to accomplish?  Availability or mass
> >> storage space?  You could continue running like you are now and use a 1TiB
> >> disk as your "scratch" area and rsync the important data off to your
> >> RAID-5 nightly for example.
> >>
> >> Another option (probably not a good one) take two of your 200s and make a
> >> RAID1, leave your RAID-5 as-is, buy another 200GiB as a spare and then
> >> with the rest of the $ buy something else, there are no good alternatives,
> >> those are pretty old disks you got there, but I agree if its been running
> >> fine, no reason to replace it.
> > Hehe, i myself am in a somewhat similar position.. i have a 6x300gb
> > raid5 array.. And the disks appears perfectly fine through smart etc,
> > but on the other hand, a SINGLE new disk today can present me with the
> > same level of usable capacity very cheap, and ill bet using considerably
> > less power. Thus i have chosen to very soon retire this setup, and make
> > a replacement 8x1tb or 6x1.5tb raid6 for increased capacity and
> > safety :)
> >
> > i'd recommend you work towards deprecating LOTS of drives in favor of
> > fewer bigger newer, and keep the old ones around as an archive/backup
> > thing.
> Agree here, but the 1.5TiB are not enterprise disks, I would not recommend 
> moving to them yet, but rather 1TiB, that is what I am currently doing, 
> moving to WD RE3's (1TiB model).
I am somewhat scared of the seagate stuff too.. I however will probably
go the WD10EADS way instead, i know its not the "enterprise" disks, but
they are really lowpower, and well.. i would hope raid6 can bail me out
of any disk failures.

> 
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

