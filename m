From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 3/4] imsm: avoid double change of serial number of missing
 device
Date: Thu, 05 Apr 2012 17:30:54 +0200
Message-ID: <20120405153054.19851.39398.stgit@linux.site>
References: <20120405152553.19851.48052.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405152553.19851.48052.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If degraded state is set in OROM, it do not set 'failed' flag for missing,
device, just changes serial number, sets scsiId to 0xffff and sets highest
bit in ord table in map. When mdadm replaces missing disk, the one left
there is marked as failed and missing again (changing already marked serial
number).

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f843997..b361b72 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6908,12 +6908,15 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
 		return 0;
 
-	memcpy(buf, disk->serial, MAX_RAID_SERIAL_LEN);
-	buf[MAX_RAID_SERIAL_LEN] = '\000';
-	strcat(buf, ":0");
-	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
-		shift = len - MAX_RAID_SERIAL_LEN + 1;
-	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);
+	/* do not add ":0", OROM has already done it */
+	if (!(ord & IMSM_ORD_REBUILD)) {
+		memcpy(buf, disk->serial, MAX_RAID_SERIAL_LEN);
+		buf[MAX_RAID_SERIAL_LEN] = '\000';
+		strcat(buf, ":0");
+		if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
+			shift = len - MAX_RAID_SERIAL_LEN + 1;
+		strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);
+	}
 
 	disk->status |= FAILED_DISK;
 	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);

