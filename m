From: Gustavo Franco <stratus@acm.org>
Subject: Problems with RAID1 using SATA disks.
Date: Wed, 12 May 2004 13:50:29 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40A255D5.3090602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

[ Send your reply Cc: to me, i'm not subscribed. ]

I've already reported[0] my problem on Apr 12, with few details on
lkml.Since then, only Steve Lord (xfs) have replied to me writing that
Christoph was looking into it.I'll explain my problem here again, since
with my new tests i can see clearly that it isn't a xfs problem.I just don't
known if it's a hardware, software raid or libata problem.

I've 4 SATA drives, using initially two arrays, a mirror for the root 
partition
that is working without any problem and a linear one to store the backup.
My TODO is establish a new linear one and put a mirror on top of both
linears, but i haven't assembled it yet, i'm having problems when i put
heavy i/o on the linear array cited before.

I've tested the setup described above using both 2.6.5 and 2.6.6 kernels,
you can read the kernel configuration, mdadm output, lspci, dmesg and the
df+mount output on my post to lkml[0].Note that since then, i've migrated
the contents from xfs to ext3, with the same problem after, but obviously
it now shows on the call trace, functions related to ext3.

Today, i've migrated the linear array content (ext3) to a external 
partition (xfs),
but on a SATA disk too, but it's just a workaround and a test to check 
if it's a
software raid problem (or any fail on the configuration) or a libata bug.

Am i missing something, or is it a strange bug?

[0] = http://www.uwsg.iu.edu/hypermail/linux/kernel/0404.1/0706.html


Thanks in advance,
Gustavo Franco

