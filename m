From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Joys of spare disks!
Date: Thu, 3 Mar 2005 10:37:24 +0100
Message-ID: <62b0912f050303013754af4415@mail.gmail.com>
References: <62b0912f05030204054b1ab8ae@mail.gmail.com>
	 <200503021617.j22GH0516373@www.watkins-home.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503021617.j22GH0516373@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:

I generally agree with you, so I'm just gonna cite / reply to the
points where we don't :-).

> This sounded like Neil's current plan.  But if I understand the plan, the
> drive would be kicked out of the array.

Yeah, sounds bad.
Although it should be marked as "degraded" in mdstat, since there's
basically no redundancy until the failed blocks have been reassigned
somehow.

> And 1000 bad blocks!  I have never had 2 on the same disk at the
> same time.  AFAIK.  I would agree that 1000 would put a strain on the
> system!

Well, it happened to me on a Windows system, so I don't think that
that is far-fetched.

This was a desktop system with the case open, so it was bounced about a lot.

Every time the disk reached one of the faulty areas, it recalibrated
the head and then moved it out to try and read again.  It retried the
operation 5 times before giving up.  While this was ongoing, Windows
was frozen.  It took at least 3 seconds each time I hit a bad area,
and I think even more.

If MD could read from a disk while a similar scenario occurred, and
just mark the bad blocks for "rewriting" in some "bad block rewrite
bitmap" or whatever, a system hang could be avoided.  Trying to
rewrite every failed sector sequentially in the code that also reads
the data would incur a system hang.  That's what I tried to say
originally, though I probably didn't do a good job (I know little of
linux md, guess it shows =)).

Of course, the disks would, in the case of IDE, probably have to _not_
be in master/slave configurations, since the disk with failing blocks
could perhaps hog the bus.  Of course I know as little of ATA/IDE as I
do of linux MD, so I'm basically just guessing here ;-).

> Sometime in the past I have said there should be a threshold on the number
> of bad blocks allowed.  Once the threshold is reached, the disk should be
> assumed bad, or at least failing, and should be replaced.

Hm.  Why?
If a re-write on the block succeeds and then a read on the block
returns the correct data, the block has been fixed.  I can see your
point on old disks where it might be a magnetic problem that was
causing the sector to fail, but on a modern disk, it has probably been
relocated to the spare area.  I think the disk should just be failed
when a rewrite-and-verify cycle still fails.  The threshold suggestion
adds complexity and user-configurability (error-prone) to an area
where it's not really needed, doesn't it?

Another note.  I'd like to see MD being able to have a
user-specifiable "bad block relocation area", just like modern disks
have.  It could use this when the disks spare area filled up.  I even
thought up a use case at one time that wasn't insane like, "my disks
is really beginning to show up a lot of failures now, but I think I'll
keep it running a bit more", but I can't quite reminisce what it was.

> Does anyone know how many spare blocks are on a disk?

It probably varies?
Ie. crappy disks probably have a much too small area ;-).
In this case it would be very cute if MD had an option to specify it's
own relocation area (and perhaps even a recommendation for the user on
how to set it wrt. specific harddisks).
But OTOH, it sucks to implement features in MD that would be much
easier to solve in the disks by just expanding the spare area (when
present).

> My worse disk has 28 relocated bad blocks.

Doesn't sound bad.
Isn't there a SMART value that will show you how big a percentage of
spare is used (0-255)?
