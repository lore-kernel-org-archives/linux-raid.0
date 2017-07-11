From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Need to shrink md component disk partitions - what is the best
 method?
Date: Mon, 10 Jul 2017 21:27:27 -0500
Message-ID: <317ec719-0979-e1ae-b6ad-7192ef074ac4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I shrunk md device to suit my needs and now I need to shrink the 
partition of each component device so that I can reuse the unused space 
on the component disks. Every google search that I encountered only 
outlines a method where you fail, remove, re-partition, add, sync each 
disk. With bitmap, I guess each sync will be very fast as data is really 
not being changed. Since I have raid6, I should be able to work on one 
disk at a time without much risk also.

However, is this the recommended method? Why not simply boot on a rescue 
system, do not assemble the array, simply change all partitions and 
reboot the original system so that the array will get assembled the 
normal way? Is this too risky or inferior?

While we are at it, mdadm -E says
>  Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
What is Used Dev Size? Is is the last sector used or the number of 
sectors used? If my current partition(s) start at 2048, does it mean I 
should end the md partitions on or after 6174015488 or (6174015488+2048)?

How do I make mdadm scrub the entire array even though bit map says 
there is no need?

Ramesh

