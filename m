From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/6] md: Remove the hash tables from raid0 V2 -- Introduction.
Date: Fri, 15 May 2009 15:18:12 +0200
Message-ID: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

As mentioned by Neil, the raid0 hash table does probably not add
any value and contains some rather strange code that manipulates the
various sector counts needed to maintain this table.

This patch series against Neil's for-next tree as of yesterday removes
the hash table from the raid0 code.

Patch #1 replaces the hash table lookup by a simple function that
loops over all strip zones to find the zone that holds a given sector.
This change allows to get rid of the hash table itself (patch #2)
and of related fields of struct raid0_private_data (patch #3).

Patch #4 makes raid0 return a proper error code rather than -ENOMEM
in case the array could not be started for reasons different from
memory shortage.

Patch #5 cleans up the allocation of the buffers for the raid0
configuration.

Patch #6 fixes a memory leak that happens when a raid0 array is
shut down.

The patched kernel has been tested with a smallish raid0 array
consisting of five devices of different sizes (created with an
unpatched kernel) and seems to work just fine. Moreover, it passes
the raid0 tests of the mdadm test suite.

Differences to the first version of the patch set:

	- According to the discussion on linux-raid, ->zone_start has
	been renamed to ->zone_end with the obvious semantic change.

	- Patch #5 and #6 of the old patch set have been combined
	and the allocation/freeing of the raid0 configuration has
	been moved from raid0_run() to create_strip_zones().

	- Patch #6 is new.

 drivers/md/raid0.c |  174 +++++++++++++---------------------------------------
 drivers/md/raid0.h |    6 +--
 2 files changed, 45 insertions(+), 135 deletions(-)

