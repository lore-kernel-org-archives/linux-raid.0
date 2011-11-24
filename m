From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/11] imsm: FIX: Restore critical section on degraded array
Date: Thu, 24 Nov 2011 13:17:58 +0100
Message-ID: <20111124121758.5254.18968.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When during assembly degradation occurs restoring metadata critical section
fails whole assembly.
Allow for degradation during assembly and not restore data on degraded disk.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0fc907d..ccd9883 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7984,6 +7984,10 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 int open_backup_targets(struct mdinfo *info, int raid_disks, int *raid_fds)
 {
 	struct mdinfo *sd;
+	int i;
+
+	for (i = 0; i < raid_disks; i++)
+		raid_fds[i] = -1;
 
 	for (sd = info->devs ; sd ; sd = sd->next) {
 		char *dn;
@@ -8293,7 +8297,11 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	if (!targets)
 		goto abort;
 
-	open_backup_targets(info, new_disks, targets);
+	if (open_backup_targets(info, new_disks, targets)) {
+		fprintf(stderr,
+			Name ": Cannot open devices belongs to array.\n");
+		goto abort;
+	}
 
 	for (i = 0; i < new_disks; i++) {
 		if (targets[i] < 0) {

