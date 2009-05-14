From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/6] md: Remove the hash tables from raid0.
Date: Thu, 14 May 2009 11:30:56 +0200
Message-ID: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

As mentioned by Neil, the raid0 hash table code does probably not
add any value. Moreover, it contains some rather strange sector_t
manipulations which are needed to setup and maintain the table.

This patch series against Neil's for-next tree as of yesterday removes
the hash table from the raid0 code.

Patch #1 replaces the hash table lookup by a simple function that
loops over all strip zones to find the zone that holds a given sector.
This change allows to get rid of the hash table itself (patch #2)
and of related fields of struct raid0_private_data (patch #3).

Patch #4 makes raid0 return a proper error code rather than -ENOMEM
in case the array could not be started for reasons other than memory
shortage.

The remaining two patches are simple cleanups that further simplify
the raid0 code a bit.

The patched kernel has been tested with a smallish raid0 array
consisting of five devices of varying sizes (created and filled with
contents by an unpatched kernel) and seems to work just fine. It
passes the raid0 tests of the mdadm test suite.

Please consider for inclusion.

 drivers/md/raid0.c |  150 ++++++++++++++--------------------------------------
 drivers/md/raid0.h |    4 --
 2 files changed, 39 insertions(+), 115 deletions(-)

Thanks
Andre
