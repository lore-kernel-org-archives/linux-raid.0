From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Two system lockups, Magic SysKeys works, RAID6 resyncs on reboot
Date: Wed, 1 Apr 2015 12:07:20 -0700
Message-ID: <CAK2H+edy-eMGPOraOakbV1gZK2K50aKAxm6cDd8eWrjZoL6sug@mail.gmail.com>
References: <CAK2H+efDuxdjmWZiOiJw+EK3wohY6FxRWgsm8rJc1j1+fniWig@mail.gmail.com>
	<20150401013032.5c908e85@natsu>
	<CAK2H+ec5Lo0=QaEXa=RrbXCzG5m6nRc7BynSPYEqvCc5Lb4z3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ec5Lo0=QaEXa=RrbXCzG5m6nRc7BynSPYEqvCc5Lb4z3g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 31, 2015 at 3:08 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Tue, Mar 31, 2015 at 1:30 PM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Tue, 31 Mar 2015 08:00:27 -0700
>> Mark Knecht <markknecht@gmail.com> wrote:
>>
>>> md3 : active raid6 sdc3[9] sdg3[5] sdf3[6] sde3[7] sdd3[8]
>>>       1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>>>       [====>................]  resync = 22.8% (110608304/484088160)
>>> finish=78.5min speed=79206K/sec
>>
>> Looks like you are running this without a write intent bitmap, why? It would
>> at least save you from a full resync each time.
>>
>> --
>> With respect,
>> Roman
>
> Honestly, I don't know. The machine was the first I ever built using
> RAID for the system drive and I probably didn't find out about it, or
> was just trying to keep it simple? Not at all sure.
>
> I'll check it out.
>
> Thanks,
> Mark

At this point, having put everything back together, I cannot find any
specific clues about what caused the problem. Possibly the system
might be showing its age. Maybe it's a corner condition in the 3.18
series kernel vs the 3.14 I was running before. No idea. The mdadm
RAID seems to have done it's job wonderfully. At least at the Linux
level there's no evidence at this time that anything was lost. Within
my Windows VMs that were running on the mdadm RAID6 at the time of the
Magic Sys Key reboot there seem to be minimal issues. One Windows
program (Schwab's StreetSmart Edge) lost some of my trading
environment configuration and I needed to recall only that file off
the web server to get the platform configured correctly again.
TradeStation was running in a second VM and showed no issues. Both
trading platforms were live at the time of the lockup so I came out of
this really well, and as I have good backups nothing would have been
lost anyway.

As per Roman's question/suggestion I've added the write intent bitmaps
to all three RAIDs. Nominally only md3 is mounted most of the time
anyway, but it's there to help if this problem continues.

If anyone sees anything else in the data I posted yesterday let me
know but everything mdadm specific seems good at this point.

Cheers,
Mark
