From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 19:57:40 -0500
Message-ID: <200501060057.j060vk928131@www.watkins-home.com>
References: <20050105223556.GS99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050105223556.GS99565@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Andy Smith' <andy@lug.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Going off topic, but...

I come from an HP-UX environment.
With HP-UX, I have always had to configure swap space.
Maybe only for 1 reason.  If you used shared memory, you must have an equal
amount of swap space available.  We always used shared memory (shmget).  It
was called a "backing store", if I recall.  Including Informix, we used
almost the hardware (OS) limit of about 1.7 Gig of shared memory on some
systems.  So we needed at least 1.7 Gig of swap space.  We would allocate
3-4 Gig I think, just to be safe.  The swap space would be allocated
(reserved), but not used, unless you really ran low on RAM.

So, the question is:
	Assume I have enough RAM to never need to swap.
	Do I need any swap space with Linux?

Silly story:
I once had a 486 with 4 Meg of ram.  Running Windows 3.1 I think.
I had 8 Meg of swap space.  So 12 meg total available virtual memory.
One day I added 16 Meg of RAM.  So now I had 20 Meg of RAM.  I deleted my
swap space.  Everyone told me I needed 20-40 Meg of swap space now!  Swap
space should be 2 time RAM size.  How crazy, my memory requirements did not
change, just the amount of memory.  I used that system for a year or so like
that.  Go figure!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Andy Smith
Sent: Wednesday, January 05, 2005 5:36 PM
To: linux-raid@vger.kernel.org
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM:
Kernel 2.6.10 crashing repeatedly and hard)

On Wed, Jan 05, 2005 at 10:32:37AM -0800, Alvin Oga wrote:
> 
> hi ya andy
> 
> On Wed, 5 Jan 2005, Andy Smith wrote:
> 
> > > > Your recommendations
> > > 
> > > that'd be your comment ... that is not whati said above
> > 
> > Direct quote:
> > 
> >         i'd add more memory before i'd use raid
> 
> i see ... when i say "i would use" ... i dont mean or imply 
> others to do so ..

That is not a very useful thing to say in response to someone who
suggests using RAID mirrors for swap.

> > > and all i said, was use memory before you use swap on disks
> > 
> > Which means what?  Who is there on this list who likes to use swap
> > *before* physical memory?
> 
> you'd be surprized how many people wonder why their system is slow
> and they using 100% swap ( hundreds of MB of swap ) and little memory
> beause its $50 of expensive memory

What you said was (and I quoted it for you) "use memory before you
use swap".  I am asking you if this also is a useful thing to say,
because I was not aware there was anyone who would prefer to use
swap before memory.

Unless you simply mean "add more memory" which again would be a
strange thing to say in a discussion about putting swap on a RAID
mirror -> implies "always have enough RAM, configure no swap" but
since you seem to have a great objection to me trying to make sense
of what you're saying I won't go any further stating what I think
you imply.

> > Do all your machines which you believe have adequate memory also
> > have no swap configured?
> 
> yes .... in my machines .. they are all mostly tuned for specfic
> tasks ... very little ( say 0.05% swap usage even at peak )

So "no" then as I asked if your machines had any swap configured and
you reply that they use 0.05% at peak.  To use 0.05% they need to
have swap configured.

So your machines do have swap configured, that is what the question
was.

> > Fact is if your machine has swap configured then that swap is part
> > of your virtual memory and if a device that is providing part of
> > your virtual memory suddenly fails then your machine is going down.
> 
> yup...
> 
> and in some systems ... having swap ( too slow ) is NOT an option ... 
> 	( embedded systems, realtime operations, ... )

That's great but it's irrelevant to this discussion since the
situation discussed is swap on mirror or not.  Whether swap is
required or beneficial is an admin issue outside the scope of RAID.
We can assume that the admin ahs already determined that configuring
some amount of swap is required, otherwise we cannot assume anything
about their setup and will be telling them how to lay out their
filesystems, what distribution to use, etc. etc..  There are some
things that just don't need to be said and on a RAID list, "add more
memory, swap is slow" is IMHO one of them.

