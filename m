From: Koti <satha_koti@yahoo.co.in>
Subject: Need information regarding RAID 6 Async APIs for kernel version 2.6.27
Date: Thu, 28 May 2009 17:57:18 +0000 (UTC)
Message-ID: <loom.20090528T173957-742@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

When I am using the linux kernel version 2.6.21, I applied the RAID5 and RAID6 
Async_tx APIs, and those are working fine.

But When I upgraded to linux kernel version 2.6.27, it has RAID5 async_tx APIs 
inline, but not the RAID6.

I downloaded the recent RAID6 async_tx APIs released on March2009, from the 
links

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git raid6-for-neil


The following is my questions:
1) Is these are suitable for my kernel version, if not can you please provide 
me the link where I can get the patches for this kernel.

1) If these are currect one Iam looking, then I have a few more doubts while 
traversing the code, It has async calls like async_pq, async_r6_dd_recov, ...
From where these functions are invoked
how the link happens between these async calls and the md-raid driver.

Can anybody help in solving this problem, it is very useful for my work.
Thanks in advance for your support.


Thanks,
Satha Koti

