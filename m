From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID6 rebuild oddity
Date: Wed, 29 Mar 2017 16:12:52 +0800
Message-ID: <5584b8b1-b4f1-0d2e-cbf3-f14b4127d031@fnarfbargle.com>
References: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com>
 <87zig467z3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zig467z3.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/03/17 12:08, NeilBrown wrote:

>
> sdj is getting twice the utilization of the others but only about 10%
> more rKB/sec.  That suggests lots of seeking.

Yes, something is not entirely sequential.

> Does "fuser /dev/sdj" report anything funny?

No. No output. As far as I can tell nothing should be touching the disks 
other than the md kernel thread.

> Is there filesystem IO happening? If so, what filesystem?
> Have you told the filesystem about the RAID layout?
> Maybe the filesystem keeps reading some index blocks that are always on
> the same drive.

No. I probably wasn't as clear as I should have been in the initial 
post. There was nothing mounted at the time.

Right now the array contains one large LUKS container (dm-crypt). This 
was mounted and a continuous dd done to the dm device to zero it out :

4111195+1 records in
4111195+1 records out
34487205507072 bytes (34 TB) copied, 57781.1 s, 597 MB/s

So there is no filesystem on the drive.

I failed and removed sdi :

root@test:~# mdadm --fail /dev/md0 /dev/sdi
mdadm: set /dev/sdi faulty in /dev/md0
root@test:~# mdadm --remove /dev/md0 /dev/sdi
mdadm: hot removed /dev/sdi from /dev/md0
root@test:~# mdadm --zero-superblock /dev/sdi
root@test:~# mdadm --add /dev/md0 /dev/sdi
mdadm: added /dev/sdi

Rebooted the machine to remove all tweaks of things like stripe cache 
size, readahead, NCQ and anything else.

I opened the LUKS container, dd'd a meg to the start to write to the 
array and kick off the resync, then closed the LUKS container. At this 
point dm should no longer be touching the drive and I've verified the 
device has gone.

I then ran sync a couple of times and waited a couple of minutes until I 
was positive _nothing_ was touching md0, then ran :

blktrace -w 5 /dev/sd[bcdefgij] /dev/md0

> So the problem moves from drive to drive?  Strongly suggests filesystem
> metadata access to me.

Again, sorry for me not being clear. The situation changes on a resync 
specific basis. For example the reproduction I've done now I popped out 
sdi rather than sdb, and now the bottleneck is sdg. It is the same if 
the exact circumstances remain the same.

>
> If you can capture several seconds of trace on all drives plus the
> array, compress it and host it somewhere, I can pick it up and have
> look.

I've captured 5 seconds. I was overly optimistic initially and tried 20 
seconds, but that resulted in 100M bzipped.

This is 19M. The kernel is a clean 4.10.6 compiled up half an hour ago 
as I forgot to include block tracing in there.

http://www.fnarfbargle.com/private/170329-Resync/resync-blktrace.tar.bz2

root@test:~/bench# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Wed Mar 22 14:01:41 2017
      Raid Level : raid6
      Array Size : 35162348160 (33533.43 GiB 36006.24 GB)
   Used Dev Size : 5860391360 (5588.90 GiB 6001.04 GB)
    Raid Devices : 8
   Total Devices : 8
     Persistence : Superblock is persistent

     Update Time : Wed Mar 29 16:08:20 2017
           State : clean, degraded, recovering
  Active Devices : 7
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

  Rebuild Status : 2% complete

            Name : test:0  (local to host test)
            UUID : 93a09ba7:f159e9f5:7c478f16:6ca8858e
          Events : 715

     Number   Major   Minor   RaidDevice State
        8       8       16        0      active sync   /dev/sdb
        1       8       32        1      active sync   /dev/sdc
        2       8       48        2      active sync   /dev/sdd
        3       8       64        3      active sync   /dev/sde
        4       8       80        4      active sync   /dev/sdf
        5       8       96        5      active sync   /dev/sdg
        9       8      128        6      spare rebuilding   /dev/sdi
        7       8      144        7      active sync   /dev/sdj


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.08    0.00    4.77    4.75    0.00   90.41

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     1.40    0.00    3.00     0.00    10.60 
7.07     0.01    4.67    0.00    4.67   4.67   1.40
sdb           14432.20     0.00  120.20    0.00 57295.20     0.00 
953.33     2.04   16.71   16.71    0.00   3.23  38.80
sdc           14432.20     0.00  120.20    0.00 57295.20     0.00 
953.33     1.99   16.26   16.26    0.00   3.21  38.60
sdd           14432.20     0.00  120.80    0.00 57602.40     0.00 
953.68     2.14   17.55   17.55    0.00   3.18  38.40
sde           14432.20     0.00  120.80    0.00 57602.40     0.00 
953.68     2.02   16.57   16.57    0.00   3.20  38.60
sdf           14432.20     0.00  120.80    0.00 57602.40     0.00 
953.68     2.08   17.04   17.04    0.00   3.25  39.20
sdg           16135.40     0.00  224.60    0.00 65811.20     0.00 
586.03   126.46  575.26  575.26    0.00   4.45 100.00
sdh               0.00     1.40    0.00    3.00     0.00    10.60 
7.07     0.02    6.67    0.00    6.67   6.67   2.00
sdi               0.00 14982.60    0.00  123.20     0.00 59801.60 
970.81     4.52   35.57    0.00   35.57   3.25  40.00
sdj           14432.40     0.00  120.80    0.00 57603.20     0.00 
953.70     1.84   15.07   15.07    0.00   3.06  37.00
md1               0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    2.20     0.00     8.80 
8.00     0.00    0.00    0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00


Thanks for having a look. It seems odd to me, but I can't figure it out.

Regards,
Brad
