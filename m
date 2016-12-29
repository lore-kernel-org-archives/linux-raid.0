From: Doug Dumitru <doug@easyco.com>
Subject: Re: Intel SSD or other brands
Date: Thu, 29 Dec 2016 10:50:42 -0800
Message-ID: <CAFx4rwT+j3mx3B_bj803Zs1kX=x-1w4Nwwsyb=a=NumFo8-Ufw@mail.gmail.com>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. Goryachev,

I find it easier to look at these numbers in terms of IOPS.  You are
dealing with 17,500 IOPS vs 100 IOPS.  This pretty much has to be the
"commit" from the drive.  The benchmark is basically waiting for the
data to actually hit "recorded media" before the IO completes.  The
"better" drive is returning this "write ACK" when the data is in RAM,
the the "worse" drive is returning this "write ACK" after the data is
somewhere much slower (probably flash).  I would note that 17,500 IOPS
is a "good" but not "great" number.

Doing commit writes to Flash is expensive.  Not only do you have to
wait for the flash, but you have to update the mapping tables to get
to the data.  Flash also does not typically allow 4K updates (even
given the erase rules), so your 4K sync update probably has to update
a 16K "page" is probably causing a lot of flash wear.  Maybe as much
as 10:1 write amplification.  Maybe more.

There are a bunch of things to consider when looking at "sync"
performance.  The easiest way to look at this is that the drive
"absolutely" has to have the data in stable storage to be "correct".
This is not really true, and the overhead of this can be huge.  File
systems "know" this behavior and instead of looking for a hard sync,
they use "barriers".  The idea of a barrier, is that the drive is
allowed to buffer writes, just not re-order them  so that an IO
crosses a "barrier".

Testing of SSDs for this is looking for "serialization errors".  If
you pull power from an SSD and then go look at the blocks that made it
to the media after the reboot, drives can work in one of three ways.
If absolutely every ACKd block is on the drive, then sync works and
barriers are not relevant.  If the writes stop and no "newer" write
made it to the drive when an "older" one did not, then the drive is
still OK with barriers.  If "newer" writes made it to the media but
older writes did not, then this is a serialization error and you have
spaghetti.  SSDs with power fail serialization errors are "bad".  Then
again, it is important to understand the system-level implications of
how the error will impact your stack.

In the case of RAID-5 in a "traditional" Linux deployment, and
especially with DRBD protecting you on another node, you are probably
fine without having every last ACK "perfect".  After all, if you power
fail the primary node, the secondary will become the primary, and any
"tail writes" that are missing will get re-sync'd by DRBD's hash
checks.  And because the amount of data being re-synced is small, it
will happen very quickly and you might not even notice it.

Back to performance, you should also consider what your array is doing
to you.  You are running an 8 drive raid-5 array.  This will limit
performance even more because every write becomes 2 sync writes, plus
6 reads.  With q=1 latencies, if you run this test on the array with
"good" drives, you should probably get about 15K IOPS max, but it
might be a bit worse as the read and write latencies add for each OP.

I tried your test on our "in house" "server-side FTL" mapping layer on
8 drives raid-5.  This is an E5-1650 v3 w/ an LSI 3008 SAS controller
and 8 Samsung 256GB 850 Pro SSDs.  The array is "new" so it will slow
down somewhat as it fills.  439K IOPS is actually quite a bit under
the array's bandwidth, but at q=1, you end up benchmarking the
benchmark program.  (at q=10, the array saturates the drives linear
performance at about 900K IOPS or 3518 MB/sec).

root@ubuntu-16-24-2:/usr/local/ess# fio --filename=/dev/mapper/ess-md0
--direct=1 --sync=1 --rw=write --bs=4k --iodepth=1 --runtime=60
--time_based --group_reporting --name=ess-raid5 --numjobs=1
ess-raid5: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.2.10
Starting 1 process
Jobs: 1 (f=1): [W(1)] [100.0% done] [0KB/1714MB/0KB /s] [0/439K/0
iops] [eta 00m:00s]
ess-raid5: (groupid=0, jobs=1): err= 0: pid=29544: Thu Dec 29 10:36:13 2016
  write: io=102653MB, bw=1710.9MB/s, iops=437980, runt= 60001msec
    clat (usec): min=1, max=155, avg= 2.06, stdev= 0.49
     lat (usec): min=1, max=155, avg= 2.10, stdev= 0.49
    clat percentiles (usec):
     |  1.00th=[    1],  5.00th=[    1], 10.00th=[    2], 20.00th=[    2],
     | 30.00th=[    2], 40.00th=[    2], 50.00th=[    2], 60.00th=[    2],
     | 70.00th=[    2], 80.00th=[    2], 90.00th=[    3], 95.00th=[    3],
     | 99.00th=[    3], 99.50th=[    3], 99.90th=[    7], 99.95th=[    8],
     | 99.99th=[   11]
    bw (MB  /s): min= 1330, max= 1755, per=100.00%, avg=1710.84, stdev=39.12
    lat (usec) : 2=5.17%, 4=94.51%, 10=0.31%, 20=0.02%, 50=0.01%
    lat (usec) : 250=0.01%
  cpu          : usr=14.08%, sys=85.92%, ctx=47, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=26279247/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=102653MB, aggrb=1710.9MB/s, minb=1710.9MB/s,
