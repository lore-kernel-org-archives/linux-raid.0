From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: New FAQ entry? (was IBM xSeries stop responding during RAID1
 reconstruction)
Date: Thu, 22 Jun 2006 23:14:51 -0400
Message-ID: <449B5CAB.50409@tmr.com>
References: <Pine.LNX.4.44.0606212219120.10004-100000@coffee.psychology.mcmaster.ca> <449A1E10.2050402@fooplanet.com> <20060622071145.GA718@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060622071145.GA718@rigacci.org>
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: linux-raid@vger.kernel.org, Mark Hahn <hahn@physics.mcmaster.ca>
List-Id: linux-raid.ids

Niccolo Rigacci wrote:

>>>personally, I don't see any point to worrying about the default,
>>>compile-time or boot time:
>>>
>>>for f in `find /sys/block/* -name scheduler`; do echo cfq > $f; done
>>>      
>>>
>
>I tested this case:
>
>- reboot as per power failure (RAID goes dirty)
>- RAID start resyncing as soon as the kernel assemble it
>- every disk activity is blocked, even DHCP failed!
>- host services are unavailable
>
>This is why I changed the kernel default.
>
>  
>
Changing on the command line assumes that you built all of the 
schedulers in... but making that assumption, perhaps the correct 
fail-safe is to have cfq as the default, and at the end of rc.local 
check for rebuild, and if everything is clean change to whatever work 
best at the end of the boot. If the raid is not clean stay with cfq.

Has anyone tried deadline for this? I think I had this as deafult and 
didn't hand on a raid5 fail/rebuild.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

