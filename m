From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [RFC] Process requests instead of bios to use a scheduler
Date: Wed, 28 May 2014 15:04:14 +0200
Message-ID: <5385DECE.5060507@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Florian-Ewald?= =?ISO-8859-1?Q?_M=FCller?= <florian-ewald.mueller@profitbricks.com>
List-Id: linux-raid.ids

Hi Neil,

at ProfitBricks we use the raid0 driver stacked on top of raid1 to form
a RAID-10. Above there is LVM and SCST/ib_srpt.

We've extended the md driver for our 3.4 based kernels to do full bio
accounting (by adding ticks and in-flights). Then, we've extended it to
use the request-by-request mode using blk_init_queue() and an
md_request_function() selectable by a module parameter and extended
mdadm. This way the block layer provides the accounting and the
possibility to select a scheduler.
With the ticks we maintain a latency statistic. This way we can compare
both modes.

My colleague Florian is in CC as he has been the main developer for this.

We did some fio 2.1.7 tests with iodepth 64, posixaio, 10 LVs with 1M
chunks sequential I/O and 10 LVs with 4K chunks sequential as well as
random I/O - one fio call per device. After 60s all fio processes are
killed.
Test systems have four 1 TB Seagate Constellation HDDs in RAID-10. LVs
are 20G in size each.

The biggest issue in our cloud is unfairness leading to high latency,
SRP timeouts and reconnects. This way we would need a scheduler for our
raid0 device.
The difference is tremendous when comparing the results of 4K random
writes fighting against 1M sequential writes. With a scheduler the
maximum write latency dropped from 10s to 1.6s. The other statistic
values are number of bios for scheduler none and number of requests for
other schedulers. First read, then write.

Scheduler: none
<      8 ms: 0 2139
<     16 ms: 0 9451
<     32 ms: 0 10277
<     64 ms: 0 3586
<    128 ms: 0 5169
<    256 ms: 2 31688
<    512 ms: 3 115360
<   1024 ms: 2 283681
<   2048 ms: 0 420918
<   4096 ms: 0 10625
<   8192 ms: 0 220
<  16384 ms: 0 4
<  32768 ms: 0 0
<  65536 ms: 0 0
>= 65536 ms: 0 0
 maximum ms: 660 9920

Scheduler: deadline
<      8 ms: 2 435
<     16 ms: 1 997
<     32 ms: 0 1560
<     64 ms: 0 4345
<    128 ms: 1 11933
<    256 ms: 2 46366
<    512 ms: 0 182166
<   1024 ms: 1 75903
<   2048 ms: 0 146
<   4096 ms: 0 0
<   8192 ms: 0 0
<  16384 ms: 0 0
<  32768 ms: 0 0
<  65536 ms: 0 0
>= 65536 ms: 0 0
 maximum ms: 640 1640

We clone the bios from the request and put them into a bio list. The
request is marked as in-flight and afterwards the bios are processed
one-by-one the same way as with the other mode.

Is it safe to do it like this with a scheduler?

Any concerns regarding the write-intent bitmap?

Do you have any other concerns?

We can provide you with the full test results, the test scripts and also
some code parts if you wish.

Cheers,
Sebastian