maxb=1710.9MB/s, mint=60001msec, maxt=60001msec

On Wed, Dec 28, 2016 at 6:14 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> Apologies for my prematurely sent email (if it gets through), this one is
> complete...
>
> Hi all,
>
> I've spent a number of years trying to build up a nice RAID array for my
> SAN, but I seem to be slowly solving one bottle neck only to find another
> one. Right now, I've identified the underlying SSD's as being a major factor
> in that performance issue.
>
> I started with 5 x 480GB Intel 520s SSD's in a RAID5 array, and this
> performed really well.
> I added 1 x 480GB 530s SSD
> I added 2 x 480GB 530s SSD
>
> I now found out that performance of a 520s SSD is around 180 times faster
> than a 530s SSD. I had to run many tests, but eventually I found the right
> things to test for (which matched my real life results), and the numbers
> were nothing short of crazy.
> Running each test 5 times and average the results...
> 520s: 70MB/s
> 530s: 0.4MB/s
>
> OK, so before I could remove and test the 520s, I removed/tested one of the
> 530s and saw the horrible performance, so I bought and tested a 540s and
> found:
> 540s: 6.7MB/s
> So, around 20 times better than the 530, so I replaced all the drives with
> the 540, but I still have worse performance than the original 5 x 520s
> array.
>
> Working with Intel, they swapped a 530s drive for a DC3510, and I then found
> the DC3510 was awesome:
> DC3510: 99MB/s
> Except, a few weeks back when I placed the order, I was told there is no
> longer any stock of this drive, (I wanted 16 x 800GB model), and that the
> replacement model is the DC3520. So I figure I won't just blindly buy the
> DC3520 assuming it's performance will be similar to the previous model, so I
> buy 4 x 480GB DC3520 and start testing.
> DC3520: 37MB/s
>
> So, 1/3rd of a DC3510, but still better than the current live 540s drives,
> but also still half the original 520s drives.
>
> Summary:
> 520s:   70217kB/s
> 530s:     391kB/s
> 540s:    6712kB/s
> 330s:      24kB/s
> DC3510: 99313kB/s
> DC3520: 37051kB/s
> WD2TBCB:  475kB/s
>
> * For comparison, I had a older Western Digital Black 2TB spare, and ran the
> same test on it. Got a better result than some of the SSD's which was really
> surprising, but it's certainly not an option.
> FYI, the test I'm running is this:
> fio --filename=/dev/sdb --direct=1 --sync=1 --rw=write --bs=4k --iodepth=1
> --runtime=60 --time_based --group_reporting --name=IntelDC3510_4kj1
> --numjobs=1
> All drives were tested on the same machine/SATA3 port (basic intel desktop
> motherboard), with nothing on the drive (no fs, no partition, nothing trying
> to access it, etc..).
> In reality, I tested iodepth from 1..10, but in my use case, the iodepth=1
> matches is the relevant number. At higher iodepth, we see performance on all
> the drives improve, if interested, I can provide a full set of my
> results/analysis.
>
> So, my actual question... Can you suggest or have you tested any Intel (or
> other brand) SSD which has good performance (similar to the DC3510 or the
> 520s)? (I can't buy and test every single variant out there, my budget
> doesn't go anywhere close to that).
> It needs to be SATA, since I don't have enough PCIe slots to get the needed
> capacity (nor enough budget). I need around 8 x drives with around 6TB
> capacity in RAID5.
>
> FYI, my storage stack is like this:
> 8 x SSD's
> mdadm - RAID5
> LVM
> DRBD
> iSCSI
>
> From my understanding, it is DRBD that makes everything a iodepth=1 issue.
> It is possible to reach iodepth=2 if I have 2 x VM's both doing a lot of IO
> at the same time, but it usually a single VM performance that is too
> limited.
>
> Regards,
> Adam
>
>
> --
> Adam Goryachev Website Managers www.websitemanagers.com.au
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Doug Dumitru
EasyCo LLC
