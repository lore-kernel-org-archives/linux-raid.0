From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
 hours (sysrq-t+w available)
Date: Mon, 2 Nov 2009 16:46:10 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0910281915400.29166@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster>
 <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> <alpine.DEB.2.00.0910221849001.24576@p34.internal.lan> <alpine.DEB.2.00.0910260723150.22950@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0910260723150.22950@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Mon, 26 Oct 2009, Justin Piszcz wrote:

>
>
> On Thu, 22 Oct 2009, Justin Piszcz wrote:
>
>> 
>> Any other ideas?
>> 
>> Currently stuck on 2.6.30.9.. (no issues, no lockups)-- Box normally has no 
>> load at all either.. Has anyone else reported similar problems?
>> 
>> Justin.
>> 
>
> --
>
> Currently running 2.6.31-rc1 for 2 days now, no crashes, will go to -rc2 
> later today and wait another 48 hours.
>
> Justin.
>
>

Kernel report:

2.6.31-rc1: no crash - uptime 2+ days
2.6.31-rc2: no crash - uptime 2+ days
2.6.31-rc3: no crash - uptime 2+ days
2.6.31-rc4: no crash but network kept dropping out
2.6.31-rc5: cannot test, service owner needs host available
2.6.31-rc6: cannot test, service owner needs host available
2.6.31-rc7: cannot test, service owner needs host available
2.6.31-rc8: cannot test, service owner needs host available
2.6.31-rc9: cannot test, service owner needs host available
   2.6.31.x: locks up D-state

It would be somewhere between -rc4 and 2.6.31.x.

Justin.

