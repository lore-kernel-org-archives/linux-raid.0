From: Derek Piper <derek.piper@gmail.com>
Subject: Joys of spare disks!
Date: Tue, 8 Mar 2005 12:15:49 -0500
Message-ID: <eaa6dfe05030809151a675209@mail.gmail.com>
References: <422547B8.4090907@wasp.net.au>
	 <200503020553.j225ru513677@www.watkins-home.com>
	 <eaa6dfe0503080915276466a1@mail.gmail.com>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <eaa6dfe0503080915276466a1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Heh.. I too have Seagate drives and have RMA'd even the drive they
sent back to replace the one I RMA'd a month or so ago. Normally
they're great, so I'm hoping the next replacement will fair better.

The one they sent back had more than 10000 unrecoverable sector errors
(!) according to smartctl by the time I RMA'd it (the first one, my
original drive, that I sent back had 3). It failed its self-tests and
all of Seagate's SeaTools tests too. The drive wasn't mishandled by
me, although I thought Seagate's own packaging looked a bit crap (two
pieces of black plastic suspending the drive within a plastic 'shell'
(the so called 'SeaShell' :>) within the box. No peanuts or bubble
wrap or anything else. Still, the drive worked at first and then
within 48hrs had problems.

I have other Seagate drives that have been run for over 15000 without
a single even reallocated bad sector. I might have to try Peter's
patch though, since I am running them in RAID-1.

Derek

/trying to un-lurk on the list (i.e. read the 120 threads that have
appeared since I forgot about checking my gmail account)

On Wed, 2 Mar 2005 00:53:51 -0500, Guy <bugzilla@watkins-home.com> wrote:
> That has not been my experience, but I have Seagate drives!
>
> Guy
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
> Sent: Tuesday, March 01, 2005 11:57 PM
> To: Robin Bowes
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Joys of spare disks!
>
> Robin Bowes wrote:
>
> > Thanks to some advice from Guy the "failed" disk is now back up and
> > running.
> >
> > To fix it I did the following;
> >
> <snip>
>
> Just watch that disk like a hawk. I had two disks fail recently in the same
> way, I did exactly what
> you did and 2 days later they both started to grow defects again and got
> kicked out of the array. I
> RMA'd both of them last week as they would not stay stable for more than a
> day or two after
> re-allocation.
>
> Regards,
> Brad
> --
> "Human beings, who are almost unique in having the ability
> to learn from the experience of others, are also remarkable
> for their apparent disinclination to do so." -- Douglas Adams
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
Derek Piper - derek.piper@gmail.com
http://doofer.org/


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
