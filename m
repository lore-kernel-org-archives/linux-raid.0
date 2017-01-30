From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 0/9] Partial Parity Log for MD RAID 5
Date: Mon, 30 Jan 2017 19:59:44 +0100
Message-ID: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This series of patches implements the Partial Parity Log for RAID5 arrays. The
purpose of this feature is closing the RAID 5 Write Hole. It is a solution
alternative to the existing raid5-cache, but the implementation is based on it
and reuses some of the code by introducing support for interchangeable
policies. This allows decoupling policy from mechanism and not adding more
boilerplate code in raid5.c.

The main differences compared to raid5-cache is that PPL is a distributed log -
it is stored on array member drives in the metadata area and does not require a
dedicated journaling drive. Write performance is reduced by up to 30%-40% but
it scales with the number of drives in the array and the journaling drive does
not become a bottleneck or a single point of failure. PPL does not protect from
losing in-flight data, only from silent data corruption. More details about how
the log works can be found in patches 5 and 7.

This feature originated from Intel RSTe, which uses IMSM metadata. This
patchset implements PPL for external metadata (specifically IMSM) as well as
native MD v1.x metadata.

Changes in mdadm are also required to make this fully usable. Patches for mdadm
will be sent later.

v3:
- Rebased to latest md for-next.
- Fixed alignment issues in the metadata structures.
- Removed reading IMSM signature from superblock.
- Removed 'rwh_policy' and per-device JournalPpl flags, added
  'consistency_policy', 'ppl_sector' and 'ppl_size' sysfs attributes.
- Reworked and simplified disk removal logic.
- Debug messages in raid5-ppl.c converted to pr_debug().
- Fixed some bugs in logging and recovery code.
- Improved descriptions and documentation.

v2:
- Rebased to latest md for-next.
- Fixed wrong PPL size calculation for IMSM.
- Simplified full stripe write case.
- Removed direct access to bi_io_vec.
- Handle failed bio_add_page().

Artur Paszkiewicz (9):
  raid5-cache: move declarations to separate header
  raid5-cache: add policy logic
  md: superblock changes for PPL
  raid5: calculate partial parity for a stripe
  raid5-ppl: Partial Parity Log write logging implementation
  md: add sysfs entries for PPL
  raid5-ppl: load and recover the log
  raid5-ppl: support disk hot add/remove with PPL
  raid5-ppl: runtime PPL enabling or disabling

 Documentation/admin-guide/md.rst |   85 ++-
 drivers/md/Makefile              |    2 +-
 drivers/md/md.c                  |  136 +++++
 drivers/md/md.h                  |   10 +
 drivers/md/raid0.c               |    3 +-
 drivers/md/raid1.c               |    3 +-
 drivers/md/raid5-cache.c         |  270 ++++------
 drivers/md/raid5-cache.h         |  197 +++++++
 drivers/md/raid5-ppl.c           | 1101 ++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c               |  195 ++++++-
 drivers/md/raid5.h               |   32 +-
 include/uapi/linux/raid/md_p.h   |   44 +-
 12 files changed, 1875 insertions(+), 203 deletions(-)
 create mode 100644 drivers/md/raid5-cache.h
 create mode 100644 drivers/md/raid5-ppl.c

-- 
2.11.0

