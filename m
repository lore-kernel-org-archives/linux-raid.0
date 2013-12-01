From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?bWQgcmFpZDUgcmFuZG9tIHBlcmZvcm1hY2UgNnggU1NEIFJBSUQ1?=
Date: Mon, 02 Dec 2013 00:33:51 +0800
Message-ID: <efed564c-afcf-4871-b6eb-65c0814709d8@aliyun.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com> <20131126061458.GM8803@dastard>,529455CB.6050907@hardwarefreak.com,3c94e3bd-c74f-44ed-a1da-443b08edc43e@aliyun.com <36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>,5296C98D.8000302@hardwarefreak.com <fa7f0ec0-e7ba-46ca-a129-24bb45b52460@aliyun.com>,5297FE1C.6080504@hardwarefreak.com <b76f02a4-b751-4533-81ba-1c73aa65e4b4@aliyun.com>,529B4461.5080004@hardwarefreak.com,07cc6128-f0b8-423b-88af-9395cb7bf0e6@aliyun.com
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 07cc6128-f0b8-423b-88af-9395cb7bf0e6@aliyun.com
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

six ssd disk ,raid5 cpu:Intel(R) Xeon(R) CPU     X5650  @ 2.67GHz memory:32G
sTEC SSD disk: single disk iops=35973
root@host0:/sys/block/md127/md# cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid5 sdg[6] sdl[4] sdk[3] sdj[2] sdi[1] sdh[0]
      3906404480 blocks super 1.2 level 5, 128k chunk, algorithm 2 [6/6] [UUUUUU]
    
unused devices: <none>


ramdom write iops is as follows:
 stripe_cache_size==2048   iops= 59617
 stripe_cache_size==4096   iops=61623
 stripe_cache_size==8192   iops= 59877


why the random write iops is so low,while single disk write IOPS reach to 3.6W?


 fio parameter is as follows:

the test result shows: stripe_cache_size==2048
root@sc0:~# fio -filename=/dev/md/md0    -iodepth 16 -thread -rw=randwrite -ioengine=libaio -bs=4k -size=30G  -numjobs=16 -runtime=1000 -group_reporting -name=mytest
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
fio 1.59
Starting 16 threads
Jobs: 7 (f=7): [www__w____w_w__w] [47.3% done] [0K/186.6M /s] [0 /46.7K iops] [eta 18m:35s]s]
mytest: (groupid=0, jobs=16): err= 0: pid=5208
  write: io=232889MB, bw=238470KB/s, iops=59617 , runt=1000036msec
    slat (usec): min=1 , max=65595 , avg=264.91, stdev=3322.66
    clat (usec): min=4 , max=111435 , avg=3992.16, stdev=12317.14
     lat (usec): min=40 , max=111439 , avg=4257.19, stdev=12679.23
    bw (KB/s) : min=    0, max=350792, per=6.31%, avg=15039.33, stdev=6492.82
  cpu          : usr=1.45%, sys=31.90%, ctx=7766821, majf=136, minf=3585068
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/59619701/0, short=0/0/0
     lat (usec): 10=0.01%, 50=19.28%, 100=70.12%, 250=1.14%, 500=0.01%
     lat (usec): 750=0.01%, 1000=0.01%
     lat (msec): 2=0.01%, 4=0.02%, 10=0.05%, 20=0.09%, 50=9.14%
     lat (msec): 100=0.13%, 250=0.01%

Run status group 0 (all jobs):
  WRITE: io=232889MB, aggrb=238470KB/s, minb=244193KB/s, maxb=244193KB/s, mint=1000036msec, maxt=1000036msec
root@host0:~# 



the test result shows: stripe_cache_size==4096
root@host0:~# fio -filename=/dev/md/md0    -iodepth 16 -thread -rw=randwrite -ioengine=libaio -bs=4k -size=30G  -numjobs=16 -runtime=1000 -group_reporting -name=mytest
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
fio 1.59
Starting 16 threads
Jobs: 7 (f=7): [ww_ww_ww_______w] [48.3% done] [0K/224.8M /s] [0 /56.2K iops] [eta 17m:58s]s]               
mytest: (groupid=0, jobs=16): err= 0: pid=4851
  write: io=240727MB, bw=246495KB/s, iops=61623 , runt=1000037msec
    slat (usec): min=1 , max=837996 , avg=257.06, stdev=3387.21
    clat (usec): min=4 , max=838074 , avg=3873.92, stdev=12967.09
     lat (usec): min=41 , max=838077 , avg=4131.10, stdev=13376.14
    bw (KB/s) : min=    0, max=449685, per=6.28%, avg=15490.34, stdev=5760.87
  cpu          : usr=6.16%, sys=18.83%, ctx=15818324, majf=181, minf=3591162
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/61626113/0, short=0/0/0
     lat (usec): 10=0.01%, 50=20.21%, 100=70.72%, 250=0.21%, 500=0.01%
     lat (usec): 750=0.01%, 1000=0.01%
     lat (msec): 2=0.01%, 4=0.02%, 10=0.06%, 20=0.10%, 50=7.87%
     lat (msec): 100=0.75%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%