> 	== you should NEVER have swap problems
> 	== otherwise, toss that system out or salvage what you can
> 	==

If you use RAID-1 (-4, -5,- 10, etc.) then I think you are
acknowledging that your disks are a cause for concern for you.
Otherwise no one would be using RAID.  If you would not be willing
to say the following:

        you should NEVER have filesystem problems
        otherwise, toss that system out or salvage what you can

then I don't understand why you are willing to say it when it comes
to swap and not a filesystem.  Disks fail, it's why we're here on
this list.

> >  You are replying to add more memory and
> > don'trun things that can get swapped. 
> 
> you're twisting things gain

All I've got to work with is what you're giving me.  Direct quotes
of yours lead me to believe that these are your points.  In a
discussion about swap on RAID you have clearly stated to add more
RAM, use higher quality components, not run certain userland
processes.  If you say these things in a discussion about swap on
RAID then I'm left to believe either that you see these things as an
alternative to swap on RAID or else you are just posting irrelevant
basic admin tips that have nothing to do with linux RAID.

> > Those don't seem like very  useful recommendations.
> 
> that is becuase you're twisting things so you can make
> comments i didnt say

Then please explain yourself better using points that are relevant
to RAID using md on Linux.

> > > 	- and i don't think anybody is idiotic enough to add
> > > 	more memory for the "spikes" in the workload
> > 
> > OK so you must add swap to handle those spikes which means either
> > you are happy that your machine will crash should the device that
> > the swap is on die, or you use swap on a mirror to try to mitigate
> > that.
> 
> this is pointless isnt it ...
> 
> are you an idiot or what ..

It's possible to disagree and debate while still being civil.  If you
don't have that skill then I'm not willing to spend time teaching
you it.

> do you like to put words and recommendations that i didnt say
> and twist it in your favor 

No, I like understanding your point but at the moment all I can see
is basic unix admin recommendations that are unrelated to the
discussion at hand - you admit you have swap configured on your
servers so all the other stuff you have mentioned is irrelevant.  So
help me understand.

I don't understand how you intend to survive a disk failure
involving your swap unless you put it on a mirror or configure no
swap or never have a disk failure, ever, or intend to have downtime
when you do have a disk failure.

So help me understand.

> > From previous email (not a direct quote):
> > 
> >         Don't run lpd on user-accessible machine
> 
> you obviously do NOT understand where to run lpd and where
> to run dns and where to run pop and where to run ssh and where
> to run mta ... and on and on and on ...

You have no idea whether I do or do not know these things and on
this list you never will, because placement of these things is
irrelevant to linux raid.

> > If you do not suffer disk crashes then why do you use mirrors at
> > all?
> 
> i do NOT use mirrors for the protection against disk failures
> 
> nobody said i did .. you again are twisting things into your
> own ideas and misconceptions

Well indeed, if you never suffer disk failures as you go on to say
then I imagine you don't use mirrors for that..

> >  If you do suffer disk crashes then any disk that is providing
> > swap may very well cause the machine to crash.
> 
> i dont have that problem ...  but if someone ddid have that
> problem ... i assuem they are smart enough to figure out
> within 5-10 minutes why the disk/system is crashing

Such a person, if they were not as fortunate and/or skiled at
purchasing hardware as you appear to be, and so happened to suffer
the occasional disk failure, may wish that their system did not
crash and suffer 5 to 10 minutes of downtime because a disk failed.
They may wish that the device would just fail and they could
schedule a downtime or hot swap it.

If you are not one of those people (and, since you say you don't
have disk failures then you wouldn't be), it doesn't mean those
people don't exist and don't have a valid requirement.

> > I thought everyone suffered disk crashes and that was the point of
> > RAID.
> 
> not everybody suffers disk crashes ... in such great numbers
> that raid is better solution ...
> 	- raid is NOT theonly solution
> 
> == ever hear of high availability ...
> 	= clusters ...
> 	= even plain ole backups
> 
> there are more than one solution to one disk crashing

Is there any reason why someone could not use swap on raid as well
as any of the above as they see fit?  Maybe those who advocate swap
on raid already use high availablity and clusters.  And we'd
certainly hope they have backups.

