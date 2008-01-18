From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors Again
Date: Fri, 18 Jan 2008 10:35:21 -0500
Message-ID: <29a863790801180735n379a27f1t4987686b2ec1aa50@mail.gmail.com>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin, thanks for the script. Here's my results. I ran it a few times
with different tests, hence the small number of results you see here,
I slowly trimmed out the obvious not-ideal sizes.

System
---
Athlon64 3500
2GB RAM
4x500GB WD Raid editions, raid 5. SDE is the old 4-platter version
(5000YS), the others are the 3 platter version. Faster :-)

/dev/sdb:
 Timing buffered disk reads:  240 MB in  3.00 seconds =  79.91 MB/sec
/dev/sdc:
 Timing buffered disk reads:  248 MB in  3.01 seconds =  82.36 MB/sec
/dev/sdd:
 Timing buffered disk reads:  248 MB in  3.02 seconds =  82.22 MB/sec
/dev/sde:  (older model, 4 platters instead of 3)
 Timing buffered disk reads:  210 MB in  3.01 seconds =  69.87 MB/sec
/dev/md3:
 Timing buffered disk reads:  628 MB in  3.00 seconds = 209.09 MB/sec


Testing
---
Test was : dd if=/dev/zero of=/r1/bigfile bs=1M count=10240; sync
64-chunka.txt:2:00.63
128-chunka.txt:2:00.20
256-chunka.txt:2:01.67
512-chunka.txt:2:19.90
1024-chunka.txt:2:59.32


Test was : Unraring multipart RAR's, 1.2 gigabytes. Source and dest
drive were the raid array.
64-chunkc.txt:1:04.20
128-chunkc.txt:0:49.37
256-chunkc.txt:0:48.88
512-chunkc.txt:0:41.20
1024-chunkc.txt:0:40.82



So, there's a toss up between 256 and 512. If I'm interpreting
correctly here, raw throughput is better with 256, but 512 seems to
work better with real-world stuff? I'll try to think up another test
or two perhaps, and removing 64 as one of the possible options to save
time (mke2fs takes a while on 1.5TB)

Next step will be playing with read aheads and stripe cache sizes I
guess! I'm open to any comments/suggestions you guys have!

Greg
