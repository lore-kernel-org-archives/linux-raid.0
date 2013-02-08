From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Sat, 09 Feb 2013 00:58:13 +1100
Message-ID: <51150475.2020803@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/13 02:32, Dave Cundiff wrote:
> On Thu, Feb 7, 2013 at 7:49 AM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>>>
>>> I definitely see that. See below for a FIO run I just did on one of my RAID10s

OK, some fio results.

Firstly, this is done against /tmp which is on the single standalone
Intel SSD used for the rootfs (shows some performance level of the
chipset I presume):

root@san1:/tmp/testing# fio /root/test.fio
seq-read: (g=0): rw=read, bs=64K-64K/64K-64K, ioengine=libaio, iodepth=32
seq-write: (g=1): rw=write, bs=64K-64K/64K-64K, ioengine=libaio, iodepth=32
Starting 2 processes
seq-read: Laying out IO file(s) (1 file(s) / 4096MB)
Jobs: 1 (f=1): [_W] [100.0% done] [0K/137M /s] [0/2133 iops] [eta 00m:00s]
seq-read: (groupid=0, jobs=1): err= 0: pid=4932
  read : io=4096MB, bw=518840KB/s, iops=8106, runt=  8084msec
seq-write: (groupid=1, jobs=1): err= 0: pid=5138
  write: io=4096MB, bw=136405KB/s, iops=2131, runt= 30749msec
Run status group 0 (all jobs):
   READ: io=4096MB, aggrb=518840KB/s, minb=531292KB/s, maxb=531292KB/s,
mint=8084msec, maxt=8084msec

Run status group 1 (all jobs):
  WRITE: io=4096MB, aggrb=136404KB/s, minb=139678KB/s, maxb=139678KB/s,
mint=30749msec, maxt=30749msec

Disk stats (read/write):
  sda: ios=66570/66363, merge=10297/10453, ticks=259152/993304,
in_queue=1252592, util=99.34%


PS, I'm assuming I should omit the extra output similar to what you
did.... If I should include all info, I can re-run and provide...

This seems to indicate a read speed of 531M and write of 139M, which to
me says something is wrong. I thought write speed is slower, but not
that much slower?

Moving on, I've stopped the secondary DRBD, created a new LV (testlv) of
15G, and formatted with ext4, mounted it, and re-run the test:

seq-read: (groupid=0, jobs=1): err= 0: pid=19578
  read : io=4096MB, bw=640743KB/s, iops=10011, runt=  6546msec
seq-write: (groupid=1, jobs=1): err= 0: pid=19997
  write: io=4096MB, bw=208765KB/s, iops=3261, runt= 20091msec
Run status group 0 (all jobs):
   READ: io=4096MB, aggrb=640743KB/s, minb=656120KB/s, maxb=656120KB/s,
mint=6546msec, maxt=6546msec

Run status group 1 (all jobs):
  WRITE: io=4096MB, aggrb=208765KB/s, minb=213775KB/s, maxb=213775KB/s,
mint=20091msec, maxt=20091msec

Disk stats (read/write):
  dm-14: ios=65536/64841, merge=0/0, ticks=206920/469464,
in_queue=676580, util=98.89%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0,
aggrin_queue=0, aggrutil=0.00%
    drbd2: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=-nan%

dm-14 is the testlv

So, this indicates a max read speed of 656M and write of 213M, again,
write is very slow (about 30%).

With these figures, just 2 x 1Gbps links would saturate the write
performance of this RAID5 array.

Finally, changing the fio config file to point filename=/dev/vg0/testlv
(ie, raw LV, no filesystem):
seq-read: (groupid=0, jobs=1): err= 0: pid=10986
  read : io=4096MB, bw=652607KB/s, iops=10196, runt=  6427msec
seq-write: (groupid=1, jobs=1): err= 0: pid=11177
  write: io=4096MB, bw=202252KB/s, iops=3160, runt= 20738msec
Run status group 0 (all jobs):
   READ: io=4096MB, aggrb=652606KB/s, minb=668269KB/s, maxb=668269KB/s,
mint=6427msec, maxt=6427msec

Run status group 1 (all jobs):
  WRITE: io=4096MB, aggrb=202252KB/s, minb=207106KB/s, maxb=207106KB/s,
mint=20738msec, maxt=20738msec

Not much difference, which I didn't really expect...

So, should I be concerned about these results? Do I need to try to
re-run these tests at a lower layer (ie, remove DRBD and/or LVM from the
picture)? Are these meaningless and I should be running a different
test/set of tests/etc ?

Thanks,
Adam





-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
