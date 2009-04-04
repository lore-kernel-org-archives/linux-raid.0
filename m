From: Andrew Burgess <aab@cichlid.com>
Subject: RE: RAID halting
Date: Sat, 04 Apr 2009 09:39:24 -0700
Message-ID: <1238863164.16200.71.camel@cichlid.com>
References: <20090404151557.VWAG19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090404151557.VWAG19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2009-04-04 at 10:15 -0500, Lelsie Rhorer wrote:

> > Oprofile is supposed to be good for user and kernel profiling but I
> > don't know if it can find non-cpu bound stuff. There are also a bunch of
> > latency analysis tools in the kernel that were used for realtime tuning,
> > they might show where something is getting stuck. Andrew Morton did alot
> > of work in this area.
> 
> Do you know if he subscribes to this list?  If not, how may I reach him?

He's on the kernel list which I seldom read nowadays. His email used to
be akpm@something I think.

He worked on ftrace, documented in the kernel source
in /usr/src/linux/Documentation/ftrace.txt

An excerpt:

"Ftrace is an internal tracer designed to help out developers and
designers of systems to find what is going on inside the kernel.
It can be used for debugging or analyzing latencies and performance
issues that take place outside of user-space.

Although ftrace is the function tracer, it also includes an
infrastructure that allows for other types of tracing. Some of the
tracers that are currently in ftrace include a tracer to trace
context switches, the time it takes for a high priority task to
run after it was woken up, the time interrupts are disabled, and
more (ftrace allows for tracer plugins, which means that the list of
tracers can always grow)."


