From: CoolCold <coolthecold@gmail.com>
Subject: Re: internal write-intent bitmap is horribly slow with RAID10 over 20 drives
Date: Mon, 12 Jun 2017 13:12:02 +0700
Message-ID: <CAGqmV7p+Ww0Yand0wpZqFmAwwTeghDB7N3+qh8Jwe2gqpnJoGg@mail.gmail.com>
References: <CAGqmV7qRh+_BXAr-qf6vUkiZyzi69E8CiX_vA92tZV2LfDxq_A@mail.gmail.com>
 <87tw3tdbs1.fsf@notabene.neil.brown.name> <CAGqmV7qVq8nBmop5h7OZKr9ZjCjGLcoPqMF5xa4d2iHzf2uQdw@mail.gmail.com>
 <87fufcdbak.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fufcdbak.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
i've started doing testing as proposed by you and found other strange
behavior with _4_ drives ~ 44 iops as well:
mdadm --create --assume-clean -c $((64*1)) -b internal
--bitmap-chunk=$((128*1024)) -n 4 -l 10 /dev/md1 /dev/sde /dev/sdf
/dev/sdg /dev/sdh

mdstat:
[root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid10 sdh[3] sdg[2] sdf[1] sde[0]
      3516066176 blocks super 1.2 64K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/14 pages [0KB], 131072KB chunk


fio:
[root@spare-a17484327407661 tests]# fio --runtime 60 randwrite.conf
randwrite: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio,
iodepth=512
fio-2.2.8
Starting 1 process
Jobs: 1 (f=1): [w(1)] [100.0% done] [0KB/179KB/0KB /s] [0/44/0 iops]
[eta 00m:00s]
randwrite: (groupid=0, jobs=1): err= 0: pid=35048: Mon Jun 12 06:03:28 2017
  write: io=35728KB, bw=609574B/s, iops=148, runt= 60018msec
    slat (usec): min=6, max=3006.6K, avg=6714.32, stdev=33548.39
    clat (usec): min=137, max=14323K, avg=3430245.54, stdev=4822029.01
     lat (msec): min=22, max=14323, avg=3436.96, stdev=4830.87
    clat percentiles (msec):
     |  1.00th=[   40],  5.00th=[   76], 10.00th=[   87], 20.00th=[  115],
     | 30.00th=[  437], 40.00th=[  510], 50.00th=[  553], 60.00th=[  619],
     | 70.00th=[ 2376], 80.00th=[11600], 90.00th=[11731], 95.00th=[11863],
     | 99.00th=[12387], 99.50th=[13435], 99.90th=[14091], 99.95th=[14222],
     | 99.99th=[14353]
    bw (KB  /s): min=  111, max=14285, per=95.41%, avg=567.70, stdev=1623.95
    lat (usec) : 250=0.01%
    lat (msec) : 50=2.02%, 100=12.52%, 250=7.01%, 500=17.02%, 750=30.62%
    lat (msec) : 1000=0.12%, 2000=0.50%, >=2000=30.18%
  cpu          : usr=0.06%, sys=0.34%, ctx=2607, majf=0, minf=30
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=0.4%, >=64=99.3%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=8932/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=512

Run status group 0 (all jobs):
  WRITE: io=35728KB, aggrb=595KB/s, minb=595KB/s, maxb=595KB/s,
mint=60018msec, maxt=60018msec

Disk stats (read/write):
    md1: ios=61/8928, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=16/6693, aggrmerge=0/0, aggrticks=13/512251,
aggrin_queue=512265, aggrutil=83.63%
  sde: ios=40/6787, merge=0/0, ticks=15/724812, in_queue=724824, util=83.63%
  sdf: ios=2/6787, merge=0/0, ticks=5/694057, in_queue=694061, util=82.20%
  sdg: ios=24/6599, merge=0/0, ticks=27/154988, in_queue=155022, util=80.72%
  sdh: ios=1/6599, merge=0/0, ticks=6/475150, in_queue=475155, util=82.29%





comparing to the same drives on RAID5 fio shows ~ 142 iops:
[root@spare-a17484327407661 tests]# fio --runtime 60 randwrite.conf
randwrite: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio,
iodepth=512
fio-2.2.8
Starting 1 process
Jobs: 1 (f=1): [w(1)] [0.0% done] [0KB/571KB/0KB /s] [0/142/0 iops]
[eta 93d:11h:20m:52s]
randwrite: (groupid=0, jobs=1): err= 0: pid=34914: Mon Jun 12 05:59:23 2017
  write: io=41880KB, bw=707115B/s, iops=172, runt= 60648msec

raid5 created basically the same as for RAID10
mdadm --create --assume-clean -c $((64*1)) -b internal
--bitmap-chunk=$((128*1024)) -n 4 -l 5 /dev/md1 /dev/sde /dev/sdf
/dev/sdg /dev/sdh

mdstat output for raid5:
[root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid5 sdh[3] sdg[2] sdf[1] sde[0]
      5274099264 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 7/7 pages [28KB], 131072KB chunk


for both cases, the same fio config:
[root@spare-a17484327407661 tests]# cat randwrite.conf
[randwrite]
blocksize=4k
#blocksize=64k
filename=/dev/md1
#filename=/dev/md2
readwrite=randwrite
#rwmixread=75
direct=1
buffered=0
ioengine=libaio
iodepth=512
#numjobs=4
group_reporting=1

from iostat, hard drives are having more requests than md1 (compare
40-43 on md1 and ~ 60 per device)
[root@spare-a17484327407661 rovchinnikov]# iostat -d -xk 1  /dev/md1
/dev/sde /dev/sdf /dev/sdg /dev/sdh
Linux 3.10.0-327.el7.x86_64 (spare-a17484327407661.sgdc)
06/12/2017      _x86_64_        (40 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sde               0.00     0.00    0.00   59.00     0.00   236.00
8.00     0.76   12.76    0.00   12.76  12.75  75.20
sdh               0.00     0.00    0.00   59.00     0.00   236.00
8.00     0.76   12.85    0.00   12.85  12.88  76.00
sdf               0.00     0.00    0.00   62.00     0.00   248.00
8.00     0.78   12.89    0.00   12.89  12.58  78.00
sdg               0.00     0.00    0.00   62.00     0.00   248.00
8.00     0.77   12.71    0.00   12.71  12.45  77.20
md1               0.00     0.00    0.00   40.00     0.00   160.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sde               0.00     0.00    0.00   66.00     0.00   264.00
8.00     0.80   12.39    0.00   12.39  12.09  79.80
sdh               0.00     0.00    0.00   62.00     0.00   248.00
8.00     0.78   12.87    0.00   12.87  12.58  78.00
sdf               0.00     0.00    0.00   66.00     0.00   264.00
8.00     0.78   11.82    0.00   11.82  11.82  78.00
sdg               0.00     0.00    0.00   62.00     0.00   248.00
8.00     0.80   12.82    0.00   12.82  12.85  79.70
md1               0.00     0.00    0.00   43.00     0.00   172.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sde               0.00     0.00    0.00   65.00     0.00   260.00
8.00     0.81   12.43    0.00   12.43  12.40  80.60
sdh               0.00     0.00    0.00   58.00     0.00   232.00
8.00     0.74   12.81    0.00   12.81  12.78  74.10
sdf               0.00     0.00    0.00   71.00     0.00   284.00
8.00     0.81   11.38    0.00   11.38  11.34  80.50
sdg               0.00     0.00    0.00   64.00     0.00   256.00
8.00     0.82   12.77    0.00   12.77  12.73  81.50
md1               0.00     0.00    0.00   43.00     0.00   172.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00

I don't see any good explanation for this, kindly waiting for your advice.


On Wed, Jun 7, 2017 at 5:02 AM, NeilBrown <neilb@suse.com> wrote:
> On Tue, Jun 06 2017, CoolCold wrote:
>
>> Hello!
>> Neil, thanks for reply, further inline
>>
>> On Tue, Jun 6, 2017 at 10:40 AM, NeilBrown <neilb@suse.com> wrote:
>>> On Mon, Jun 05 2017, CoolCold wrote:
>>>
>>>> Hello!
>>>> Keep testing the new box and while having not the best sync speed,
>>>> it's not the worst thing I found.
>>>>
>>>> Doing FIO testing, for RAID10 over 20 10k RPM drives, I have very bad
>>>> performance, like _45_ iops only.
>>>
>>> ...
>>>>
>>>>
>>>> Output from fio with internal write-intent bitmap:
>>>> Jobs: 1 (f=1): [w(1)] [28.3% done] [0KB/183KB/0KB /s] [0/45/0 iops]
>>>> [eta 07m:11s]
>>>>
>>>> array definition:
>>>> [root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
>>>> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
>>>> md1 : active raid10 sdx[19] sdw[18] sdv[17] sdu[16] sdt[15] sds[14]
>>>> sdr[13] sdq[12] sdp[11] sdo[10] sdn[9] sdm[8] sdl[7] sdk[6] sdj[5]
>>>> sdi[4] sdh[3] sdg[2] sdf[1] sde[0]
>>>>       17580330880 blocks super 1.2 64K chunks 2 near-copies [20/20]
>>>> [UUUUUUUUUUUUUUUUUUUU]
>>>>       bitmap: 0/66 pages [0KB], 131072KB chunk
>>>>
>>>> Setting journal to be
>>>> 1) on SSD (separate drives), shows
>>>> Jobs: 1 (f=1): [w(1)] [5.0% done] [0KB/18783KB/0KB /s] [0/4695/0 iops]
>>>> [eta 09m:31s]
>>>> 2) to 'none' (disabling) shows
>>>> Jobs: 1 (f=1): [w(1)] [14.0% done] [0KB/18504KB/0KB /s] [0/4626/0
>>>> iops] [eta 08m:36s]
>>>
>>> These numbers suggest that the write intent bitmap causes a 100-fold slow
>>> down.
>>> i.e. 45 iops instead of 4500 iops (roughly).
>>>
>>> That is certainly more than I would expect, so maybe there is a bug.
>> I suppose noone is using raid10 over more than 4 drives then, i can't
>> believe i'm the one who hit this problem.
>
> We have customers who use RAID10 will many more than 4 drives, but I
> haven't had reports like this.  Presumably whatever problem is affecting
> you is not affecting them.  We cannot know until we drill down to
> understand the problem.
>
>>
>>>
>>> Large RAID10 is a worst-base for bitmap updates as the bitmap is written
>>> to all devices instead of just those devices that contain the data which
>>> the bit corresponds to.  So every bitmap update goes to 10 device.
>>>
>>> Your bitmap chunk size of 128M is nice and large, but making it larger
>>> might help - maybe 1GB.
>> Tried that already, wasn't any much difference, but will gather more statistics.
>>
>>>
>>> Still 100-fold ... that's a lot..
>>>
>>> A potentially useful exercise would be to run a series of tests,
>>> changing the number of devices in the array from 2 to 10, changing the
>>> RAID chunk size from 64K to 64M, and changing the bitmap chunk size from
>>> 64M to 4G.
>> Changing chunk size to up to 64M just to gather statistics or you
>> suppose it may be some practical usage for this?
>
> I don't have any particular reason to expect this to have an effect.
> But it is easy to change, and changing it might show provide some hints.
> So probably "just to gather statistics".
>
> NeilBrown
>
>
>>> In each configuration, run the same test and record the iops.
>>> (You don't need to wait for a resync each time, just use
>>> --assume-clean).
>> This helps, thanks
>>> Then graph all this data (or just provide the table and I'll graph it).
>>> That might provide an insight into where to start looking for the
>>> slowdown.
>>>
>>> NeilBrown
>>
>>
>>
>> --
>> Best regards,
>> [COOLCOLD-RIPN]
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
[COOLCOLD-RIPN]
