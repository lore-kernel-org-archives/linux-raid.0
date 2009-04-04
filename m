From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 4 Apr 2009 02:12:49 -0500
Message-ID: <20090404071250.NYQP28081.cdptpa-omta04.mail.rr.com@Leslie>
References: <d3305d5ff61b5cc8c487d475cd90f7f0.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3305d5ff61b5cc8c487d475cd90f7f0.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>This sounds like a filesys problem rather than a RAID problem.

I considered that.  It may well be.

>One thing that can cause this sort of behaviour is if the filesystem is in
>the middle of a sync and has to complete it before the create can
>complete, and the sync is writing out many megabytes of data.

For between 40 seconds and 2 minutes?  The drive subsystem can easily gulp
down 200 megabytes to 6000 megabytes in that period of time.  What synch
would be that large?  Secondly, the problem occurs also when there is
relatively little or no data being written to the array.  Finally, unless I
am misunderstanding at what layers iostat and atop are reporting the
traffic, the fact all drive writes invariably fall to dead zero during an
event and reads on precisely half the drives (and always the same drives)
drop to dead zero suggests to me this is not the case.


>You can see if this is happening by running

>     watch 'grep Dirty /proc/meminfo'

>if that is large when the hang starts, and drops down to zero, and the
>hang lets go when it hits (close to) zero, then this is the problem.

Thanks, I'll give it a try later today.  Right now I am dead tired, plus
there are some batches running I really don't want interrupted, and
triggering an event might halt them.

>The answer then is to keep that number low by writing a suitable
>number into
>   /proc/sys/vm/dirty_ratio   (a percentage of system RAM)
>or
>   /proc/sys/vm/dirty_bytes

Um, OK.  What would constitute suitable numbers, assuming it turns out to be
the issue?

>If that doesn't turn out to be the problem, then knowing how the
>"Dirty" count is behaving might still be useful, and I would probably
>look at what processes are in 'D' state, (ps axgu) and look at their
>stack (/proc/$PID/stack)..

I'll surely try that, too.

>You didn't say what kernel you are running.  It might make a difference.

>NeilBrown

Oh, sorry!  2.6.26-1-amd64  4G of RAM, with typically 600 - 800M in use.
The swap space is 4.7G, but the used swap space has never exceeded 200K.

