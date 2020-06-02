From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] md: improve io stats accounting
Date: Tue, 2 Jun 2020 13:47:03 +0200
Message-ID: <26d5f5c7-9a20-e7f9-617f-0353c5d9bb2e@intel.com>
References: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
 <CAPhsuW4fjc4NgFGQUPuAKSvtWvtzyPor876anj64NF=nqaPo5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4fjc4NgFGQUPuAKSvtWvtzyPor876anj64NF=nqaPo5g@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/2/20 8:48 AM, Song Liu wrote:
>> +               clone = bio_clone_fast(bio, GFP_NOIO, &mddev->md_io_bs);
> 
> Handle clone == NULL?

I think this should never fail - bio_alloc_bioset() guarantees that. It
is used in a similar manner in raid1 and raid10. How about
BUG_ON(clone == NULL)?

> Also, have you done benchmarks with this change?

I tested 4k random reads on a raid0 (4x P4510 2TB) and it was 2550k vs
2567k IOPS, that's slower only by about 0.66%:

without patch:

# fio --direct=1 --thread --rw=randread --ioengine=libaio --iodepth=64 --bs=4k --name=fio --filename=/dev/md0 --time_based --runtime=300 --numjobs=16 --group_reporting --norandommap --randrepeat=0
fio: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
...
fio-3.20
Starting 16 threads
Jobs: 16 (f=16): [r(16)][100.0%][r=9.81GiB/s][r=2571k IOPS][eta 00m:00s]
fio: (groupid=0, jobs=16): err= 0: pid=8678: Tue Jun  2 13:19:38 2020
  read: IOPS=2567k, BW=9.79GiB/s (10.5GB/s)(2938GiB/300002msec)
    slat (nsec): min=1384, max=798130, avg=2852.52, stdev=1108.15
    clat (usec): min=48, max=12387, avg=395.81, stdev=260.52
     lat (usec): min=51, max=12389, avg=398.70, stdev=260.51
    clat percentiles (usec):
     |  1.00th=[  101],  5.00th=[  135], 10.00th=[  157], 20.00th=[  196],
     | 30.00th=[  233], 40.00th=[  273], 50.00th=[  322], 60.00th=[  379],
     | 70.00th=[  457], 80.00th=[  562], 90.00th=[  734], 95.00th=[  889],
     | 99.00th=[ 1287], 99.50th=[ 1500], 99.90th=[ 2147], 99.95th=[ 2442],
     | 99.99th=[ 3130]
   bw (  MiB/s): min= 9664, max=10215, per=100.00%, avg=10033.54, stdev= 4.59, samples=9584
   iops        : min=2474063, max=2615178, avg=2568585.96, stdev=1176.06, samples=9584
  lat (usec)   : 50=0.01%, 100=0.94%, 250=33.51%, 500=39.98%, 750=16.36%
  lat (usec)   : 1000=6.16%
  lat (msec)   : 2=2.92%, 4=0.14%, 10=0.01%, 20=0.01%
  cpu          : usr=16.07%, sys=41.29%, ctx=193003298, majf=0, minf=90976
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=770061876,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=9.79GiB/s (10.5GB/s), 9.79GiB/s-9.79GiB/s (10.5GB/s-10.5GB/s), io=2938GiB (3154GB), run=300002-300002msec

Disk stats (read/write):
    md0: ios=769770571/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=192515469/0, aggrmerge=0/0, aggrticks=74947558/0, aggrin_queue=6006362, aggrutil=100.00%
  nvme3n1: ios=192511957/0, merge=0/0, ticks=76700358/0, in_queue=6215887, util=100.00%
  nvme6n1: ios=192503722/0, merge=0/0, ticks=72629807/0, in_queue=5520156, util=100.00%
  nvme2n1: ios=192518930/0, merge=0/0, ticks=74719743/0, in_queue=5979779, util=100.00%
  nvme1n1: ios=192527267/0, merge=0/0, ticks=75740325/0, in_queue=6309628, util=100.00%

with patch:

# fio --direct=1 --thread --rw=randread --ioengine=libaio --iodepth=64 --bs=4k --name=fio --filename=/dev/md0 --time_based --runtime=300 --numjobs=16 --group_reporting --norandommap --randrepeat=0
fio: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
...
fio-3.20
Starting 16 threads
Jobs: 16 (f=16): [r(16)][100.0%][r=9934MiB/s][r=2543k IOPS][eta 00m:00s]
fio: (groupid=0, jobs=16): err= 0: pid=8463: Tue Jun  2 13:32:12 2020
  read: IOPS=2550k, BW=9961MiB/s (10.4GB/s)(2918GiB/300002msec)
    slat (nsec): min=1512, max=3578.1k, avg=5145.36, stdev=2145.71
    clat (usec): min=50, max=12421, avg=396.13, stdev=210.38
     lat (usec): min=52, max=12428, avg=401.33, stdev=210.45
    clat percentiles (usec):
     |  1.00th=[  133],  5.00th=[  178], 10.00th=[  208], 20.00th=[  247],
     | 30.00th=[  281], 40.00th=[  314], 50.00th=[  347], 60.00th=[  383],
     | 70.00th=[  437], 80.00th=[  510], 90.00th=[  644], 95.00th=[  783],
     | 99.00th=[ 1156], 99.50th=[ 1369], 99.90th=[ 1991], 99.95th=[ 2311],
     | 99.99th=[ 2999]
   bw (  MiB/s): min= 9266, max=10648, per=100.00%, avg=9967.23, stdev=13.31, samples=9584
   iops        : min=2372118, max=2725915, avg=2551610.09, stdev=3407.18, samples=9584
  lat (usec)   : 100=0.13%, 250=20.62%, 500=58.25%, 750=15.25%, 1000=3.92%
  lat (msec)   : 2=1.72%, 4=0.10%, 10=0.01%, 20=0.01%
  cpu          : usr=15.97%, sys=66.59%, ctx=11235674, majf=0, minf=41238
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=764997277,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=9961MiB/s (10.4GB/s), 9961MiB/s-9961MiB/s (10.4GB/s-10.4GB/s), io=2918GiB (3133GB), run=300002-300002msec

Disk stats (read/write):
    md0: ios=764702549/0, merge=0/0, ticks=242091778/0, in_queue=242091754, util=100.00%, aggrios=191249319/0, aggrmerge=0/0, aggrticks=59760064/0, aggrin_queue=2798855, aggrutil=100.00%
  nvme3n1: ios=191250967/0, merge=0/0, ticks=61633420/0, in_queue=3032943, util=100.00%
  nvme6n1: ios=191257919/0, merge=0/0, ticks=59065688/0, in_queue=2784603, util=100.00%
  nvme2n1: ios=191255129/0, merge=0/0, ticks=58520284/0, in_queue=2461116, util=100.00%
  nvme1n1: ios=191233262/0, merge=0/0, ticks=59820864/0, in_queue=2916760, util=100.00%
