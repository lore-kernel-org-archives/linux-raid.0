From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Tue, 29 Mar 2011 13:52:15 +0200
Message-ID: <201103291352.15797.thomas.jarosch@intra2net.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com> <201103291153.06495.thomas.jarosch@intra2net.com> <20110329100744.GK6736@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110329100744.GK6736@htj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Tuesday, 29. March 2011 12:07:44 Tejun Heo wrote:
> > I'll put the box in a reboot loop over the lunch break.
> 
> Hmmm.. interesting, so no RT task there.  I don't know why the
> softlockup is triggering then.  Ah, okay, none of CONFIG_PREEMPT and
> CONFIG_PREEMPT_VOLUNTARY is set, right?

"grep PREEM .config" shows:

# CONFIG_PREEMPT_RCU is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set

You were right :)

> Anyways, the root cause here is that md_open() -ERESTARTSYS retrying
> is busy looping without giving the put path a chance to run.  When it
> was using flush_scheduled_work(), there were some unrelated work items
> there so it ended up sleeping by accident giving the put path a chance
> to run.  With the conversion, the flush domain is reduced and there's
> nothing unrelated to wait for so it just busy loops.

The test box survived 52 reboots without a hickup. When we come up with a 
final solution, I'm going to let that reboot loop run over night
to be on the safe side.

Thanks!

The HP Proliant ML110 G6 issue seemes unrelated to this one
as I can reproduce the slowdown issue also with 2.6.36.
I also don't think it's md related as the box is only slow
over the network (igb driver) and fast on the console.
So it must be something else. Crap, two issues to hunt down :o)

Thomas
