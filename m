From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
	hours (sysrq-t+w available)
Date: Tue, 20 Oct 2009 11:33:58 +1100
Message-ID: <20091020003358.GW9464@discord.disaster>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758119AbZJTAeO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On Mon, Oct 19, 2009 at 06:18:58AM -0400, Justin Piszcz wrote:
> On Mon, 19 Oct 2009, Dave Chinner wrote:
>> On Sun, Oct 18, 2009 at 04:17:42PM -0400, Justin Piszcz wrote:
>>> It has happened again, all sysrq-X output was saved this time.
>> .....
>>
>> All pointing to log IO not completing.
>>
....
> So far I do not have a reproducible test case,

Ok. What sort of load is being placed on the machine?

> the only other thing not posted was the output of ps auxww during
> the time of the lockup, not sure if it will help, but here it is:
>
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root         1  0.0  0.0  10320   684 ?        Ss   Oct16   0:00 init [2] 
....
> root       371  0.0  0.0      0     0 ?        R<   Oct16   0:01 [xfslogd/0]
> root       372  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/1]
> root       373  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/2]
> root       374  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/3]
> root       375  0.0  0.0      0     0 ?        R<   Oct16   0:00 [xfsdatad/0]
> root       376  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsdatad/1]
> root       377  0.0  0.0      0     0 ?        S<   Oct16   0:03 [xfsdatad/2]
> root       378  0.0  0.0      0     0 ?        S<   Oct16   0:01 [xfsdatad/3]
> root       379  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/0]
> root       380  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/1]
> root       381  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/2]
> root       382  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/3]
.....

It appears that both the xfslogd and the xfsdatad on CPU 0 are in
the running state but don't appear to be consuming any significant
CPU time. If they remain like this then I think that means they are
stuck waiting on the run queue.  Do these XFS threads always appear
like this when the hang occurs? If so, is there something else that
is hogging CPU 0 preventing these threads from getting the CPU?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
