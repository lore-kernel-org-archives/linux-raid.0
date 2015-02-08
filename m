From: Dark Penguin <darkpenguin@yandex.ru>
Subject: An old "write-mostly" read balance issue
Date: Sun, 08 Feb 2015 18:40:07 +0300
Message-ID: <54D78357.7020808@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is an old issue about RAID1 read-balancing when "write-mostly" 
disks are present.

The problem is, according to the manual, "md driver will avoid reading 
from these devices if at all possible".

One way to understand this statement is that these drives will never be 
read from, except when the main drive can not be read from. There are A 
LOT of situations when this is the expected and desired behaviour:
- People mirroring an SSD with an HDD and suffering a performance loss;
- People mirroring a fast HDD with a slow HDD for reliability, for 
example, mirroring a 300Gb WD Raptor to a 300Gb partition on a 3Tb 5900 
"green" drive for backup; since the larger drive may be used for 
something other than this RAID, many would prefer it to be spared the 
workload.
- In my case, I have a home RAID1 storage, which is idle 95% of the 
time, and 95% of the remaining 5% I only read from it. So I want one of 
the drives to spin down and never turn on, in order to avoid wearing 
down the mechanics. They say, "The best way to keep a device from 
breaking is to turn it off and not use it". :) But even if I simply 
retrieve the contents of my volume, that request is apparently enough to 
load the first drive to 100% for a split second, which causes the second 
drive to spin up, which is extremely undesirable.

I've spent a lot of time looking for the answer "why does it spin up", 
and "normal forum users" couldn not even help me, but then I found out 
that there is another way to read that statement: apparently, there are 
other people who would like to see whatever little benefit reading from 
the second drive could give them. I can not say which side is a 
majority, but I respect their wishes as well, and personally I'm fine 
with any default behaviour as long as I have what I need.

I've found a patch for that:
http://marc.info/?l=linux-raid&m=135982797322422
Apparently, it can be used with any kernel, but I'm not good enough to 
make sure nothing's broken everytime I upgrade the kernel, and frankly, 
I think there are A LOT of people who wish to see the behaviour I would 
expect. So my plea is for the developers to accept this patch and make 
this behaviour optional, if not default. At least give us a compile 
option to build the kernel this way! There are people out there who use 
RAID1 at home and not in production, and therefore care less about 
performance than home storage idling, and who understand the words "if 
at all possible" in the more obvious way! I think that's the whole 
reason why the "write-mostly" option is there in the first place, but if 
there are people who don't agree with me - I'm not going to argue, they 
can have it their way, just give us the option to do what we want, too!


-- 
darkpenguin
