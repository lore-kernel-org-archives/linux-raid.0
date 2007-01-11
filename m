From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Tweaking/Optimizing MD RAID: 195MB/s write, 181MB/s read (so far)
Date: Thu, 11 Jan 2007 18:05:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0701111804310.3847@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kerne.org
Cc: xfs@oss.sgi.com
List-Id: linux-raid.ids

With 4 Raptor 150s & XFS (default XFS options):

# Stripe tests:
echo 8192 > /sys/block/md3/md/stripe_cache_size

# DD TESTS [WRITE]

DEFAULT:
$ dd if=/dev/zero of=10gb.no.optimizations.out bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 96.6988 seconds, 111 MB/s

8192 STRIPE CACHE
$ dd if=/dev/zero of=10gb.8192k.stripe.out bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 55.0628 seconds, 195 MB/s
$

16384 STRIPE CACHE
$ dd if=/dev/zero of=10gb.16384k.stripe.out bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 56.2793 seconds, 191 MB/s

# DD TESTS [READ]

DEFAULT:
$ dd if=10gb.16384k.stripe.out of=/dev/null bs=1M
298+0 records in
297+0 records out
311427072 bytes (311 MB) copied, 3.5453 seconds, 87.8 MB/s

2048K READ AHEAD
$ dd if=10gb.16384k.stripe.out of=/dev/null bs=1M
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 85.4632 seconds, 126 MB/s

8192K READ AHEAD
$ dd if=10gb.16384k.stripe.out of=/dev/null bs=1M
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 64.9454 seconds, 165 MB/s

16384K READ AHEAD
$ dd if=10gb.16384k.stripe.out of=/dev/null bs=1M
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 59.3119 seconds, 181 MB/s


