From: hank peng <pengxihan@gmail.com>
Subject: how to decrease raid5 write penalty in my case?
Date: Fri, 4 Jun 2010 12:15:17 +0800
Message-ID: <AANLkTin2zcAMc_grkvJ3rwz4BVtPt2Y0RE9mFyFyX6aW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I created a raid5 array which consists of 4 SATA disks, then I make a
XFS on it. Now, I pre-allocate a file using posix_fallocate, its size
is 512MB. So I think the file space allocated by file system is
sequential. After that , I am filling data into this file from the
start position, for example, every time I write 64KB data, but there
are 1 seconds interval between two writes.

As for RAID5 layer in kernel, due to the 1s interval between writes,
extra read operation(write penalty) maybe caused although the
following writes is sequential in this file's space.
So, in my case, is there some parameters to adjust in order to
decrease this kind of write penalty? Can we tell raid5 layer to delay
the read operation for that stripe parity computation because we know
that the following writes start at the previous writes's end point?


-- 
The simplest is not all best but the best is surely the simplest!
