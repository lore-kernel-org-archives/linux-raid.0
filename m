From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RAID5 Tweaked to 195MB/s on 4 x 150 Raptors
Date: Thu, 11 Jan 2007 17:52:41 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0701111752050.3746@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The stripe_cache_size is a VERY important feature!

# Stripe tests:
echo 8192 > /sys/block/md3/md/stripe_cache_size

# DD TESTS

$ dd if=/dev/zero of=10gb.no.optimizations.out bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 96.6988 seconds, 111 MB/s

$ dd if=/dev/zero of=10gb.8192k.stripe.out bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 55.0628 seconds, 195 MB/s
$ 

$ dd if=/dev/zero of=10gb.16384k.stripe.out bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 56.2793 seconds, 191 MB/s


