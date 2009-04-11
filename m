From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Fri, 10 Apr 2009 20:37:29 -0500
Message-ID: <20090411013735.VDNG2520.cdptpa-omta04.mail.rr.com@Leslie>
References: <49DF666A.7030603@tmr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DF666A.7030603@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > Something very disturbing is happening now, however.  Just a few minutes
> > after loading oprofile, the system did a sudden total shutdown.  The
> file
> > systems were all left dirty, and power was suddenly cut to the main
> chassis.
> > This has never happened before.  I rebooted the system, and the file
> systems
> > replayed their journals.  Some data was lost, of course, but nothing
> > serious.  A few hours later, the exact same thing happened again:  A
> sudden
> > shut-down.  Nothing like this has ever happened before.  Of course the
> > system can issue a power shutdown from software, but it is supposed to
> clean
> > up the file systems first, and it's not supposed to just do it
> autonomously.
> >
> 
> Just for grins, is this system by any chance on a UPS? Because I found
> an interesting failure mode if that's the case.

Yeah, you bet.  Indeed, the first thing I considered was a false Low Battery
indication causing the system to shut down, but in that case it should have
been a clean shut-down.

