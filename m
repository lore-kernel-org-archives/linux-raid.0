From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 10] md: Various bug fixes and small improvements for md in 2.6.26-rc
Date: Mon, 19 May 2008 11:10:00 +1000
Message-ID: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>, Bernd Schubert <bernd-schubert@gmx.de>, Bernd Schubert <bs@q-leap.de>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Eivind Sarto <ivan@kasenna.com>, "Fairbanks, David" <David.Fairbanks@stratus.com>, Mike Snitzer <snitzer@gmail.com>
List-Id: linux-raid.ids

Following are a collection of 10 patches for md/raid that are suitable
for 2.6.26-rc.  They are ordered roughly from simple to more complex with 
serious bugfixes possibly getting elevated in the sort order.

Thanks,
NeilBrown

 [PATCH 000 of 10] md: Introduction EXPLAIN PATCH SET HERE
 [PATCH 001 of 10] md: Fix possible oops when removing a bitmap from an active array
 [PATCH 002 of 10] md: proper extern for mdp_major
 [PATCH 003 of 10] md: kill file_path wrapper
 [PATCH 004 of 10] md: md: raid5 rate limit error printk
 [PATCH 005 of 10] md: raid1: Fix restoration of bio between failed read and write.
 [PATCH 006 of 10] md: Notify userspace on 'write-pending' changes to array_state
 [PATCH 007 of 10] md: notify userspace on 'stop' events
 [PATCH 008 of 10] md: Improve setting of "events_cleared" for write-intent bitmaps.
 [PATCH 009 of 10] md: Allow parallel resync of md-devices.
 [PATCH 010 of 10] md: Restart recovery cleanly after device failure.
