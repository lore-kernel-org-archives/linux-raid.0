From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --monitor
Date: Fri, 17 May 2002 16:59:31 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15588.43603.518843.477359@notabene.cse.unsw.edu.au>
References: <15587.34271.342444.898591@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.30.0205170842220.22765-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Danilo Godec on Friday May 17
To: Danilo Godec <danci@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 17, danci@agenda.si wrote:
> On Thu, 16 May 2002, Neil Brown wrote:
> 
> > > [root]# cat /usr/local/sbin/raidalert:
> > >
> > > #!/bin/bash
> > > #
> > > #
> > >
> > > logger -p kern.crit -t RAID
> > >
> >
> >
> > Try
> >    logger -p kern.crit -t RAID $*
> >
> > the program doesn't get anything on stdin.  I just gets 2 or three
> > command-line arguments.
> 
> Oh, I see! Yes, this way it does work... :)
> 
> Maybe you should explain this explicitly or even add the above example to
> the docs.
> 
>   D.
> 

The documentation in mdadm.conf.5 seems suitably explicit:

The
.B program
line gives the name of a program to be run when
.B "mdadm --monitor"
detects potentially interesting events on any of the arrays that it
is monitoring.  This program gets run with two or three arguments, they
being the Event, the md device, and possibly the related component
device.


mdadm.8 however doesn't seem explicit at all :-(
I have added:

When passing event to program, the program is run once for each event
and is given 2 or 3 command-line arguements.  The first is the
name of the event (see below).  The second is the name of the
md device which is affected, and the third is the name of a related
device if relevant, such as a componenet device that has failed.

just after


The result of monitoring the arrays is the generation of events.
These events are passed to a separate program (if specified) and may
be mailed to a given E-mail address.


Thanks,
NeilBrown
