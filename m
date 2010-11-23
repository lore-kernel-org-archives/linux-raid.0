From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/21] FIX: Level field can be NULL
Date: Tue, 23 Nov 2010 13:41:32 +0100
Message-ID: <20101123124132.17770.86136.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When array changes its shape/level or array is about closing
level field in mdstat can be NULL. This causes core dump in mdmon.
Patch introduces guard in code for this situation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/mdstat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/mdstat.c b/mdadm/mdadm/mdstat.c
index aecd1d4..1f818b1 100644
--- a/mdadm/mdadm/mdstat.c
+++ b/mdadm/mdadm/mdstat.c
@@ -291,6 +291,8 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 
 int mdstat_to_level(struct mdstat_ent *ms)
 {
+	if (ms->level == NULL)
+		return LEVEL_UNSUPPORTED;
 	if (strncmp(ms->level, "raid0", 5) == 0)
 		return 0;
 	else if (strncmp(ms->level, "raid10", 6) == 0)

