From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Questions about software RAID
Date: Wed, 20 Apr 2005 11:26:28 +0200
Message-ID: <62b0912f05042002266bfef91d@mail.gmail.com>
References: <200504200415.j3K4FWm29946@www.watkins-home.com>
	 <42660BED.7000804@dgreaves.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42660BED.7000804@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Guy wrote:
> > Well, I agree with KISS, but from the operator's point of view!
> >
> > I want...
> [snip]
> 
> Fair enough.
[snip]
> should the LED control code be built into mdadm?

Obviously not.
But currently, a LED control app would have to pull information from
/proc/mdstat, right?
mdstat is a crappy place to derive any state from.
It currently seems to have a dual purpose:
 - being a simple textual representation of RAID state for the user.
 - providing MD state information for userspace apps.

That's not good.

There seems to be an obvious lack of a properly thought out interface
to notify userspace applications of MD events (disk failed --> go
light a LED, etc).

Please correct me if I'm on the wrong track, in which case the rest of
this posting will be bogus.  Maybe there are IOCTLs or such that I'm
not aware of.

I'm not sure how a proper interface could be done (so I'm basically
just blabbering).  ACPI has some sort of event system, but the MD one
would need to be more flexible.  For instance userspace apps has to
pick up on MD events such as disk failures, even if the userspace app
happens to not be running in the exact moment that the event occurs
(due to system restart, daemon restart or what not).  So the system
that ACPI uses is probably unsuited.

Perhaps a simple logfile would do.  It's focus should be
machine-readability (vs. human readability for mdstat).  A userspace
app could follow MD's state from the beginning (bootup, no devices
discovered, logfile cleared), through device discovery and RAID
assembly and to failing devices.  By adding up the information in all
the log lines, a userspace app could derive the current state of MD
(which disks are dead..).

Just a thought.
