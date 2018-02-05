From: =?UTF-8?B?SsOpcsO0bWUgQ2hhcmFvdWk=?= <jcharaoui@cmaisonneuve.qc.ca>
Subject: 4k random writes initially quite slow on raid10 md device
Date: Mon, 5 Feb 2018 14:15:37 -0500
Message-ID: <4ecac452-4fbc-7ccf-331e-a100c18cbaaf@cmaisonneuve.qc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: fr
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[apologies for cross-posting this from the fio mailing list, but it was 
suggested to me that this may be of interest to the linux-raid list]


Hello,

I've been running some tests on a bunch of disks lately and came across 
a strange test result that I'm struggling to explain.

I built a 20-device raid10 md array with SSDs and ran several fio tests 
on it. The 4k-randwrite test really stands out because the IOPS starts 
out fairly low, around 800 IOPS, but within a few seconds climbs up to 
about 70K IOPS, which is nearly three times higher than the IOPS I'm 
getting with the randread test (25K).

I tried disabling the drive caches using hdparm -W 0, and also disabling 
the internal write-intent bitmap on the md array, but the results are 
the same. I've also tried disabling front_merges, also to no effect. 
Disabling hyper-threading and switching the CPU scaling governor to 
'performance' helped gain a few extra IOPS, but the curve still remains.

Here are the test parameters:

ioengine=libaio
invalidate=1
ramp_time=10
iodepth=4
runtime=60
time_based
direct=1
randrepeat=0
filename=/dev/md1
bs=4k
rw=randwrite

I generated some gnuplot graphs from the logs:

randread test: https://imgur.com/dj25FFH
randwrite test: https://imgur.com/BuZVNmh

Any idea what could be causing this delay in random write speeds? There 
is no other IO going on on this machine.

Thanks,

-- Jerome

