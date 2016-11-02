From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 15:27:23 -0600
Message-ID: <CAANLjFqj44wE_Be8FOaVU9AwM-=n_hquyqD1CHUy5y0W06G=wA@mail.gmail.com>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
 <20161102181923.GA21325@www5.open-std.org> <CAANLjFqqTvs0Uh1R6Bvk9FyQUgQqhj+48uC4iiut_A3Uh6j6DA@mail.gmail.com>
 <20161102194842.GA25173@www5.open-std.org> <CAANLjFpQ-s4E3dKmaEEp0DcWaSQx21-Leafukir6idET++zMsg@mail.gmail.com>
 <20161102210022.GA19707@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161102210022.GA19707@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hmmm....

RAID1
root@rleblanc-pc:~/junk# fio -rw=read --size=1G --numjobs=4
--name=mdadm_test --group_reporting
mdadm_test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
...
fio-2.10
Starting 4 processes
mdadm_test: Laying out IO file(s) (1 file(s) / 1024MB)
mdadm_test: Laying out IO file(s) (1 file(s) / 1024MB)
mdadm_test: Laying out IO file(s) (1 file(s) / 1024MB)
Jobs: 1 (f=1): [R(1),_(3)] [88.9% done] [423.8MB/0KB/0KB /s] [108K/0/0
iops] [eta 00m:01s]
mdadm_test: (groupid=0, jobs=4): err= 0: pid=20564: Wed Nov  2 15:15:40 2016
 read : io=4096.0MB, bw=567642KB/s, iops=141910, runt=  7389msec
   clat (usec): min=0, max=22233, avg=23.02, stdev=288.38
    lat (usec): min=0, max=22233, avg=23.12, stdev=288.38
   clat percentiles (usec):
    |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    1],
    | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    2],
    | 70.00th=[    2], 80.00th=[    2], 90.00th=[    2], 95.00th=[    3],
    | 99.00th=[  644], 99.50th=[ 1144], 99.90th=[ 4128], 99.95th=[ 5600],
    | 99.99th=[11584]
   bw (KB  /s): min=94396, max=469418, per=28.62%, avg=162451.40, stdev=81106.83
   lat (usec) : 2=58.15%, 4=39.21%, 10=0.87%, 20=0.09%, 50=0.16%
   lat (usec) : 100=0.13%, 250=0.14%, 500=0.13%, 750=0.26%, 1000=0.29%
   lat (msec) : 2=0.29%, 4=0.20%, 10=0.09%, 20=0.01%, 50=0.01%
 cpu          : usr=4.14%, sys=10.87%, ctx=15564, majf=0, minf=41
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=1048576/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  READ: io=4096.0MB, aggrb=567641KB/s, minb=567641KB/s,
maxb=567641KB/s, mint=7389msec, maxt=7389msec

Disk stats (read/write):
   md13: ios=48375/3, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=12292/6, aggrmerge=0/0, aggrticks=31009/140,
aggrin_queue=31145, aggrutil=97.41%
 loop1: ios=14654/6, merge=0/0, ticks=39524/156, in_queue=39672, util=97.41%
 loop4: ios=5791/6, merge=0/0, ticks=13976/100, in_queue=14072, util=45.45%
 loop2: ios=16575/6, merge=0/0, ticks=37360/152, in_queue=37508, util=90.92%
 loop3: ios=12150/6, merge=0/0, ticks=33176/152, in_queue=33328, util=91.08%

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
nvme0n1           0.50  1387.00 3234.00 2996.50 388746.00 17500.00
130.41     4.44    0.71    1.29    0.09   0.16  98.40
loop1             0.00     0.00 1510.00    2.50 128839.75     6.50
170.38     5.10    3.37    3.34   24.80   0.66 100.00
loop2             0.00     0.00 1570.00    2.50 133952.25     6.50
170.38     5.22    3.31    3.27   25.60   0.64 100.00
loop3             0.00     0.00 1521.50    2.50 129855.75     6.50
170.42     5.00    3.27    3.24   25.60   0.65  98.60
loop4             0.00     0.00    2.50    2.50   248.00     6.50
101.80     0.04    8.40    1.60   15.20   8.00   4.00
loop5             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md13              0.00     0.00 4603.50    1.50 392832.00     6.00
170.61     0.00    0.00    0.00    0.00   0.00   0.00

root@rleblanc-pc:~/junk# fio -rw=randread --size=1G --numjobs=4
--name=mdadm_test --group_reporting
mdadm_test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
...
fio-2.10
Starting 4 processes
Jobs: 1 (f=1): [_(3),r(1)] [100.0% done] [35996KB/0KB/0KB /s]
[8999/0/0 iops] [eta 00m:00s]
mdadm_test: (groupid=0, jobs=4): err= 0: pid=21036: Wed Nov  2 15:17:47 2016
 read : io=4096.0MB, bw=133254KB/s, iops=33313, runt= 31476msec
   clat (usec): min=4, max=14896, avg=103.19, stdev=123.06
    lat (usec): min=4, max=14896, avg=103.27, stdev=123.06
   clat percentiles (usec):
    |  1.00th=[    7],  5.00th=[    9], 10.00th=[   11], 20.00th=[   90],
    | 30.00th=[   95], 40.00th=[   99], 50.00th=[  104], 60.00th=[  112],
    | 70.00th=[  118], 80.00th=[  125], 90.00th=[  141], 95.00th=[  167],
    | 99.00th=[  247], 99.50th=[  318], 99.90th=[ 2256], 99.95th=[ 2512],
    | 99.99th=[ 4256]
   bw (KB  /s): min=26472, max=57008, per=28.80%, avg=38380.41, stdev=7929.82
   lat (usec) : 10=6.96%, 20=10.26%, 50=1.27%, 100=22.67%, 250=57.86%
   lat (usec) : 500=0.68%, 750=0.04%, 1000=0.02%
   lat (msec) : 2=0.09%, 4=0.12%, 10=0.01%, 20=0.01%
 cpu          : usr=1.51%, sys=7.30%, ctx=1051111, majf=0, minf=38
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=1048576/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  READ: io=4096.0MB, aggrb=133254KB/s, minb=133254KB/s,
maxb=133254KB/s, mint=31476msec, maxt=31476msec

