From: Joshua Kinard <kumba@gentoo.org>
Subject: Problem w/ commit ac8fa4196d20 on older, slower hardware
Date: Mon, 5 Oct 2015 03:41:39 -0400
Message-ID: <561229B3.4050101@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Per commit ac8fa4196d20:

> md: allow resync to go faster when there is competing IO.
> 
> When md notices non-sync IO happening while it is trying to resync (or
> reshape or recover) it slows down to the set minimum.
> 
> The default minimum might have made sense many years ago but the drives have
> become faster. Changing the default to match the times isn't really a long
> term solution.

This holds true for modern hardware, but this commit is causing problems on
older hardware, like SGI MIPS platforms, that use mdraid.  Namely, while trying
to chase down an unrelated hardlock bug on an Onyx2, one of the arrays got out
of sync, so on the next reboot, mdraid's attempt to resync at full speed
absolutely murdered interactivity.  It took close to 30mins for the system to
finally reach the login prompt.

Revert this patch was working to mitigate the problem at first, but it appears
that in recent kernels, this is no longer the case, and reverting this commit
has no noticeable effect anymore.  I assume I'd have to hunt down newer commits
to revert, but it's probably saner to just highlight the problem and test any
proposed solutions.

Is there some way to resolve this in such a way that old hardware maintains
some level of interactivity during a resync, but that won't inconvenience the
more modern systems?

http://git.linux-mips.org/cgit/ralf/linux.git/commit/?id=ac8fa4196d20

Thanks!,

--J
