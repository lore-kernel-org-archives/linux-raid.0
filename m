From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Mon, 9 Jan 2006 09:00:06 +0100
Message-ID: <62b0912f0601090000l8eb613ci4c3b237805c77182@mail.gmail.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>
	 <17341.8541.33899.167524@smtp.charter.net>
	 <fd8d0180601050603t6f62ff91o@mail.gmail.com>
	 <17341.27534.41206.232976@smtp.charter.net>
	 <fd8d0180601060108rbe9d663p@mail.gmail.com>
	 <20060106104931.GB20546@atc5.vermine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060106104931.GB20546@atc5.vermine.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Majorel wrote:
> With LVM, you can create a snapshot of the block device at any
> time, mount the snapshot read-only (looks like another block
> device) and backup that. Ensuring consistency at application level
> is still up to you but at least, if that involves stopping
> services, the unavailability window is greatly reduced.

Hmm.  And 1 out of 10 times it will completely *nuke* your data.
Not just the new snapshot you've just created, mind you, but also the
volume you're snapshotting.

I'm talking from experience.  That's a "stable" version of LVM I'm
talking about, and it was a fresh install from the most recent RedHat
distro too.

A week ago I compiled my own version of kernel/device-mapper tools/lvm
from the newest sources I could find.  It didn't trash my data, but
1/4 times it created an unusable snapshot.

I've personally burn-in tested the hardware and there's absolutely no
problems there.  It's a standard server from HP, naturally not
overclocked or anything like that.

It's apparently a known fact that the code is wildly unstable, so stay
away from it if you happen to like your data :-).
