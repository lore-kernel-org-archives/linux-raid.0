From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
  by user
Date: Fri, 7 Jan 2011 02:42:01 +0100
Message-ID: <20110107014200.GA28194@tango.0pointer.de>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
 <20110107003827.GD21627@tango.0pointer.de>
 <20110107121628.71146d21@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110107121628.71146d21@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrey Borzenkov <arvidjaar@gmail.com>, linux-raid@vger.kernel.org, SystemD Devel <systemd-devel@lists.freedesktop.org>
List-Id: linux-raid.ids

On Fri, 07.01.11 12:16, NeilBrown (neilb@suse.de) wrote:

> 
> On Fri, 7 Jan 2011 01:38:27 +0100 Lennart Poettering <lennart@poettering.net>
> wrote:
> 
> > On Sat, 04.12.10 11:41, Andrey Borzenkov (arvidjaar@gmail.com) wrote:
> > 
> > > If user starts array manually (mdadm -A -s as example) from within
> > > user session and array needs mdmon, mdmon becomes part of user session
> > > control group:
> > 
> > Are you suggesting that mdadm forks off mdmon from within the user
> > session? This is horribly ugly and broken and they shouldn't do that.
> 
> What alternative would you suggest?

Start it as a normal service like any other. But if you fork off the
daemon from the user session then the daemon will run in a very broken
context: the resource limits of the user apply, the audit trail will
point to the user (i.e. /proc/self/loginuid), the cgroup will be of the
user, the daemon cannot be supervised as every other daemon. Also, the
daemon will inherit all the other process properties from the user,
which is almost definitely wrong. i.e. the env block and so
on, the sig mask. gazillions of small little properties. Of course, a
big bunch of them you can reset in your code, but that's a race you
cannot win: the kernel adds new process properties all the time, and
you'd have to reset them manually.

It's is really essential that daemons are started from a clean process
environment, and are detached from the user session. SysV kinda provides
that, for everything started on boot and in a limited way for stuff
started via /sbin/service. systemd provides that too and much more
correct. But just forking off things just like that is not a good
solution.

A thinkable, relatively simple solution in a systemd world is to pull in
the mdmon service from the udev device. The udev device would do all the
necessary matching to figure out whether mdmon is needed or not. If you
care about non-systemd environments something like this of course
becomes a lot more complex.

> A daemon needs to be running while certain md arrays are running and writable.

Well, but auto-spawning it from the user session is not really a usable solution.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
