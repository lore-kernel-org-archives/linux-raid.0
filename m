From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: possible deadlock through raid5/md
Date: Sun, 15 Oct 2006 22:06:51 +0200
Message-ID: <200610152006.k9FK6pt28846@inv.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

While travelling the last few days, a theory has occurred to me to
explain this sort of thing ...


>  A user has sent me a ps ax output showing an enbd client daemon
>  blocked in get_active_stripe (I presume in raid5.c).
> 
>     ps ax -of,uid,pid,ppid,pri,ni,vsz,rss,wchan:30,stat,tty,time,command
> 
>     F   UID   PID  PPID PRI  NI   VSZ  RSS WCHAN STAT TT TIME COMMAND
>     5     0 26540     1  23   0  2140 1048 get_active_stripe Ds   ?  00:00:00 enbd-client iss04 1300 -i iss04-hdd -n 2  -e -m -b 4096 -p 30 /dev/ndl


Suppose that memory is full of dirty buffers and that the _transport_
for the medium on which one of the raid disks is running (in this case
tcp, under enbd and elsewhere) needs buffers.  It needs buffers both to
read and write.  But there are none available so the call through the
user process which wants to use the transport causes the kernel to try
and free pages.

That causes the user process to end up in the kernel routines which try
and flush devices to disk, and through them in the various (request?)
functions of device drivers, and perhaps even in raid5's
get_active_stripe.

However, if that stripe is on a remote disk availale through tcp, then
tcp is blocked by lack of the resources that are trying to be freed, so
we are in deadlock?


Sound plausible? Cure ought to be to keep some kernel memory available
for tcp that is not available to dirty buffers.

Peter

