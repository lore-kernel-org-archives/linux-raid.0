From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: mismatch_cnt != 0
Date: Sat, 23 Feb 2008 04:34:52 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802230434100.3809@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Should I be worried?

Fri Feb 22 20:00:02 EST 2008: Executing RAID health check for /dev/md0...
Fri Feb 22 20:00:03 EST 2008: Executing RAID health check for /dev/md1...
Fri Feb 22 20:00:04 EST 2008: Executing RAID health check for /dev/md2...
Fri Feb 22 20:00:05 EST 2008: Executing RAID health check for /dev/md3...
Fri Feb 22 21:00:06 EST 2008: cat /sys/block/md0/md/mismatch_cnt
Fri Feb 22 21:00:06 EST 2008: 0
Fri Feb 22 21:00:06 EST 2008: cat /sys/block/md1/md/mismatch_cnt
Fri Feb 22 21:00:06 EST 2008: 0
Fri Feb 22 21:00:06 EST 2008: cat /sys/block/md2/md/mismatch_cnt
Fri Feb 22 21:00:06 EST 2008: 0
Fri Feb 22 21:00:06 EST 2008: cat /sys/block/md3/md/mismatch_cnt
Fri Feb 22 21:00:06 EST 2008: 936
Fri Feb 22 21:00:06 EST 2008: The meta-device /dev/md0 has no mismatched
sectors.
Fri Feb 22 21:00:07 EST 2008: The meta-device /dev/md1 has no mismatched
sectors.
Fri Feb 22 21:00:08 EST 2008: The meta-device /dev/md2 has no mismatched
sectors.
Fri Feb 22 21:00:09 EST 2008: The meta-device /dev/md3 has 936 mismatched
sectors.
Fri Feb 22 21:00:09 EST 2008: Executing repair on /dev/md3
Fri Feb 22 22:00:10 EST 2008: cat /sys/block/md0/md/mismatch_cnt
Fri Feb 22 22:00:10 EST 2008: 0
Fri Feb 22 22:00:10 EST 2008: cat /sys/block/md1/md/mismatch_cnt
Fri Feb 22 22:00:10 EST 2008: 0
Fri Feb 22 22:00:10 EST 2008: cat /sys/block/md2/md/mismatch_cnt
Fri Feb 22 22:00:10 EST 2008: 0
Fri Feb 22 22:00:10 EST 2008: cat /sys/block/md3/md/mismatch_cnt
Fri Feb 22 22:00:10 EST 2008: 936

