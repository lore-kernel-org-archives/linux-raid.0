From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 18:00:44 -0600
Message-ID: <CAE9DZURuPGEL4bG=44ntbjp+51jktn36LFGfn11xFR-X9O9POw@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<5669DB3B.30101@turmel.org>
	<CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
	<CAK2H+ednN7dCGzcOt8TxgNdhdDA1mN6Xr5P8vQ+Y=-uRoxRksw@mail.gmail.com>
	<CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
	<CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
	<CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
	<CAE9DZUQo4CojhuVkQ6y=gTEWG5qUkeu57wcZsqbXZtGD_V5JCQ@mail.gmail.com>
	<CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
	<CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
	<22122.64143.522908.45940@quad.stoffel.home>
	<CAE9DZUQ=QynBKYJvq2JSnMaACKNpm+5yrhz+5x9Tx6_TK78mCg@mail.gmail.com>
	<22123.9525.433754.283927@quad.stoffel.home>
	<CAE9DZUTMnwpUX1e95c_i04uWREHd+aR8P2yCE_W-WmEbL6YRkw@mail.gmail.com>
	<CAE9DZUTTP1VhVgT56dyv6aLaM2V8peWSHaBg4xvXzGGUZcJ_hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUTTP1VhVgT56dyv6aLaM2V8peWSHaBg4xvXzGGUZcJ_hw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 11, 2015 at 5:30 PM, Dallas Clement
<dallas.a.clement@gmail.com> wrote:
> On Fri, Dec 11, 2015 at 3:24 PM, Dallas Clement
> <dallas.a.clement@gmail.com> wrote:
>> On Fri, Dec 11, 2015 at 1:34 PM, John Stoffel <john@stoffel.org> wrote:
>>>>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:
>>>
>>> Dallas> On Fri, Dec 11, 2015 at 10:32 AM, John Stoffel <john@stoffel.org> wrote:
>>>>>>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:
>>>>>
>>> Dallas> Hi Mark.  I have three different controllers on this
>>> Dallas> motherboard.  A Marvell 9485 controls 8 of the disks.  And an
>>> Dallas> Intel Cougar Point controls the 4 remaining disks.
>>>>>
>>>>> What type of PCIe slots are the controllers in?  And how fast are the
>>>>> controllers/drives?  Are they SATA1/2/3 drives?
>>>>>
>>>>>>> If you're spinning in IO loops then it could be a driver issue.
>>>>>
>>> Dallas> It sure is looking like that.  I will try to profile the
>>> Dallas> kernel threads today and maybe use blktrace as Phil
>>> Dallas> recommended to see what is going on there.
>>>>>
>>>>> what kernel aer you running?
>>>>>
>>> Dallas> This is pretty sad that 12 single threaded fio jobs can bring
>>> Dallas> this system to its knees.
>>>>>
>>>>> I think it might be better to lower the queue depth, you might be just
>>>>> blowing out the controller caches...  hard to know.
>>>
>>> Dallas> Hi John.
>>>
>>>>> What type of PCIe slots are the controllers in?  And how fast are the
>>>>> controllers/drives?  Are they SATA1/2/3 drives?
>>>
>>> Dallas> The MV 9485 controller is attached to an Intel Sandy Bridge
>>> Dallas> via PCIe GEN2 x 8.  This one controls 8 of the disks.  The
>>> Dallas> Intel Cougar Point is connected to the Intel Sandy Bridge via
>>> Dallas> DMI bus.
>>>
>>> So that should all be nice and fast.
>>>
>>> Dallas> All of the drives are SATA III, however I do have two of the
>>> Dallas> drives connected to SATA II ports on the Cougar Point.  These
>>> Dallas> two drives used to be connected to SATA III ports on a MV
>>> Dallas> 9125/9120 controller.  But it had truly horrible write
>>> Dallas> performance.  Moving to the SATA II ports on the Cougar Point
>>> Dallas> boosted the performance close to the same as the other drives.
>>> Dallas> The remaining 10 drives are all connected to SATA III ports.
>>>
>>>>> what kernel aer you running?
>>>
>>> Dallas> Right now, I'm using 3.10.69.  But I have tried the 4.2 kernel
>>> Dallas> in Fedora 23 with similar results.
>>>
>>> Hmm... maybe if your feeling adventerous you could try v4.4-rc4 and
>>> see how it works.  You don't want anything between 4.2.6 and that
>>> because of problems with blk req management.  I'm hazy on the details.
>>>
>>>>> I think it might be better to lower the queue depth, you might be just
>>>>> blowing out the controller caches...  hard to know.
>>>
>>> Dallas> Good idea.  I'll trying lowering to see what effect.
>>>
>>> It might also make sense to try your tests starting with just 1 disk,
>>> and then adding one more disk, re-running the tests, then another
>>> disk, re-running the tests, etc.
>>>
>>> Try with one on the MV, then one on the Cougar, then one on MV and one
>>> on Cougar, etc.
>>>
>>> Try to see if you can spot where the performance falls off the cliff.
>>>
>>> Also, which disk scheduler are you using?  Instead of CFQ, you might
>>> try deadline instead.
>>>
>>> As you can see, there's a TON of knobs to twiddle with, it's not a
>>> simple thing to do at times.
>>>
>>> John
>>
>>> It might also make sense to try your tests starting with just 1 disk,
>>> and then adding one more disk, re-running the tests, then another
>>> disk, re-running the tests, etc
>>
>>> Try to see if you can spot where the performance falls off the cliff.
>>
>> Okay, did this.  Interestingly, things did not fall of the cliff until
>> adding in the 12th disk.  I started adding disks one at a time
>> beginning with the Cougar Point.  The %iowait jumped up right away
>> with this guy also.
>>
>>> Also, which disk scheduler are you using?  Instead of CFQ, you might
>>> try deadline instead.
>>
>> I'm using deadline.  I have definitely observed better performance
>> with this vs cfq.
>>
>> At this point I think I need to probably use a tool like blktrace to
>> get more visibility than what I have with ps and iostat.
>
> I have one more observation.  I tried varying the queue depth from 1,
> 4, 16, 32, 64, 128, 256.  Surprisingly, all 12 disks are able to
> handle this load with queue depth <= 128.  Each disk is at 100%
> utilization and writing 170-180 MB/s.  Things start to fall apart with
> queue depth = 256 after adding in the 12th disk.  The inflection point
> on load average seems to be around queue depth = 32.  The load average
> for this 8 core system goes up to about 13 when I increase the queue
> depth to 64.
>
> So is my workload of 12 fio jobs writing sequential 2 MB blocks with
> direct I/O just too abusive?  Seems so with high queue depth.
>
> I started this discussion because my RAID 5 and RAID 6 write
> performance is really bad.  If my system is able to write to all 12
> disks at 170 MB/s in JBOD mode, I am expecting that one fio job should
> be able to write at a speed of (N - 1) * X = 11 * 170 MB/s = 1870
> MB/s.  However, I am getting < 700 MB/s for queue depth = 32 and < 600
> MB/s for queue depth = 256.  I get similarly disappointing results for
> RAID 6 writes.

