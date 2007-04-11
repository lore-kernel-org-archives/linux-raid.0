From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH RFC 0/4] raid5: write-back caching policy and write performance
Date: Tue, 10 Apr 2007 23:00:21 -0700
Message-ID: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These patches are presented to further the discussion of raid5 write
performance and are not yet meant for mainline or -mm inclusion.  Raz's
delayed-activation patch showed interesting results so it has been
ported/included in this series.  The question to be answered is whether
the sequential write performance of a raid5 array, out of the box, can
approach that of a similarly configured raid0 array (minus one disk).
Currently, on an iop13xx platform, tiobench is reporting a 2x advantage
for the N-1 raid0 array, so it seems there is room for improvement.

The third patch in the series adds a write-back caching capability to md
to investigate the raw throughput to the stripe cache.  Since battery
backed memory is not being used this patch makes the system markedly
less safe, so only use it with data that can be thrown away.  Initial
testing with dd shows the performance of this policy can be ~1.8x that
of the default write-through policy.  That is, when the data set is
smaller than the cache size.  Once cache pressure begins to force the
writes to disk performance drops well below the write-through case.  So
work remains to be done to see how the write-through case achieves
better sustained throughput numbers.

I am interested in the performance of these patches on other
platforms/configurations and comments on the implementation.

[ based on 2.6.21-rc6 + git-md-accel.patch from -mm ]
      md: introduce struct stripe_head_state
      md: refactor raid5 cache policy code using 'struct stripe_cache_policy'
      md: writeback caching policy for raid5 [experimental]
      md: delayed stripe activation

The patches can also be pulled via git:
git pull git://lost.foo-projects.org/~dwillia2/git/iop md-accel+experimental

--
Dan
