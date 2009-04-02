From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re:
Date: Thu, 2 Apr 2009 08:33:50 +0100
Message-ID: <18900.27230.197006.570645@tree.ty.sabi.co.uk>
References: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> The issue is the entire array will occasionally pause completely
> for about 40 seconds when a file is created. [ ... ] During heavy
> file transfer activity, sometimes the system halts with every
> other file creation. [ ... ] There are other drives formatted
> with other file systems on the machine, but the issue has never
> been seen on any of the other drives.  When the array runs its
> regularly scheduled health check, the problem is much worse. [
> ... ]

Looks like that either you have hw issues (transfer errors, bad
blocks) or more likely the cache flusher and elevator settings have
not been tuned for a steady flow.

> How can I troubleshoot and more importantly resolve this issue?

Well, troubleshooting would require a good understanding of file
system design and storage subsystem design, and quite a bit of time.

However, for hardware errors check the kernel logs, and for cache
flusher and elevator settings check the 'bi'/'bo' numbers of
'vmstat 1' while the pause happens.

For a deeper profile of per-drive IO run 'watch iostat 1 2' while
this is happening. This might also help indicate drive errors (no
IO is happening) or flusher/elevator tuning issues (lots of IO is
happening suddenfly).