One other thing I failed to mention is that I seem to be unable to
saturate my RAID device using fio.  I have tried increasing the number
of jobs and that has actually resulted in worse performance.  Here's
what I get with just one job thread.

# fio ../job.fio
job: (g=0): rw=write, bs=2M-2M/2M-2M/2M-2M, ioengine=libaio, iodepth=256
fio-2.2.7
Starting 1 process
Jobs: 1 (f=1): [W(1)] [90.5% done] [0KB/725.3MB/0KB /s] [0/362/0 iops]
[eta 00m:02s]
job: (groupid=0, jobs=1): err= 0: pid=30569: Sat Dec 12 08:22:54 2015
  write: io=10240MB, bw=561727KB/s, iops=274, runt= 18667msec
    slat (usec): min=316, max=554160, avg=3623.16, stdev=20560.63
    clat (msec): min=25, max=2744, avg=913.26, stdev=508.27
     lat (msec): min=26, max=2789, avg=916.88, stdev=510.13
    clat percentiles (msec):
     |  1.00th=[  221],  5.00th=[  553], 10.00th=[  594], 20.00th=[  635],
     | 30.00th=[  660], 40.00th=[  685], 50.00th=[  709], 60.00th=[  742],
     | 70.00th=[  791], 80.00th=[  947], 90.00th=[ 1827], 95.00th=[ 2114],
     | 99.00th=[ 2442], 99.50th=[ 2474], 99.90th=[ 2540], 99.95th=[ 2737],
     | 99.99th=[ 2737]
    bw (KB  /s): min= 3093, max=934603, per=97.80%, avg=549364.82,
stdev=269856.22
    lat (msec) : 50=0.14%, 100=0.39%, 250=0.78%, 500=2.03%, 750=58.67%
    lat (msec) : 1000=18.18%, 2000=11.41%, >=2000=8.40%
  cpu          : usr=5.30%, sys=8.89%, ctx=2219, majf=0, minf=32
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.6%, >=64=98.8%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=0/w=5120/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=256

Run status group 0 (all jobs):
  WRITE: io=10240MB, aggrb=561727KB/s, minb=561727KB/s,
maxb=561727KB/s, mint=18667msec, maxt=18667msec

Disk stats (read/write):
    md10: ios=1/81360, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=660/4402, aggrmerge=9848/234056, aggrticks=23282/123890,
aggrin_queue=147976, aggrutil=66.50%
  sda: ios=712/4387, merge=10727/233944, ticks=24150/130830,
in_queue=155810, util=61.32%
  sdb: ios=697/4441, merge=10246/234331, ticks=19820/108830,
in_queue=129430, util=59.58%
  sdc: ios=636/4384, merge=9273/233886, ticks=21380/123780,
in_queue=146070, util=62.17%
  sdd: ios=656/4399, merge=9731/234030, ticks=23050/135000,
in_queue=158880, util=63.91%
  sdf: ios=672/4427, merge=9862/234117, ticks=20110/101910,
in_queue=122790, util=58.53%
  sdg: ios=656/4414, merge=9801/234081, ticks=20820/110860,
in_queue=132390, util=61.38%
  sdh: ios=644/4385, merge=9526/234047, ticks=25120/131670,
in_queue=157630, util=62.80%
  sdi: ios=739/4369, merge=10757/233876, ticks=32430/160810,
in_queue=194080, util=66.50%
  sdj: ios=687/4386, merge=10525/234033, ticks=25770/131950,
in_queue=158530, util=64.18%
  sdk: ios=620/4454, merge=9572/234495, ticks=22010/117190,
in_queue=139960, util=60.80%
  sdl: ios=610/4393, merge=9090/233924, ticks=23800/118340,
in_queue=142910, util=62.12%
  sdm: ios=602/4394, merge=9066/233915, ticks=20930/115520,
in_queue=137240, util=60.96%

As you can see, the array utilization is only 66.5% and the disk
utilization is about the same.  Perhaps I am just using the wrong tool
or using fio incorrectly. On the other hand, I suppose it still could
be a problem with RAID 5, 6 implementation.

This is my fio job config:

# cat ../job.fio
[job]
ioengine=libaio
iodepth=256
prio=0
rw=write
bs=2048k
filename=/dev/md10
numjobs=1
size=10g
direct=1
invalidate=1
ramp_time=15
runtime=120
time_based
