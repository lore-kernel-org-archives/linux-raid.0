From: Peter Landmann <sfrazt@googlemail.com>
Subject: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 11:00:48 +0000 (UTC)
Message-ID: <loom.20130403T122905-373@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i wrote it there http://article.gmane.org/gmane.linux.raid/42365 but want to go 
in detail. Maybe there is another problem or 
problem in my thinking.

Environment:
HW: AMD Phenom II 1055T 2,8 GHz, 8GB ram
    Intel X25-M G2 Postville 80 GB SATA2 SSD
SW: kernel 3.4.0 but same performace with 3.8 from git and 3.9 from "next" tree
    distribution: debian sid
Raid Settings: 
    for each hdd a 10 GB partition is used, 70 GB spare capacity
    noop-scheduler
    raid creation:
    mdadm --create /dev/md9 --force --raid-devices=4 --chunk=64 --assume-clean -
-level=5 /dev/sdb1 /dev/sdc1 ..

FIO settings:
bs=4096
iodepth=248
direct=1
continue_on_error=1
rw=randwrite
ioengine=libaio
norandommap
refill_buffers
group_reporting
[test1]
numjobs=1


Theoretical performance: in single mode without raid each ssd writes 20k IOPS 
and reads 40k IOPS.
With Raid 5 and with at least 4 SSDs there are as many write operations as read 
operations. So a single SSD should deliver 13333 
read and write operations per second.

