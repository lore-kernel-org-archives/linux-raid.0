From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 20/21] imsm: Optimize expansion speed when no backup is
	required
Date: Wed, 08 Jun 2011 18:12:14 +0200
Message-ID: <20110608161214.24327.24869.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When no reshape backup is required (e.g. OLCE after critical section),
check-pointing can use bigger steps than backup space allows for.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fae1218..71a1189 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8855,11 +8855,19 @@ static int imsm_manage_reshape(
 					"migration record (UNIT_SRC_IN_CP_AREA)\n");
 				goto abort;
 			}
+		} else {
+			/* set next step to use whole border area */
+			border /= next_step;
+			if (border > 1)
+				next_step *= border;
 		}
 		/* When data backed up, checkpoint stored,
 		 * kick the kernel to reshape unit of data
 		 */
 		next_step = next_step + sra->reshape_progress;
+		/* limit next step to array max position */
+		if (next_step > max_position)
+			next_step = max_position;
 		sysfs_set_num(sra, NULL, "suspend_lo", sra->reshape_progress);
 		sysfs_set_num(sra, NULL, "suspend_hi", next_step);
 		sra->reshape_progress = next_step;

