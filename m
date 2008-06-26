From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Slowww raid check (raid10, f2)
Date: Thu, 26 Jun 2008 15:47:39 -0500
Message-ID: <4864006B.50703@gmail.com>
References: <cccedfc60806260621ud3af517j959f5ce3c2e521ef@mail.gmail.com>	 <4863A6A1.3010408@gmail.com>	 <cccedfc60806261303t4a6d4124w2ab12227d8acb99f@mail.gmail.com>	 <4863F85D.7080502@gmail.com> <cccedfc60806261322r100e8b8x3a964ae683a46f59@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60806261322r100e8b8x3a964ae683a46f59@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
>> That is a good built-in controller then, the scaling is almost perfect,
>> predicted would be  74, 158, 222 vs. 74, 154, 205.
> 
> I would really like to know how you arrived at what appear to be
> fairly specific numbers.
> 
> 


 From your test results each disk does about 74, both together should do 2x that 
in a perfect world (no interference with each other), and 3 should do 3x that, 
at 3x your system is 17MB/second slower than perfect, which is pretty good.

With a PCI controller (32bit/33mhz-standard desktop-max 133MB/second) the 
numbers look more like this:
70, 100, 115 (pretty bad).

You could get better estimates of how much interference is going on by using 
"vmstat 60" as that will give you a more accurate sustained number, and would 
give you better ideas of what the disks can sustain over longer periods of time, 
note though that the disks get slower the further you are into the disk, if you 
start a dd and graph the vmstat output then the disk speed will slowly decrease 
as you get to the inside of the disk, but your built-in controller is pretty good.

And the seeking around won't hurt too bad unless the block size is small, with a 
8ms seek time you can write/read about 600kb of data in the time it takes for a 
seek, so if you seek,read,seek,read with 600kb blocks you will get about 50% of 
disk speed, but if you do the same with smaller blocks the seek time uses up 
more time than the write/reads.    If you use 1M blocks you are spending more 
time doing writes/reads, if you use 256kb blocks more time is spent seeking than 
write/read.

                            Roger
