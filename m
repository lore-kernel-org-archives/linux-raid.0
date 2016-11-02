From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 14:59:13 -0600
Message-ID: <CAANLjFoXWyjBnDyxtAcTYrVxrpSp4YFYFnpWXG-cDkxouw9QGg@mail.gmail.com>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
 <20161102181923.GA21325@www5.open-std.org> <CAANLjFqqTvs0Uh1R6Bvk9FyQUgQqhj+48uC4iiut_A3Uh6j6DA@mail.gmail.com>
 <20161102194842.GA25173@www5.open-std.org> <CAANLjFpQ-s4E3dKmaEEp0DcWaSQx21-Leafukir6idET++zMsg@mail.gmail.com>
 <20161102204153.GA23899@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161102204153.GA23899@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

root@rleblanc-pc:~# losetup -l
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE   DIO
/dev/loop1         0      0         0  0 /root/junk1   0
/dev/loop4         0      0         0  0 /root/junk4   0
/dev/loop2         0      0         0  0 /root/junk2   0
/dev/loop5         0      0         0  0 /root/junk5   0
/dev/loop3         0      0         0  0 /root/junk3   0
root@rleblanc-pc:~# mdadm --create /dev/md13 --level 1 --raid-devices
4 --run /dev/loop{1..4}
mdadm: Note: this array has metadata at the start and
   may not be suitable as a boot device.  If you plan to
   store '/boot' on this device please ensure that
   your boot-loader understands md/v1.x metadata, or use
   --metadata=0.90
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md13 started.
root@rleblanc-pc:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md13 : active raid1 loop4[3] loop3[2] loop2[1] loop1[0]
     10477568 blocks super 1.2 [4/4] [UUUU]

unused devices: <none>
root@rleblanc-pc:~# mkfs.ext4 /dev/md13
mke2fs 1.43.3 (04-Sep-2016)
Discarding device blocks: done
Creating filesystem with 2619392 4k blocks and 655360 inodes
Filesystem UUID: 3bb68653-50af-492f-a3d4-8d0a5f2f4ca4
Superblock backups stored on blocks:
       32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

root@rleblanc-pc:~# mkdir junk
root@rleblanc-pc:~# mount /dev/md13 junk
root@rleblanc-pc:~# cd junk
root@rleblanc-pc:~/junk# fio -rw=read --size=5G --name=mdadm_test
mdadm_test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.10
Starting 1 process
mdadm_test: Laying out IO file(s) (1 file(s) / 5120MB)
Jobs: 1 (f=1): [R(1)] [100.0% done] [338.3MB/0KB/0KB /s] [86.6K/0/0
iops] [eta 00m:00s]
mdadm_test: (groupid=0, jobs=1): err= 0: pid=18198: Wed Nov  2 14:54:20 2016
 read : io=5120.0MB, bw=483750KB/s, iops=120937, runt= 10838msec
   clat (usec): min=0, max=21384, avg= 7.98, stdev=108.10
    lat (usec): min=0, max=21384, avg= 8.02, stdev=108.10
   clat percentiles (usec):
    |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
    | 30.00th=[    0], 40.00th=[    0], 50.00th=[    1], 60.00th=[    1],
    | 70.00th=[    1], 80.00th=[    1], 90.00th=[    1], 95.00th=[    1],
    | 99.00th=[  274], 99.50th=[  386], 99.90th=[  828], 99.95th=[ 2704],
    | 99.99th=[ 4640]
   bw (KB  /s): min=324608, max=748032, per=95.94%, avg=464090.29,
stdev=120877.09
   lat (usec) : 2=95.25%, 4=3.09%, 10=0.06%, 20=0.02%, 50=0.09%
   lat (usec) : 100=0.01%, 250=0.35%, 500=0.88%, 750=0.13%, 1000=0.02%
   lat (msec) : 2=0.01%, 4=0.06%, 10=0.01%, 20=0.01%, 50=0.01%
 cpu          : usr=5.02%, sys=12.25%, ctx=19708, majf=0, minf=10
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=1310720/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  READ: io=5120.0MB, aggrb=483749KB/s, minb=483749KB/s,
maxb=483749KB/s, mint=10838msec, maxt=10838msec

Disk stats (read/write):
   md13: ios=60029/3, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=15360/6, aggrmerge=0/0, aggrticks=13502/101,
