From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID5 crash and burn
Date: Mon, 1 Nov 2004 02:01:21 -0500
Message-ID: <200411010701.iA171QN31414@www.watkins-home.com>
References: <Pine.LNX.4.44.0411010106290.17633-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0411010106290.17633-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>, 'Nathan Dietsch' <njd@ndietsch.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You said:
"swapouts mean that the kernel doesn't need to dedicate a page of 
physical memory to keep track of some stale page.  swapping out 
active pages would be mistake, obviously.  the kernel tries to 
avoid that mistake in any OS."

Any OS!  MS NT 2000 and XP favor disk cache over all running programs.  If
you leave your computer during a virus scan, or disk backup, when you come
back everything has been swapped, all windows are very slow to respond.  My
system has 1 Gig of ram.  With 300-400Meg used, the disk cache can grow to
700-600 Meg.  But it goes well beyond that!  Well, maybe you don't consider
NT, 2000 or XP as operating systems!  :)

Back to swapping.  I can't think how swapping could be better than having
enough memory.

In my example, I did not have enough memory.  The system was very very slow.
But CPU usage was only 10-20% since everything runnable was sitting out on
disk.  Once I added enough swap spindles, the system was able to swap fast
enough to utilize most of the CPU, which was about 90% or more.  This made
the users happy, it was like a new computer.  But if I was able to add more
memory the system would have been even faster.  The memory was added at some
point.  And swapping stopped, or at least most of it stopped.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Monday, November 01, 2004 1:33 AM
To: Nathan Dietsch
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID5 crash and burn

>  From Understanding the Linux Kernel "Every access by a program to a 
> page that is swapped out increases the process execution time by an 
> order of magnitude. In short, if performance is of great importance, 
> swapping should be considered as a last resort." (p. 529)

not relevant: we're talking about what it costs to perform
a swapout, not what happens if the wrong page is chosen for 
swapout, and later necessitates a swapin.

> I agree that the write is cheap compared to the read (where you will 
> stall), but what is the purpose of writing something to swap if you do 
> not plan to read it again?

to free the underlying physical page for other use.

> >let me put it a completely other way: swap outs are normal, fairly
> >frequent, and GOOD for performance. 
> >
> Please explain how swapping out a page is good for performance.

swapouts mean that the kernel doesn't need to dedicate a page of 
physical memory to keep track of some stale page.  swapping out 
active pages would be mistake, obviously.  the kernel tries to 
avoid that mistake in any OS.

> I understand that unused pages are paged out, but how does this improve 
> performance beyond making more room for the FS cache?

a swapout frees a physical page, period.  whether it's used for 
the FS cache or not is irrelevant.  perhaps your model for how 
the system works involves uniform references to all pages?
if that were true, then indeed, swapouts would be dubious.
since references are highly skewed, there are some pages which
are not effective investments of physical ram, so to speak,
but which can't be thrown away (because they're dirty and/or anonymous).

> I am simply saying that comparing RAID5 and RAID1 for the purposes of 
> swapping is irrelevant, because if you are relying on the performance of 
> your swap device, you are missing the point that you have run out of 
> memory.

which is either vapid or wrong.  yes, it's silly to worry about 
how fast your system thrashes.  but no one is talking about non-fatal error
conditions like thrashing.  and there *is* a good reason to choose 
r1 over r5 for swap, since writes are so much lower-overhead.  worrying
about the efficiency of r1 vs r5 reads verges on the "optimizing 
for thrashing" that you're so worried about.

> [0] Some longer running tasks (like batch jobs), that do not have 
> performance limitations can afford to swap.

interesting way to think of it, since you're assuming that systems 
will always have as much memory as they can possibly use.  all real
systems have "memory pressure", which leads the VM to attempt top
optimize which needs consume the limited, inadequate number of physical 
pages.  swapouts are nothing more than the kernel trying to find a 
better (hotter) use for a page.  pure capacity swapouts aren't really
interesting, since there's really nothing you can do about them.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

