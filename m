From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: New raid level suggestion.
Date: Sun, 2 Jan 2011 22:33:20 -0600
Message-ID: <4D.AA.19545.091512D4@cdptpa-omtalb.mail.rr.com>
References: <20101230094230.GE2986@bitwizard.nl>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101230094230.GE2986@bitwizard.nl>
Sender: linux-raid-owner@vger.kernel.org
To: 'Rogier Wolff' <R.E.Wolff@BitWizard.nl>, 'Steven Haigh' <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Rogier Wolff
> Sent: Thursday, December 30, 2010 3:43 AM
> To: Steven Haigh
> Cc: Rogier Wolff; linux-raid@vger.kernel.org
> Subject: Re: New raid level suggestion.
> 
> On Thu, Dec 30, 2010 at 07:47:10PM +1100, Steven Haigh wrote:
> > Maybe I'm not quite understanding right, however you can easily do RAID6
> > with 4 drives. That will give you two redundant, effectively give you
> > RAID5 if I drive fails, and save buttloads of messing around...

	Theree's been quite a bit of back and forth in this thread.  I think
it would be best if you could more narrowly define your application.
Exactly what is this app doing?  Is it, as has been suggested, a web server?
How many transactions / second is it servicing at peak?  How large are the
files?  Is there some unusual .cgi script which causes huge amounts of disk
thrashing?  You might post the results of iostat.

> Steven, My friend has a server where the drives take up to a third of
> a second to respond.

	Respond to what?  I have a .cgi script that takes up to 30 seconds
to respond, but it's not because of any lack of array responsiveness.  It's
performing all sorts of investigations and calculations.  1/3of a second may
or may not be a terrible delay depending on what is going on, and the delay
may not be as a result of disk I/O.

> When asking for help, everybody pounced on us:
> - NEVER use raid5 for a server doing small-file-io like a mailserver.
>   (always use RAID10).

	Even a mailserver may not need anything radical in terms of disk
performance, depending on the number of users.  Again, you haven't
quantified the number of users the server is tending.

> So apparently RAID5 (and by extension RAID6) is not an option for some
> systems.
> 
> I'm willing to tolerate the RAID4 situation during the time that it
> takes me to replace the drive.

	A hot spare can certainly mitigate any windshield time, but before
anyone can really determine that RAID5 or RAID5 is not sufficient, one must
specify the actual service parameters.

