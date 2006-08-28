From: "Rob Bray" <raid@bymeinc.com>
Subject: Raid5 reads and cpu
Date: Mon, 28 Aug 2006 14:33:45 -0400 (EDT)
Message-ID: <1436.68.254.47.18.1156790025.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This might be a dumb question, but what causes md to use a large amount of
cpu resources when reading a large amount of data from a raid1 array?
Examples are on a 2.4GHz AMD64, 2GB, 2.6.15.1 (I realize there are md
enhancements to later versions; I had some other unrelated issues and
rolled back to one I've run on for several months).

A given 7-disk raid0 array can read 450MB/s (using cat > null) and use
virtually no CPU resources. (Although cat and kswapd use quite a bit [60%]
munching on the data)

A raid5 array on the same drive set pulls in at 250MB/s, but md uses
roughly 50% of the CPU (the other 50% is spent dealing with the data,
saturating the processor).

A consistency check on the raid5 array uses roughly 3% of the cpu. It is
otherwise ~97% idle.
md11 : active raid5 sdi2[5] sdh2[4] sdf2[3] sde2[2] sdd2[1] sdc2[6] sdb2[0]
      248974848 blocks level 5, 256k chunk, algorithm 2 [7/7] [UUUUUUU]
      [==============>......]  resync = 72.2% (29976960/41495808)
finish=3.7min speed=51460K/sec
(~350MB/s aggregate throughput, 50MB/s on each device)

Just a friendly question as to why CPU utilization is significantly
different between a check and a real-world read on raid5? I feel like if
there was vm overhead getting the data into userland, the slowdown would
be present in raid0 as well. I assume parity calculations aren't done on a
read of the array, which leaves me at my question.

Thanks,
Rob

