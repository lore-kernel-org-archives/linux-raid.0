From: Doug Ledford <dledford@redhat.com>
Subject: Re: Good news / bad news - The joys of RAID
Date: Tue, 30 Nov 2004 22:34:31 -0500
Message-ID: <1101872071.3815.135.camel@compaq-rhel4.xsintricity.com>
References: <200411192142.iAJLgRN12792@www.watkins-home.com>
	 <41A9CF7E.4000804@robinbowes.com>
	 <16811.54622.500830.508054@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16811.54622.500830.508054@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Robin Bowes <robin-lists@robinbowes.com>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2004-11-30 at 13:05 +1100, Neil Brown wrote:
> On Sunday November 28, robin-lists@robinbowes.com wrote:
> > Guy wrote:
> > > I use mdadm's monitor mode to send me email when events occur.
> > 
> > Guy,
> > 
> > I've been meaning to write this for a while...
> > 
> > I tried monitoring once but had a problem when shutting down as the 
> > arrays were reported as "busy" because mdadm --monitor was running on 
> > them. I guess it needs to be killed earlier in the shutdown process.
> 
> That bug was fixed in mdadm 1.6.0
> 
> NeilBrown
> 
> 
>  From the ChangeLog:
> Changes Prior to 1.6.0 release
> ...
>     -   Fix bug in --monitor where an array could be held open and so
> 	could not be stopped without killing mdadm.
> ...

If I recall correctly, this fixes the primary symptom, but not the whole
problem.  When in --monitor mode, mdadm will reopen each device every 15
seconds to scan its status.  As such, a shutdown could still fail if
mdadm is still running and the timing is right.  In that instance,
retrying the shutdown on failure would likely be enough to solve the
problem, but that sounds icky to me.  Would be much better if mdadm
could open a control device of some sort and query about running arrays
instead of opening the arrays themselves.

-- 
  Doug Ledford <dledford@redhat.com>
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606

