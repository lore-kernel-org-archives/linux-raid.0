From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results
Date: Sun, 17 Feb 2013 20:52:14 +1100
Message-ID: <5120A84E.4020702@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51150475.2020803@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/13 00:58, Adam Goryachev wrote:
> On 08/02/13 02:32, Dave Cundiff wrote:
>> On Thu, Feb 7, 2013 at 7:49 AM, Adam Goryachev
>> <mailinglists@websitemanagers.com.au> wrote:
>>>> I definitely see that. See below for a FIO run I just did on one of my RAID10s
> OK, some fio results.
>
> Firstly, this is done against /tmp which is on the single standalone
> Intel SSD used for the rootfs (shows some performance level of the
> chipset I presume):
>
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
>
>
> PS, I'm assuming I should omit the extra output similar to what you
> did.... If I should include all info, I can re-run and provide...
>
> This seems to indicate a read speed of 531M and write of 139M, which to
> me says something is wrong. I thought write speed is slower, but not
> that much slower?
>
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
>
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

OK, I've upgraded to:
Linux san1 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.35-2~bpo60+1 x86_64
GNU/Linux
I also upgraded to iscsitarget from testing, as there seemed a few fixes
there, even though not the one I might have liked:
ii  iscsitarget                         1.4.20.2-10.1               
iSCSI Enterprise Target userland tools
ii  iscsitarget-dkms                    1.4.20.2-10.1               
iSCSI Enterprise Target kernel module source - dkms version


Then I re-ran the fio tests from above and here is what I get when
testing against an LV which has a snapshot against it:
seq-read: (groupid=0, jobs=1): err= 0: pid=10168
  read : io=4096MB, bw=1920MB/s, iops=30724, runt=  2133msec
seq-write: (groupid=1, jobs=1): err= 0: pid=10169
  write: io=2236MB, bw=38097KB/s, iops=595, runt= 60094msec
Run status group 0 (all jobs):
   READ: io=4096MB, aggrb=1920MB/s, minb=1966MB/s, maxb=1966MB/s,
mint=2133msec, maxt=2133msec

Run status group 1 (all jobs):
  WRITE: io=2236MB, aggrb=38097KB/s, minb=39011KB/s, maxb=39011KB/s,
mint=60094msec, maxt=60094msec

So, 1920MB/s read, that sounds good to me, almost 3 times faster,
however, the write performance is pretty dismal :(

After removing the snapshot, here is another look:
seq-read: (groupid=0, jobs=1): err= 0: pid=10222
  read : io=4096MB, bw=2225MB/s, iops=35598, runt=  1841msec
seq-write: (groupid=1, jobs=1): err= 0: pid=10223
  write: io=4096MB, bw=111666KB/s, iops=1744, runt= 37561msec
Run status group 0 (all jobs):
   READ: io=4096MB, aggrb=2225MB/s, minb=2278MB/s, maxb=2278MB/s,
mint=1841msec, maxt=1841msec

Run status group 1 (all jobs):
  WRITE: io=4096MB, aggrb=111666KB/s, minb=114346KB/s, maxb=114346KB/s,
mint=37561msec, maxt=37561msec

A big improvement, 111MB/s write, and even better reads. However, this
write speed still seems pretty slow.

Another run after stopping the secondary DRBD sync:
seq-read: (groupid=0, jobs=1): err= 0: pid=10708
  read : io=4096MB, bw=2242MB/s, iops=35870, runt=  1827msec
seq-write: (groupid=1, jobs=1): err= 0: pid=10709
  write: io=4096MB, bw=560661KB/s, iops=8760, runt=  7481msec
Run status group 0 (all jobs):
   READ: io=4096MB, aggrb=2242MB/s, minb=2296MB/s, maxb=2296MB/s,
mint=1827msec, maxt=1827msec

Run status group 1 (all jobs):
  WRITE: io=4096MB, aggrb=560660KB/s, minb=574116KB/s, maxb=574116KB/s,
mint=7481msec, maxt=7481msec

Now THAT is what I was hoping to see.... 2,242MB/s read, enough to
saturate 18 x 1Gbps ports... and 560MB/s write, enough for 4.5 x 1Gbps,
which is more than the maximum from 2 machines. So as long as I have the
secondary DRBD disconnected during the day (I do), and don't have any
LVM snapshots (I don't due to performance), then things should be a lot
better.

Now looking back at all this, I think I was probably suffering from a
whole bunch of problems:

1) Write cache enabled on windows
2) iSCSI not configured to properly deal with intermittent/slow
responses, queue forever instead of returning an error
3) Not using multipath IO
4) Server storage performance too slow to keep up (due to kernel bug in
debian stable squeeze/2.6.32)
5) Using LVM snapshots which degraded performance
6) Using DRBD during the day with spinning disks on the secondary
(couldn't keep up, slowed down the primary)
7) Sharing a single ethernet for user traffic and SAN traffic, allowing
one protocol to flood/block the other
8) Using RR bonding with more ports on the SAN than the client, causing
flooding, 802.3X pause frames, etc

I can't say that any one of the above fixed the problem, it has been
getting progressively better as each item has been addressed. I'd like
to think that its very close to done now.
The only thing I still need to do is get rid of the bond0 on the SAN,
change to use 8 individual IP's, and configure the clients to talk to
two of the IP's on the san, but only one over each ethernet interface.

I'd again like to say thanks to all the people who've helped out with
this drama. I did forget to take those photo's, but I'll take some next
time I'm in, I think I did a pretty good job overall, and it looks
reasonably neat (by my standards anyway :)

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

