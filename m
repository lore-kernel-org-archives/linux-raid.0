From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: When do you replace old hard drives in a raid6?
Date: Wed, 9 Mar 2016 07:43:16 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1603090733030.31096@uplift.swm.pp.se>
References: <56DB465E.9010703@gmail.com> <56DCCB55.1060906@turmel.org> <56DCD0E9.8040506@gmail.com> <56DD0F12.2060104@turmel.org> <56DF6A39.4020904@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56DF6A39.4020904@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 8 Mar 2016, Ram Ramesh wrote:

> My disks have about 10K hours (my server only runs from 4pm-2am). I 
> think I have quite a bit of life left assuming an on/off cycle is not as 
> bad as extra 14 hours of run time.

I had very high failure rates of the early 2TB WD Greens, but I still have 
some WD20EARS and WD20EADS that are alive after 58k hours.

One of the slightly lower power on time ones has a scary load cycle count 
though:

Device Model:     WDC WD20EARS-00S8B1
   9 Power_On_Hours          0x0032   033   033   000    Old_age   Always       -       49255
193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always       -       1317839

I'm running this as RAID6+spare and I'm just going to let these run until 
they fail and replace them with WD REDs one by one. I clearly had bathtub 
effect where I had several drives I replaced under warranty in the first 
1-2 years of their lifetime, but the ones that replaced them, and the ones 
that didn't fail, still seems to be doing fine.

I have two drives with reallocated sectors, but it's 3 and 5 sectors 
respectively, so this is not worrying yet.

I wish we had raid6e (or whatever to call it) with 3 parity drives, I'd 
really like to run that instead of raid6+spare.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
