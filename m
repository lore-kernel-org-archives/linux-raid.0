From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: AW: RAID456 direct I/O write performance
Date: Thu, 04 Sep 2014 23:12:44 +0200
Message-ID: <5408D5CC.101@shiftmail.org>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358642FF8@EXCHANGE.collogia.de> <12EF8D94C6F8734FB2FF37B9FBEDD17358643012@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD17358643012@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/09/2014 18:30, Markus Stockhausen wrote:
> A perf record of the 1 writer test gives:
>
>      38.40%      swapper  [kernel.kallsyms]   [k] default_idle
>      13.14%    md0_raid5  [kernel.kallsyms]   [k] _raw_spin_unlock_irqrestore
>      13.05%      swapper  [kernel.kallsyms]   [k] tick_nohz_idle_enter
>      10.01%          iot  [raid456]           [k] raid5_unplug
>       9.06%      swapper  [kernel.kallsyms]   [k] tick_nohz_idle_exit
>       3.39%    md0_raid5  [kernel.kallsyms]   [k] __kernel_fpu_begin
>       1.67%    md0_raid5  [xor]               [k] xor_sse_2_pf64
>       0.87%          iot  [kernel.kallsyms]   [k] finish_task_switch
>
> I'm confused and clueless. Especially I cannot see where the
> 10% overhead in the source of raid5_unplug might come
> from? Any idea from someone with better insight?

I am no kernel developer but I have read that the CPU time for serving 
interrupts is often accounted to the random process which has the bad 
luck to be running at the time the interrupt comes and steals the CPU. I 
read this for top, htop etc, which have probably a different accounting 
mechanism than perf, but maybe something similar happens here, because 
_raw_spin_unlock_irqrestore at 13% looks too absurd to me.
In fact, probably as soon as the interrupts are re-enabled by 
_raw_spin_unlock_irqrestore, the CPU often goes serving one interrupt 
that was queued, and this is before the function 
_raw_spin_unlock_irqrestore exits, so the time is really accounted there 
and that's why it's so high.

OTOH I would like to ask kernel experts one thing if I may: does anybody 
know a way to get a stack trace for a process which is currently running 
in kernel mode and is running NOW on a CPU and it is not stopped waiting 
in a queue? I know about /proc/pid/stack but that one shows 
0xffffffffffffffff for such a case. Being able to do that would help to 
answer the above question too...

Thanks
EW