Run status group 0 (all jobs):
  WRITE: io=240727MB, aggrb=246495KB/s, minb=252411KB/s, maxb=252411KB/s, mint=1000037msec, maxt=1000037msec
root@host0:~# 

the test result shows: stripe_cache_size==8192
root@host0:~# fio -filename=/dev/md/md0    -iodepth 16 -thread -rw=randwrite -ioengine=libaio -bs=4k -size=30G  -numjobs=16 -runtime=1000 -group_reporting -name=mytest
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
fio 1.59
Starting 16 threads
Jobs: 6 (f=6): [__w_w__ww__w___w] [47.6% done] [0K/178.6M /s] [0 /44.7K iops] [eta 18m:24s]s]
mytest: (groupid=0, jobs=16): err= 0: pid=5047
  write: io=233924MB, bw=239511KB/s, iops=59877 , runt=1000114msec
    slat (usec): min=1 , max=235194 , avg=263.80, stdev=4435.78
    clat (usec): min=2 , max=391878 , avg=3974.23, stdev=16930.35
     lat (usec): min=4 , max=391885 , avg=4238.15, stdev=17467.30
    bw (KB/s) : min=    0, max=303248, per=6.34%, avg=15180.71, stdev=5877.14
  cpu          : usr=4.93%, sys=27.37%, ctx=6335719, majf=103, minf=3591206
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/59884454/0, short=0/0/0
     lat (usec): 4=0.01%, 10=0.01%, 20=0.01%, 50=36.26%, 100=55.83%
     lat (usec): 250=0.78%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.01%, 4=0.02%, 10=0.05%, 20=0.09%, 50=5.38%
     lat (msec): 100=0.75%, 250=0.80%, 500=0.01%

Run status group 0 (all jobs):
  WRITE: io=233924MB, aggrb=239510KB/s, minb=245258KB/s, maxb=245258KB/s, mint=1000114msec, maxt=1000114msec
root@host0:~# 

// single ssd disk
root@host0:~# fio -filename=/dev/sdb    -iodepth 16 -thread -rw=randwrite -ioengine=libaio -bs=4k -size=30G  -numjobs=16 -runtime=1000 -group_reporting -name=mytest
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
fio 1.59
Starting 16 threads
Jobs: 1 (f=1): [___w____________] [28.5% done] [0K/0K /s] [0 /0  iops] [eta 43m:08s]        s]
mytest: (groupid=0, jobs=16): err= 0: pid=5308
  write: io=140528MB, bw=143894KB/s, iops=35973 , runt=1000046msec
    slat (usec): min=1 , max=159802 , avg=443.06, stdev=4487.35
    clat (usec): min=4 , max=159916 , avg=6665.26, stdev=16174.17
     lat (usec): min=40 , max=159922 , avg=7108.46, stdev=16611.67
    bw (KB/s) : min=    3, max=892696, per=6.26%, avg=9008.49, stdev=8706.58
  cpu          : usr=2.61%, sys=13.09%, ctx=7436836, majf=58, minf=782937
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=0/35975210/0, short=0/0/0
     lat (usec): 10=0.01%, 50=16.00%, 100=67.45%, 250=1.81%, 500=0.05%
     lat (usec): 750=0.01%, 1000=0.01%
     lat (msec): 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=13.33%
     lat (msec): 100=1.28%, 250=0.04%

Run status group 0 (all jobs):
  WRITE: io=140528MB, aggrb=143894KB/s, minb=147347KB/s, maxb=147347KB/s, mint=1000046msec, maxt=1000046msec

Disk stats (read/write):
  sdb: ios=261/27342034, merge=0/5212609, ticks=48/143752312, in_queue=143721596, util=100.00%
root@host0:~# 




