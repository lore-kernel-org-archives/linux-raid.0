From: Vladimir Milovanovic <vlad@webmail.co.za>
Subject: RAID 4 and RAID 5
Date: Tue, 15 Oct 2002 10:05:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DABCC4A.9070206@webmail.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am thrilled that I have found this list, as I didn't know about it.
I have been playing with RAID for a while, and I am enjoying what it can 
do. The one problem I have is differentiating between RAID 4 and RAID 5.

Both are documented in the HOWTO and I have tried to set them up both. 
The /etc/raidtab file does not complain when I define RAID 4 as the 
raid-level argument, but after creating an array with RAID 4 and doing 
cat /proc/mdstat , I see active RAID5, and all the disks. The parity 
algorithm is stated as 0, and at the bottom it states the space 
available on the array and the "level 4".

Setting up RAID 5 is very much the same thing, except it says that the 
parity-algorithm is 2, (I am using left-symmetric) and then, next to the 
space available, it says level 5.

Now here is the crunch : both RAID 4 and RAID 5 give me EXACTLY the same 
results, both in read write performance. I am using many programs for 
benching, hdparm, bonnie, iozone, tiobench and the results are 
consistent and repeatable.

Does anyone know with any degree of certainity whether RAID 4 is 
supported in Linux? What exactly is the status of that? I know that 
there is no point in using RAID 4 over RAID 5 but I want to know so that 
I am able to document it.

Thanks, and nice to see so much discussion about RAID!!! I think I am 
gonna like this place.

Vlad.


