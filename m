From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Where is the performance bottleneck?
Date: Wed, 28 Sep 2005 16:04:47 -0400
Message-ID: <433AF75F.2060208@tmr.com>
References: <200508302305.j7UN5bE23350@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200508302305.j7UN5bE23350@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Holger Kiehl' <Holger.Kiehl@dwd.de>, 'Mark Hahn' <hahn@physics.mcmaster.ca>, 'linux-raid' <linux-raid@vger.kernel.org>, 'linux-kernel' <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Guy wrote:

>In most of your results, your CPU usage is very high.  Once you get to about
>90% usage, you really can't do much else, unless you can improve the CPU
>usage.
>
That seems one of the problems with software RAID, the calculations are 
done in the CPU and not dedicated hardware. As you move to the top end 
drive hardware the CPU gets to be a limit. I don't remember off the top 
of my head how threaded this code is, and if more CPUs will help.

I see you are using RAID-1 for your system stuff, did one of the tests 
use RAID-0 over all the drives? Mirroring or XOR redundancy help 
stability but hurt performance. Was the 270MB/s with RAID-0 or ???

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

