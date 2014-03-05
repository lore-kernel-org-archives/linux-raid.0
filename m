From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid5 write latency is 10x the drive latency
Date: Wed, 5 Mar 2014 00:16:14 +0000
Message-ID: <21270.27854.246608.2637@tree.ty.sabi.co.uk>
References: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
	<21268.65296.503057.601739@tree.ty.sabi.co.uk>
	<CAGRgLy542j-G2WAbRdqGf26xfnQ5wkCqnEmgPecHtEp-WpXOSA@mail.gmail.com>
	<21270.21852.212278.318577@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21270.21852.212278.318577@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
>>> Because some of the numbers look a bit amazing or strange:
>>> 
>>> * Only 20% of IOPS are reads, which is pretty miraculous.
>>> [ ... ]
>>> * Each drive delivers over 1,000 4kiB IOPS (mixed r/W), which is
>>> also pretty miraculous if they are disk drives, and terrible if
>>> they are flash drives.
>>> [ ... ]
>>> and the percent of reads goes down to 16.6% almost exactly.
>>> These numbers tell a story, a pretty strong story.
[ ... ]
> From a very similar test on a RAID5 I had created for fun, [ ... ]
>  Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>  sdc2             45.00     6.00   20.00  111.00   260.00   452.00    10.87     1.22    9.34    4.20   10.27   2.32  30.40
>  sdd2             48.00     8.00   29.00  117.00   308.00   500.00    11.07     1.34    9.15   12.55    8.31   2.82  41.20
>  sde2             42.00     6.00   19.00  109.00   244.00   444.00    10.75     1.14    8.91    7.79    9.10   2.59  33.20
>  sdf2             35.00     5.00   22.00  107.00   228.00   464.00    10.73     1.02    7.66    7.27    7.74   2.26  29.20
>  sdg2             40.00     7.00   23.00  106.00   252.00   452.00    10.91     1.12    8.47    7.65    8.64   2.39  30.80
>  md2               0.00     0.00    0.00  100.00     0.00  1344.00    26.88     0.00    0.00    0.00    0.00   0.00   0.00

I have redone the test with more details. Same hardware, a
contemporary PC with an ADM 6100 CPU, 8GiB of RAM, several
7200RPM 1TB contemporary SATA drives, entirely quiet. The MD
RAID set was created out of 112GiB partitions in the outer (but
not outermost) cylinders. One drive slower than the other 4.

------------------------------------------------------------------------
  #  mdadm -C /dev/md2 -f -c 64 -l 5 -n 5 /dev/sd{c,d,e,f}2 missing
  mdadm: array /dev/md2 started.
  #  echo 200000 >| /sys/block/md2/md/sync_speed_min 
  #  echo 500000 >| /sys/block/md2/md/sync_speed_max
  #  mdadm /dev/md2 --add /dev/sdg2
  mdadm: added /dev/sdg2
  #  grep -A2 md2 /proc/mdstat 
  md2 : active raid5 sdg2[5] sdc2[0] sdf2[3] sde2[2] sdd2[1]
	486538752 blocks super 1.0 level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
	[>....................]  recovery =  3.7% (4581684/121634688) finish=26.1min speed=74591K/sec</li>
  #  grep -A2 md2 /proc/mdstat 
  md2 : active raid5 sdg2[5] sdc2[0] sdf2[3] sde2[2] sdd2[1]
	486538752 blocks super 1.0 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
------------------------------------------------------------------------
  #  mkfs.xfs -f -s size=4096 -i size=512,attr=2 -l size=64m,su=256k -L tmp /dev/md2
  meta-data=/dev/md2               isize=512    agcount=16, agsize=7602160 blks
	   =                       sectsz=4096  attr=2, projid32bit=0
  data     =                       bsize=4096   blocks=121634560, imaxpct=25
	   =                       sunit=16     swidth=64 blks
  naming   =version 2              bsize=4096   ascii-ci=0
  log      =internal log           bsize=4096   blocks=16384, version=2
	   =                       sectsz=4096  sunit=64 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  #  mount -t xfs -o defaults,inode64,barrier /dev/md2 /fs/tmp
  #  echo 32000 >| /sys/block/md2/md/stripe_cache_size
------------------------------------------------------------------------

At this point I started 'iostat -dkxz sd{c,d,e,f,g}2 md2' in
another window, and manually created the file for 'fio', having
raised the 'stripe_cache' to speed that up a bit, as 256 is a
bit too low:

------------------------------------------------------------------------
  #  dd bs=1M count=420000 if=/dev/zero conv=fsync of=/fs/tmp/FIO-TEST
  420000+0 records in
  420000+0 records out
  440401920000 bytes (440 GB) copied, 1128.98 s, 390 MB/s
  #  filefrag /fs/tmp/FIO-TEST 
  /fs/tmp/FIO-TEST: 27 extents found
------------------------------------------------------------------------

During the 'dd' to create the file 'iostat' reported something
like:

  Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
  sdc2             16.00 25583.00   10.00  238.00   104.00 103656.00   836.77     3.99   16.13   32.40   15.45   3.32  82.40
  sdd2             30.00 25569.00    9.00  242.00   160.00 103616.00   826.90     3.03   12.13   17.78   11.92   3.03  76.00
  sde2              9.00 25569.00    2.00  238.00    44.00 102076.00   851.00     4.71   18.43  104.00   17.71   3.60  86.40
  sdf2             21.00 25564.00    3.00  248.00    96.00 103620.00   826.42     9.88   39.39   58.67   39.16   3.90  98.00
  sdg2             17.00 25553.00    5.00  256.00    88.00 103620.00   794.70    10.74   41.18   72.80   40.56   3.75  98.00
  md2               0.00     0.00    0.00 6349.00     0.00 404176.00   127.32     0.00    0.00    0.00    0.00   0.00   0.00