Disk stats (read/write):
   md13: ios=1047839/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=262144/0, aggrmerge=0/0, aggrticks=25507/0,
aggrin_queue=25490, aggrutil=92.98%
 loop1: ios=342845/0, merge=0/0, ticks=29440/0, in_queue=29424, util=92.98%
 loop4: ios=190900/0, merge=0/0, ticks=20568/0, in_queue=20552, util=65.09%
 loop2: ios=257401/0, merge=0/0, ticks=26512/0, in_queue=26492, util=83.65%
 loop3: ios=257430/0, merge=0/0, ticks=25508/0, in_queue=25492, util=80.67%

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
nvme0n1           0.00     0.00 34484.50    0.00 141398.00     0.00
 8.20     3.02    0.09    0.09    0.00   0.03 100.00
loop11            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop12            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop13            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop14            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop15            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md14              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00

RAID10
root@rleblanc-pc:~/junk# fio -rw=read --size=1G --numjobs=4
--name=mdadm_test --group_reporting
...
Disk stats (read/write):
   md14: ios=36295/19, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=9227/27, aggrmerge=0/0, aggrticks=274586/1967,
aggrin_queue=276552, aggrutil=98.05%
 loop13: ios=9006/27, merge=0/0, ticks=253296/1824, in_queue=255120, util=95.31%
 loop11: ios=9171/27, merge=0/0, ticks=260884/1876, in_queue=262760, util=96.57%
 loop14: ios=9593/27, merge=0/0, ticks=313672/2256, in_queue=315924, util=98.05%
 loop12: ios=9141/27, merge=0/0, ticks=270492/1912, in_queue=272404, util=97.20%

root@rleblanc-pc:~/junk# fio -rw=randread --size=1G --numjobs=4
--name=mdadm_test --group_reporting
...
Disk stats (read/write):
   md14: ios=1047470/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=262144/0, aggrmerge=0/0, aggrticks=33242/0,
aggrin_queue=33209, aggrutil=92.62%
 loop13: ios=258512/0, merge=0/0, ticks=33188/0, in_queue=33160, util=90.21%
 loop11: ios=275798/0, merge=0/0, ticks=34120/0, in_queue=34088, util=92.62%
 loop14: ios=252031/0, merge=0/0, ticks=31976/0, in_queue=31936, util=87.15%
 loop12: ios=262235/0, merge=0/0, ticks=33684/0, in_queue=33652, util=91.52%

Much better distribution, especially on RAID10. I wonder if because we
are running a single VM on the array that libvirt is basically single
threaded causing what we are seeing. I think libvirt can have multiple
threads for I/O, we'll have to look into that. It is obvious that md
can split reads from a single thread, I wonder what is preventing from
allowing it to do it more efficiently.

This warrants more probing.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Nov 2, 2016 at 3:00 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Wed, Nov 02, 2016 at 01:56:02PM -0600, Robert LeBlanc wrote:
>> Yes, we can have any number of disks in a RAID1 (we currently have
>> three), but reads only ever come from the first drive.
>
> Only if there's only one reader. So it depends on what activity
> there is on the machine.
>
>> We just need the option to grow a RAID10 like we can with RAID1.
>
> Patches welcome, I'm sure? ;-)
>
>> Basically, we want to be super paranoid with several identical copies
>> of the data and get extra read performance.
>
> You could put RAID on RAID and thus achieve other modes but not sure
> if it's worth the overhead or even applies in any way to your use case
> and using non standard setups always comes with its own pitfalls.
>
> RAID 1, with RAID0 on top, three disks ABC, two partitions ab,
> different disk order.
>
>   A B C
> a 1 2 3
> b 3 1 2
>
> Three RAID 1 md1, md2, md3, (and md0 a RAID-0 on top).
>
> You can grow it.
>
>   A B C D
> a 1 2 3 ?
> b 3 1 2 ?
>
>   A B C D
> a 1 2 3 ?
> b 3 1 2 3
>
> md3 has 3 disks temporarily here.
>
>   A B C D
> a 1 2 3 4
> b 4 1 2 3
>
> md4 is new, to be added to md0.
>
> Three copies? Same thing with three partitions.
>
> Will it help any or make things worse? I dunno.
> Have to be careful to make md0 assemble last.
>
> Could also be RAID5 on top instead of RAID1.
> That's even stranger though.
>
> Regards
> Andreas Klauer
