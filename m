From: Markus Doits <markus.doits@googlemail.com>
Subject: Raid10 disc-activity every five seconds
Date: Tue, 24 Nov 2009 12:04:20 +0100
Message-ID: <4B0BBDB4.1010403@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

just wanted to silency my pc by reducing disk-activity. what bothers me
is: my disk "click" about every five seconds. already raised
"dirty_writeback_centisecs" with some luck, but not good enough.

my setup (ubuntu karmic x86_64):

md2: raid10 out of 3 disks
md1: raid1 out of 3 disks (same disks as above, other parititions)

2.6.31-ubuntu48-bfs #1 SMP PREEMPT Sun Nov 15 19:56:03 CET 2009 x86_64
GNU/Linux (with brain-fuck-scheduler 310 compiled myself)

mdadm 2.6.7.1


running "lm-profiler" gives constant disk access:

Write accesses at 5/600 in lm-profiler run: md2_raid10
Write accesses at 10/600 in lm-profiler run: md2_raid10
Write accesses at 14/600 in lm-profiler run: md2_raid10
Write accesses at 19/600 in lm-profiler run: md2_raid10
Write accesses at 23/600 in lm-profiler run: md2_raid10
Write accesses at 28/600 in lm-profiler run: md2_raid10
Write accesses at 30/600 in lm-profiler run: md2_raid10
Write accesses at 32/600 in lm-profiler run: md2_raid10
Write accesses at 33/600 in lm-profiler run: md2_raid10
Write accesses at 37/600 in lm-profiler run: md2_raid10
Write accesses at 41/600 in lm-profiler run: md2_raid10
Write accesses at 42/600 in lm-profiler run: md2_raid10
[...]

seems to be a "kernel-thread":

ps ax | grep md2
  331 ?        D      0:00 [md2_raid10]


when my pc is idle, it happens about every five seconds. what is it
doing there, something raid10 specific (since my raid1 seems to be
quiet)? is it expected behavior - can it be tuned in some way to make it
happen less frequently?

already had a look into "/sys/block/md2/md", but did not find the right
"switch" that might be my problem.

before investigating further (e.g. trying other kernels) i'll wait for
your reply, since maybe you know what's going on there.

regards
Markus

p.s. please reply to me directly, too, since i'm not subscribed to the list
