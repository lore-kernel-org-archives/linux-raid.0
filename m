From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: In reply to the scheduler performance across md/software RAID.
Date: Wed, 25 Jun 2008 09:22:10 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806250916250.7338@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757951AbYFYNWX@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Strictly "benchmark" only, not example of a real load of course, but we 
see that overall, most of them finish around the same time, with the 
exception of CFQ which I had used 0 for the slice idle time for all of the 
disks.

Using 10 Raptor 150s in this test in a md/RAID 5 w/1024k chunk size, 
utilizing the XFS filesystem:
http://home.comcast.net/~jpiszcz/20080625/scheduler_comparison.html

jp@p63:~$ mkdir sched
jp@p63:~$ mkdir sched/cfq
jp@p63:~$ /usr/bin/time ./rt3.sh && mv *txt sched/cfq/
1507.95jp 323.73system 39:28.73elapsed 77%CPU (0avgtext+0avgdata 0maxresident)
k 0inputs+0outputs (19major+4157minor)pagefaults 0swaps
jp@p63:~$ mkdir sched/noop
jp@p63:~$ /usr/bin/time ./rt3.sh && mv *txt sched/noop/
1503.31jp 323.09system 40:02.06elapsed 76%CPU (0avgtext+0avgdata 0maxresident)
k 0inputs+0outputs (20major+4131minor)pagefaults 0swaps
jp@p63:~$ /usr/bin/time ./rt3.sh && mv *txt sched/noop/
jp@p63:~$ mkdir sched/deadline
jp@p63:~$ /usr/bin/time ./rt3.sh && mv *txt sched/deadline 
1518.49jp 323.65system 40:06.39elapsed 76%CPU (0avgtext+0avgdata 0maxresident)
k 0inputs+0outputs (23major+4127minor)pagefaults 0swaps
jp@p63:~$ mkdir sched/anticipatory
jp@p63:~$ /usr/bin/time ./rt3.sh && mv *txt sched/anticipatory
1513.15jp 324.27system 40:11.93elapsed 76%CPU (0avgtext+0avgdata 0maxresident)
k 0inputs+0outputs (22major+4129minor)pagefaults 0swaps
jp@p63:~$

The benchmarks in bonnie++ csv format:
anticipatory,16G,59195.3,96.7,412735.7,57.3,164809.0,27.7,63879.3,99.0,517301.3,45.3,395.7,0.0,16:100000:16/64,1018.0,8.7,13848.3,38.3,1765.3,11.3,1109.0,9.3,12592.3,35.3,1329.7,10.0
cfq,16G,59954.3,96.3,407278.3,56.0,171710.3,29.0,63246.0,99.0,512973.3,45.0,446.5,0.7,16:100000:16/64,967.7,8.7,18546.0,49.0,2631.3,16.3,1036.7,9.0,8993.7,24.3,2990.7,22.3
deadline,16G,59800.0,96.7,410798.3,57.0,161085.0,27.0,62722.3,99.0,529839.3,46.7,416.8,0.3,16:100000:16/64,904.7,7.7,11398.3,29.3,3050.7,19.3,1028.3,9.0,8335.7,23.0,2453.3,18.0
noop,16G,59763.3,96.3,398172.3,55.3,167762.7,28.0,63928.3,99.0,512906.3,44.7,428.3,0.3,16:100000:16/64,897.0,7.7,12563.7,32.7,1845.7,12.0,926.3,8.3,12868.0,33.7,2015.0,15.0

Justin.
