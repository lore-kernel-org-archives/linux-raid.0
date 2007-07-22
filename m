From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH 0/2] stripe-queue for 2.6.23 consideration
Date: Sun, 22 Jul 2007 02:44:52 -0700
Message-ID: <20070722094115.18906.64495.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: akpm@linux-foundation.org, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew, Neil,

The stripe-queue patches are showing solid performance improvement.

	git://lost.foo-projects.org/~dwillia2/git/iop md-for-linus

 drivers/md/raid5.c         | 1484 ++++++++++++++++++++++++++++++++------------
 include/linux/raid/raid5.h |   87 +++-
 2 files changed, 1164 insertions(+), 407 deletions(-)

Dan Williams (2):
      raid5: add the stripe_queue object for tracking raid io requests (take2)
      raid5: use stripe_queues to prioritize the "most deserving" requests (take4)

I initially considered them 2.6.24 material but after fixing the sync+io
data corruption regression, fixing the large 'stripe_cache_size' values
performance regression, and seeing how well it performed on my IA
platform I would like them to be considered for 2.6.23.  That being said
I have not yet tested expand operations or raid6.

Without any tuning a 4 disk (SATA) RAID5 array can reach 190MB/s.  Previously
performance was around 90MB/s.  Blktrace data confirms that less reads are
occurring and more writes are being merged.

$ mdadm --create /dev/md0 /dev/sd[abcd] -n 4 -l 5 --assume-clean
$ blktrace /dev/sd[abcd] &
$ for i in `seq 1 3`; do dd if=/dev/zero of=/dev/md0 bs=1024k count=1024; done
$ fg ^C
$ blkparse /dev/sda /dev/sdb /dev/sdc /dev/sdd

=====pre-patch=====
Total (sda):
 Reads Queued:       3,136,   12,544KiB	 Writes Queued:     187,068,  748,272KiB
 Read Dispatches:      676,   12,384KiB	 Write Dispatches:   30,949,  737,052KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:      662,   12,080KiB	 Writes Completed:   30,630,  736,964KiB
 Read Merges:        2,452,    9,808KiB	 Write Merges:      155,885,  623,540KiB
 IO unplugs:             1        	 Timer unplugs:           1

Total (sdb):
 Reads Queued:       1,541,    6,164KiB	 Writes Queued:      91,224,  364,896KiB
 Read Dispatches:      323,    6,184KiB	 Write Dispatches:   14,603,  335,528KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:      303,    6,124KiB	 Writes Completed:   13,650,  328,520KiB
 Read Merges:        1,209,    4,836KiB	 Write Merges:       76,080,  304,320KiB
 IO unplugs:             0        	 Timer unplugs:           0

Total (sdc):
 Reads Queued:       1,372,    5,488KiB	 Writes Queued:      82,995,  331,980KiB
 Read Dispatches:      297,    5,280KiB	 Write Dispatches:   13,258,  304,020KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:      268,    4,948KiB	 Writes Completed:   12,320,  298,668KiB
 Read Merges:        1,067,    4,268KiB	 Write Merges:       69,154,  276,616KiB
 IO unplugs:             0        	 Timer unplugs:           0

Total (sdd):
 Reads Queued:       1,383,    5,532KiB	 Writes Queued:      80,186,  320,744KiB
 Read Dispatches:      307,    5,008KiB	 Write Dispatches:   13,241,  298,400KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:      276,    4,888KiB	 Writes Completed:   12,677,  294,324KiB
 Read Merges:        1,050,    4,200KiB	 Write Merges:       66,772,  267,088KiB
 IO unplugs:             0        	 Timer unplugs:           0


=====post-patch=====
Total (sda):
 Reads Queued:         117,      468KiB	 Writes Queued:      71,511,  286,044KiB
 Read Dispatches:       17,      308KiB	 Write Dispatches:    8,412,  699,204KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        6,       96KiB	 Writes Completed:    3,704,  321,552KiB
 Read Merges:           96,      384KiB	 Write Merges:       67,880,  271,520KiB
 IO unplugs:            14        	 Timer unplugs:          15

Total (sdb):
 Reads Queued:          88,      352KiB	 Writes Queued:      56,687,  226,748KiB
 Read Dispatches:       11,      288KiB	 Write Dispatches:    8,142,  686,412KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        8,      184KiB	 Writes Completed:    2,770,  257,740KiB
 Read Merges:           76,      304KiB	 Write Merges:       54,005,  216,020KiB
 IO unplugs:            16        	 Timer unplugs:          17

Total (sdc):
 Reads Queued:          60,      240KiB	 Writes Queued:      61,863,  247,452KiB
 Read Dispatches:        7,      248KiB	 Write Dispatches:    8,302,  699,832KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        5,      144KiB	 Writes Completed:    2,907,  258,900KiB
 Read Merges:           50,      200KiB	 Write Merges:       58,926,  235,704KiB
 IO unplugs:            20        	 Timer unplugs:          23

Total (sdd):
 Reads Queued:          61,      244KiB	 Writes Queued:      66,330,  265,320KiB
 Read Dispatches:       10,      180KiB	 Write Dispatches:    9,326,  694,012KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        4,      112KiB	 Writes Completed:    3,562,  285,912KiB
 Read Merges:           47,      188KiB	 Write Merges:       62,751,  251,004KiB
 IO unplugs:            16        	 Timer unplugs:          17

Tiobench measures >90% performance increases on my IA platform with none of the read
performance anomalies seen on previous takes:

File Size (MB)
Blk Size (KB)
Avg Rate (MB/s)

=====pre-patch=====
File   Blk      Num     Avg
Size   Size     Thr     Rate
----   -----    ---     ------
2048   4096     1       71.79
2048   4096     2       55.86
2048   4096     4       43.43
2048   4096     8       40.88
2048   131072   1       72.02
2048   131072   2       54.67
2048   131072   4       42.85
2048   131072   8       41.51

=====post-patch=====
File   Blk      Num     Avg
Size   Size     Thr     Rate
----   -----    ---     ------
2048   4096     1       142.34
2048   4096     2       71.6
2048   4096     4       53.28
2048   4096     8       50.46
2048   131072   1       140.86
2048   131072   2       72.94
2048   131072   4       52.16
2048   131072   8       50.18

Andrew, please add this git tree to -mm.  Neil, if you are comfortable with the
current state please ack and I will send a last minute pull request for 2.6.23.

Thanks,
Dan
