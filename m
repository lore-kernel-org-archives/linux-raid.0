From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: New raid level suggestion.
Date: Tue, 4 Jan 2011 16:29:07 +0100
Message-ID: <20110104152907.GN21618@bitwizard.nl>
References: <20101230094230.GE2986@bitwizard.nl> <4D.AA.19545.091512D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D.AA.19545.091512D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Rogier Wolff' <R.E.Wolff@BitWizard.nl>, 'Steven Haigh' <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 02, 2011 at 10:33:20PM -0600, Leslie Rhorer wrote:
> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Rogier Wolff
> > Sent: Thursday, December 30, 2010 3:43 AM
> > To: Steven Haigh
> > Cc: Rogier Wolff; linux-raid@vger.kernel.org
> > Subject: Re: New raid level suggestion.
> > 
> > On Thu, Dec 30, 2010 at 07:47:10PM +1100, Steven Haigh wrote:
> > > Maybe I'm not quite understanding right, however you can easily do RAID6
> > > with 4 drives. That will give you two redundant, effectively give you
> > > RAID5 if I drive fails, and save buttloads of messing around...

> 	Theree's been quite a bit of back and forth in this thread.  I think
> it would be best if you could more narrowly define your application.
> Exactly what is this app doing?  Is it, as has been suggested, a web server?

App? Yes, its' a web/mail server for a few small domains.

> How many transactions / second is it servicing at peak?

Not all that many. It handles a few thousand Emails a day. 

>   How large are the
> files?  

Emails? A few kb. Maybe 10kb on average. 

> Is there some unusual .cgi script which causes huge amounts of disk
> thrashing?  You might post the results of iostat.

No.

> > Steven, My friend has a server where the drives take up to a third of
> > a second to respond.
> 
> 	Respond to what?

Read what I wrote. The DISK DRIVE takes up to a third of a second to
respond to an IO request.

iostat reports this when started with the -x option. 

When the DISK takes a third of a second to respond, the load can
skyrocket to say 20. You'll then find that 18 of those are in the
queue waiting for one of the disks, giving an average waiting time for
the result of the io request (thus queue + service time of the disk)
of around 6 seconds. That's when the server feels laggy.... You type a
command, some of the data needs to come from that drive, and then it
takes up to 6 seconds for the results to come back.

I have been running iostat -x on several different machines and
webservers and none of the disks happen to take more than 20ms to
respond to an IO request.

There is something wrong with that machine. Although some have
suggested that the RAID config is not ideal for high throughput, it
should work reasonably for this low-performance server. Although some
have suggested that these disks are not ideal for this load, they
should be able to respond to IO requests at a higher rate than 3 per
second.

I do not think the drives are bad. I expect to be able to test the
drives at high throughput and high IO-rate once the server is replaced
by a new server.

I suspect that something is wrong with the machine. Something like
interrupts for "IO DONE" for the sata controllers not getting
delivered immediately. However everybody so far has been shouting: 
bad disks! bad raid config!

> I have a .cgi script that takes up to 30 seconds to respond, but
> it's not because of any lack of array responsiveness.  It's
> performing all sorts of investigations and calculations.  1/3of a
> second may or may not be a terrible delay depending on what is going
> on, and the delay may not be as a result of disk I/O.

We measure delays of up to tens of seconds for things that should take
less than a tenth of a second, and we've narrowed it down to the disks
being slow to respond.

> > When asking for help, everybody pounced on us:
> > - NEVER use raid5 for a server doing small-file-io like a mailserver.
> >   (always use RAID10).
> 
> 	Even a mailserver may not need anything radical in terms of disk
> performance, depending on the number of users.  Again, you haven't
> quantified the number of users the server is tending.

On a different server, there are 7 users. 18k Emails/day. 
This server I think about 10 times more users, 1k Emails/day. 

So why do you want to know the number of users? The number of Emails
is relevant.

> > So apparently RAID5 (and by extension RAID6) is not an option for some
> > systems.
> > 
> > I'm willing to tolerate the RAID4 situation during the time that it
> > takes me to replace the drive.
 
> A hot spare can certainly mitigate any windshield time, but before
> anyone can really determine that RAID5 or RAID5 is not sufficient,
> one must specify the actual service parameters.

Hmm. This seems to be in response to my plan of a new raid config.  On
a different mailing list we've had tons of useless discussions about
how wrong that machine was configured after I asked if someone knew
how to find out why the disks were taking so long to respond.

This seems to be moving in the same direction.  In this thread I'm NOT
fishing for help with that server. (Although if you know of a way how
to figure out why those disks (seem to) respond so slowly you're
welcome). 

What this is about is: 

People suggest that RAID 5 is not appropriate for a medium-to-high
traffic mailserver, so you'd run raid 10. 

However, running RAID10 has the disadvantage that when one disk fails,
you're open to dataloss with a large window if it takes you up to a
week to replace the failed drive. (which is typical in my and my
friends case, and it's acceptable for me and my friends application)

So what I suggested is that once you have a setup where you're happy
with only half the total disk space, you can run RAID10 for speed, and
convert to RAID4 after one disk fails. This in practice would cover
about 98% of the time between the disk failing and the replacement
disk arriving, reducing the chances of "dataloss" by about 50 fold.

You'll have less performance with the downed drive, but it's much
better to have good performance 99% of the time (when you have 4/4
disks) and bad performance during 1% of the time (when you have only
3/4 disks available) than having bad performance all the time (because
of the bad write performance of raid5 and raid6.)

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
