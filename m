From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: [PATCH 2/2] mdadm: raid10.c Remove near atomic break
Date: Mon, 7 Nov 2016 17:12:42 -0700
Message-ID: <CAANLjFrSsNY4T231_Q8Htyx=U98NynxHaPjYCdPYSOgjgZ=1Ng@mail.gmail.com>
References: <20161103234508.12641-1-robert@leblancnet.us> <20161103234508.12641-3-robert@leblancnet.us>
 <87k2cjq4eh.fsf@notabene.neil.brown.name> <CAANLjFrXjS3HX-qv_FAXBapD6PE-n+y=d=6kzCwO3pSjajafWQ@mail.gmail.com>
 <87oa1snrch.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oa1snrch.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure why 'near' performance can't be close to 'far'
performance. Here is the results from some tests I did today. These
are 6TB SAS drives that I filled with 5TB of fio data (took all day
Friday to fill them) so that I prevent short stroking drives.

The format of the name is
[NVME-]RAID(level)-(num_drives)[-parity_layout]. The NVME test was an
afterthought so there may be some variance between tests not seen in
the others. I usually do several tests and average the results and do
a distribution to get what is significant, but I didn't have a lot of
time.

Pre-patch                                    clat (usec)
Seq                 io(MB)  bw(KB/s)  iops   min      max     avg    stdev
Single               12762   217801  54450     0    60462   17.71   156.30
RAID1-4              12903   220216  55053     0    42778   17.75   160.62
RAID10-4-n4          20057   342298  85574     0    50977   11.52   283.84
RAID10-4-f4          48711   831319 207829     0    74020    4.62   175.52
RAID10-3-n2          18439   314684  78671     0    61328   12.45   340.17
RAID10-3-f2          37169   634293 158573     0    65365    6.10   210.42
NVME-RAID10-4-n4    171950  2934682 733641     0     8016    1.16    14.15
NVME-RAID10-4-f4    172480  2943693 735903     0     7309    1.16    16.78

Post-patch
Seq
Single               12898   220118  55029     0    47805   17.85   159.62
RAID1-4              12895   220067  55016     0    51156   17.85   168.47
RAID10-4-n4          12797   218385  54596     0    65610   18.01   377.55
RAID10-4-f4          48751   832000 208000     0    90652    4.61   183.18
RAID10-3-n2          18656   318388  79596     0    62684   12.30   262.32
RAID10-3-f2          37181   634487 158621     0    72696    6.11   211.63
NVME-RAID10-4-n4    172738  2947174 737001     0     1057    1.16    13.08
NVME-RAID10-4-f4    188423  3215770 803926     0     1242    1.05    16.33

Pre-patch
Random
Single                19.5    333.3     83  1000    48000   12000     4010
RAID1-4               19.4    331.6     82  2000    49000   12060     4110
RAID10-4-n4           19.5    332.9     83  1000    38000   12010     4210
RAID10-4-f4           27.2    463.9    115  1000    50000    8620     3190
RAID10-3-n2           22.6    385.6     96  1000    44000   10370     3620
RAID10-3-f2           26.1    444.7    111  1000   366000    8990     5430
NVME-RAID10-4-n4    2458.3  41954.0  10488    77      414      94       10
NVME-RAID10-4-f4    2509.7  42830.0  10707    74      373      93       14

Post-patch
Random
Single                19.5    332.5     83  2000    37000   12020     4040
RAID1-4               19.4    331.0     82  2000    34000   12080     4070
RAID10-4-n4           27.0    460.6    115   178    50950    8678     3278
RAID10-4-f4           27.0    460.1    115  1000    43000    8690     3260
RAID10-3-n2           25.3    431.6    107  1000    46000    9260     3330
RAID10-3-f2           26.1    445.4    111  1000    44000    8970     3270
NVME-RAID10-4-n4    2334.5  39840.0   9960    47      308     100       13
NVME-RAID10-4-f4    2376.6  40551.0  10137    73     2675      97       18

With this patch, 'near' performance is almost exactly 'far'
performance for random reads. The sequential reads suffer from this
patch, but not worse than the the RAID1 or bare drive. RAID10-4-n4 has
38% random performance increase, RAID10-3-n2 has 12% random read
performance increase and RAID-4-n4 has 36% sequential performance
degradation where the RAID10-3-n2 seq performance has a 1% performance
increase (probably insignificant).

Interesting note:
Pre-patch Seq RAID10-4-n4 split the reads between the drives pretty
good and pre-patch random RAID10-4-n4 has all I/O going to one drive.
Post-patch these results are swapped with Seq RAID10-4-n4 being
serviced from a single drive and random RAID10-4-n4 spreading I/O to
all drives.

The patch doesn't really seem to impact NVME, there is possibly some
error in this test that throws doubts on the results in my mind since
both 'far' and 'near' have the same amount of change (~5%).

I hope this helps explain my reasoning. Just need to keep/improve the
original seq performance but get the improved random performance.

Robert LeBlanc
