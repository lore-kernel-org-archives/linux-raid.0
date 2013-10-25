From: Phil Turmel <philip@turmel.org>
Subject: Re: Help raid10 recovery from 2 disks removed
Date: Fri, 25 Oct 2013 08:09:13 -0400
Message-ID: <526A5F69.1030309@turmel.org>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <alpine.DEB.2.02.1310241050290.1838@uplift.swm.pp.se> <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net> <52690FB2.6000005@turmel.org> <1F36A02C60ACD1478457DCD917DA0FA8034D07@ZEX001-0M9030.jp.ykgw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1F36A02C60ACD1478457DCD917DA0FA8034D07@ZEX001-0M9030.jp.ykgw.net>
Sender: linux-raid-owner@vger.kernel.org
To: yuji_touya@yokogawa-digital.com, swmike@swm.pp.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/25/2013 06:47 AM, yuji_touya@yokogawa-digital.com wrote:
> Phil,
> 
>>> Device Model:     ST2000DM001-9YN164
>>
>> If I recall correctly, this model doesn't support error recovery
>> control.  If you haven't fixed your driver timeouts, it explains your
>> situation.
> 
> I had been believing that nowadays all hdd drive can reallocate bad sectors.
> It is wrong, right?

Yes and no.  Yes, all modern hard drives can reallocate bad sectors.
No, they can't do so until that sector is *written*.  Since you can't
read the data, and you need to write it to fix it, you need to get that
data from a redundant location.

The kernel MD module will do this on a running array when it encounters
a read error.  Your problem is that your drives do not report read
errors before the low level kernel driver (not MD) times out (30
seconds).  Non-raid drives typically take over two minutes to report a
read error.  When the kernel driver times out, it attempts to reset the
connection to the drive.  But the drive is still trying to read, and
ignores the reset.  So when MD tries to write the sector to repair it,
the drive appears to be disconnected.  *BOOM*

When you look at it a little later, it appears to be fine (and it
probably is).

> I had not fixed driver timeouts. It's a new word to me.
> I wonder these settings are required to use rest Seagate drives (sdd and sde).

Please search the list archives.  I've explained in detail many times in
the past few years.

And yes, you need to deal with the problem for all of your drives.

> I'll use RAID-capable drives when exchanging kicked out disks.
> Thank you for your advice.
> 
> I'm learnning a lot through my problem and really thank to linux-raid community,
> people helped me, and of course software RAID system. ;-)

You're welcome.

Phil