Without Raid (a maximum performance of 140000 random read and 120000 random 
write operations per second is archieved. so hw 
shouldn't be the limiting factor for raid 5.


Evaluation: Random write in IOPS
#SSD experimental    theoretical
3  14497.7           24000
4  14005             26666
5  17172.3           33333
6  19779             40000

Following stats and output for  raid 5 with 6 SSDs

fio:
ssd10gbraid5rw: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, 
iodepth=248
2.0.8
Starting 1 process

ssd10gbraid5rw: (groupid=0, jobs=1): err= 0: pid=32400
  Description  : [SSD 10GB raid5 (mdadm) random write test]
  write: io=988.0KB, bw=79133KB/s, iops=19783 , runt=5300335msec
    slat (usec): min=3 , max=282137 , avg= 7.46, stdev=36.26
    clat (usec): min=250 , max=338796K, avg=12525.28, stdev=136706.65
     lat (usec): min=259 , max=338796K, avg=12533.00, stdev=136706.66
    clat percentiles (usec):
     |  1.00th=[ 1048],  5.00th=[ 2096], 10.00th=[ 2672], 20.00th=[ 3504],
     | 30.00th=[ 4576], 40.00th=[ 6496], 50.00th=[ 8512], 60.00th=[11456],
     | 70.00th=[15168], 80.00th=[20352], 90.00th=[28544], 95.00th=[33536],
     | 99.00th=[39168], 99.50th=[41216], 99.90th=[56064], 99.95th=[292864],
     | 99.99th=[309248]
    bw (KB/s)  : min= 6907, max=100088, per=100.00%, avg=79313.22, stdev=8802.19
    lat (usec) : 500=0.05%, 750=0.27%, 1000=0.52%
    lat (msec) : 2=3.52%, 4=20.98%, 10=30.25%, 20=23.99%, 50=20.29%
    lat (msec) : 100=0.03%, 250=0.01%, 500=0.10%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.01%
  cpu          : usr=7.75%, sys=21.55%, ctx=47382311, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=0/d=104857847, short=r=0/w=0/d=0
     errors    : total=0, first_error=0/<(null)>

Run status group 0 (all jobs):
  WRITE: io=409601MB, aggrb=79132KB/s, minb=79132KB/s, maxb=79132KB/s, 
mint=5300335msec, maxt=5300335msec

Disk stats (read/write):
    md9: ios=84/104857172, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, 
aggrios=34949993/34951372, aggrmerge=401/512, 
aggrticks=130838494/122401043, aggrin_queue=253198596, aggrutil=96.05%
  sdb: ios=34950097/34951445, merge=400/511, ticks=130214828/121603063, 
in_queue=251778978, util=95.86%
  sdc: ios=34952941/34954281, merge=399/516, ticks=130736987/122271756, 
in_queue=252969493, util=95.91%
  sdd: ios=34943892/34945256, merge=417/527, ticks=131734001/123258071, 
in_queue=254949447, util=95.89%
  sde: ios=34954980/34956283, merge=367/473, ticks=125822046/117619660, 
in_queue=243399327, util=95.95%
  sdf: ios=34952583/34954080, merge=415/532, ticks=137200055/128624635, 
in_queue=265784289, util=96.05%
  sdg: ios=34945469/34946890, merge=408/517, ticks=129323047/121029077, 
in_queue=250310045, util=95.99%

top:
  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
 4525 root      20   0     0    0    0 R  39,6  0,0  98:16.78 md9_raid5
32400 root      20   0 79716 1824  420 S  30,6  0,1   0:02.77 fio
29099 root      20   0     0    0    0 R   7,3  0,0   0:33.90 kworker/u:0
31740 root      20   0     0    0    0 S   6,7  0,0   4:59.61 kworker/u:3
18488 root      20   0     0    0    0 S   5,7  0,0   2:06.64 kworker/u:1
31197 root      20   0     0    0    0 S   4,7  0,0   0:13.77 kworker/u:4
23450 root      20   0     0    0    0 S   3,0  0,0   1:34.33 kworker/u:7
27068 root      20   0     0    0    0 S   1,7  0,0   0:51.94 kworker/u:2

mpstat:
CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
all    1,17    0,00   12,67   12,71    3,27    3,05    0,00    0,00   67,13
0    1,41    0,00    7,88   15,42    0,07    0,15    0,00    0,00   75,07
1    0,00    0,00   38,04    3,14   19,20   18,08    0,00    0,00   21,54
2    1,50    0,00    7,55   14,78    0,07    0,02    0,00    0,00   76,08
3    1,09    0,00    7,31   12,15    0,05    0,02    0,00    0,00   79,38
4    1,35    0,00    7,41   12,94    0,07    0,00    0,00    0,00   78,23
5    1,65    0,00    7,78   17,84    0,12    0,03    0,00    0,00   72,57

iostat -x 1:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,67    0,00   18,79    3,69    0,00   76,85

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await r_await w_await  svctm  %util
sdb               0,00     0,00 6952,00 6935,00 27808,00 27740,00     8,00    
24,97    1,80    2,00    1,59   0,06  77,90
sda               2,00     0,00 6774,00 6789,00 27104,00 27156,00     8,00    
21,26    1,57    1,78    1,36   0,06  77,60
sdd               4,00     4,00 7059,00 7013,00 28252,00 28068,00     8,00   
136,01    9,66   10,34    8,98   0,07  99,60
sdc               0,00     0,00 6851,00 6851,00 27404,00 27404,00     8,00    
22,80    1,66    1,86    1,46   0,06  77,70
sdf               0,00     0,00 6931,00 6995,00 27724,00 27980,00     8,00    
41,78    3,03    3,26    2,80   0,06  79,70
sde               0,00     0,00 6842,00 6837,00 27368,00 27348,00     8,00    
31,59    2,31    2,53    2,08   0,06  79,60

another snapshot
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,84    0,00   22,35    2,18    0,00   74,62

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await r_await w_await  svctm  %util
sdb               1,00     2,00 8344,00 8400,00 33380,00 33608,00     8,00    
67,39    4,06    4,30    3,82   0,06  97,80
sda               1,00     0,00 8305,00 8290,00 33224,00 33160,00     8,00    
28,74    1,73    1,94    1,52   0,05  88,40
sdd               5,00     5,00 8393,00 8419,00 33592,00 33696,00     8,00    
96,74    5,76    6,02    5,49   0,06  98,80
sdc               0,00     1,00 8199,00 8201,00 32796,00 32808,00     8,00    
27,64    1,68    1,92    1,45   0,05  87,80
sdf               1,00     0,00 8332,00 8323,00 33328,00 33292,00     8,00    
40,95    2,44    2,66    2,23   0,05  89,30
sde               0,00     0,00 8256,00 8263,00 33024,00 33052,00     8,00    
28,94    1,75    1,96    1,54   0,05  89,50

mpstat for same test with 3.9 kernel from next-tree
CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
all    0,50    0,00   10,03    1,34    2,01    6,35    0,00    0,00   79,77
0    0,00    0,00    0,00    0,00    0,00    0,00    0,00    0,00  100,00
1    0,00    0,00   25,00    0,00    5,00   18,00    0,00    0,00   52,00
2    0,00    0,00   20,83    0,00    5,21   18,75    0,00    0,00   55,21
3    0,00    0,00    0,00    0,00    0,00    0,00    0,00    0,00  100,00
4    3,06    0,00   15,31    8,16    0,00    0,00    0,00    0,00   73,47
5    0,00    0,00    0,00    0,00    0,00    0,00    0,00    0,00  100,00


So you have an idea why the real performance is only 50% of the theoretical 
performance? No cpu core is at its limits.
As i said in my other post. I would be interested to solve the problem but i 
have problems to identify it.

Peter Landmann


