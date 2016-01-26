From: Chien Lee <chienlee@qnap.com>
Subject: Re: [PATCH/RFC/RFT] md: allow resync to go faster when there is
 competing IO.
Date: Tue, 26 Jan 2016 10:32:10 +0800
Message-ID: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.com, shli@kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Recently we find a bug about this patch (commit No. is
ac8fa4196d205ac8fff3f8932bddbad4f16e4110 ).

We know that this patch committed after Linux kernel 4.1.x is intended
to allowing resync to go faster when there is competing IO. However,
we find the performance of random read on syncing Raid6 will come up
with a huge drop in this case. The following is our testing detail.

The OS what we choose in our test is CentOS Linux release 7.1.1503
(Core) and the kernel image will be replaced for testing. In our
testing result, the 4K random read performance on syncing raid6 in
Kernel 4.2.8 is much lower than in Kernel 3.19.8. In order to find out
the root cause, we try to rollback this patch in Kernel 4.2.8, and we
find the 4K random read performance on syncing Raid6 will be improved
and go back to as what it should be in Kernel 3.19.8.

Nevertheless, it seems that it will not affect some other read/write
patterns. In our testing result, the 1M sequential read/write, 4K
random write performance in Kernel 4.2.8 is performed almost the same
as in Kernel 3.19.8.

It seems that although this patch increases the resync speed, the
logic of !is_mddev_idle() cause the sync request wait too short and
reduce the chance for raid5d to handle the random read I/O.


Following is our test environment and some testing results:


OS: CentOS Linux release 7.1.1503 (Core)

CPU: Intel(R) Xeon(R) CPU E3-1245 v3 @ 3.40GHz

Processor number: 8

Memory: 12GB

fio command:

1.      (for numjobs=64):

fio --filename=/dev/md2 --sync=0 --direct=0 --rw=randread --bs=4K
--runtime=180 --size=50G --name=test-read --ioengine=libaio
--numjobs=64 --iodepth=1 --group_reporting

2.      (for numjobs=1):

fio --filename=/dev/md2 --sync=0 --direct=0 --rw=randread --bs=4K
--runtime=180 --size=50G --name=test-read --ioengine=libaio
--numjobs=1 --iodepth=1 --group_reporting



Here are test results:


Part I. SSD (4 x 240GB Intel SSD create Raid6(syncing))


a.      4K Random Read, numjobs=64

                                             Average Throughput    Average IOPS

Kernel 3.19.8                                 715937KB/s              178984

Kernel 4.2.8                                   489874KB/s              122462

Kernel 4.2.8 Patch Rollback            717377KB/s              179344



b.      4K Random Read, numjobs=1

                                             Average Throughput    Average IOPS

Kernel 3.19.8                                 32203KB/s                8051

Kernel 4.2.8                                  2535.7KB/s                633

Kernel 4.2.8 Patch Rollback            31861KB/s                7965




Part II. HDD (4 x 1TB TOSHIBA HDD create Raid6(syncing))


a.      4K Random Read, numjobs=64

                                             Average Throughput    Average IOPS

Kernel 3.19.8                                2976.6KB/s               744

Kernel 4.2.8                                  2915.8KB/s               728

Kernel 4.2.8 Patch Rollback           2973.3KB/s               743



b.      4K Random Read, numjobs=1

                                             Average Throughput    Average IOPS

Kernel 3.19.8                                481844 B/s                 117

Kernel 4.2.8                                   24718 B/s                   5

Kernel 4.2.8 Patch Rollback           460090 B/s                 112



Thanks,

-- 

Chien Lee
