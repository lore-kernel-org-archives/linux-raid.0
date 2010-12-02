From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/10] Add support to skip slot configuration
Date: Thu, 02 Dec 2010 09:19:12 +0100
Message-ID: <20101202081912.4639.23284.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When disk is added, set valid slot numbers (positive) only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index 16e41fb..7a0403d 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -614,7 +614,8 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 			 * yet, so just ignore status for now.
 			 */
 			sysfs_set_str(sra, sd, "state", "insync");
-		rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
+		if (sd->disk.raid_disk >= 0)
+			rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
 		if (resume)
 			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
 	}

