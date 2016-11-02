From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 15:11:57 -0600
Message-ID: <CAANLjFq=hSv4Y6AJHzqfoU_ebnpvBsb-=epO5gbSbaM0XgTt4g@mail.gmail.com>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
 <20161102181923.GA21325@www5.open-std.org> <CAANLjFqqTvs0Uh1R6Bvk9FyQUgQqhj+48uC4iiut_A3Uh6j6DA@mail.gmail.com>
 <20161102194842.GA25173@www5.open-std.org> <CAANLjFpQ-s4E3dKmaEEp0DcWaSQx21-Leafukir6idET++zMsg@mail.gmail.com>
 <20161102204153.GA23899@cthulhu.home.robinhill.me.uk> <CAANLjFoXWyjBnDyxtAcTYrVxrpSp4YFYFnpWXG-cDkxouw9QGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFoXWyjBnDyxtAcTYrVxrpSp4YFYFnpWXG-cDkxouw9QGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As a comparision, here is a RAID10 n4 with 4 disks....

root@rleblanc-pc:~# mdadm --detail /dev/md14
/dev/md14:
       Version : 1.2
 Creation Time : Wed Nov  2 15:01:09 2016
    Raid Level : raid10
    Array Size : 10477568 (9.99 GiB 10.73 GB)
 Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
  Raid Devices : 4
 Total Devices : 4
   Persistence : Superblock is persistent

   Update Time : Wed Nov  2 15:01:28 2016
         State : clean, resyncing
Active Devices : 4
Working Devices : 4
Failed Devices : 0
 Spare Devices : 0

        Layout : near=4
    Chunk Size : 512K

 Resync Status : 38% complete

          Name : rleblanc-pc:14  (local to host rleblanc-pc)
          UUID : 61114475:19a4404b:07b0a66d:a0e4447a
        Events : 6

   Number   Major   Minor   RaidDevice State
      0       7       11        0      active sync set-A   /dev/loop11
      1       7       12        1      active sync set-B   /dev/loop12
      2       7       13        2      active sync set-C   /dev/loop13
      3       7       14        3      active sync set-D   /dev/loop14

root@rleblanc-pc:~/junk# fio -rw=read --size=5G --name=mdadm_test
mdadm_test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.10
Starting 1 process
mdadm_test: Laying out IO file(s) (1 file(s) / 5120MB)
Jobs: 1 (f=1): [R(1)] [100.0% done] [238.3MB/0KB/0KB /s] [60.1K/0/0
iops] [eta 00m:00s]
mdadm_test: (groupid=0, jobs=1): err= 0: pid=19925: Wed Nov  2 15:08:15 2016
 read : io=5120.0MB, bw=343278KB/s, iops=85819, runt= 15273msec
   clat (usec): min=0, max=25847, avg=11.16, stdev=237.64
    lat (usec): min=0, max=25847, avg=11.23, stdev=237.64
   clat percentiles (usec):
    |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
    | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    1],
    | 70.00th=[    1], 80.00th=[    1], 90.00th=[    2], 95.00th=[    2],
    | 99.00th=[    4], 99.50th=[    8], 99.90th=[ 2992], 99.95th=[ 4080],
    | 99.99th=[11456]
   bw (KB  /s): min=240136, max=528384, per=100.00%, avg=345144.53,
stdev=83065.30
   lat (usec) : 2=82.29%, 4=16.62%, 10=0.63%, 20=0.05%, 50=0.03%
   lat (usec) : 100=0.01%, 250=0.01%, 500=0.04%, 750=0.02%, 1000=0.01%
   lat (msec) : 2=0.08%, 4=0.15%, 10=0.04%, 20=0.01%, 50=0.01%
 cpu          : usr=5.71%, sys=14.59%, ctx=4480, majf=0, minf=11
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=1310720/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  READ: io=5120.0MB, aggrb=343277KB/s, minb=343277KB/s,
maxb=343277KB/s, mint=15273msec, maxt=15273msec

Disk stats (read/write):
   md14: ios=46045/3, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=11520/7, aggrmerge=0/0, aggrticks=85659/98,
