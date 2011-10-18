From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: imsm: prevent segfault in mark_failure
Date: Tue, 18 Oct 2011 09:44:48 +0200
Message-ID: <20111018074448.4114.43297.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Using an array of chars without trailing '\000' as a parameter
in sprintf() function can cause segfault. The snprintf() function
should be used instead.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index af06660..696cff3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6015,7 +6015,7 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
 		return 0;
 
-	sprintf(buf, "%s:0", disk->serial);
+	snprintf(buf, MAX_RAID_SERIAL_LEN, "%s:0", disk->serial);
 	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
 		shift = len - MAX_RAID_SERIAL_LEN + 1;
 	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);

