From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5/9] imsm: fix reserved sectors for spares
Date: Thu, 25 Aug 2011 19:14:24 -0700
Message-ID: <20110826021424.28015.2342.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Anna Czarnowska <anna.czarnowska@intel.com>, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Different OROMs reserve different amounts of space for the migration area.
When activating a spare minimize the reserved space otherwise a valid spare
can be prevented from joining an array with a migration area smaller than
IMSM_RESERVED_SECTORS.

This may result in an array that cannot be reshaped, but that is less
surprising than not being able to rebuild a degraded array.
imsm_reserved_sectors() already reports the minimal value which adds to
the confusion when trying rebuild an array because mdadm -E indicates
that the device has enough space.

Cc: Anna Czarnowska <anna.czarnowska@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0347183..193e0d0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -833,7 +833,16 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl)
 	struct extent *rv, *e;
 	int i;
 	int memberships = count_memberships(dl, super);
-	__u32 reservation = MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
+	__u32 reservation;
+
+	/* trim the reserved area for spares, so they can join any array
+	 * regardless of whether the OROM has assigned sectors from the
+	 * IMSM_RESERVED_SECTORS region
+	 */
+	if (dl->index == -1)
+		reservation = MPB_SECTOR_CNT;
+	else
+		reservation = MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
 
 	rv = malloc(sizeof(struct extent) * (memberships + 1));
 	if (!rv)