aggrin_queue=85756, aggrutil=80.49%
 loop13: ios=17421/7, merge=0/0, ticks=133600/132, in_queue=133732, util=74.76%
 loop11: ios=4006/7, merge=0/0, ticks=22572/80, in_queue=22648, util=45.68%
 loop14: ios=19532/7, merge=0/0, ticks=154152/112, in_queue=154268, util=80.49%
 loop12: ios=5124/7, merge=0/0, ticks=32312/68, in_queue=32376, util=49.54%

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
nvme0n1          46.50  1459.00 4351.00 2990.50 386402.00 17792.00
110.11     3.94    0.53    0.86    0.05   0.13  94.80
loop11            0.00     0.00  252.50    0.00 29785.50     0.00
235.92     1.77    6.82    6.82    0.00   1.89  47.60
loop12            0.00     0.00  260.50    0.00 30805.50     0.00
236.51     2.00    7.66    7.66    0.00   1.88  49.00
loop13            0.00     0.00  905.00    0.00 102173.00     0.00
225.80     8.08    8.95    8.95    0.00   0.80  72.80
loop14            0.00     0.00 1074.50    0.00 120820.25     0.00
224.89    10.61    9.90    9.90    0.00   0.78  83.60
loop15            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md14              0.00     0.00 2493.00    0.00 283648.00     0.00
227.56     0.00    0.00    0.00    0.00   0.00   0.00

root@rleblanc-pc:~/junk# fio -rw=randread --size=5G --name=mdadm_test
mdadm_test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.10
Starting 1 process
Jobs: 1 (f=1): [r(1)] [97.7% done] [195.4MB/0KB/0KB /s] [49.1K/0/0
iops] [eta 00m:02s]
mdadm_test: (groupid=0, jobs=1): err= 0: pid=19953: Wed Nov  2 15:10:18 2016
 read : io=5120.0MB, bw=62013KB/s, iops=15503, runt= 84545msec
   clat (usec): min=4, max=11510, avg=63.40, stdev=96.01
    lat (usec): min=4, max=11510, avg=63.47, stdev=96.03
   clat percentiles (usec):
    |  1.00th=[    6],  5.00th=[    7], 10.00th=[    8], 20.00th=[    8],
    | 30.00th=[    9], 40.00th=[   11], 50.00th=[   17], 60.00th=[   61],
    | 70.00th=[  102], 80.00th=[  122], 90.00th=[  155], 95.00th=[  185],
    | 99.00th=[  258], 99.50th=[  298], 99.90th=[  494], 99.95th=[ 1816],
    | 99.99th=[ 3056]
   bw (KB  /s): min=22992, max=227816, per=99.90%, avg=61952.96, stdev=53309.04
   lat (usec) : 10=33.36%, 20=18.05%, 50=7.94%, 100=9.46%, 250=29.99%
   lat (usec) : 500=1.09%, 750=0.02%, 1000=0.01%
   lat (msec) : 2=0.03%, 4=0.04%, 10=0.01%, 20=0.01%
 cpu          : usr=2.63%, sys=13.01%, ctx=1310641, majf=0, minf=9
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=1310720/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  READ: io=5120.0MB, aggrb=62012KB/s, minb=62012KB/s, maxb=62012KB/s,
mint=84545msec, maxt=84545msec

Disk stats (read/write):
   md14: ios=1304718/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=327680/0, aggrmerge=0/0, aggrticks=18719/0,
aggrin_queue=18689, aggrutil=88.37%
 loop13: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
 loop11: ios=1310108/0, merge=0/0, ticks=74856/0, in_queue=74736, util=88.37%
 loop14: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
 loop12: ios=612/0, merge=0/0, ticks=20/0, in_queue=20, util=0.02%

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
nvme0n1          11.00     0.00 7046.00    0.00 30048.00     0.00
8.53     0.60    0.09    0.09    0.00   0.08  59.20
loop11            0.00     0.00 7953.00    0.00 31812.00     0.00
8.00     0.88    0.11    0.11    0.00   0.11  88.40
loop12            0.00     0.00    3.50    0.00    14.00     0.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00
loop13            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop14            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop15            0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md14              0.00     0.00 7956.50    0.00 31826.00     0.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00

