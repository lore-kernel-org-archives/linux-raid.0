From: hank peng <pengxihan@gmail.com>
Subject: Can I skip recovery for RAID5 in this way?
Date: Sat, 9 Jan 2010 12:23:51 +0800
Message-ID: <389deec71001082023h21bdb12dg548b62d12d1c6c35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

For my platform, recovery when creating a raid5 array or adding a new
disk to a degraded raid5 array is not only time-consuming but also cpu
cost. I am thinking now when every write into a raid5 stripe, if we
only use reconstruct_write method, can I use this way to skip
recovery?
BTW, my appliation mainly focus on sequential write and I can also
limit the number of disks in raid5.
Please correct me if I am wrong, maybe my way is stupid.

-- 
The simplest is not all best but the best is surely the simplest!
