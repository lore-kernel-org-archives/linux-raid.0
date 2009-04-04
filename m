From: Andrew Burgess <aab@cichlid.com>
Subject: RE: RAID halting
Date: Sat, 04 Apr 2009 08:04:17 -0700
Message-ID: <1238857457.16200.64.camel@cichlid.com>
References: <20090404143918.VANQ19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090404143918.VANQ19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2009-04-04 at 09:39 -0500, Lelsie Rhorer wrote:

> Well, diagnostically, I think the situation is clear.  All ten drives stop
> writing completely.  Five of the ten stop reading, and the other five slow
> their reads to a dribble - always the same five drives.

So the delay seems to be hiding in the kernel else the userspace tools
would see it (they see some kernel stuff too, like utilization)

Oprofile is supposed to be good for user and kernel profiling but I
don't know if it can find non-cpu bound stuff. There are also a bunch of
latency analysis tools in the kernel that were used for realtime tuning,
they might show where something is getting stuck. Andrew Morton did alot
of work in this area.

If the cpu was spinning somewhere it would show as system time so it
must be waiting for a timer or some other event (wild guessing). It's as
if the i/o completion never arrives but some timer eventually goes off
and maybe the i/o is retried and everything gets back on track? But that
should cause utilization to go up and you'd think some sort of
message... 

Perhaps the ide list would know of some diagnostic knobs to tweak.

It's a puzzler...

One last thing, the cpu goes toward 100% idle not wait?

