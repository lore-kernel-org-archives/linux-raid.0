From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Thu, 2 Apr 2009 18:01:12 -0500
Message-ID: <20090402230114.EFCO22375.cdptpa-omta01.mail.rr.com@Leslie>
References: <18900.27230.197006.570645@tree.ty.sabi.co.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18900.27230.197006.570645@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> The issue is the entire array will occasionally pause completely
>> for about 40 seconds when a file is created. [ ... ] During heavy
>> file transfer activity, sometimes the system halts with every
>> other file creation. [ ... ] There are other drives formatted
>> with other file systems on the machine, but the issue has never
>> been seen on any of the other drives.  When the array runs its
>> regularly scheduled health check, the problem is much worse. [
>> ... ]

>Looks like that either you have hw issues (transfer errors, bad
>blocks) or more likely the cache flusher and elevator settings have
>not been tuned for a steady flow.

That doesn't sound right.  I can read and write all day long at up to 450
Mbps in both directions continuously for hours at a time.  It's only when a
file is created, even a file of only a few bytes, that the issue occurs, and
then not always.  Indeed, earlier today I had transfers going with an
average throughput of more than 300 Mbps total and despite creating more
than 20 new files, not once did the transfers halt.

> How can I troubleshoot and more importantly resolve this issue?

>Well, troubleshooting would require a good understanding of file
>system design and storage subsystem design, and quite a bit of time.

>However, for hardware errors check the kernel logs, and for cache
>flusher and elevator settings check the 'bi'/'bo' numbers of
>'vmstat 1' while the pause happens.

I've already done that.  There are no errors of any sort in the kernel log.
Vmstat only tells me both bi and bo are zero, which we already knew.  I've
tried ps, iostat, vmstat, and top, and nothing provides anything of any
significance I can see except that resierfs is waiting on md, which we
already knew, and (as I recall - it's been a couple of weeks) the number of
bytes in and out of md0 falls to zero.

>For a deeper profile of per-drive IO run 'watch iostat 1 2' while
>this is happening. This might also help indicate drive errors (no
>IO is happening) or flusher/elevator tuning issues (lots of IO is
>happening suddenfly).

I'll give it a try.  I haven't been able to reproduce the issue today.
Usually it's pretty easy.

