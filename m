From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Mon, 9 Jan 2006 08:16:17 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601090809510.4480@lion.drogon.net>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
 <fd8d0180601050106s5f5b4306o@mail.gmail.com>  <17341.8541.33899.167524@smtp.charter.net>
  <fd8d0180601050603t6f62ff91o@mail.gmail.com>  <17341.27534.41206.232976@smtp.charter.net>
  <fd8d0180601060108rbe9d663p@mail.gmail.com>  <20060106104931.GB20546@atc5.vermine.org>
 <62b0912f0601090000l8eb613ci4c3b237805c77182@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0601090000l8eb613ci4c3b237805c77182@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Jan 2006, Molle Bestefich wrote:

> Andre Majorel wrote:
> > With LVM, you can create a snapshot of the block device at any
> > time, mount the snapshot read-only (looks like another block
> > device) and backup that. Ensuring consistency at application level
> > is still up to you but at least, if that involves stopping
> > services, the unavailability window is greatly reduced.
>
> Hmm.  And 1 out of 10 times it will completely *nuke* your data.
> Not just the new snapshot you've just created, mind you, but also the
> volume you're snapshotting.
>
> I'm talking from experience.  That's a "stable" version of LVM I'm
> talking about, and it was a fresh install from the most recent RedHat
> distro too.

I was bitten with LVM some time back (maybe 18 months to 2 years) and then
I didn't have time to track down the real cause, so resorted to just
doubling up on disk space (disk is cheap!) and running a nightly rsync to
create/update the snapshot (and you can make several days worth too with
some cleverness and not much more disk space), then dumping the snapshot
to tape... The 3-400GB volumes I have take less than an hour for the rsync
so it's not a big impact in the middle of the night. (Servers I'm dumping
to tape don't have more than about 400GB partitions to fit it all onto one
300/600 DLT tape)

Since then (nearly) all the big servers I've built have been this way -
double the anticipated disk space and either snapshotting to themselves,
or over the 'net to another box on the same LAN. Saves all that faffing
about when luser asks you to restore a file/dir from tape that they've
accidentally deleted. I keep the 'archive' partition read-only through the
day, so that keeps it sane too.

Gordon
