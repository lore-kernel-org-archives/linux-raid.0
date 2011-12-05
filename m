From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is this stupid?
Date: Mon, 5 Dec 2011 01:42:37 -0600
Message-ID: <89.AE.23309.EE57CDE4@cdptpa-omtalb.mail.rr.com>
References: <20111205170114.49cf7437@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111205170114.49cf7437@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, December 05, 2011 12:01 AM
> To: Leslie Rhorer
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Is this stupid?
> 
> On Sun, 4 Dec 2011 16:28:25 -0600 "Leslie Rhorer" <lrhorer@satx.rr.com>
> wrote:
> 
> > I have a system - one that is not expandable - that has relatively
> limited
> > RAM, comparatively speaking, and must boot from a usb stick.  The system
> > hosts a RAID array, but one cannot assume the RAID array is available
> when
> > the system boots.  IOW, I want to be able to take down the RAID array
> for
> > maintenance, possibly booting the system with no array created, at all.
> >
> > On the other hand, USB sticks have a limited number of writes available
> > before they fail, so I don't want the system to be thrashing the flash
> drive
> > any more than necessary.  At this time,  I have /var/run, /var/log,
> > /var/lock, and /tmp mounted as tmpfs file systems.  What I propose is to
> run
> > an init script that checks to see if the array is mounted, and if so
> appends
> > files in the aforementioned directories to existing directories on the
> array
> > and then remounts and binds the directories on the array.  The stop call
> in
> > the script will reverse the process so the system can shutdown or so I
> can
> > take the array offline after booting for maintenance.  Is this unwise?
> Am I
> > missing something crucial that might cause the system to blow up?
> 
> Sounds reasonably sane.
> 
> After the bind mount you would need to make sure any process with a file
> open in one of those directories re-opens the file.  So you might want to
> restart syslogd.

Yeah, I was intending to do that, along with any other processes that
require it.  'Basically do the same thing that logrotate does.

