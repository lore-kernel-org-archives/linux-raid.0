From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 00/12] Partial Parity Log for MD RAID 5
Date: Mon,  5 Dec 2016 16:31:01 +0100
Message-ID: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This series of patches implements the Partial Parity Log for RAID5 arrays. The
purpose of this feature is closing the RAID Write Hole. It is a solution
alternative to the existing raid5-cache, but the implementation is based on it
and reuses some of the code by introducing support for interchangeable
policies. This allows decoupling policy from mechanism and not adding more
boilerplate code in raid5.c.

The issue addressed by PPL is, that on a dirty shutdown, parity for a
particular stripe may be inconsistent with data on other member disks. In
degraded state, there is no way to recalculate parity, because one of the disks
is missing. PPL addresses this issue and allows recalculating the parity. It
stores only enough data needed for recovering from RWH and is not a true
journal, like the raid5-cache implementation. It does not protect from losing
in-flight data.

PPL is a distributed log - data is stored on all RAID member drives in the
metadata area. It does not need a dedicated journaling drive. Performance is
reduced by up to 30%-40% but it scales with the number of drives in the array
and the journaling drive does not become a bottleneck.

This feature originated from Intel RSTe, which uses IMSM metadata. This
patchset implements PPL for external metadata (specifically IMSM) as well as
native MD v1.1 and v1.2 metadata.

v2:
- Rebased to latest md for-next.
- Fixed wrong PPL size calculation for IMSM.
- Simplified full stripe write case.
- Removed direct access to bi_io_vec.
- Handle failed bio_add_page().

Artur Paszkiewicz (12):
  raid5-cache: move declarations to separate header
  raid5-cache: add policy logic
  raid5-cache: add a new policy
  md: superblock changes for PPL
  raid5-ppl: Partial Parity Log implementation
  raid5-ppl: calculate partial parity
  md: mddev_find_container helper function
  md: expose rdev->sb_start as sysfs attribute
  raid5-ppl: read PPL signature from IMSM metadata
  raid5-ppl: recovery from dirty shutdown using PPL
  raid5-ppl: support disk add/remove with distributed PPL
  raid5-ppl: runtime PPL enabling or disabling

 drivers/md/Makefile            |    2 +-
 drivers/md/md.c                |   81 ++-
 drivers/md/md.h                |   14 +
 drivers/md/raid5-cache.c       |  275 ++++------
 drivers/md/raid5-cache.h       |  169 ++++++
 drivers/md/raid5-ppl.c         | 1153 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |  274 +++++++++-
 drivers/md/raid5.h             |   10 +-
 include/uapi/linux/raid/md_p.h |   18 +-
 9 files changed, 1814 insertions(+), 182 deletions(-)
 create mode 100644 drivers/md/raid5-cache.h
 create mode 100644 drivers/md/raid5-ppl.c

-- 
2.10.1

