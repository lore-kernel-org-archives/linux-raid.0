From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Odd CPU usage in the last stage of a raid5 reshape
Date: Fri, 19 Apr 2013 09:54:04 +0200
Message-ID: <20130419075404.GA1938@frosties>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm still reshaping a 2 disk raid5 to 3 disks. It has now progressed
past the 50% mark so all data has been reshaped. So now the kernel
simply writes zeroes (I assume) to all 3 disks. There are no more
reads, only writes.

Now what is odd is the cpu usage:

/proc/mdsata:
md0 : active raid5 sdd1[3] sdc1[2] sda1[0]
      3907015168 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      [============>........]  reshape = 62.0% (2425537964/3907015168) finish=22
0.0min speed=112230K/sec

iostat -k 10:
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             834.40         0.00    103372.60          0    1033726
md0               0.00         0.00         0.00          0          0
sdc             813.90         0.00    104601.80          0    1046018
sdd             718.50         0.00    104499.40          0    1044994

top:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 2058 root      20   0     0    0    0 R   96  0.0   1106:40 md0_raid5
18379 root      20   0     0    0    0 R   50  0.0 324:11.19 md0_reshape

Is the kernel zero filling the raid device and computing the XOR of
zeroes for the parity blocks? Wouldn't it be less cpu consuming to
insert zero filled stripes directly into the stripe cache?

MfG
	Goswin
