From: Mike Hardy <mhardy@h3c.com>
Subject: Re: High System Load
Date: Wed, 28 Jul 2004 16:54:30 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41083CB6.9070901@h3c.com>
References: <A506359028CAD21191C10008C75D895C0A06C865@NPRI54EXC14.NPT.NUWC.NAVY.MIL> <Pine.LNX.4.55.0407281322170.17864@umi.cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0407281322170.17864@umi.cfht.hawaii.edu>
To: Kanoa Withington <kanoa@cfht.hawaii.edu>
Cc: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Even without DMA there should only ever be one kernel thread issuing 
instructions, resulting in a load of 1, which is all I've ever seen.

DMA vs. PIO modes will just result in a lower resync throughput, which 
you can watch with something like (you can even try using hdparm to 
change modes while the resync is happening to see the effect if you're 
brave):

#!/bin/tcsh
while 1
   cat /proc/mdstat
   sleep 1
   clear
end

There's got to be something else happening on the machine...

-Mike

Kanoa Withington wrote:
> There is a lot of activity after you first create a mirror but the CPU
> load should not be that high. Maybe you don't have DMA turned on?
> Check using "hdparm".
> 
> -Kanoa
> 
> On Wed, 28 Jul 2004, Huntress Gary B NPRI wrote:
> 
> 
>>Hi,
>>
>>I'm creating my first software RAID array.  I'm on a 900 MHz system with 786MB of ram, running Fedora RC1.  I'm creating a RAID 1 array consisting only of two drives, split on two IDE channels.
>>
>>I used mdadm --create and everything is running fine so far, but my system load is well over 10.   Is this normal?   I suspect that this is just overhead while creating the array the first time.   Can I assume that when the array is actually put into use that the system loads will not be this high?  (I hope not!)
>>
>>Thanks,
>>
>>Gary H.
