From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Bug#557262: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state
 after	24-48 hours (sysrq-t+w available) - root cause found = asterisk
Date: Sat, 21 Nov 2009 08:29:18 -0600
Message-ID: <4B07F93E.10502@gmail.com>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>	<20091019030456.GS9464@discord.disaster>	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>	<20091020003358.GW9464@discord.disaster>	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> <alpine.DEB.2.00.0911201530500.10757@p34.internal.lan> <4B0729D8.3000105@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B0729D8.3000105@debian.org>
Sender: linux-raid-owner@vger.kernel.org
To: Faidon Liambotis <paravoid@debian.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, 557262@bugs.debian.org, Dave Chinner <david@fromorbit.com>, submit@bugs.debian.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org, asterisk-users@lists.digium.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Faidon Liambotis wrote:
> Justin Piszcz wrote:
>  > Found root cause-- root cause is asterisk PBX software.  I use an
> SPA3102.
>> When someone called me, they accidentally dropped the connection, I called
>> them back in a short period.  It is during this time (and the last time)
>> this happened that the box froze under multiple(!) kernels, always when
>> someone was calling.
> <snip>
>> I don't know what asterisk is doing but top did run before the crash
>> and asterisk was using 100% CPU and as I noted before all other processes
>> were in D-state.
>>
>> When this bug occurs, it freezes I/O to all devices and the only way to
>> recover
>> is to reboot the system.
> That's obviously *not* the root cause.
> 
> It's not normal for an application that isn't even privileged to hang
> all I/O and, subsequently everything on a system.
> 
> This is almost probably a kernel issue and asterisk just does something
> that triggers this bug.
> 
> Regards,
> Faidon


I had an application in 2.6.5 (SLES9)...that would hang XFS.

The underlying application was multi-threaded and both threads were 
doing full disks syncs every so often, and sometimes when doing the 
full disk sync the XFS subsystem would deadlock, it appeared to me tha 
one sync had a lock and was waiting for another, and the other process 
had the second lock and was waiting for the first...   We were able to 
disable the full disk sync from the application and the deadlock went 
away.   All non-xfs filesytems still worked and could still be 
accessed.    I did report the bug with some traces but I don't believe 
anyone ever determined where the underlying issues was.


