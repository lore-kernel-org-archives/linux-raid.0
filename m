From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
 hours (sysrq-t+w available)
Date: Tue, 20 Oct 2009 04:33:37 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
 <20091020003358.GW9464@discord.disaster>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751305AbZJTIdf@vger.kernel.org>
In-Reply-To: <20091020003358.GW9464@discord.disaster>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Tue, 20 Oct 2009, Dave Chinner wrote:

> On Mon, Oct 19, 2009 at 06:18:58AM -0400, Justin Piszcz wrote:
>> On Mon, 19 Oct 2009, Dave Chinner wrote:
>>> On Sun, Oct 18, 2009 at 04:17:42PM -0400, Justin Piszcz wrote:
>>>> It has happened again, all sysrq-X output was saved this time.
>>> .....
>>>
>>> All pointing to log IO not completing.
>>>
> ....
>> So far I do not have a reproducible test case,
>
> Ok. What sort of load is being placed on the machine?
Hello, generally the load is low, it mainly serves out some samba shares.

>
>> the only other thing not posted was the output of ps auxww during
>> the time of the lockup, not sure if it will help, but here it is:
>>
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root         1  0.0  0.0  10320   684 ?        Ss   Oct16   0:00 init [2]
> ....
>> root       371  0.0  0.0      0     0 ?        R<   Oct16   0:01 [xfslogd/0]
>> root       372  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/1]
>> root       373  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/2]
>> root       374  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/3]
>> root       375  0.0  0.0      0     0 ?        R<   Oct16   0:00 [xfsdatad/0]
>> root       376  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsdatad/1]
>> root       377  0.0  0.0      0     0 ?        S<   Oct16   0:03 [xfsdatad/2]
>> root       378  0.0  0.0      0     0 ?        S<   Oct16   0:01 [xfsdatad/3]
>> root       379  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/0]
>> root       380  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/1]
>> root       381  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/2]
>> root       382  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/3]
> .....
>
> It appears that both the xfslogd and the xfsdatad on CPU 0 are in
> the running state but don't appear to be consuming any significant
> CPU time. If they remain like this then I think that means they are
> stuck waiting on the run queue.  Do these XFS threads always appear
> like this when the hang occurs? If so, is there something else that
> is hogging CPU 0 preventing these threads from getting the CPU?
Yes, the XFS threads show up like this on each time the kernel crashed.  So far
with 2.6.30.9 after ~48hrs+ it has not crashed.  So it appears to be some issue
between 2.6.30.9 and 2.6.31.x when this began happening.  Any recommendations
on how to catch this bug w/certain options enabled/etc?


>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
>
