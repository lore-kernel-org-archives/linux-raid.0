From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Tue, 8 Feb 2011 10:48:43 +0100
Message-ID: <20110208094843.GD11446@tango.0pointer.de>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
 <201012041012.23757.trapni@gentoo.org>
 <AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
 <20101204121413.GC11336@mother.pipebreaker.pl>
 <AANLkTi=nTSdHc55f08G9sdEK6u8eXp276VOTHHr0jmXT@mail.gmail.com>
 <20110125034434.GC7046@tango.0pointer.de>
 <AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
 <20110125042814.GA9727@tango.0pointer.de>
 <AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 04.02.11 22:55, Andrey Borzenkov (arvidjaar@mail.ru) wrote:

> >> That's right, but the names are not known in advance and can change
> >> between reboots. This means such units have to be generated
> >> dynamically, exist until reboot (ramfs?) and be removed when array is
> >> destroyed. Not sure it is really manageable.
> >
> > Hmm? It should be sufficient to just write the service template properly
> > ("mdmon@.service") and then instantiate it when needed with "systemctl
> > start mdmon@xyz.service" or something equivalent. itMs a matter of
> > issuing a single dbus call.
> >
> >> And which instance should generate them? mdadm?
> >
> > i think it is much nicer to spawn the necessary mdadm service instance
> > from a udev rule,
> 
> Yes, this can be done relatively easily; as proof of concept:
> 
> SUBSYSTEM!="block", GOTO="systemd_md_end"
> ACTION!="change", GOTO="systemd_md_end"
> KERNEL!="md*", GOTO="systemd_md_end"
> ATTR{md/metadata_version}=="external:[A-Za-z]*", RUN+="/bin/systemctl
> start mdmon@%k.service"
> LABEL="systemd_md_end"

Nah, it's much better to simply use the SYSTEMD_WANTS var on the device.

Something like this:

...., ENV{SYSTEMD_WANTS}="mdmon@%k.service"

That way the device unit will simply have a wants dep on the service
unit, and this is prefectly discoverable.

> Setting SYSTEMD_WANTS would be more elegant solution, but it does not
> work with current systemd implementation. It is capable of starting
> requested units only on "add" event (effectively the very first time
> device becomes plugged), while mdmon must be started on "change"
> event, as only then we know whether mdmon is required at all.

Oha, so you are actually aware of SYSTEMD_WANTS. Hmm. I need to think
about this. Why does md employ the change event? Is this really
necessary, smells a bit foul.

> Running mdmon via systemd in this way opens up interesting
> possibility. E.g. service could be declared "immortal" and be exempt
> from usual shutdown sequence ... or is it possible to do already?

A service needs to conflict with shutdown.target to be shut down when we
go down normally. If your service does not conflict with shutdown.target
then it will stay around and be killed only after systemd is gone and
PID1 is systemd-shutdown which then kills all processes remaining
(independent of any idea of "service") and the unmounts all file
systems. Normally all services conflict with shutdown.target implicitly,
which you can turn off by setting DefaultDependencies=.

> Actually it can be implemented even without mdadm patches; apparently
> it is possible to suppress normal starting of mdmon by setting
> MDADM_NO_MDMON=1

A this point mdmon is simply broken: if glibc or mdmon itself (or any
lib it is using) is upgraded, then mdmon will keep referencing the old
.so or binary as long as it is running. This means that the fs these
files are on cannot be remounted r/o. However mdmon insists on being
shutdown only after all fs got remounted ro. So you have a cyclic
ordering loop here: mdmon wants to be shut down after the remount, but
we need to shut it down before the remount. 

This is unfixable unless a) mdmon learns reexecution of itself without
losing state (like most init systems so), or b) mdmon would stop
insisting on being shutdown only after the remount.

In my eyes b) is very much preferebale: It should be possible to shut
down mdmon like any other service. And if then some md related code
still needs to be run on late shutdown this should be done from a new
process. I would be willing to add some hooks for this, so that we can
execute arbitrary drop-in processes as part of the final shutdown loop.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
