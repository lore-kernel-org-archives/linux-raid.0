From: Chen Rong <rongx.a.chen@intel.com>
Subject: [PATCH 1/2] incremental: fix check journal device
Date: Thu, 17 Aug 2017 15:41:20 +0800
Message-ID: <1502955681-17313-1-git-send-email-rongx.a.chen@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Chen Rong <rongx.a.chen@intel.com>
List-Id: linux-raid.ids

set journal_clean=1 if not journal device

Signed-off-by: Chen Rong <rongx.a.chen@intel.com>
---
 Incremental.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index 0f507bb..a91f82c 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -733,7 +733,7 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 
 		info.array.raid_disks = raid_disks;
 		st->ss->getinfo_super(st, &info, devmap + raid_disks * devnum);
-		if (info.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
+		if (info.disk.raid_disk != MD_DISK_ROLE_JOURNAL)
 			bestinfo->journal_clean = 1;
 		if (!avail) {
 			raid_disks = info.array.raid_disks;
-- 
2.7.4

