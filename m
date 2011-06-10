From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] imsm: Fix: klocwork: targets variable can be used
	uninitialized
Date: Fri, 10 Jun 2011 17:56:30 +0200
Message-ID: <20110610155630.24539.30608.stgit@gklab-128-013.igk.intel.com>
References: <20110610154856.24539.28960.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110610154856.24539.28960.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When target_offsets allocation fails execution goes to abort label,
where elements from targets table are closed.

Initialize targets table after allocation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 40fd940..8dd0805 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7724,6 +7724,9 @@ int save_backup_imsm(struct supertype *st,
 	if (!targets)
 		goto abort;
 
+	for (i = 0; i < new_disks; i++)
+		targets[i] = -1;
+
 	target_offsets = malloc(new_disks * sizeof(unsigned long long));
 	if (!target_offsets)
 		goto abort;

