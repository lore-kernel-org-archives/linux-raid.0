From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 15:42:25 -0600
Message-ID: <51157141.90205@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51150475.2020803@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/8/2013 7:58 AM, Adam Goryachev wrote:

> Firstly, this is done against /tmp which is on the single standalone
> Intel SSD used for the rootfs (shows some performance level of the
> chipset I presume):

The chipset performance shouldn't be an issue, but it's possible.

> root@san1:/tmp/testing# fio /root/test.fio
> seq-read: (g=0): rw=read, bs=64K-64K/64K-64K, ioengine=libaio, iodepth=32
> seq-write: (g=1): rw=write, bs=64K-64K/64K-64K, ioengine=libaio, iodepth=32
> Starting 2 processes
> seq-read: Laying out IO file(s) (1 file(s) / 4096MB)
> Jobs: 1 (f=1): [_W] [100.0% done] [0K/137M /s] [0/2133 iops] [eta 00m:00s]
> seq-read: (groupid=0, jobs=1): err= 0: pid=4932
>   read : io=4096MB, bw=518840KB/s, iops=8106, runt=  8084msec
> seq-write: (groupid=1, jobs=1): err= 0: pid=5138
>   write: io=4096MB, bw=136405KB/s, iops=2131, runt= 30749msec
> Run status group 0 (all jobs):
>    READ: io=4096MB, aggrb=518840KB/s, minb=531292KB/s, maxb=531292KB/s,
> mint=8084msec, maxt=8084msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4096MB, aggrb=136404KB/s, minb=139678KB/s, maxb=139678KB/s,
> mint=30749msec, maxt=30749msec
> 
> Disk stats (read/write):
>   sda: ios=66570/66363, merge=10297/10453, ticks=259152/993304,
> in_queue=1252592, util=99.34%
...
> This seems to indicate a read speed of 531M and write of 139M, which to
> me says something is wrong. I thought write speed is slower, but not
> that much slower?

Study this:
http://www.anandtech.com/show/5508/intel-ssd-520-review-cherryville-brings-reliability-to-sandforce/3

That's the 240GB version of your 520S.  Note the write tests are all
well over 300MB/s, one seq write test reaching almost 400MB/s.  The
480GB version should be even better.  These tests use 4KB *aligned* IOs.
 If you've partitioned the SSDs, and your partition boundaries fall in
the middle of erase blocks instead of perfectly between them, then your
IOs will be unaligned, and performance will suffer.  Considering the
numbers you're seeing with FIO this may be part of the low performance
problem.

> Moving on, I've stopped the secondary DRBD, created a new LV (testlv) of
> 15G, and formatted with ext4, mounted it, and re-run the test:
> 
> seq-read: (groupid=0, jobs=1): err= 0: pid=19578
>   read : io=4096MB, bw=640743KB/s, iops=10011, runt=  6546msec
> seq-write: (groupid=1, jobs=1): err= 0: pid=19997
>   write: io=4096MB, bw=208765KB/s, iops=3261, runt= 20091msec
> Run status group 0 (all jobs):
>    READ: io=4096MB, aggrb=640743KB/s, minb=656120KB/s, maxb=656120KB/s,
> mint=6546msec, maxt=6546msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4096MB, aggrb=208765KB/s, minb=213775KB/s, maxb=213775KB/s,
> mint=20091msec, maxt=20091msec
> 
> Disk stats (read/write):
>   dm-14: ios=65536/64841, merge=0/0, ticks=206920/469464,
> in_queue=676580, util=98.89%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0,
> aggrin_queue=0, aggrutil=0.00%
>     drbd2: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=-nan%
> 
> dm-14 is the testlv
> 
> So, this indicates a max read speed of 656M and write of 213M, again,
> write is very slow (about 30%).
> 
> With these figures, just 2 x 1Gbps links would saturate the write
> performance of this RAID5 array.

You might get close if you ran a synthetic test, but you wouldn't
bottleneck at the array with CIFS traffic from that DC.  Now, once you
get the network problems straightened out, then you may bottleneck the
SSDs with multiple large sequential writes.  Assuming you don't get the
block IO issues fixed.

I recommend blowing away the partitions entirely and building your md
array on bare drives.  As part of this you will have to recreate your
LVs you're exporting via iSCSI.  Make sure all LVs are aligned to the
underlying md device geometry.  This will eliminate any possible
alignment issues.

Whether it does or not, given what I've learned of this environment, I'd
go ahead and install one of the LSI 9207-8i 6GB/s SAS/SATA HBAs I
mentioned earlier, in SLOT6 for full bandwidth, and move all the SSDs in
the array over to it.  This will give you 600MB/s peak bandwidth per SSD
eliminating any possible issues created by running them at SATA2 link
speed, and eliminate any possible issues with the C204 Southbridge chip,
while giving you substantially higher controller IOPS: 700,000.  If the
SSDs are not on a chassis backplane you'll need two SFF8088 breakout
cables to connect the drives to the card.  The "kit" version of these
cards comes with these cables.  Kit runs ~$350 USD.

> Finally, changing the fio config file to point filename=/dev/vg0/testlv
> (ie, raw LV, no filesystem):
> seq-read: (groupid=0, jobs=1): err= 0: pid=10986
>   read : io=4096MB, bw=652607KB/s, iops=10196, runt=  6427msec
> seq-write: (groupid=1, jobs=1): err= 0: pid=11177
>   write: io=4096MB, bw=202252KB/s, iops=3160, runt= 20738msec
> Run status group 0 (all jobs):
>    READ: io=4096MB, aggrb=652606KB/s, minb=668269KB/s, maxb=668269KB/s,
> mint=6427msec, maxt=6427msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4096MB, aggrb=202252KB/s, minb=207106KB/s, maxb=207106KB/s,
> mint=20738msec, maxt=20738msec
> 
> Not much difference, which I didn't really expect...
> 
> So, should I be concerned about these results? Do I need to try to
> re-run these tests at a lower layer (ie, remove DRBD and/or LVM from the
> picture)? Are these meaningless and I should be running a different
> test/set of tests/etc ?

The ~200MB/s seq writes is a bit alarming, as is the ~500MB/s read rate.
 5 SSDs in RAID5 should be able to do much much more, especially reads.
 Theoretically you should be able to squeeze 2GB/s of read speed out of
this RAID5.  But given this is a RAID5 array, write will always be
slower, even with SSD.  But they shouldn't be this much slower with SSD
because the RMW latency is so much lower.  But with large sequential
writes you shouldn't have RMW cycles anyway.  If DRBD is mirroring the
md/RAID5 device it will definitely skew your test results lower, but not
drastically so.  I can't recall if you stated the size of your md stripe
cache.  If it's too small that may be hurting performance.

Something we've only briefly touched on so far is the single write
thread bottleneck of the md/RAID5 driver.  To verify if this is part of
this problem you need to capture CPU core utilization during your write
tests to see if md is eating all of one core.  If it is then your RAID5
speed will never get better on this mobo/CPU combo, until you upgrade to
a kernel with the appropriate patches.  But at only 200MB/s I doubt this
is the case, but check it anyway.  Once you get the IO problem fixed you
may run into the single thread problem, so you'll check this again at
that time.

IIRC, people on this list are hitting ~400-500MB/s sequential writes
with RAID5/6/10 rust arrays, so I don't think the write thread is your
problem.  Not yet anyway.

-- 
Stan

