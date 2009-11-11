From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 02:53:24 -0600
Message-ID: <20091111085333854.MDRZ6968@cdptpa-omta02.mail.rr.com>
References: <4877c76c0911110019u42b6f664r22c31a8d8c78586@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911110019u42b6f664r22c31a8d8c78586@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> That kind of exception is one of the main areas I think major dists
> fail.  Making it so absolutely difficult to insert administratively
> know requirements at 'odd' points in the boot order.  When I last used
> Debian it was easy with that S## / K## linking system.

	I agree.  It may not be the fastest or the most "sexy" method, but
it is solid, simple, and easy to manage, the oddness I discovered this
evening notwithstanding.  (The backup server doesn't have the issue, only
the main video server did.  I simply erased the "duplicate" links, so now
RAID is started at boot and the monitor is started on entry to runlevel 2 -
5.)

>  Arch is
> another dist that has a way of doing that, except it's based in a core
> config file.  I like Debian's method more because then you can use
> shell scripts to easily slice/dice/add things at given points.  Arch
> is more than sufficient for normal tasks though.

	The main reason I like Debian is it stays well away from the
bleeding edge.  Most distros have a stable and an unstable version, and some
have a testing version.  Debian has experimental, testing, unstable, and
stable, and its testing version is more like what most distros call their
stable version.  I do really like the approach Debian takes to its booting.
It's really easy to troubleshoot a booting issue.  Making changes to the
boot sequence often doesn't even require editing any files.  One can simply
rename a link to a higher or lower number to move it about in the boot
sequence, or rename it from Sxxyyy to Kxxyyy to disable it.

	It took me less than 3 minutes total to implement the explicit mount
routine on both servers, and unless someone can give me either a much better
solution or a solid reason I should not take this approach, I think I'm
going to stay with it until such time as I either re-format the root
partition or else re-format the array on either respective system.  I don't
expect the former on either system any time soon.  I expect to do the latter
on one of the arrays some time in the next three or four months, and the
other within a year or so, at which point I may choose the internal bitmap.
I don't know, though.  I think I rather prefer the external bitmap.

