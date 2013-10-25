From: Phil Turmel <philip@turmel.org>
Subject: Re: Help raid10 recovery from 2 disks removed
Date: Fri, 25 Oct 2013 08:21:09 -0400
Message-ID: <526A6235.2020801@turmel.org>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net> <alpine.DEB.2.02.1310241441280.1838@uplift.swm.pp.se> <2614300.keHkAfZ48K@eseries.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2614300.keHkAfZ48K@eseries.newtech.fi>
Sender: linux-raid-owner@vger.kernel.org
To: dag@newtech.fi, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: yuji_touya@yokogawa-digital.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Dag,

On 10/25/2013 03:27 AM, Dag Nygren wrote:

> Just enabling scterc (which is disabled by default and will be
> after a power down of the drive), setting the timeout 
> and then running a repair on the array
> fixed it for me as md was smart enough to try to rewrite the
> sector(s) that had failed and with scterc the drive would then reallocate
> the failed sector. 
> I thought I had this done, but a syntax error in the script had
> prevented it from working.. :-( )
> 
> The working script I ran for this was:
> =============================
> # Set up RAID drive timeouts
> for x in b c d e
> do
>         smartctl -l scterc,70,70 /dev/sd$x
>         echo 180 >/sys/block/sd$x/device/timeout
> done
> ==============================

You shouldn't do both.  You only need the long driver timeout if the
hard disk doesn't support scterc.  Long timeouts are bad for application
software, as you can get very long system pauses while waiting for a
sector recovery.  But the long timeout is the only option if you have
non-scterc drives.

Some time ago I posted a similar script that checked the result code
from smartctl.  It only resets the driver timeout if smartctl couldn't
set scterc.

HTH,

Phil
