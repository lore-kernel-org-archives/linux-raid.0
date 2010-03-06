From: Asdo <asdo@shiftmail.org>
Subject: Re: What RAID type and why?
Date: Sun, 07 Mar 2010 00:03:41 +0100
Message-ID: <4B92DF4D.5070802@shiftmail.org>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mark Knecht wrote:
> First post. I've never used RAID but am thinking about it and looking
> for newbie-level info. Thanks in advance.
>
> I'm thinking about building a machine for long term number crunching
> of stock market data. Highest end processor I can get, 16GB and at
> least reasonably fast drives. I've not done RAID before and don't know
> how to choose one RAID type over another for this sort of workload.
> All I know is I want the machine to run 24/7 computing 100% of the
> time and be reliable at least in the sense of not losing data if 1
> drive or possibly 2 go down.
>
> If a drive does go down I'm not overly worried about down time. I'll
> stock a couple of spares when I build the machine and power the box
> back up within an hour or two.
>
> What RAID type do I choose and why?
>
> Do I need a 5 physical drive RAID array to meet these requirements?
> Assume 1TB+ drives all around.
>
> How critical is it going forward with Linux RAID solutions to be able
> to get exactly the same drives in the future? 1TB today is 4TB a year
> from now, etc.
>   
Hi Mark

I'll reply to just a few points.

You don't need the same drives, only a few requirements:

1 - The drives need to play well with the controller. Do some tests. 
There were rare cases of certain drives being dropped by certain 
controllers e.g. on high I/O. Just do some tests before putting valuable 
data in. Maybe look at the HCL list for your controller before buying.

2 - the new drives need to be at least as large as the old ones. Extra 
space will be wasted (ok not exactly, you can use the extra space for 
other purposes). Speed is not relevant for bare functionality.

3 - It's better if new drives are not slower than the older drives. 
Everything moves at the speed of the slowest drive.

4 - Better to take raid-edition or enterprise-grade drives, especially 
because they usually have RTL "recovery time limit" also called TLER 
(time limited error recovery). Go google for it to understand why it is 
useful in RAID.

> With an 8 core processor (high-end Intel Core i7 probably) do I need
> to worry much about CPU usage doing RAID? I suspect not and I don't
> really want to get into hardware RAID controllers unless critically
> necessary which I suspect it isn't.
>   

I think for a 5 disks raid array the CPU power is still not the limiting 
factor. Especially not in the fast raids like raid10. Note that only 1 
core will be used for RAID parity computation for raid456. All cores 
will be used for handling interrupts from the drives though.

Difficult to suggest what RAID you should use. We don't know access 
patterns, speed requirements, value of your data.

Minimum for redundancy is raid-1 on 2 drives.


