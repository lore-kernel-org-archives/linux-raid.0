From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sat, 6 Dec 2008 09:28:50 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Someone should write a document with XFS and barrier support, if I recall,
in the past, they never worked right on raid1 or raid5 devices, but it
appears now they they work on RAID1, which slows down performance ~12 times!!

l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar 
0.15user 1.54system 0:13.18elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+325minor)pagefaults 0swaps
l1:~#

l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar
0.14user 1.66system 2:39.68elapsed 1%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+324minor)pagefaults 0swaps
l1:~#

Before:
/dev/md2        /               xfs     defaults,noatime  0       1

After:
/dev/md2        /               xfs     defaults,noatime,nobarrier,logbufs=8,logbsize=262144 0 1

There is some mention of it here:
http://oss.sgi.com/projects/xfs/faq.html#wcache_persistent

But basically I believe it should be noted in the kernel logs, FAQ or somewhere
because just through the process of upgrading the kernel, not changing fstab
or any other part of the system, performance can drop 12x just because the
newer kernels implement barriers.

Justin.
