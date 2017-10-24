From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 0/3] Add basic support for clustered raid10
Date: Tue, 24 Oct 2017 15:11:49 +0800
Message-ID: <20171024071153.5275-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

Previously, we had added the support for clustered raid1,
now we are trying to support raid10 as well.

This patchset just avoid potential write and resync request
conflict among nodes. Since raid10 has different layouts
such as near, far and offset etc, and we just consider to
support near layout since other layouts could have trouble
while resyncing.

Also, clustered raid10 has limited support since it lacks
some features which suitable for native raid10, such as add
disk under grow mode, we consider add more features for it
in future.

Guoqing Jiang (3):
  md-cluster/raid10: set "do_balance = 0" if area is resyncing
  md-cluster: Suspend writes in RAID10 if within range
  md-cluster: Use a small window for raid10 resync
  md-cluster: update document for raid10

 Documentation/md/md-cluster.txt |   3 +-
 drivers/md/Kconfig              |   5 +-
 drivers/md/md-cluster.c         |   2 +-
 drivers/md/raid10.c             | 137 +++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid10.h             |   6 ++
 5 files changed, 146 insertions(+), 7 deletions(-)

-- 
2.10.0

