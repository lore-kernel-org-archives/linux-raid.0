From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: prevent segfault in mark_failure
Date: Wed, 19 Oct 2011 11:51:48 +0200
Message-ID: <20111019095148.6240.80135.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Using an array of chars without the terminating null byte
as a parameter of sprintf() function causes segfault
when dealing with SAS drives (with 20-digits serial number).
The memcpy() function is used instead.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 401c701..2c1bf05 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6015,7 +6015,9 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
 		return 0;
 
-	sprintf(buf, "%s:0", disk->serial);
+	memcpy(buf, disk->serial, MAX_RAID_SERIAL_LEN);
+	buf[MAX_RAID_SERIAL_LEN] = '\000';
+	strcat(buf, ":0");
 	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
 		shift = len - MAX_RAID_SERIAL_LEN + 1;
 	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);

