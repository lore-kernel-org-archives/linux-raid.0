From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: "Free swap" drops during raid data-check
Date: Sun, 16 Mar 2014 20:10:54 +0100
Message-ID: <5325F73E.80109@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

For quite a while we have been observing that during raid "data-check" 
(initiated by cron every saturday at 0:00) the free swap spaces drops to 
0. It seems as if the data-check generates many I/O's that "fill" the 
buffer cache, which pushes out memory to swap. Is this a reasonable 
assumption? If so, wouldn't it be better if data-check related I/O 
bypasses the buffer cache?

I know that these are just assumptions, here are some facts:

What happens is illustrated by this graph: 
http://www.rolf-fokkens.nl/kvm01-swap.png
- It covers 7 days
- In weekends you see the drop in free swap
- everfy night swap drops too, this is because of backups

And the related syslog messages:

Mar  8 00:00:01 kvm01 kernel: md: data-check of RAID array md0
Mar  8 00:00:01 kvm01 kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for data-check.
Mar  9 12:21:22 kvm01 kernel: md: md0: data-check done
Mar 15 00:00:02 kvm01 kernel: md: data-check of RAID array md0
Mar 15 00:00:02 kvm01 kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for data-check.
Mar 16 10:42:04 kvm01 kernel: md: md0: data-check done.

Some additional information:
- The machine has a total of 32GB RAM and 32GB SSD SWAP
- The machine is used to host 12 KVM VM's which in total have 47GB RAM
- I know this is "living on the edge"..
- but it works fine.
- in general performance is OK
- based on SMART measurements the SSD will last another 4 years.
- we reduced swappiness to 10, but that didn't make really big difference.

I'm looking forward to any information that can make us understand 
what's happening.

Thanks,

Rolf