aggrin_queue=13600, aggrutil=98.75%
 loop1: ios=61427/6, merge=0/0, ticks=54008/116, in_queue=54112, util=98.75%
 loop4: ios=0/6, merge=0/0, ticks=0/92, in_queue=92, util=0.84%
 loop2: ios=16/6, merge=0/0, ticks=0/104, in_queue=104, util=0.95%
 loop3: ios=0/6, merge=0/0, ticks=0/92, in_queue=92, util=0.84%

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
nvme0n1           0.00  1206.50 3517.50 2018.50 446660.00 12878.00
166.02     1.60    0.29    0.42    0.06   0.17  93.00
loop1             0.00     0.00 5233.50    0.00 446536.25     0.00
170.65     5.01    0.96    0.96    0.00   0.19 100.00
loop2             0.00     0.00    1.00    0.00   120.00     0.00
240.00     0.00    0.00    0.00    0.00   0.00   0.00
loop3             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop4             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop5             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md13              0.00     0.00 5235.00    0.00 446720.00     0.00
170.67     0.00    0.00    0.00    0.00   0.00   0.00

root@rleblanc-pc:~/junk# fio -rw=randread --size=5G --name=mdadm_test
mdadm_test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.10
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [444.5MB/0KB/0KB /s] [114K/0/0
iops] [eta 00m:00s]
mdadm_test: (groupid=0, jobs=1): err= 0: pid=18924: Wed Nov  2 14:55:16 2016
 read : io=5120.0MB, bw=463890KB/s, iops=115972, runt= 11302msec
   clat (usec): min=4, max=15649, avg= 8.03, stdev=37.76
    lat (usec): min=4, max=15649, avg= 8.07, stdev=37.76
   clat percentiles (usec):
    |  1.00th=[    5],  5.00th=[    5], 10.00th=[    6], 20.00th=[    6],
    | 30.00th=[    6], 40.00th=[    6], 50.00th=[    7], 60.00th=[    7],
    | 70.00th=[    7], 80.00th=[    8], 90.00th=[    9], 95.00th=[   10],
    | 99.00th=[   17], 99.50th=[   95], 99.90th=[  151], 99.95th=[  179],
    | 99.99th=[ 1528]
   bw (KB  /s): min=237416, max=543576, per=99.67%, avg=462350.91,
stdev=62842.83
   lat (usec) : 10=93.06%, 20=6.09%, 50=0.25%, 100=0.13%, 250=0.45%
   lat (usec) : 500=0.01%, 750=0.01%, 1000=0.01%
   lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
 cpu          : usr=12.39%, sys=46.90%, ctx=1310616, majf=1, minf=9
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=1310720/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
    latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  READ: io=5120.0MB, aggrb=463889KB/s, minb=463889KB/s,
maxb=463889KB/s, mint=11302msec, maxt=11302msec

Disk stats (read/write):
   md13: ios=1303936/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=327680/0, aggrmerge=0/0, aggrticks=1635/0, aggrin_queue=1621,
aggrutil=56.53%
 loop1: ios=1310359/0, merge=0/0, ticks=6504/0, in_queue=6448, util=56.53%
 loop4: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
 loop2: ios=361/0, merge=0/0, ticks=36/0, in_queue=36, util=0.32%
 loop3: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
nvme0n1           0.00     8.50 1255.00    9.50  7552.00    64.00
12.05     0.23    0.18    0.17    1.68   0.12  15.60
loop1             0.00     0.00 115485.50    0.00 461942.00     0.00
  8.00     0.63    0.01    0.01    0.00   0.01  62.80
loop2             0.00     0.00   31.50    0.00   126.00     0.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00
loop3             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop4             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
loop5             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md13              0.00     0.00 115512.50    0.00 462050.00     0.00
  8.00     0.00    0.00    0.00    0.00   0.00   0.00

This is indicative of what we see in production as well. As you can
see fio closely matches what iostat shows as far as device work. I
don't know how you are seeing even reads. I've seen this on both
CentOS and Debian.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Nov 2, 2016 at 2:41 PM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Wed Nov 02, 2016 at 01:56:02pm -0600, Robert LeBlanc wrote:
>
>> Yes, we can have any number of disks in a RAID1 (we currently have
>> three), but reads only ever come from the first drive.
>>
> How are you testing? I use RAID1 on a number of systems and reads
> look to be pretty evenly spread across the drives.
>
> Cheers,
>     Robin
