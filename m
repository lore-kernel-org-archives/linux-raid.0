From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Two system lockups, Magic SysKeys works, RAID6 resyncs on reboot
Date: Tue, 31 Mar 2015 15:08:49 -0700
Message-ID: <CAK2H+ec5Lo0=QaEXa=RrbXCzG5m6nRc7BynSPYEqvCc5Lb4z3g@mail.gmail.com>
References: <CAK2H+efDuxdjmWZiOiJw+EK3wohY6FxRWgsm8rJc1j1+fniWig@mail.gmail.com>
	<20150401013032.5c908e85@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150401013032.5c908e85@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 31, 2015 at 1:30 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Tue, 31 Mar 2015 08:00:27 -0700
> Mark Knecht <markknecht@gmail.com> wrote:
>
>> md3 : active raid6 sdc3[9] sdg3[5] sdf3[6] sde3[7] sdd3[8]
>>       1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>>       [====>................]  resync = 22.8% (110608304/484088160)
>> finish=78.5min speed=79206K/sec
>
> Looks like you are running this without a write intent bitmap, why? It would
> at least save you from a full resync each time.
>
> --
> With respect,
> Roman

Honestly, I don't know. The machine was the first I ever built using
RAID for the system drive and I probably didn't find out about it, or
was just trying to keep it simple? Not at all sure.

I'll check it out.

Thanks,
Mark
