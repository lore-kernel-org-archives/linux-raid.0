From: "NeilBrown" <neilb@suse.de>
Subject: Re: Strange filesystem slowness with 8TB RAID6
Date: Thu, 2 Apr 2009 15:38:11 +1100 (EST)
Message-ID: <d3305d5ff61b5cc8c487d475cd90f7f0.squirrel@neil.brown.name>
References: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, April 2, 2009 3:16 pm, Lelsie Rhorer wrote:

> The issue is the entire array will occasionally pause completely for about
> 40 seconds when a file is created.  This does not always happen, but the
> situation is easily reproducible.  The frequency at which the symptom
> occurs seems to be related to the transfer load on the array.  If no other
> transfers are in process, then the failure seems somewhat more rare,
> perhaps accompanying less than 1 file creation in 10..  During heavy file
> transfer activity, sometimes the system halts with every other file
> creation.  Although I have observed many dozens of these events, I have
> never once observed it to happen except when a file creation occurs.
> Reading and writing existing files never triggers the event, although any
> read or write occurring during the event is halted for the duration.
...

> How can I troubleshoot and more importantly resolve this issue?

This sounds like a filesys problem rather than a RAID problem.

One thing that can cause this sort of behaviour is if the filesystem is in
the middle of a sync and has to complete it before the create can
complete, and the sync is writing out many megabytes of data.

You can see if this is happening by running

     watch 'grep Dirty /proc/meminfo'

if that is large when the hang starts, and drops down to zero, and the
hang lets go when it hits (close to) zero, then this is the problem.
The answer then is to keep that number low by writing a suitable
number into
   /proc/sys/vm/dirty_ratio   (a percentage of system RAM)
or
   /proc/sys/vm/dirty_bytes

If that doesn't turn out to be the problem, then knowing how the
"Dirty" count is behaving might still be useful, and I would probably
look at what processes are in 'D' state, (ps axgu) and look at their
stack (/proc/$PID/stack)..

You didn't say what kernel you are running.  It might make a difference.

NeilBrown

