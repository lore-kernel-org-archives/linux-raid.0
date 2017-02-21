From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v4 0/7] Partial Parity Log for MD RAID 5
Date: Tue, 21 Feb 2017 20:43:54 +0100
Message-ID: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This series of patches implements the Partial Parity Log for RAID5 arrays. The
purpose of this feature is closing the RAID 5 Write Hole. It is a solution
alternative to the existing raid5-cache, but the logging workflow and much of
the implementation is based on it.

The main differences compared to raid5-cache is that PPL is a distributed log -
it is stored on array member drives in the metadata area and does not require a
dedicated journaling drive. Write performance is reduced by up to 30%-40% but
it scales with the number of drives in the array and the journaling drive does
not become a bottleneck or a single point of failure. PPL does not protect from
losing in-flight data, only from silent data corruption. More details about how
the log works can be found in patches 3 and 5.

This feature originated from Intel RSTe, which uses IMSM metadata. This
patchset implements PPL for external metadata (specifically IMSM) as well as
native MD v1.x metadata.

Changes in mdadm are also required to make this fully usable. Patches for mdadm
will be sent later.

v4:
- Separated raid5-cache and ppl structures.
- Removed the policy logic from raid5-cache, ppl calls moved to raid5 core.
- Checking wrong configuration when validating superblock.
- Moved documentation to separate file.
- More checks for ppl sector/size.
- Some small fixes and improvements.

v3:
- Fixed alignment issues in the metadata structures.
- Removed reading IMSM signature from superblock.
- Removed 'rwh_policy' and per-device JournalPpl flags, added
  'consistency_policy', 'ppl_sector' and 'ppl_size' sysfs attributes.
- Reworked and simplified disk removal logic.
- Debug messages in raid5-ppl.c converted to pr_debug().
- Fixed some bugs in logging and recovery code.
- Improved descriptions and documentation.

v2:
- Fixed wrong PPL size calculation for IMSM.
- Simplified full stripe write case.
- Removed direct access to bi_io_vec.
- Handle failed bio_add_page().

Artur Paszkiewicz (7):
  md: superblock changes for PPL
  raid5: calculate partial parity for a stripe
  raid5-ppl: Partial Parity Log write logging implementation
  md: add sysfs entries for PPL
  raid5-ppl: load and recover the log
  raid5-ppl: support disk hot add/remove with PPL
  raid5-ppl: runtime PPL enabling or disabling

 Documentation/admin-guide/md.rst |   32 +-
 Documentation/md/raid5-ppl.txt   |   44 ++
 drivers/md/Makefile              |    2 +-
 drivers/md/md.c                  |  140 +++++
 drivers/md/md.h                  |   10 +
 drivers/md/raid0.c               |    3 +-
 drivers/md/raid1.c               |    3 +-
 drivers/md/raid5-ppl.c           | 1151 ++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c               |  227 +++++++-
 drivers/md/raid5.h               |   19 +
 include/uapi/linux/raid/md_p.h   |   44 +-
 11 files changed, 1657 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/md/raid5-ppl.txt
 create mode 100644 drivers/md/raid5-ppl.c

-- 
2.11.0

