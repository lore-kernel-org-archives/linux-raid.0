From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Tue, 22 Jan 2008 10:30:54 -0500
Message-ID: <47960C2E.8090706@tmr.com>
References: <4793AE0E.609@pobox.com> <20080120215734.GD17584@teal.hq.k1024.org> <47940F31.7020907@pobox.com> <18325.21933.337369.104689@fisica.ufpr.br> <4795D4B6.4070908@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4795D4B6.4070908@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Carlos Carvalho wrote:
>
>> I use reiser3 and xfs. reiser3 is very good with many small files. A
>> simple test shows interactively perceptible results: removing large
>> files is faster with xfs, removing large directories (ex. the kernel
>> tree) is faster with reiser3.
>
> My current main concern about XFS and reiser3 is writebacks. The 
> default mode for ext3 is "journal," which in case of power failure is 
> more robust than the writeback modes of XFS, reiser3, or JFS -- or so 
> I'm given to understand.
>
> On the other hand, I have a UPS and it should shut down gracefully 
> regardless if there's a power failure. I wonder if I'm being too 
> cautious?
>
No.

If you haven't actually *tested* the UPS failover code to be sure your 
system is talking to the UPS properly, and that the UPS is able to hold 
up power long enough for a shutdown after the system detects the 
problem, then you don't know if you actually have protection.  Even 
then, if you don't proactively replace batteries on schedule, etc, then 
you aren't as protected as you might wish to be.

And CPU fans fail, capacitors pop, power supplies fail, etc. These are 
things which have happened here in the last ten years. I also had a 
charging circuit in a UPS half-fail (from full wave rectifier to half). 
So the UPS would discharge until it ran out of power, then the system 
would fail hard. By the time I got on site and rebooted the UPS had 
trickle charged and would run the system. After replacing two 
"intermittent power supplies" in the system, the UPS was swapped on 
general principles and the real problem was isolated.

Shit happens, don't rely on graceful shutdowns (or recovery, have backups).

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


