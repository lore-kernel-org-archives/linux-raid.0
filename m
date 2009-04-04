From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 4 Apr 2009 12:05:58 -0500
Message-ID: <20090404170600.YFXC19140.cdptpa-omta03.mail.rr.com@Leslie>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> One thing that can cause this sort of behaviour is if the filesystem is in
> the middle of a sync and has to complete it before the create can
> complete, and the sync is writing out many megabytes of data.
> 
> You can see if this is happening by running
> 
>      watch 'grep Dirty /proc/meminfo'

OK, I did this.

> if that is large when the hang starts, and drops down to zero, and the
> hang lets go when it hits (close to) zero, then this is the problem.

No, not really.  The value of course rises and falls erratically during
normal operation (anything from a few dozen K to 200 Megs), but it is not
necessarily very high at the event onset.  When the halt occurs it drops
from whatever value it may have (perhaps 256K or so) to 16K, and then slowly
rises to several hundred K until the event terminates.

> If that doesn't turn out to be the problem, then knowing how the
> "Dirty" count is behaving might still be useful, and I would probably
> look at what processes are in 'D' state, (ps axgu)

Well, nothing surprising, there.  The process(es) involved with the
transfer(s) are dirty (D+), as well as the trigger process (for testing, I
simply copy /etc/hosts over to a directory on the RAID array), and pdflush
had a D state (no plus), but that's all.

> and look at their stack (/proc/$PID/stack)..

Um, I thought I knew what you meant by this, but apparently not.  I tried to
`cat /proc/<PID of the process with a D status>/stack`, but the system
returns "cat: /proc/8005/stack: No such file or directory".  What did I do
wrong?