The I run the random RW test with what I regard as
semi-plausible options:

------------------------------------------------------------------------
  #  cat /root/fio-randomw.ini
  [global]
  bs=8k
  ioengine=libaio
  iodepth=2
  size=400g
  fsync=4
  runtime=60
  directory=/fs/tmp
  filename=FIO-TEST

  [rand-write]
  rw=randwrite
  stonewall
------------------------------------------------------------------------
  #  fio /root/fio-randomw.ini
  rand-write: (g=0): rw=randwrite, bs=8K-8K/8K-8K, ioengine=libaio, iodepth=2
  fio 1.59
  Starting 1 process
  Jobs: 1 (f=1): [w] [100.0% done] [0K/261K /s] [0 /31  iops] [eta 00m:00s]
  rand-write: (groupid=0, jobs=1): err= 0: pid=32227
    write: io=16192KB, bw=276269 B/s, iops=33 , runt= 60016msec
      slat (usec): min=12 , max=73 , avg=18.28, stdev= 7.31
      clat (usec): min=16 , max=394656 , avg=29652.40, stdev=53335.77
       lat (usec): min=29 , max=394669 , avg=29671.12, stdev=53333.29
      bw (KB/s) : min=  156, max=  338, per=100.31%, avg=269.84, stdev=34.30
    cpu          : usr=0.02%, sys=0.34%, ctx=4717, majf=0, minf=23
    IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
       issued r/w/d: total=0/2024/0, short=0/0/0
       lat (usec): 20=43.73%, 50=31.23%, 100=0.05%
       lat (msec): 100=6.27%, 250=18.68%, 500=0.05%

  Run status group 0 (all jobs):
    WRITE: io=16192KB, aggrb=269KB/s, minb=276KB/s, maxb=276KB/s, mint=60016msec, maxt=60016msec

  Disk stats (read/write):
    md2: ios=0/4279, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=1111/13535, aggrmerge=3096/738, aggrticks=15718/142220, aggrin_queue=157931, aggrutil=52.91%
      sdd: ios=1140/13698, merge=3162/742, ticks=20808/158072, in_queue=178864, util=52.91%
      sde: ios=1064/13477, merge=2893/694, ticks=16804/128884, in_queue=145680, util=41.19%
      sdf: ios=1059/13479, merge=2864/738, ticks=11832/117780, in_queue=129604, util=35.02%
      sdc: ios=1178/13773, merge=3377/773, ticks=13316/125512, in_queue=138828, util=38.35%
      sdg: ios=1117/13251, merge=3186/745, ticks=15832/180852, in_queue=196680, util=45.99%
------------------------------------------------------------------------

The above seems pretty clear to me. During the above a typical
'iostat' report looks like:

  Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
  sdc2             12.00    12.00   15.00  207.00   108.00   876.00     8.86     2.08    9.39   15.20    8.97   1.08  24.00
  sdd2             13.00    13.00   14.00  158.00   108.00   684.00     9.21     2.45   14.26   26.86   13.14   1.91  32.80
  sde2             12.00    12.00   14.00  158.00   104.00   680.00     9.12     2.08   12.09   19.43   11.44   1.60  27.60
  sdf2             12.00    12.00   13.00  151.00   100.00   652.00     9.17     1.68   10.24   15.08    9.83   1.44  23.60
  sdg2             11.00    11.00   12.00  181.00    92.00   704.00     8.25     4.81   29.58   16.33   30.45   2.16  41.60
  md2               0.00     0.00    0.00   64.00     0.00  2112.00    66.00     0.00    0.00    0.00    0.00   0.00   0.00

Which seems entirely plausible to me. Having rerun the same
test with a stripe cache size of 256 I get:

  Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
  sdc2            119.00    14.00   22.00  191.00   564.00   820.00    13.00     2.39   11.23    9.64   11.41   1.37  29.20
  sdd2            103.00    13.00   30.00  187.00   532.00   800.00    12.28     2.29   10.54   17.60    9.41   1.95  42.40
  sde2             70.00    10.00   15.00  164.00   340.00   696.00    11.58     1.76    9.83   12.53    9.59   1.43  25.60
  sdf2             66.00     7.00   15.00  138.00   324.00   580.00    11.82     1.63   10.67    6.93   11.07   1.23  18.80
  sdg2             93.00    14.00   25.00  171.00   472.00   740.00    12.37     2.59   13.22   15.52   12.89   1.86  36.40
  md2               0.00     0.00    0.00   69.00     0.00  2304.00    66.78     0.00    0.00    0.00    0.00   0.00   0.00

By varying 'iodepth' and 'fsync' I get interesting variation;
larger device latencies and much larger MD latencies (hundreds
of ms) happen with many threads, which is (euphemism alert)
unsurprising.

>>>> [ ... ] is 10 times the latency of individual drives. [ ... ]

>>> The latency of what actually? [ ... ] The definition of
>>> 'await' if that's what you are looking may be interesting.
>>> [ ... ] Because some of the numbers look a bit amazing or
>>> strange: [ ... ] Which tool settings? How many threads? [
>>> ... ]

Apposite :-).

>> Also what's the size of those LV members of the MD set? It
>> may be quite small...

Guessing wildly, the strange 'iostat' reports might indicate
that the IOMETER test has been run "inadvertently" against a
very small file/area compared to the number of threads, and
their strangeness should have raised "concerns".
