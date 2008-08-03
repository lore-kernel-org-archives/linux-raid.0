From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Q: Is this how 'check' works (on raid10 in particular)?
Date: Sun, 3 Aug 2008 14:54:13 +0200
Message-ID: <20080803125413.GA10118@rap.rap.dk>
References: <cccedfc60808030532u14cfd668vfeca77a79996d11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60808030532u14cfd668vfeca77a79996d11@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-sabmag@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 03, 2008 at 07:32:00AM -0500, Jon Nelson wrote:
> After digging through the code (admittedly, way too late at night), I
> think I have a basic understanding of how the resync code works, and
> why it appears to be suboptimal (speed-wise) for raid10.
> 
> It would appear that, upon receipt of a 'check' (other resync methods
> have different paths, sometimes), md.c basically says, "start at the
> first sector or the first sector after the checkpoint and proceed
> logically through the end (unless told to stop)' and md.c schedules
> this check with the relevant sync_request method. For raid10, this
> finds the first device with that logical sector as a copy and then
> compares the data there to the data in all of the other copies on the
> other disks. For raid10 in f2 format (and to a less extent with the
> offset format) this is going to result in a great deal of thrashing.
> I'm guessing this is the reason why a 'check' operation raid10,f2
> takes 2x as long as for raid5 (same disks). One way to improve the
> efficiency here would be to perform a loop like this:
> 
> for device in devices:
>   for chunk that is not a mirror:
>     read chunk
>     compare chunk to mirror chunks on other devices
> 
> If I'm not wrong this should result in near streaming speeds from each
> device with a minimum of seeking. However, to effect this change it
> looks like the changes would be more invasive than just changing
> raid10.c. One way, of course, might be to abstract the sync code just
> a bit more so that md.c could ask each device to provide a function
> which does the driving (the above 4 lines) and md.c does all of the
> common error checking, interrupt checking, etc... Does this seem like
> crazy talk? If I can get some help I might give it a stab.

My idea is to do the checks in bigger blocks, then you would minimize
the trashing, by minimizing the number of times you need to move the
head.  And this would not need much change in the code. I have done a
patch to do this, but I have not yet tested it.

Best regards
keld