So sequential reads are being spread out, not completely evenly, but
some. Random reads looks almost like RAID1 with only one disk doing
all the work.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Nov 2, 2016 at 2:59 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> root@rleblanc-pc:~# losetup -l
> NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE   DIO
> /dev/loop1         0      0         0  0 /root/junk1   0
> /dev/loop4         0      0         0  0 /root/junk4   0
> /dev/loop2         0      0         0  0 /root/junk2   0
> /dev/loop5         0      0         0  0 /root/junk5   0
> /dev/loop3         0      0         0  0 /root/junk3   0
> root@rleblanc-pc:~# mdadm --create /dev/md13 --level 1 --raid-devices
> 4 --run /dev/loop{1..4}
> mdadm: Note: this array has metadata at the start and
>    may not be suitable as a boot device.  If you plan to
>    store '/boot' on this device please ensure that
>    your boot-loader understands md/v1.x metadata, or use
>    --metadata=0.90
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md13 started.
> root@rleblanc-pc:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md13 : active raid1 loop4[3] loop3[2] loop2[1] loop1[0]
>      10477568 blocks super 1.2 [4/4] [UUUU]
>
> unused devices: <none>
> root@rleblanc-pc:~# mkfs.ext4 /dev/md13
> mke2fs 1.43.3 (04-Sep-2016)
> Discarding device blocks: done
> Creating filesystem with 2619392 4k blocks and 655360 inodes
> Filesystem UUID: 3bb68653-50af-492f-a3d4-8d0a5f2f4ca4
> Superblock backups stored on blocks:
>        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632
>
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: done
>
> root@rleblanc-pc:~# mkdir junk
> root@rleblanc-pc:~# mount /dev/md13 junk
> root@rleblanc-pc:~# cd junk
> root@rleblanc-pc:~/junk# fio -rw=read --size=5G --name=mdadm_test
> mdadm_test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> fio-2.10
> Starting 1 process
> mdadm_test: Laying out IO file(s) (1 file(s) / 5120MB)
> Jobs: 1 (f=1): [R(1)] [100.0% done] [338.3MB/0KB/0KB /s] [86.6K/0/0
> iops] [eta 00m:00s]
> mdadm_test: (groupid=0, jobs=1): err= 0: pid=18198: Wed Nov  2 14:54:20 2016
>  read : io=5120.0MB, bw=483750KB/s, iops=120937, runt= 10838msec
>    clat (usec): min=0, max=21384, avg= 7.98, stdev=108.10
>     lat (usec): min=0, max=21384, avg= 8.02, stdev=108.10
>    clat percentiles (usec):
>     |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
>     | 30.00th=[    0], 40.00th=[    0], 50.00th=[    1], 60.00th=[    1],
>     | 70.00th=[    1], 80.00th=[    1], 90.00th=[    1], 95.00th=[    1],
>     | 99.00th=[  274], 99.50th=[  386], 99.90th=[  828], 99.95th=[ 2704],
>     | 99.99th=[ 4640]
>    bw (KB  /s): min=324608, max=748032, per=95.94%, avg=464090.29,
> stdev=120877.09
>    lat (usec) : 2=95.25%, 4=3.09%, 10=0.06%, 20=0.02%, 50=0.09%
>    lat (usec) : 100=0.01%, 250=0.35%, 500=0.88%, 750=0.13%, 1000=0.02%
>    lat (msec) : 2=0.01%, 4=0.06%, 10=0.01%, 20=0.01%, 50=0.01%
>  cpu          : usr=5.02%, sys=12.25%, ctx=19708, majf=0, minf=10
>  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>     issued    : total=r=1310720/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>     latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>   READ: io=5120.0MB, aggrb=483749KB/s, minb=483749KB/s,
> maxb=483749KB/s, mint=10838msec, maxt=10838msec
>
> Disk stats (read/write):
>    md13: ios=60029/3, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> aggrios=15360/6, aggrmerge=0/0, aggrticks=13502/101,
> aggrin_queue=13600, aggrutil=98.75%
>  loop1: ios=61427/6, merge=0/0, ticks=54008/116, in_queue=54112, util=98.75%
>  loop4: ios=0/6, merge=0/0, ticks=0/92, in_queue=92, util=0.84%
>  loop2: ios=16/6, merge=0/0, ticks=0/104, in_queue=104, util=0.95%
>  loop3: ios=0/6, merge=0/0, ticks=0/92, in_queue=92, util=0.84%
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> nvme0n1           0.00  1206.50 3517.50 2018.50 446660.00 12878.00
> 166.02     1.60    0.29    0.42    0.06   0.17  93.00
> loop1             0.00     0.00 5233.50    0.00 446536.25     0.00
> 170.65     5.01    0.96    0.96    0.00   0.19 100.00
> loop2             0.00     0.00    1.00    0.00   120.00     0.00
> 240.00     0.00    0.00    0.00    0.00   0.00   0.00
> loop3             0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> loop4             0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> loop5             0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> md13              0.00     0.00 5235.00    0.00 446720.00     0.00
> 170.67     0.00    0.00    0.00    0.00   0.00   0.00
>
> root@rleblanc-pc:~/junk# fio -rw=randread --size=5G --name=mdadm_test
> mdadm_test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> fio-2.10
> Starting 1 process
> Jobs: 1 (f=1): [r(1)] [100.0% done] [444.5MB/0KB/0KB /s] [114K/0/0
> iops] [eta 00m:00s]
> mdadm_test: (groupid=0, jobs=1): err= 0: pid=18924: Wed Nov  2 14:55:16 2016
>  read : io=5120.0MB, bw=463890KB/s, iops=115972, runt= 11302msec
>    clat (usec): min=4, max=15649, avg= 8.03, stdev=37.76
>     lat (usec): min=4, max=15649, avg= 8.07, stdev=37.76
>    clat percentiles (usec):
>     |  1.00th=[    5],  5.00th=[    5], 10.00th=[    6], 20.00th=[    6],
>     | 30.00th=[    6], 40.00th=[    6], 50.00th=[    7], 60.00th=[    7],
>     | 70.00th=[    7], 80.00th=[    8], 90.00th=[    9], 95.00th=[   10],
>     | 99.00th=[   17], 99.50th=[   95], 99.90th=[  151], 99.95th=[  179],
>     | 99.99th=[ 1528]
>    bw (KB  /s): min=237416, max=543576, per=99.67%, avg=462350.91,
> stdev=62842.83
>    lat (usec) : 10=93.06%, 20=6.09%, 50=0.25%, 100=0.13%, 250=0.45%
>    lat (usec) : 500=0.01%, 750=0.01%, 1000=0.01%
>    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
>  cpu          : usr=12.39%, sys=46.90%, ctx=1310616, majf=1, minf=9
>  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>     issued    : total=r=1310720/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>     latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>   READ: io=5120.0MB, aggrb=463889KB/s, minb=463889KB/s,
> maxb=463889KB/s, mint=11302msec, maxt=11302msec
>
> Disk stats (read/write):
>    md13: ios=1303936/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> aggrios=327680/0, aggrmerge=0/0, aggrticks=1635/0, aggrin_queue=1621,
> aggrutil=56.53%
>  loop1: ios=1310359/0, merge=0/0, ticks=6504/0, in_queue=6448, util=56.53%
>  loop4: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>  loop2: ios=361/0, merge=0/0, ticks=36/0, in_queue=36, util=0.32%
>  loop3: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> nvme0n1           0.00     8.50 1255.00    9.50  7552.00    64.00
> 12.05     0.23    0.18    0.17    1.68   0.12  15.60
> loop1             0.00     0.00 115485.50    0.00 461942.00     0.00
>   8.00     0.63    0.01    0.01    0.00   0.01  62.80
> loop2             0.00     0.00   31.50    0.00   126.00     0.00
> 8.00     0.00    0.00    0.00    0.00   0.00   0.00
> loop3             0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> loop4             0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> loop5             0.00     0.00    0.00    0.00     0.00     0.00
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> md13              0.00     0.00 115512.50    0.00 462050.00     0.00
>   8.00     0.00    0.00    0.00    0.00   0.00   0.00
>
> This is indicative of what we see in production as well. As you can
> see fio closely matches what iostat shows as far as device work. I
> don't know how you are seeing even reads. I've seen this on both
> CentOS and Debian.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Wed, Nov 2, 2016 at 2:41 PM, Robin Hill <robin@robinhill.me.uk> wrote:
>> On Wed Nov 02, 2016 at 01:56:02pm -0600, Robert LeBlanc wrote:
>>
>>> Yes, we can have any number of disks in a RAID1 (we currently have
>>> three), but reads only ever come from the first drive.
>>>
>> How are you testing? I use RAID1 on a number of systems and reads
>> look to be pretty evenly spread across the drives.
>>
>> Cheers,
>>     Robin
