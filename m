From: Peter Landmann <sfrazt@googlemail.com>
Subject: Solving the raid write performance problems
Date: Tue, 2 Apr 2013 11:36:13 +0000 (UTC)
Message-ID: <loom.20130402T133516-865@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i'm a university student in end phase and considering to write my master thesis
about the md raid performance issues and to implement a prototype to solve it.

What i have done and know:
1. I wrote a (internal) paper to measure raid performance with SSDs with freebsd
software raid implementations and md raid under linux. I tested RAID 0 and RAID
5 with up to 6 Intel SSDs (X25-M G2, each 20k Write and 40k read OPS) and esp
for RAID 5 it doesn't scaled. With my fio and general environment (bs 4k,
iodepth 256, direct=1, randomwrite, spare capacity 87,5%, noop scheduler, latest
mainline kernel from git, amd phenom II 1055T 2,8 GHz, 8GB ram) i got
SSDs IOPS
3    14497.7
4    14005
5    17172.3
6    19779 

2. AFAIK the main problem is that md uses only one write thread for each raid
instance and their is a patch in work but still not availible.

So my questions:
1. Is this problem solved (i know it isn't in mainline)? Is there still some
work to do?
2. If not solved: Why isn't solved already (time? technical problem? priority?
Not solvable?)
3. Is it the only problem? With my tests i captured detailed cpu stats and no
cpu core was nearly at its capacity. So there are known other big reasons for
perfomance issues?
For example: 6 SSD randomwrite:
CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
all    1,17    0,00   12,67   12,71    3,27    3,05    0,00    0,00   67,13
0    1,41    0,00    7,88   15,42    0,07    0,15    0,00    0,00   75,07
1    0,00    0,00   38,04    3,14   19,20   18,08    0,00    0,00   21,54
2    1,50    0,00    7,55   14,78    0,07    0,02    0,00    0,00   76,08
3    1,09    0,00    7,31   12,15    0,05    0,02    0,00    0,00   79,38
4    1,35    0,00    7,41   12,94    0,07    0,00    0,00    0,00   78,23
5    1,65    0,00    7,78   17,84    0,12    0,03    0,00    0,00   72,57

4. Is this (bringing the raid performance to or near the theoretically
performance) a work that a man can archieve in less then 6 months without
practical experience in kernel hacking (and i'm not a genuis :( )

Thanks in advance for your responses,
Peter Landmann

