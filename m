From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/2] An evolutionary change to the raid456 queuing model
Date: Wed, 27 Jun 2007 12:09:23 -0700
Message-ID: <20070627190534.5685.34447.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, raziebe@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Raz's stripe-deadline patch illuminated the fact that the current
queuing model leaves write performance on the table in some cases.  The
following patches introduce a new queuing model which attempts to
recover this performance.

On an ARM based iop13xx platform I see an averaged %14.7 increase in
throughput as reported by the following simple test:

	for i in `seq 1 10`; do dd if=/dev/zero of=/dev/md0 bs=1024k count=512; done

This was performed on a default configured 4-disk SATA array (chunksize=64k
stripe_cache_size=256)

However, a test with an ext2 filesystem and tiobench showed negligible
changes.  My suspicion is that the new queuing model, as it currently stands,
can extract some more performance when full stripe writes are present, but in
the tiobench case there is not enough to take advantage of the queue's preread
prevention logic (improving this case is the goal of releasing this version of
the patches).

These patches are on top of the md-accel series.  I will spin a complete
set based on 2.6.22 once it goes final (2.6.22-iop1 to be released on
SourceForge).  Until then the complete series is available via git:

	git://lost.foo-projects.org/~dwillia2/git/iop md-accel+experimental

Not to be confused with the acceleration patch set released yesterday which is
targetted at 2.6.23.  These queuing changes need some more time to cook.

-- 
Dan
